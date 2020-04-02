From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-make-page_evictable-inline-fix.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:27:36 -0700
Message-ID: <20200402032736.bguhunxIe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733044AbgDBD1i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-swap-make-page_evictable-inline-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-make-page_evictable-inline-fix.patch

This patch was dropped because it was folded into mm-swap-make-page_evictable-inline.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-make-page_evictable-inline-fix

move page_evictable() to internal.h

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   23 -----------------------
 mm/internal.h           |   23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/pagemap.h~mm-swap-make-page_evictable-inline-fix
+++ a/include/linux/pagemap.h
@@ -116,29 +116,6 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
-/**
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
-static inline bool page_evictable(struct page *page)
-{
-	bool ret;
-
-	/* Prevent address_space of inode and swap cache from being freed */
-	rcu_read_lock();
-	ret = !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
-	rcu_read_unlock();
-	return ret;
-}
-
 void release_pages(struct page **pages, int nr);
 
 /*
--- a/mm/internal.h~mm-swap-make-page_evictable-inline-fix
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-make-page_evictable-inline.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
