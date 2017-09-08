From: akpm@linux-foundation.org
Subject: [patch 012/126] mm/hmm: heterogeneous memory management
 (HMM for short)
Date: Fri, 08 Sep 2017 16:11:23 -0700
Message-ID: <20170908231123.7igA8VEr2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756895AbdIHXL2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/hmm: heterogeneous memory management (HMM for short)

HMM provides 3 separate types of functionality:
    - Mirroring: synchronize CPU page table and device page table
    - Device memory: allocating struct page for device memory
    - Migration: migrating regular memory to device memory

This patch introduces some common helpers and definitions to all of
those 3 functionality.

Link: http://lkml.kernel.org/r/20170817000548.32038-3-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Mark Hairgrove <mhairgrove@nvidia.com>
Signed-off-by: Sherry Cheung <SCheung@nvidia.com>
Signed-off-by: Subhash Gutti <sgutti@nvidia.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h      |  152 +++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |    6 +
 kernel/fork.c            |    3 
 mm/Kconfig               |   13 +++
 mm/Makefile              |    2 
 mm/hmm.c                 |   74 ++++++++++++++++++
 6 files changed, 249 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/hmm.h
--- /dev/null
+++ a/include/linux/hmm.h
@@ -0,0 +1,152 @@
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
+ * Authors: JÃ©rÃ´me Glisse <jglisse@redhat.com>
+ */
+/*
+ * Heterogeneous Memory Management (HMM)
+ *
+ * See Documentation/vm/hmm.txt for reasons and overview of what HMM is and it
+ * is for. Here we focus on the HMM API description, with some explanation of
+ * the underlying implementation.
+ *
+ * Short description: HMM provides a set of helpers to share a virtual address
+ * space between CPU and a device, so that the device can access any valid
+ * address of the process (while still obeying memory protection). HMM also
+ * provides helpers to migrate process memory to device memory, and back. Each
+ * set of functionality (address space mirroring, and migration to and from
+ * device memory) can be used independently of the other.
+ *
+ *
+ * HMM address space mirroring API:
+ *
+ * Use HMM address space mirroring if you want to mirror range of the CPU page
+ * table of a process into a device page table. Here, "mirror" means "keep
+ * synchronized". Prerequisites: the device must provide the ability to write-
+ * protect its page tables (at PAGE_SIZE granularity), and must be able to
+ * recover from the resulting potential page faults.
+ *
+ * HMM guarantees that at any point in time, a given virtual address points to
+ * either the same memory in both CPU and device page tables (that is: CPU and
+ * device page tables each point to the same pages), or that one page table (CPU
+ * or device) points to no entry, while the other still points to the old page
+ * for the address. The latter case happens when the CPU page table update
+ * happens first, and then the update is mirrored over to the device page table.
+ * This does not cause any issue, because the CPU page table cannot start
+ * pointing to a new page until the device page table is invalidated.
+ *
+ * HMM uses mmu_notifiers to monitor the CPU page tables, and forwards any
+ * updates to each device driver that has registered a mirror. It also provides
+ * some API calls to help with taking a snapshot of the CPU page table, and to
+ * synchronize with any updates that might happen concurrently.
+ *
+ *
+ * HMM migration to and from device memory:
+ *
+ * HMM provides a set of helpers to hotplug device memory as ZONE_DEVICE, with
+ * a new MEMORY_DEVICE_PRIVATE type. This provides a struct page for each page
+ * of the device memory, and allows the device driver to manage its memory
+ * using those struct pages. Having struct pages for device memory makes
+ * migration easier. Because that memory is not addressable by the CPU it must
+ * never be pinned to the device; in other words, any CPU page fault can always
+ * cause the device memory to be migrated (copied/moved) back to regular memory.
+ *
+ * A new migrate helper (migrate_vma()) has been added (see mm/migrate.c) that
+ * allows use of a device DMA engine to perform the copy operation between
+ * regular system memory and device memory.
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
+ * hmm_pfn_t - HMM uses its own pfn type to keep several flags per page
+ *
+ * Flags:
+ * HMM_PFN_VALID: pfn is valid
+ * HMM_PFN_WRITE: CPU page table has write permission set
+ */
+typedef unsigned long hmm_pfn_t;
+
+#define HMM_PFN_VALID (1 << 0)
+#define HMM_PFN_WRITE (1 << 1)
+#define HMM_PFN_SHIFT 2
+
+/*
+ * hmm_pfn_t_to_page() - return struct page pointed to by a valid hmm_pfn_t
+ * @pfn: hmm_pfn_t to convert to struct page
+ * Returns: struct page pointer if pfn is a valid hmm_pfn_t, NULL otherwise
+ *
+ * If the hmm_pfn_t is valid (ie valid flag set) then return the struct page
+ * matching the pfn value stored in the hmm_pfn_t. Otherwise return NULL.
+ */
+static inline struct page *hmm_pfn_t_to_page(hmm_pfn_t pfn)
+{
+	if (!(pfn & HMM_PFN_VALID))
+		return NULL;
+	return pfn_to_page(pfn >> HMM_PFN_SHIFT);
+}
+
+/*
+ * hmm_pfn_t_to_pfn() - return pfn value store in a hmm_pfn_t
+ * @pfn: hmm_pfn_t to extract pfn from
+ * Returns: pfn value if hmm_pfn_t is valid, -1UL otherwise
+ */
+static inline unsigned long hmm_pfn_t_to_pfn(hmm_pfn_t pfn)
+{
+	if (!(pfn & HMM_PFN_VALID))
+		return -1UL;
+	return (pfn >> HMM_PFN_SHIFT);
+}
+
+/*
+ * hmm_pfn_t_from_page() - create a valid hmm_pfn_t value from struct page
+ * @page: struct page pointer for which to create the hmm_pfn_t
+ * Returns: valid hmm_pfn_t for the page
+ */
+static inline hmm_pfn_t hmm_pfn_t_from_page(struct page *page)
+{
+	return (page_to_pfn(page) << HMM_PFN_SHIFT) | HMM_PFN_VALID;
+}
+
+/*
+ * hmm_pfn_t_from_pfn() - create a valid hmm_pfn_t value from pfn
+ * @pfn: pfn value for which to create the hmm_pfn_t
+ * Returns: valid hmm_pfn_t for the pfn
+ */
+static inline hmm_pfn_t hmm_pfn_t_from_pfn(unsigned long pfn)
+{
+	return (pfn << HMM_PFN_SHIFT) | HMM_PFN_VALID;
+}
+
+
+/* Below are for HMM internal use only! Not to be used by device driver! */
+void hmm_mm_destroy(struct mm_struct *mm);
+
+static inline void hmm_mm_init(struct mm_struct *mm)
+{
+	mm->hmm = NULL;
+}
+
+#else /* IS_ENABLED(CONFIG_HMM) */
+
+/* Below are for HMM internal use only! Not to be used by device driver! */
+static inline void hmm_mm_destroy(struct mm_struct *mm) {}
+static inline void hmm_mm_init(struct mm_struct *mm) {}
+
+#endif /* IS_ENABLED(CONFIG_HMM) */
+#endif /* LINUX_HMM_H */
diff -puN include/linux/mm_types.h~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5 include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5
+++ a/include/linux/mm_types.h
@@ -23,6 +23,7 @@
 
 struct address_space;
 struct mem_cgroup;
