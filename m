From: akpm@linux-foundation.org
Subject: [patch 030/126] mm/hmm: avoid bloating arch that do not
 make use of HMM
Date: Fri, 08 Sep 2017 16:12:32 -0700
Message-ID: <20170908231232.VH-p13b4V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdIHXMe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dan.j.williams@intel.com, jglisse@redhat.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org

From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: avoid bloating arch that do not make use of HMM

This moves all new code including new page migration helper behind kernel
Kconfig option so that there is no codee bloat for arch or user that do
not want to use HMM or any of its associated features.

arm allyesconfig (without all the patchset, then with and this patch):
   text	   data	    bss	    dec	    hex	filename
83721896	46511131	27582964	157815991	96814b7	../without/vmlinux
83722364	46511131	27582964	157816459	968168b	vmlinux

[jglisse@redhat.com: struct hmm is only use by HMM mirror functionality]
  Link: http://lkml.kernel.org/r/20170825213133.27286-1-jglisse@redhat.com
[sfr@canb.auug.org.au: fix build (arm multi_v7_defconfig)]
  Link: http://lkml.kernel.org/r/20170828181849.323ab81b@canb.auug.org.au
Link: http://lkml.kernel.org/r/20170818032858.7447-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h      |    9 ++++++---
 include/linux/memremap.h |   22 +++++++---------------
 include/linux/migrate.h  |   13 +++++++++++++
 include/linux/mm.h       |   26 +++++++++++++++++---------
 mm/Kconfig               |    4 ++++
 mm/Makefile              |    3 ++-
 mm/hmm.c                 |    7 +++----
 mm/migrate.c             |    2 ++
 8 files changed, 54 insertions(+), 32 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/include/linux/hmm.h
@@ -501,18 +501,21 @@ void hmm_device_put(struct hmm_device *h
 
 
 /* Below are for HMM internal use only! Not to be used by device driver! */
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
 void hmm_mm_destroy(struct mm_struct *mm);
 
 static inline void hmm_mm_init(struct mm_struct *mm)
 {
 	mm->hmm = NULL;
 }
+#else /* IS_ENABLED(CONFIG_HMM_MIRROR) */
+static inline void hmm_mm_destroy(struct mm_struct *mm) {}
+static inline void hmm_mm_init(struct mm_struct *mm) {}
+#endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
-#else /* IS_ENABLED(CONFIG_HMM) */
 
-/* Below are for HMM internal use only! Not to be used by device driver! */
+#else /* IS_ENABLED(CONFIG_HMM) */
 static inline void hmm_mm_destroy(struct mm_struct *mm) {}
 static inline void hmm_mm_init(struct mm_struct *mm) {}
-
 #endif /* IS_ENABLED(CONFIG_HMM) */
 #endif /* LINUX_HMM_H */
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
@@ -35,15 +35,16 @@
 
 #define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
-
+#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
 /*
  * Device private memory see HMM (Documentation/vm/hmm.txt) or hmm.h
  */
 DEFINE_STATIC_KEY_FALSE(device_private_key);
 EXPORT_SYMBOL(device_private_key);
+#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
 
 
-#ifdef CONFIG_HMM
+#if IS_ENABLED(CONFIG_HMM_MIRROR)
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 
 /*
@@ -128,9 +129,7 @@ void hmm_mm_destroy(struct mm_struct *mm
 {
 	kfree(mm->hmm);
 }
-#endif /* CONFIG_HMM */
 
-#if IS_ENABLED(CONFIG_HMM_MIRROR)
 static void hmm_invalidate_range(struct hmm *hmm,
 				 enum hmm_update_type action,
 				 unsigned long start,
diff -puN mm/migrate.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm mm/migrate.c
--- a/mm/migrate.c~mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm
+++ a/mm/migrate.c
@@ -2127,6 +2127,7 @@ out_unlock:
 
 #endif /* CONFIG_NUMA */
 
+#if defined(CONFIG_MIGRATE_VMA_HELPER)
 struct migrate_vma {
 	struct vm_area_struct	*vma;
 	unsigned long		*dst;
@@ -2980,3 +2981,4 @@ int migrate_vma(const struct migrate_vma
 	return 0;
 }
 EXPORT_SYMBOL(migrate_vma);
+#endif /* defined(MIGRATE_VMA_HELPER) */
_
