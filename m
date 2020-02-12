From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-fix-various-data-races.patch added to
 -mm tree
Date: Tue, 11 Feb 2020 16:30:29 -0800
Message-ID: <20200212003029._vHO_x2zz%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgBLAaa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:30:30 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, david@redhat.com, dvyukov@google.com, elver@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: mm/page_counter.c: fix various data races
has been added to the -mm tree.  Its filename is
     mm-page_counter-fix-various-data-races.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-fix-various-data-races.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-fix-various-data-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_counter.c: fix various data races

The commit 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") could
had memcg->memsw->watermark been accessed concurrently as reported by
KCSAN,

 Reported by Kernel Concurrency Sanitizer on:
 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_char=
ge

 read to 0xffff8fb18c4cd190 of 8 bytes by task 1081 on cpu 59:
  page_counter_try_charge+0x4d/0x150 mm/page_counter.c:138
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x58/0x140
  __memcg_kmem_charge+0xcc/0x280
  __alloc_pages_nodemask+0x1e1/0x450
  alloc_pages_current+0xa6/0x120
  pte_alloc_one+0x17/0xd0
  __pte_alloc+0x3a/0x1f0
  copy_p4d_range+0xc36/0x1990
  copy_page_range+0x21d/0x360
  dup_mmap+0x5f5/0x7a0
  dup_mm+0xa2/0x240
  copy_process+0x1b3f/0x3460
  _do_fork+0xaa/0xa20
  __x64_sys_clone+0x13b/0x170
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffff8fb18c4cd190 of 8 bytes by task 1153 on cpu 120:
  page_counter_try_charge+0x5b/0x150 mm/page_counter.c:139
  try_charge+0x131/0xd50 mm/memcontrol.c:2405
  mem_cgroup_try_charge+0x159/0x460
  mem_cgroup_try_charge_delay+0x3d/0xa0
  wp_page_copy+0x14d/0x930
  do_wp_page+0x107/0x7b0
  __handle_mm_fault+0xce6/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

Since watermark could be compared or set to garbage due to load or store
tearing which would change the code logic, fix it by adding a pair of
READ_ONCE() and WRITE_ONCE() in those places.

Link: http://lkml.kernel.org/r/20200129105224.4016-1-cai@lca.pw
Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-fix-various-data-races
+++ a/mm/page_counter.c
@@ -82,8 +82,8 @@ void page_counter_charge(struct page_cou
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 }
 
@@ -135,8 +135,8 @@ bool page_counter_try_charge(struct page
 		 * Just like with failcnt, we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
-			c->watermark = new;
+		if (new > READ_ONCE(c->watermark))
+			WRITE_ONCE(c->watermark, new);
 	}
 	return true;
 
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-annotate-a-data-race-in-checksum.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-page_counter-fix-various-data-races.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
