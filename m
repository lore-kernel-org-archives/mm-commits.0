From: akpm@linux-foundation.org
Subject: [merged] mm-swap-make-page_evictable-inline.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:37:11 -0700
Message-ID: <20200403203711.Vqm91iFLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUhM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: swap: make page_evictable() inline
has been removed from the -mm tree.  Its filename was
     mm-swap-make-page_evictable-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: swap: make page_evictable() inline

When backporting commit 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping
pagevecs") to our 4.9 kernel, our test bench noticed around 10% down with
a couple of vm-scalability's test cases (lru-file-readonce,
lru-file-readtwice and lru-file-mmap-read).  I didn't see that much down
on my VM (32c-64g-2nodes).  It might be caused by the test configuration,
which is 32c-256g with NUMA disabled and the tests were run in root memcg,
so the tests actually stress only one inactive and active lru.  It sounds
not very usual in mordern production environment.

That commit did two major changes:
1. Call page_evictable()
2. Use smp_mb to force the PG_lru set visible

It looks they contribute the most overhead.  The page_evictable() is a
function which does function prologue and epilogue, and that was used by
page reclaim path only.  However, lru add is a very hot path, so it sounds
better to make it inline.  However, it calls page_mapping() which is not
inlined either, but the disassemble shows it doesn't do push and pop
operations and it sounds not very straightforward to inline it.

Other than this, it sounds smp_mb() is not necessary for x86 since
SetPageLRU is atomic which enforces memory barrier already, replace it
with smp_mb__after_atomic() in the following patch.

With the two fixes applied, the tests can get back around 5% on that test
bench and get back normal on my VM.  Since the test bench configuration is
not that usual and I also saw around 6% up on the latest upstream, so it
sounds good enough IMHO.

The below is test data (lru-file-readtwice throughput) against the v5.6-rc4:
	mainline	w/ inline fix
          150MB            154MB

With this patch the throughput gets 2.67% up.  The data with using
smp_mb__after_atomic() is showed in the following patch.

Shakeel Butt did the below test:

On a real machine with limiting the 'dd' on a single node and reading 100
GiB sparse file (less than a single node).  Just ran a single instance to
not cause the lru lock contention.  The cmdline used is "dd if=file-100GiB
of=/dev/null bs=4k".  Ran the cmd 10 times with drop_caches in between and
measured the time it took.

Without patch: 56.64143 +- 0.672 sec

With patches: 56.10 +- 0.21 sec

[akpm@linux-foundation.org: move page_evictable() to internal.h]
Link: http://lkml.kernel.org/r/1584500541-46817-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping pagevecs")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    6 ++----
 include/linux/swap.h    |    1 -
 mm/internal.h           |   23 +++++++++++++++++++++++
 mm/vmscan.c             |   23 -----------------------
 4 files changed, 25 insertions(+), 28 deletions(-)

--- a/include/linux/pagemap.h~mm-swap-make-page_evictable-inline
+++ a/include/linux/pagemap.h
@@ -70,11 +70,9 @@ static inline void mapping_clear_unevict
 	clear_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
-static inline int mapping_unevictable(struct address_space *mapping)
+static inline bool mapping_unevictable(struct address_space *mapping)
 {
-	if (mapping)
-		return test_bit(AS_UNEVICTABLE, &mapping->flags);
-	return !!mapping;
+	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
 static inline void mapping_set_exiting(struct address_space *mapping)
--- a/include/linux/swap.h~mm-swap-make-page_evictable-inline
+++ a/include/linux/swap.h
@@ -374,7 +374,6 @@ extern int sysctl_min_slab_ratio;
 #define node_reclaim_mode 0
 #endif
 
-extern int page_evictable(struct page *page);
 extern void check_move_unevictable_pages(struct pagevec *pvec);
 
 extern int kswapd_run(int nid);
--- a/mm/internal.h~mm-swap-make-page_evictable-inline
+++ a/mm/internal.h
@@ -63,6 +63,29 @@ static inline unsigned long ra_submit(st
 					ra->start, ra->size, ra->async_size);
 }
 
+/**
+ * page_evictable - test whether a page is evictable
+ * @page: the page to test
+ *
+ * Test whether page is evictable--i.e., should be placed on active/inactive
+ * lists vs unevictable list.
+ *
+ * Reasons page might not be evictable:
+ * (1) page's mapping marked unevictable
+ * (2) page is part of an mlocked VMA
+ *
+ */
+static inline bool page_evictable(struct page *page)
+{
+	bool ret;
+
+	/* Prevent address_space of inode and swap cache from being freed */
+	rcu_read_lock();
+	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * Turn a non-refcounted page (->_refcount == 0) into refcounted with
  * a count of one.
--- a/mm/vmscan.c~mm-swap-make-page_evictable-inline
+++ a/mm/vmscan.c
@@ -4277,29 +4277,6 @@ int node_reclaim(struct pglist_data *pgd
 }
 #endif
 
-/*
- * page_evictable - test whether a page is evictable
- * @page: the page to test
- *
- * Test whether page is evictable--i.e., should be placed on active/inactive
- * lists vs unevictable list.
- *
- * Reasons page might not be evictable:
- * (1) page's mapping marked unevictable
- * (2) page is part of an mlocked VMA
- *
- */
-int page_evictable(struct page *page)
-{
-	int ret;
-
-	/* Prevent address_space of inode and swap cache from being freed */
-	rcu_read_lock();
-	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
-	rcu_read_unlock();
-	return ret;
-}
