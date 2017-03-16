From: akpm@linux-foundation.org
Subject: + mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:51:55 -0700
Message-ID: <58cafaeb.+4yuALACsKV3jXZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, ebaskakov@nvidia.com, jhubbard@nvidia.com, mhairgrove@nvidia.com, sgutti@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: heterogeneous memory management (HMM for short)
has been added to the -mm tree.  Its filename is
     mm-hmm-heterogeneous-memory-management-hmm-for-short.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-heterogeneous-memory-management-hmm-for-short.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: JÈrÙme Glisse <jglisse@redhat.com>
Subject: mm/hmm: heterogeneous memory management (HMM for short)

HMM provides 3 separate types of functionality:
    - Mirroring: synchronize CPU page table and device page table
    - Device memory: allocating struct page for device memory
    - Migration: migrating regular memory to device memory

This patch introduces some common helpers and definitions to all of
those 3 functionality.

Link: http://lkml.kernel.org/r/1489680335-6594-10-git-send-email-jglisse@redhat.com
Signed-off-by: JÈrÙme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS              |    7 +
 include/linux/hmm.h      |  153 +++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |    5 +
 kernel/fork.c            |    2 
 mm/Kconfig               |    4 
 mm/Makefile              |    1 
 mm/hmm.c                 |   81 +++++++++++++++++++
 7 files changed, 253 insertions(+)

diff -puN MAINTAINERS~mm-hmm-heterogeneous-memory-management-hmm-for-short MAINTAINERS
--- a/MAINTAINERS~mm-hmm-heterogeneous-memory-management-hmm-for-short
+++ a/MAINTAINERS
@@ -5964,6 +5964,13 @@ S:	Supported
 F:	drivers/scsi/hisi_sas/
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 
+HMM - Heterogeneous Memory Management
+M:	J√©r√¥me Glisse <jglisse@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/hmm*
+F:	include/linux/hmm*
+
 HOST AP DRIVER
 M:	Jouni Malinen <j@w1.fi>
 L:	linux-wireless@vger.kernel.org
