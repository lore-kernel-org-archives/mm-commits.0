From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-balloon_compaction-use-common-page-ballooning-v2.patch removed from -mm
 tree
Date: Fri, 19 Sep 2014 23:21:34 -0700
Message-ID: <541d1cee.WO2m9xzYwZ0AlqAx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaITGVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:21:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon_compaction-use-common-page-ballooning-v2
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-use-common-page-ballooning-v2.patch

This patch was dropped because it was folded into mm-balloon_compaction-use-common-page-ballooning.patch

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm-balloon_compaction-use-common-page-ballooning-v2

This patch replaces checking AS_BALLOON_MAP in page->mapping->flags
with PageBalloon which is stored directly in the struct page.
All code of balloon_compaction now under CONFIG_MEMORY_BALLOON.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/Kconfig             |    1 
 include/linux/balloon_compaction.h |   49 +++++++++++----------------
 mm/Makefile                        |    3 +
 mm/migrate.c                       |    2 +
 4 files changed, 26 insertions(+), 29 deletions(-)

diff -puN drivers/virtio/Kconfig~mm-balloon_compaction-use-common-page-ballooning-v2 drivers/virtio/Kconfig
--- a/drivers/virtio/Kconfig~mm-balloon_compaction-use-common-page-ballooning-v2
+++ a/drivers/virtio/Kconfig
@@ -25,6 +25,7 @@ config VIRTIO_PCI
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
+	select MEMORY_BALLOON
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-use-common-page-ballooning-v2 include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-use-common-page-ballooning-v2
+++ a/include/linux/balloon_compaction.h
@@ -46,6 +46,8 @@
 #include <linux/gfp.h>
 #include <linux/err.h>
 
+#ifdef CONFIG_MEMORY_BALLOON
+
 /*
  * Balloon device information descriptor.
  * This struct is used to allow the common balloon compaction interface
@@ -93,20 +95,6 @@ static inline void balloon_page_free(str
 	__free_page(page);
 }
 
-#ifdef CONFIG_BALLOON_COMPACTION
-extern bool balloon_page_isolate(struct page *page);
-extern void balloon_page_putback(struct page *page);
-extern int balloon_page_migrate(struct page *newpage,
-				struct page *page, enum migrate_mode mode);
-extern struct address_space
-*balloon_mapping_alloc(struct balloon_dev_info *b_dev_info,
-			const struct address_space_operations *a_ops);
-
-static inline void balloon_mapping_free(struct address_space *balloon_mapping)
-{
-	kfree(balloon_mapping);
-}
-
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
  *		         the page->mapping assignment accordingly.
@@ -122,6 +110,7 @@ static inline void balloon_page_insert(s
 				       struct list_head *head)
 {
 	__SetPageBalloon(page);
+	inc_zone_page_state(page, NR_BALLOON_PAGES);
 	page->mapping = mapping;
 	list_add(&page->lru, head);
 }
@@ -137,10 +126,28 @@ static inline void balloon_page_insert(s
 static inline void balloon_page_delete(struct page *page)
 {
 	__ClearPageBalloon(page);
+	dec_zone_page_state(page, NR_BALLOON_PAGES);
 	page->mapping = NULL;
 	list_del(&page->lru);
 }
 
+#endif /* CONFIG_MEMORY_BALLOON */
+
+#ifdef CONFIG_BALLOON_COMPACTION
+
+extern bool balloon_page_isolate(struct page *page);
+extern void balloon_page_putback(struct page *page);
+extern int balloon_page_migrate(struct page *newpage,
+				struct page *page, enum migrate_mode mode);
+extern struct address_space
+*balloon_mapping_alloc(struct balloon_dev_info *b_dev_info,
+			const struct address_space_operations *a_ops);
+
+static inline void balloon_mapping_free(struct address_space *balloon_mapping)
+{
+	kfree(balloon_mapping);
+}
+
 /*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
@@ -177,20 +184,6 @@ static inline void balloon_mapping_free(
 	return;
 }
 
-static inline void balloon_page_insert(struct page *page,
-				       struct address_space *mapping,
-				       struct list_head *head)
-{
-	__SetPageBalloon(page);
-	list_add(&page->lru, head);
-}
-
-static inline void balloon_page_delete(struct page *page)
-{
-	__ClearPageBalloon(page);
-	list_del(&page->lru);
-}
-
 static inline bool balloon_page_isolate(struct page *page)
 {
 	return false;
diff -puN mm/Makefile~mm-balloon_compaction-use-common-page-ballooning-v2 mm/Makefile
--- a/mm/Makefile~mm-balloon_compaction-use-common-page-ballooning-v2
+++ a/mm/Makefile
@@ -16,7 +16,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o balloon_compaction.o vmacache.o \
+			   compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   iov_iter.o $(mmu-y)
 
@@ -64,3 +64,4 @@ obj-$(CONFIG_ZBUD)	+= zbud.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
+obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
diff -puN mm/migrate.c~mm-balloon_compaction-use-common-page-ballooning-v2 mm/migrate.c
--- a/mm/migrate.c~mm-balloon_compaction-use-common-page-ballooning-v2
+++ a/mm/migrate.c
@@ -952,6 +952,7 @@ static int unmap_and_move(new_page_t get
 
 	rc = __unmap_and_move(page, newpage, force, mode);
 
+#ifdef CONFIG_MEMORY_BALLOON
 	if (unlikely(rc == MIGRATEPAGE_BALLOON_SUCCESS)) {
 		/*
 		 * A ballooned page has been migrated already.
@@ -963,6 +964,7 @@ static int unmap_and_move(new_page_t get
 		balloon_page_free(page);
 		return MIGRATEPAGE_SUCCESS;
 	}
+#endif
 out:
 	if (rc != -EAGAIN) {
 		/*
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
linux-next.patch