+struct hmm;
 
 /*
  * Each physical page in the system has a struct page associated with
@@ -503,6 +504,11 @@ struct mm_struct {
 	atomic_long_t hugetlb_usage;
 #endif
 	struct work_struct async_put_work;
+
+#if IS_ENABLED(CONFIG_HMM)
+	/* HMM needs to track a few things per mm */
+	struct hmm *hmm;
+#endif
 } __randomize_layout;
 
 extern struct mm_struct init_mm;
diff -puN kernel/fork.c~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5 kernel/fork.c
--- a/kernel/fork.c~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5
+++ a/kernel/fork.c
@@ -37,6 +37,7 @@
 #include <linux/binfmts.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
+#include <linux/hmm.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/vmacache.h>
@@ -824,6 +825,7 @@ static struct mm_struct *mm_init(struct
 	mm_init_owner(mm, p);
 	RCU_INIT_POINTER(mm->exe_file, NULL);
 	mmu_notifier_mm_init(mm);
+	hmm_mm_init(mm);
 	init_tlb_flush_pending(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	mm->pmd_huge_pte = NULL;
@@ -903,6 +905,7 @@ void __mmdrop(struct mm_struct *mm)
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
 	destroy_context(mm);
+	hmm_mm_destroy(mm);
 	mmu_notifier_mm_destroy(mm);
 	check_mm(mm);
 	put_user_ns(mm->user_ns);
diff -puN mm/Kconfig~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5 mm/Kconfig
--- a/mm/Kconfig~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5
+++ a/mm/Kconfig
@@ -692,6 +692,19 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config ARCH_HAS_HMM
+	bool
+	default y
+	depends on (X86_64 || PPC64)
+	depends on ZONE_DEVICE
+	depends on MMU && 64BIT
+	depends on MEMORY_HOTPLUG
+	depends on MEMORY_HOTREMOVE
+	depends on SPARSEMEM_VMEMMAP
+
+config HMM
+	bool
+
 config FRAME_VECTOR
 	bool
 
diff -puN mm/Makefile~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5 mm/Makefile
--- a/mm/Makefile~mm-hmm-heterogeneous-memory-management-hmm-for-short-v5
+++ a/mm/Makefile
@@ -39,7 +39,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
 			   compaction.o vmacache.o swap_slots.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o $(mmu-y)
+			   debug.o hmm.o $(mmu-y)
 
 obj-y += init-mm.o
 
diff -puN /dev/null mm/hmm.c
--- /dev/null
+++ a/mm/hmm.c
@@ -0,0 +1,74 @@
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
+ * Authors: JÃ©rÃ´me Glisse <jglisse@redhat.com>
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
+
+#ifdef CONFIG_HMM
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
+	kfree(mm->hmm);
+}
+#endif /* CONFIG_HMM */
_