diff -puN /dev/null include/linux/hmm.h
--- /dev/null
+++ a/include/linux/hmm.h
@@ -0,0 +1,153 @@
+/*
+ * Copyright 2013 Red Hat Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Authors: J√©r√¥me Glisse <jglisse@redhat.com>
+ */
+/*
+ * HMM provides 3 separate types of functionality:
+ *   - Mirroring: synchronize CPU page table and device page table
+ *   - Device memory: allocating struct pages for device memory
+ *   - Migration: migrating regular memory to device memory
+ *
+ * Each can be used independently from the others.
+ *
+ *
+ * Mirroring:
+ *
+ * HMM provides helpers to mirror a process address space on a device. For this,
+ * it provides several helpers to order device page table updates with respect
+ * to CPU page table updates. The requirement is that for any given virtual
+ * address the CPU and device page table cannot point to different physical
+ * pages. It uses the mmu_notifier API behind the scenes.
+ *
+ * Device memory:
+ *
+ * HMM provides helpers to help leverage device memory. Device memory is, at any
+ * given time, either CPU-addressable like regular memory, or completely
+ * unaddressable. In both cases the device memory is associated with dedicated
+ * struct pages (which are allocated as if for hotplugged memory). Device memory
+ * management is under the responsibility of the device driver. HMM only
+ * allocates and initializes the struct pages associated with the device memory,
+ * by hotplugging a ZONE_DEVICE memory range.
+ *
+ * Allocating struct pages for device memory allows us to use device memory
+ * almost like regular CPU memory. Unlike regular memory, however, it cannot be
+ * added to the lru, nor can any memory allocation can use device memory
+ * directly. Device memory will only end up in use by a process if the device
+ * driver migrates some of the process memory from regular memory to device
+ * memory.
+ *
+ * Migration:
+ *
+ * The existing memory migration mechanism (mm/migrate.c) does not allow using
+ * anything other than the CPU to copy from source to destination memory.
+ * Moreover, existing code does not provide a way to migrate based on a virtual
+ * address range. Existing code only supports struct-page-based migration. Also,
+ * the migration flow does not allow for graceful failure at intermediate stages
+ * of the migration process.
+ *
+ * HMM solves all of the above, by providing a simple API:
+ *
+ *      hmm_vma_migrate(ops, vma, src_pfns, dst_pfns, start, end, private);
+ *
+ * finalize_and_map(). The first,  alloc_and_copy(), allocates the destination
+ * memory and initializes it using source memory. Migration can fail at this
+ * point, and the device driver then has a place to abort the migration. The
+ * finalize_and_map() callback allows the device driver to know which pages
+ * were successfully migrated and which were not.
+ *
+ * This can easily be used outside of the original HMM use case.
+ *
+ *
+ * This header file contain all the APIs related to hmm_vma_migrate. Additional
+ * detailed documentation may be found below.
+ */
+#ifndef LINUX_HMM_H
+#define LINUX_HMM_H
+
+#include <linux/kconfig.h>
+
+#if IS_ENABLED(CONFIG_HMM)
+
+
+/*
+ * hmm_pfn_t - HMM use its own pfn type to keep several flags per page
+ *
+ * Flags:
+ * HMM_PFN_VALID: pfn is valid
+ * HMM_PFN_WRITE: CPU page table have the write permission set
+ */
+typedef unsigned long hmm_pfn_t;
+
+#define HMM_PFN_VALID (1 << 0)
+#define HMM_PFN_WRITE (1 << 1)
+#define HMM_PFN_SHIFT 2
+
+/*
+ * hmm_pfn_to_page() - return struct page pointed to by a valid hmm_pfn_t
+ * @pfn: hmm_pfn_t to convert to struct page
+ * Returns: struct page pointer if pfn is a valid hmm_pfn_t, NULL otherwise
+ *
+ * If the hmm_pfn_t is valid (ie valid flag set) then return the struct page
+ * matching the pfn value store in the hmm_pfn_t. Otherwise return NULL.
+ */
+static inline struct page *hmm_pfn_to_page(hmm_pfn_t pfn)
+{
+	if (!(pfn & HMM_PFN_VALID))
+		return NULL;
+	return pfn_to_page(pfn >> HMM_PFN_SHIFT);
+}
+
+/*
+ * hmm_pfn_to_pfn() - return pfn value store in a hmm_pfn_t
+ * @pfn: hmm_pfn_t to extract pfn from
+ * Returns: pfn value if hmm_pfn_t is valid, -1UL otherwise
+ */
+static inline unsigned long hmm_pfn_to_pfn(hmm_pfn_t pfn)
+{
+	if (!(pfn & HMM_PFN_VALID))
+		return -1UL;
+	return (pfn >> HMM_PFN_SHIFT);
+}
+
+/*
+ * hmm_pfn_from_page() - create a valid hmm_pfn_t value from struct page
+ * @page: struct page pointer for which to create the hmm_pfn_t
+ * Returns: valid hmm_pfn_t for the page
+ */
+static inline hmm_pfn_t hmm_pfn_from_page(struct page *page)
+{
+	return (page_to_pfn(page) << HMM_PFN_SHIFT) | HMM_PFN_VALID;
+}
+
+/*
+ * hmm_pfn_from_pfn() - create a valid hmm_pfn_t value from pfn
+ * @pfn: pfn value for which to create the hmm_pfn_t
+ * Returns: valid hmm_pfn_t for the pfn
+ */
+static inline hmm_pfn_t hmm_pfn_from_pfn(unsigned long pfn)
+{
+	return (pfn << HMM_PFN_SHIFT) | HMM_PFN_VALID;
+}
+
+
+/* Below are for HMM internal use only! Not to be used by device driver! */
+void hmm_mm_destroy(struct mm_struct *mm);
+
+#else /* IS_ENABLED(CONFIG_HMM) */
+
+/* Below are for HMM internal use only! Not to be used by device driver! */
+static inline void hmm_mm_destroy(struct mm_struct *mm) {}
+
+#endif /* IS_ENABLED(CONFIG_HMM) */
+#endif /* LINUX_HMM_H */
diff -puN include/linux/mm_types.h~mm-hmm-heterogeneous-memory-management-hmm-for-short include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hmm-heterogeneous-memory-management-hmm-for-short
+++ a/include/linux/mm_types.h
@@ -23,6 +23,7 @@
 
 struct address_space;
 struct mem_cgroup;
+struct hmm;
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -495,6 +496,10 @@ struct mm_struct {
 	atomic_long_t hugetlb_usage;
 #endif
 	struct work_struct async_put_work;
+#if IS_ENABLED(CONFIG_HMM)
+	/* HMM need to track few things per mm */
+	struct hmm *hmm;
+#endif
 };
 
 extern struct mm_struct init_mm;
diff -puN kernel/fork.c~mm-hmm-heterogeneous-memory-management-hmm-for-short kernel/fork.c
--- a/kernel/fork.c~mm-hmm-heterogeneous-memory-management-hmm-for-short
+++ a/kernel/fork.c
@@ -37,6 +37,7 @@
 #include <linux/binfmts.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
+#include <linux/hmm.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/vmacache.h>
@@ -863,6 +864,7 @@ void __mmdrop(struct mm_struct *mm)
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
 	destroy_context(mm);
+	hmm_mm_destroy(mm);
 	mmu_notifier_mm_destroy(mm);
 	check_mm(mm);
 	put_user_ns(mm->user_ns);
diff -puN mm/Kconfig~mm-hmm-heterogeneous-memory-management-hmm-for-short mm/Kconfig
--- a/mm/Kconfig~mm-hmm-heterogeneous-memory-management-hmm-for-short
+++ a/mm/Kconfig
@@ -289,6 +289,10 @@ config MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
+config HMM
+	bool
+	depends on MMU
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
diff -puN mm/Makefile~mm-hmm-heterogeneous-memory-management-hmm-for-short mm/Makefile
--- a/mm/Makefile~mm-hmm-heterogeneous-memory-management-hmm-for-short
+++ a/mm/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
+obj-$(CONFIG_HMM) += hmm.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
diff -puN /dev/null mm/hmm.c
--- /dev/null
+++ a/mm/hmm.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright 2013 Red Hat Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Authors: J√©r√¥me Glisse <jglisse@redhat.com>
+ */
+/*
+ * Refer to include/linux/hmm.h for information about heterogeneous memory
+ * management or HMM for short.
+ */
+#include <linux/mm.h>
+#include <linux/hmm.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+/*
+ * struct hmm - HMM per mm struct
+ *
+ * @mm: mm struct this HMM struct is bound to
+ */
+struct hmm {
+	struct mm_struct	*mm;
+};
+
+/*
+ * hmm_register - register HMM against an mm (HMM internal)
+ *
+ * @mm: mm struct to attach to
+ *
+ * This is not intended to be used directly by device drivers. It allocates an
+ * HMM struct if mm does not have one, and initializes it.
+ */
+static struct hmm *hmm_register(struct mm_struct *mm)
+{
+	if (!mm->hmm) {
+		struct hmm *hmm = NULL;
+
+		hmm = kmalloc(sizeof(*hmm), GFP_KERNEL);
+		if (!hmm)
+			return NULL;
+		hmm->mm = mm;
+
+		spin_lock(&mm->page_table_lock);
+		if (!mm->hmm)
+			mm->hmm = hmm;
+		else
+			kfree(hmm);
+		spin_unlock(&mm->page_table_lock);
+	}
+
+	/*
+	 * The hmm struct can only be freed once the mm_struct goes away,
+	 * hence we should always have pre-allocated an new hmm struct
+	 * above.
+	 */
+	return mm->hmm;
+}
+
+void hmm_mm_destroy(struct mm_struct *mm)
+{
+	struct hmm *hmm;
+
+	/*
+	 * We should not need to lock here as no one should be able to register
+	 * a new HMM while an mm is being destroy. But just to be safe ...
+	 */
+	spin_lock(&mm->page_table_lock);
+	hmm = mm->hmm;
+	mm->hmm = NULL;
+	spin_unlock(&mm->page_table_lock);
+	kfree(hmm);
+}
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

