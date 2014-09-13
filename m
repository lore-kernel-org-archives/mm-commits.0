From: akpm@linux-foundation.org
Subject: +
 mm-introduce-common-page-state-for-ballooned-memory-fix-v2.patch added to
 -mm tree
Date: Fri, 12 Sep 2014 17:07:53 -0700
Message-ID: <54138ad9.exlLt6UN1Z4fw1Oa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIMAHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 20:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-common-page-state-for-ballooned-memory-fix-v2
has been added to the -mm tree.  Its filename is
     mm-introduce-common-page-state-for-ballooned-memory-fix-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-common-page-state-for-ballooned-memory-fix-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-common-page-state-for-ballooned-memory-fix-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm-introduce-common-page-state-for-ballooned-memory-fix-v2

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/Kconfig  |    1 -
 include/linux/mm.h      |   14 ++++++++++++--
 mm/Makefile             |    3 +--
 mm/balloon_compaction.c |   16 ----------------
 4 files changed, 13 insertions(+), 21 deletions(-)

diff -puN drivers/virtio/Kconfig~mm-introduce-common-page-state-for-ballooned-memory-fix-v2 drivers/virtio/Kconfig
--- a/drivers/virtio/Kconfig~mm-introduce-common-page-state-for-ballooned-memory-fix-v2
+++ a/drivers/virtio/Kconfig
@@ -25,7 +25,6 @@ config VIRTIO_PCI
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
-	select MEMORY_BALLOON
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
diff -puN include/linux/mm.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2 include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2
+++ a/include/linux/mm.h
@@ -561,8 +561,18 @@ static inline int PageBalloon(struct pag
 	return IS_ENABLED(CONFIG_MEMORY_BALLOON) &&
 		atomic_read(&page->_mapcount) == PAGE_BALLOON_MAPCOUNT_VALUE;
 }
-void __SetPageBalloon(struct page *page);
-void __ClearPageBalloon(struct page *page);
+
+static inline void __SetPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
+	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
+}
+
+static inline void __ClearPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageBalloon(page), page);
+	atomic_set(&page->_mapcount, -1);
+}
 
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
diff -puN mm/Makefile~mm-introduce-common-page-state-for-ballooned-memory-fix-v2 mm/Makefile
--- a/mm/Makefile~mm-introduce-common-page-state-for-ballooned-memory-fix-v2
+++ a/mm/Makefile
@@ -16,7 +16,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
-			   compaction.o vmacache.o \
+			   compaction.o balloon_compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   iov_iter.o $(mmu-y)
 
@@ -64,4 +64,3 @@ obj-$(CONFIG_ZBUD)	+= zbud.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
diff -puN mm/balloon_compaction.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2 mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2
+++ a/mm/balloon_compaction.c
@@ -10,22 +10,6 @@
 #include <linux/export.h>
 #include <linux/balloon_compaction.h>
 
-void __SetPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
-	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
-	inc_zone_page_state(page, NR_BALLOON_PAGES);
-}
-EXPORT_SYMBOL(__SetPageBalloon);
-
-void __ClearPageBalloon(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageBalloon(page), page);
-	atomic_set(&page->_mapcount, -1);
-	dec_zone_page_state(page, NR_BALLOON_PAGES);
-}
-EXPORT_SYMBOL(__ClearPageBalloon);
