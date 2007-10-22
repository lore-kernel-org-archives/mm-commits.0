From: akpm@linux-foundation.org
Subject: + i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:32:21 -0700
Message-ID: <200710222132.l9MLWL4C016035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbXJVVcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: Resolve dependency of asm-i386/pgtable.h on highmem.h
has been added to the -mm tree.  Its filename is
     i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: Resolve dependency of asm-i386/pgtable.h on highmem.h
From: Christoph Lameter <clameter@sgi.com>

pgtable.h does not include highmem.h but uses various constants from
highmem.h.  We cannot include highmem.h because highmem.h will in turn include
many other include files that also depend on pgtable.h

So move the definitions from highmem.h into pgtable.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/highmem.h    |    6 ------
 include/asm-x86/pgtable_32.h |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/asm-x86/highmem.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh include/asm-x86/highmem.h
--- a/include/asm-x86/highmem.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh
+++ a/include/asm-x86/highmem.h
@@ -38,11 +38,6 @@ extern pte_t *pkmap_page_table;
  * easily, subsequent pte tables have to be allocated in one physical
  * chunk of RAM.
  */
-#ifdef CONFIG_X86_PAE
-#define LAST_PKMAP 512
-#else
-#define LAST_PKMAP 1024
-#endif
 /*
  * Ordering is:
  *
@@ -58,7 +53,6 @@ extern pte_t *pkmap_page_table;
  * VMALLOC_START
  * high_memory
  */
-#define PKMAP_BASE ( (FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK )
 #define LAST_PKMAP_MASK (LAST_PKMAP-1)
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
diff -puN include/asm-x86/pgtable_32.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h~i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh
+++ a/include/asm-x86/pgtable_32.h
@@ -78,6 +78,14 @@ void paging_init(void);
 #define VMALLOC_OFFSET	(8*1024*1024)
 #define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
+#ifdef CONFIG_X86_PAE
+#define LAST_PKMAP 512
+#else
+#define LAST_PKMAP 1024
+#endif
+
+#define PKMAP_BASE ( (FIXADDR_BOOT_START - PAGE_SIZE*(LAST_PKMAP + 1)) & PMD_MASK )
+
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
 #else
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
