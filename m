Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEB0407114
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773959592; cv=none; b=UOIYPrLxnl1Yhk5qbjEY0Pnr/QVSuiVvyjTyJWmz1LKYakSu/sU2oY3wuzVwJmm1nVm8FSAl8i3u4CUUi5roWEjOdJL0SyGrWkN2kXosVBEhmUD0awUv/ehldBC54ccCoqfwY1lJjiqNQ3JMej9DEb77GIgufjC9QHxFqtRkSEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773959592; c=relaxed/simple;
	bh=QThX9hk0IhEDlspNtttXk0HuNcMwtRy7whQ/Uv9KMfU=;
	h=Date:To:From:Subject:Message-Id; b=EEer4MuRT6/wDIJcNCnFJ2grfRW96RPxdXD9h9Dg5x7nwl3rJJQfGgcmHSQpkmSCY6gEMn9NMrAwUhNm0kfIXIlDgtyc64wmdHtqzEQfXaRVIDjE8Gbu4e+Pzh9o4quh0nHqWY0Y7jaFn6LW7wuuvd9UG7CQzo4P1yBReoi+LaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnZFSXwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnZFSXwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1D4C2BCB8;
	Thu, 19 Mar 2026 22:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773959591;
	bh=QThX9hk0IhEDlspNtttXk0HuNcMwtRy7whQ/Uv9KMfU=;
	h=Date:To:From:Subject:From;
	b=NnZFSXwlmqrzU6dI31BgYM4NmE7qnxhd35gJ7jQtm42l4uxnE2GXynts8QWx/jQlV
	 MlXZ3SSLxUosjT7sTjfnpO8pBcw7pTzavHiwEbOk7qdxIm44MzBd0RctlcGUW6aFn3
	 0s7wlf/CKGf7rAvor3MCqbL9UFkZVBePvBesd+QI=
Date: Thu, 19 Mar 2026 15:33:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,kernel@xen0n.name,joshua.hahnjy@gmail.com,jonathan.cameron@huawei.com,hpa@zytor.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,chenhuacai@kernel.org,catalin.marinas@arm.com,byungchul@sk.com,bp@alien8.de,borntraeger@linux.ibm.com,bigeasy@linutronix.de,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-config_arch_enable_memory_hotremove.patch added to mm-new branch
Message-Id: <20260319223311.5A1D4C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-config_arch_enable_memory_hotremove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-config_arch_enable_memory_hotremove.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Date: Thu, 19 Mar 2026 09:19:40 +0100

Patch series "mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and cleanup
CONFIG_MIGRATION".

While working on memory hotplug code cleanups, I realized that
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE is not really required anymore.

Changing that revealed some rather nasty looking CONFIG_MIGRATION
handling.

Let's clean that up by introducing a dedicated CONFIG_NUMA_MIGRATION
option and reducing the dependencies that CONFIG_MIGRATION has.


This patch (of 2):

All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG.  So we can just remove
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.

For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
CONFIG_CMA and CONFIG_COMPACTION already do).

We'll clean up CONFIG_MIGRATION next.

Link: https://lkml.kernel.org/r/20260319-config_migration-v1-0-42270124966f@kernel.org
Link: https://lkml.kernel.org/r/20260319-config_migration-v1-1-42270124966f@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig     |    1 -
 arch/loongarch/Kconfig |    1 -
 arch/powerpc/Kconfig   |    1 -
 arch/riscv/Kconfig     |    1 -
 arch/s390/Kconfig      |    1 -
 arch/x86/Kconfig       |    1 -
 mm/Kconfig             |    9 +++------
 7 files changed, 3 insertions(+), 12 deletions(-)

--- a/arch/arm64/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/arm64/Kconfig
@@ -16,7 +16,6 @@ config ARM64
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
--- a/arch/loongarch/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/loongarch/Kconfig
@@ -12,7 +12,6 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
--- a/arch/powerpc/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/powerpc/Kconfig
@@ -126,7 +126,6 @@ config PPC
 	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_COPY_MC			if PPC64
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
--- a/arch/riscv/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/riscv/Kconfig
@@ -21,7 +21,6 @@ config RISCV
 	select ARCH_DMA_DEFAULT_COHERENT
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
-	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
--- a/arch/s390/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/s390/Kconfig
@@ -85,7 +85,6 @@ config S390
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
--- a/arch/x86/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/arch/x86/Kconfig
@@ -69,7 +69,6 @@ config X86
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
-	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
--- a/mm/Kconfig~mm-remove-config_arch_enable_memory_hotremove
+++ a/mm/Kconfig
@@ -465,9 +465,6 @@ config HAVE_BOOTMEM_INFO_NODE
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	bool
 
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	bool
-
 # eventually, we can have this option just 'select SPARSEMEM'
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
@@ -540,8 +537,8 @@ endchoice
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
-	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
-	depends on MIGRATION
+	depends on MEMORY_HOTPLUG
+	select MIGRATION
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
@@ -636,7 +633,7 @@ config PAGE_REPORTING
 config MIGRATION
 	bool "Page migration"
 	default y
-	depends on (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
+	depends on (NUMA || MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful in
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
kasan-docs-slub-is-the-only-remaining-slab-implementation.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch
mm-memory_hotplug-remove-for_each_valid_pfn-usage.patch
mm-sparse-remove-warn_ons-from-onlineoffline_mem_sections.patch
mm-kconfig-make-config_memory_hotplug-depend-on-config_sparsemem_vmemmap.patch
mm-memory_hotplug-simplify-check_pfn_span.patch
mm-sparse-remove-config_sparsemem_vmemmap-leftovers-for-config_memory_hotplug.patch
mm-bootmem_info-remove-handling-for-config_sparsemem_vmemmap.patch
mm-bootmem_info-avoid-using-sparse_decode_mem_map.patch
mm-sparse-remove-sparse_decode_mem_map.patch
mm-sparse-remove-config_memory_hotplug-specific-usemap-allocation-handling.patch
mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch
mm-sparse-drop-set_section_nid-from-sparse_add_section.patch
mm-sparse-move-sparse_init_one_section-to-internalh.patch
mm-sparse-move-__section_mark_present-to-internalh.patch
mm-sparse-move-memory-hotplug-bits-to-sparse-vmemmapc.patch
mm-remove-config_arch_enable_memory_hotremove.patch
mm-introduce-config_numa_migration-and-simplify-config_migration.patch

