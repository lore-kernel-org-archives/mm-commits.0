From: akpm@linux-foundation.org
Subject: + mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
 added to -mm tree
Date: Fri, 18 Aug 2017 14:30:50 -0700
Message-ID: <59975c8a.BR1ydTN5k0+Tf4kX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdHRVav (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 17:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: avoid bloating arch that do not make use of HMM
has been added to the -mm tree.  Its filename is
     mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: avoid bloating arch that do not make use of HMM

This moves all new code including new page migration helper behind kernel
Kconfig option so that there is no codee bloat for arch or user that do
not want to use HMM or any of its associated features.

arm allyesconfig (without all the patchset, then with and this patch):
   text	   data	    bss	    dec	    hex	filename
83721896	46511131	27582964	157815991	96814b7	../without/vmlinux
83722364	46511131	27582964	157816459	968168b	vmlinux

Link: http://lkml.kernel.org/r/20170818032858.7447-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   22 +++++++---------------
 include/linux/migrate.h  |   13 +++++++++++++
 include/linux/mm.h       |   26 +++++++++++++++++---------
 mm/Kconfig               |    4 ++++
 mm/Makefile              |    3 ++-
 mm/hmm.c                 |    6 +++---
 mm/migrate.c             |    2 ++
 7 files changed, 48 insertions(+), 28 deletions(-)

diff -puN include/linux/memremap.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm include/linux/memremap.h
--- a/include/linux/memremap.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/include/linux/memremap.h
@@ -138,18 +138,6 @@ void *devm_memremap_pages(struct device
 struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
 
 static inline bool is_zone_device_page(const struct page *page);
-
-static inline bool is_device_private_page(const struct page *page)
-{
-	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
-}
-
-static inline bool is_device_public_page(const struct page *page)
-{
-	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
-}
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -168,17 +156,21 @@ static inline struct dev_pagemap *find_d
 {
 	return NULL;
 }
+#endif
 
+#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
 static inline bool is_device_private_page(const struct page *page)
 {
-	return false;
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
 static inline bool is_device_public_page(const struct page *page)
 {
-	return false;
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PUBLIC;
 }
-#endif
+#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
diff -puN include/linux/migrate.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm include/linux/migrate.h
--- a/include/linux/migrate.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/include/linux/migrate.h
@@ -265,6 +265,7 @@ struct migrate_vma_ops {
 				 void *private);
 };
 
+#if defined(CONFIG_MIGRATE_VMA_HELPER)
 int migrate_vma(const struct migrate_vma_ops *ops,
 		struct vm_area_struct *vma,
 		unsigned long start,
@@ -272,6 +273,18 @@ int migrate_vma(const struct migrate_vma
 		unsigned long *src,
 		unsigned long *dst,
 		void *private);
+#else
+static inline int migrate_vma(const struct migrate_vma_ops *ops,
+			      struct vm_area_struct *vma,
+			      unsigned long start,
+			      unsigned long end,
+			      unsigned long *src,
+			      unsigned long *dst,
+			      void *private)
+{
+	return -EINVAL;
+}
+#endif /* IS_ENABLED(CONFIG_MIGRATE_VMA_HELPER) */
 
 #endif /* CONFIG_MIGRATION */
 
diff -puN include/linux/mm.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm include/linux/mm.h
--- a/include/linux/mm.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/include/linux/mm.h
@@ -800,18 +800,27 @@ static inline bool is_zone_device_page(c
 }
 #endif
 
-#if IS_ENABLED(CONFIG_DEVICE_PRIVATE) ||  IS_ENABLED(CONFIG_DEVICE_PUBLIC)
+#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
 void put_zone_device_private_or_public_page(struct page *page);
-#else
+DECLARE_STATIC_KEY_FALSE(device_private_key);
+#define IS_HMM_ENABLED static_branch_unlikely(&device_private_key)
+static inline bool is_device_private_page(const struct page *page);
+static inline bool is_device_public_page(const struct page *page);
+#else /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 static inline void put_zone_device_private_or_public_page(struct page *page)
 {
 }
+#define IS_HMM_ENABLED 0
+static inline bool is_device_private_page(const struct page *page)
+{
+	return false;
+}
+static inline bool is_device_public_page(const struct page *page)
+{
+	return false;
+}
 #endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
-static inline bool is_device_private_page(const struct page *page);
-static inline bool is_device_public_page(const struct page *page);
-
-DECLARE_STATIC_KEY_FALSE(device_private_key);
 
 static inline void get_page(struct page *page)
 {
@@ -834,9 +843,8 @@ static inline void put_page(struct page
 	 * free and we need to inform the device driver through callback. See
 	 * include/linux/memremap.h and HMM for details.
 	 */
-	if (static_branch_unlikely(&device_private_key) &&
-	    unlikely(is_device_private_page(page) ||
-		     is_device_public_page(page))) {
+	if (IS_HMM_ENABLED && unlikely(is_device_private_page(page) ||
+	    unlikely(is_device_public_page(page)))) {
 		put_zone_device_private_or_public_page(page);
 		return;
 	}
diff -puN mm/Kconfig~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm mm/Kconfig
--- a/mm/Kconfig~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/mm/Kconfig
@@ -702,8 +702,12 @@ config ARCH_HAS_HMM
 	depends on MEMORY_HOTREMOVE
 	depends on SPARSEMEM_VMEMMAP
 
+config MIGRATE_VMA_HELPER
+	bool
+
 config HMM
 	bool
+	select MIGRATE_VMA_HELPER
 
 config HMM_MIRROR
 	bool "HMM mirror CPU page table into a device page table"
diff -puN mm/Makefile~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm mm/Makefile
--- a/mm/Makefile~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/mm/Makefile
@@ -39,7 +39,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
 			   compaction.o vmacache.o swap_slots.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o hmm.o $(mmu-y)
+			   debug.o $(mmu-y)
 
 obj-y += init-mm.o
 
@@ -104,3 +104,4 @@ obj-$(CONFIG_FRAME_VECTOR) += frame_vect
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
+obj-$(CONFIG_HMM) += hmm.o
diff -puN mm/hmm.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm mm/hmm.c
--- a/mm/hmm.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/mm/hmm.c
@@ -35,17 +35,17 @@
 
 #define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
-
+#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
 /*
  * Device private memory see HMM (Documentation/vm/hmm.txt) or hmm.h
  */
 DEFINE_STATIC_KEY_FALSE(device_private_key);
 EXPORT_SYMBOL(device_private_key);
+static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
+#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
 
 #ifdef CONFIG_HMM
-static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
-
 /*
  * struct hmm - HMM per mm struct
  *
diff -puN mm/migrate.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm mm/migrate.c
--- a/mm/migrate.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/mm/migrate.c
@@ -2132,6 +2132,7 @@ out_unlock:
 
 #endif /* CONFIG_NUMA */
 
+#if defined(CONFIG_MIGRATE_VMA_HELPER)
 struct migrate_vma {
 	struct vm_area_struct	*vma;
 	unsigned long		*dst;
@@ -2985,3 +2986,4 @@ int migrate_vma(const struct migrate_vma
 	return 0;
 }
 EXPORT_SYMBOL(migrate_vma);
+#endif /* defined(MIGRATE_VMA_HELPER) */
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
lib-interval_tree-fast-overlap-detection-fix.patch

