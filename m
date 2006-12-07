From: akpm@osdl.org
Subject: - mm-add-arch_alloc_page.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:29 -0800
Message-ID: <200612072256.kB7MuTG6029202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163591AbWLGW4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: add arch_alloc_page
has been removed from the -mm tree.  Its filename was
     mm-add-arch_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: add arch_alloc_page
From: Nick Piggin <npiggin@suse.de>

Add an arch_alloc_page to match arch_free_page.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/gfp.h |    3 +++
 mm/page_alloc.c     |    2 ++
 2 files changed, 5 insertions(+)

diff -puN include/linux/gfp.h~mm-add-arch_alloc_page include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-arch_alloc_page
+++ a/include/linux/gfp.h
@@ -116,6 +116,9 @@ static inline enum zone_type gfp_zone(gf
 #ifndef HAVE_ARCH_FREE_PAGE
 static inline void arch_free_page(struct page *page, int order) { }
 #endif
+#ifndef HAVE_ARCH_ALLOC_PAGE
+static inline void arch_alloc_page(struct page *page, int order) { }
+#endif
 
 extern struct page *
 FASTCALL(__alloc_pages(gfp_t, unsigned int, struct zonelist *));
diff -puN mm/page_alloc.c~mm-add-arch_alloc_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-arch_alloc_page
+++ a/mm/page_alloc.c
@@ -598,6 +598,8 @@ static int prep_new_page(struct page *pa
 			1 << PG_checked | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
 	set_page_refcounted(page);
+
+	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
 
 	if (gfp_flags & __GFP_ZERO)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch

