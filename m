From: akpm@linux-foundation.org
Subject: [merged] mm-swapc-clean-up-lru_cache_add-functions.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:50:09 -0700
Message-ID: <5390c9f1.jGk/46q35DuziS6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaFETuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, sjenning@linux.vnet.ibm.com, shli@kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, iamjoonsoo.kim@lge.com, hch@lst.de, hannes@cmpxchg.org, bob.liu@oracle.com, aquini@redhat.com, aarcange@redhat.com, nasa4836@gmail.com

Subject: [merged] mm-swapc-clean-up-lru_cache_add-functions.patch removed from -mm tree
To: nasa4836@gmail.com,aarcange@redhat.com,aquini@redhat.com,bob.liu@oracle.com,hannes@cmpxchg.org,hch@lst.de,iamjoonsoo.kim@lge.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,shli@kernel.org,sjenning@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:09 -0700


The patch titled
     Subject: mm/swap.c: clean up *lru_cache_add* functions
has been removed from the -mm tree.  Its filename was
     mm-swapc-clean-up-lru_cache_add-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/swap.c: clean up *lru_cache_add* functions

In mm/swap.c, __lru_cache_add() is exported, but actually there are no
users outside this file.

This patch unexports __lru_cache_add(), and makes it static.  It also
exports lru_cache_add_file(), as it is use by cifs and fuse, which can
loaded as modules.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   19 ++-----------------
 mm/swap.c            |   31 +++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff -puN include/linux/swap.h~mm-swapc-clean-up-lru_cache_add-functions include/linux/swap.h
--- a/include/linux/swap.h~mm-swapc-clean-up-lru_cache_add-functions
+++ a/include/linux/swap.h
@@ -308,8 +308,9 @@ extern unsigned long nr_free_pagecache_p
 
 
 /* linux/mm/swap.c */
-extern void __lru_cache_add(struct page *);
 extern void lru_cache_add(struct page *);
+extern void lru_cache_add_anon(struct page *page);
+extern void lru_cache_add_file(struct page *page);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
@@ -323,22 +324,6 @@ extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
 
-/**
- * lru_cache_add: add a page to the page lists
- * @page: the page to add
- */
-static inline void lru_cache_add_anon(struct page *page)
-{
-	ClearPageActive(page);
-	__lru_cache_add(page);
-}
-
-static inline void lru_cache_add_file(struct page *page)
-{
-	ClearPageActive(page);
-	__lru_cache_add(page);
-}
-
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff -puN mm/swap.c~mm-swapc-clean-up-lru_cache_add-functions mm/swap.c
--- a/mm/swap.c~mm-swapc-clean-up-lru_cache_add-functions
+++ a/mm/swap.c
@@ -582,13 +582,7 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-/*
- * Queue the page for addition to the LRU via pagevec. The decision on whether
- * to add the page to the [in]active [file|anon] list is deferred until the
- * pagevec is drained. This gives a chance for the caller of __lru_cache_add()
- * have the page added to the active list using mark_page_accessed().
- */
-void __lru_cache_add(struct page *page)
+static void __lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
 
@@ -598,11 +592,32 @@ void __lru_cache_add(struct page *page)
 	pagevec_add(pvec, page);
 	put_cpu_var(lru_add_pvec);
 }
-EXPORT_SYMBOL(__lru_cache_add);
+
+/**
+ * lru_cache_add: add a page to the page lists
+ * @page: the page to add
+ */
+void lru_cache_add_anon(struct page *page)
+{
+	ClearPageActive(page);
+	__lru_cache_add(page);
+}
+
+void lru_cache_add_file(struct page *page)
+{
+	ClearPageActive(page);
+	__lru_cache_add(page);
+}
+EXPORT_SYMBOL(lru_cache_add_file);
 
 /**
  * lru_cache_add - add a page to a page list
  * @page: the page to be added to the LRU.
+ *
+ * Queue the page for addition to the LRU via pagevec. The decision on whether
+ * to add the page to the [in]active [file|anon] list is deferred until the
+ * pagevec is drained. This gives a chance for the caller of lru_cache_add()
+ * have the page added to the active list using mark_page_accessed().
  */
 void lru_cache_add(struct page *page)
 {
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

