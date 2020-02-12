From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-fix-various-data-races-at-memsw.patch
 added to -mm tree
Date: Wed, 12 Feb 2020 13:16:40 -0800
Message-ID: <20200212211640.YAZ_7uAsJ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbgBLVQm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 16:16:42 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, david@redhat.com, dvyukov@google.com, elver@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     Subject: mm/page_counter: fix various data races at memsw
has been added to the -mm tree.  Its filename is
     mm-page_counter-fix-various-data-races-at-memsw.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-fix-various-data-races-at-memsw.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-fix-various-data-races-at-memsw.patch

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
Subject: mm/page_counter: fix various data races at memsw

Commit 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") could had
memcg->memsw->watermark and memcg->memsw->failcnt been accessed
concurrently as reported by KCSAN,

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

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

 BUG: KCSAN: data-race in page_counter_try_charge / page_counter_try_charge

 write to 0xffff88809bbf2158 of 8 bytes by task 11782 on cpu 0:
  page_counter_try_charge+0x100/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

 read to 0xffff88809bbf2158 of 8 bytes by task 11814 on cpu 1:
  page_counter_try_charge+0xef/0x170 mm/page_counter.c:129
  try_charge+0x185/0xbf0 mm/memcontrol.c:2405
  __memcg_kmem_charge_memcg+0x4a/0xe0 mm/memcontrol.c:2837
  __memcg_kmem_charge+0xcf/0x1b0 mm/memcontrol.c:2877
  __alloc_pages_nodemask+0x26c/0x310 mm/page_alloc.c:4780

Since watermark could be compared or set to garbage due to a data race
which would change the code logic, fix it by adding a pair of READ_ONCE()
and WRITE_ONCE() in those places.

The "failcnt" counter is tolerant of some degree of inaccuracy and is only
used to report stats, a data race will not be harmful, thus mark it as an
intentional data race using the data_race() macro.

Link: http://lkml.kernel.org/r/1581519682-23594-1-git-send-email-cai@lca.pw
Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Qian Cai <cai@lca.pw>
Reported-by: syzbot+f36cfe60b1006a94f9dc@syzkaller.appspotmail.com
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-fix-various-data-races-at-memsw
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
 
@@ -124,9 +124,10 @@ bool page_counter_try_charge(struct page
 			propagate_protected_usage(counter, new);
 			/*
 			 * This is racy, but we can live with some
-			 * inaccuracy in the failcnt.
+			 * inaccuracy in the failcnt which is only used
+			 * to report stats.
 			 */
-			c->failcnt++;
+			data_race(c->failcnt++);
 			*fail = c;
 			goto failed;
 		}
@@ -135,8 +136,8 @@ bool page_counter_try_charge(struct page
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
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-page_counter-fix-various-data-races.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
