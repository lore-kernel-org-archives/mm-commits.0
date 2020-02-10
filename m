From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
 added to -mm tree
Date: Sun, 09 Feb 2020 17:03:08 -0800
Message-ID: <20200210010308.wD7ghOZ48%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgBJBDK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 20:03:10 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru: fix a data race in list_lru_count_one
has been added to the -mm tree.  Its filename is
     mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch

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
Subject: mm/list_lru: fix a data race in list_lru_count_one

struct list_lru_one l.nr_items could be accessed concurrently as noticed
by KCSAN,

 BUG: KCSAN: data-race in list_lru_count_one / list_lru_isolate_move

 write to 0xffffa102789c4510 of 8 bytes by task 823 on cpu 39:
  list_lru_isolate_move+0xf9/0x130
  list_lru_isolate_move at mm/list_lru.c:180
  inode_lru_isolate+0x12b/0x2a0
  __list_lru_walk_one+0x122/0x3d0
  list_lru_walk_one+0x75/0xa0
  prune_icache_sb+0x8b/0xc0
  super_cache_scan+0x1b8/0x250
  do_shrink_slab+0x256/0x6d0
  shrink_slab+0x41b/0x4a0
  shrink_node+0x35c/0xd80
  balance_pgdat+0x652/0xd90
  kswapd+0x396/0x8d0
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 read to 0xffffa102789c4510 of 8 bytes by task 6345 on cpu 56:
  list_lru_count_one+0x116/0x2f0
  list_lru_count_one at mm/list_lru.c:193
  super_cache_count+0xe8/0x170
  do_shrink_slab+0x95/0x6d0
  shrink_slab+0x41b/0x4a0
  shrink_node+0x35c/0xd80
  do_try_to_free_pages+0x1f7/0xa10
  try_to_free_pages+0x26c/0x5e0
  __alloc_pages_slowpath+0x458/0x1290
  __alloc_pages_nodemask+0x3bb/0x450
  alloc_pages_vma+0x8a/0x2c0
  do_anonymous_page+0x170/0x700
  __handle_mm_fault+0xc9f/0xd00
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 56 PID: 6345 Comm: oom01 Tainted: G        W    L 5.5.0-next-20200205+ #4
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019

A shattered l.nr_items could affect the shrinker behaviour due to a data
race. Fix it by adding READ_ONCE() for the read. Since the writes are
aligned and up to word-size, assume those are safe from data races to
avoid readability issues of writing WRITE_ONCE(var, var + val).

Link: http://lkml.kernel.org/r/1581114679-5488-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-fix-a-data-race-in-list_lru_count_one
+++ a/mm/list_lru.c
@@ -190,7 +190,7 @@ unsigned long list_lru_count_one(struct
 
 	rcu_read_lock();
 	l = list_lru_from_memcg_idx(nlru, memcg_cache_id(memcg));
-	count = l->nr_items;
+	count = READ_ONCE(l->nr_items);
 	rcu_read_unlock();
 
 	return count;
_

Patches currently in -mm which might be from cai@lca.pw are

mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
