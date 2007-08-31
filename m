From: akpm@linux-foundation.org
Subject: - git-xtensa-fixup.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:30:00 -0700
Message-ID: <200708310630.l7V6U2l4027550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbXHaGaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:30:09 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7V6U6K5006596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2007 23:30:07 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-xtensa-fixup
has been removed from the -mm tree.  Its filename was
     git-xtensa-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-xtensa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |  237 +---------------------------------------
 1 file changed, 11 insertions(+), 226 deletions(-)

diff -puN arch/xtensa/mm/init.c~git-xtensa-fixup arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~git-xtensa-fixup
+++ a/arch/xtensa/mm/init.c
@@ -307,237 +307,22 @@ void show_mem(void)
 	printk("%d free pages\n", free);
 }
 
-/* ------------------------------------------------------------------------- */
+struct kmem_cache *pgtable_cache __read_mostly;
 
-#if (DCACHE_WAY_SIZE > PAGE_SIZE)
-
-/*
- * With cache aliasing, the page color of the page in kernel space and user
- * space might mismatch. We temporarily map the page to a different virtual
- * address with the same color and clear the page there.
- */
-
-void clear_user_page(void *kaddr, unsigned long vaddr, struct page* page)
+static void pgd_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
 {
+	pte_t* ptep = (pte_t*)addr;
+	int i;
 
-  	/*  There shouldn't be any entries for this page. */
-
-	__flush_invalidate_dcache_page_phys(__pa(page_address(page)));
-
-	if (!PAGE_COLOR_EQ(vaddr, kaddr)) {
-		unsigned long v, p;
-
-		/* Temporarily map page to DTLB_WAY_DCACHE_ALIAS0. */
-
-		spin_lock(&tlb_lock);
-
-		p = (unsigned long)pte_val((mk_pte(page,PAGE_KERNEL)));
-		kaddr = (void*)PAGE_COLOR_MAP0(vaddr);
-		v = (unsigned long)kaddr | DTLB_WAY_DCACHE_ALIAS0;
-		__asm__ __volatile__("wdtlb %0,%1; dsync" : :"a" (p), "a" (v));
-
-		clear_page(kaddr);
-
-		spin_unlock(&tlb_lock);
-	} else {
-		clear_page(kaddr);
-	}
+	for (i = 0; i < 1024; i++, ptep++)
+		pte_clear(NULL, 0, ptep);
 
-	/* We need to make sure that i$ and d$ are coherent. */
-
-	clear_bit(PG_cache_clean, &page->flags);
 }
 
-/*
- * With cache aliasing, we have to make sure that the page color of the page
- * in kernel space matches that of the virtual user address before we read
- * the page. If the page color differ, we create a temporary DTLB entry with
- * the corrent page color and use this 'temporary' address as the source.
- * We then use the same approach as in clear_user_page and copy the data
- * to the kernel space and clear the PG_cache_clean bit to synchronize caches
- * later.
- *
- * Note:
- * Instead of using another 'way' for the temporary DTLB entry, we could
- * probably use the same entry that points to the kernel address (after
- * saving the original value and restoring it when we are done).
- */
-
-void copy_user_page(void* to, void* from, unsigned long vaddr,
-    		    struct page* to_page)
+void __init pgtable_cache_init(void)
 {
-	/* There shouldn't be any entries for the new page. */
-
-	__flush_invalidate_dcache_page_phys(__pa(page_address(to_page)));
-
-	spin_lock(&tlb_lock);
-
-	if (!PAGE_COLOR_EQ(vaddr, from)) {
-		unsigned long v, p, t;
-
-		__asm__ __volatile__ ("pdtlb %1,%2; rdtlb1 %0,%1"
-				      : "=a"(p), "=a"(t) : "a"(from));
-		from = (void*)PAGE_COLOR_MAP0(vaddr);
-		v = (unsigned long)from | DTLB_WAY_DCACHE_ALIAS0;
-		__asm__ __volatile__ ("wdtlb %0,%1; dsync" ::"a" (p), "a" (v));
-	}
-
-	if (!PAGE_COLOR_EQ(vaddr, to)) {
-		unsigned long v, p;
-
-		p = (unsigned long)pte_val((mk_pte(to_page,PAGE_KERNEL)));
-		to = (void*)PAGE_COLOR_MAP1(vaddr);
-		v = (unsigned long)to | DTLB_WAY_DCACHE_ALIAS1;
-		__asm__ __volatile__ ("wdtlb %0,%1; dsync" ::"a" (p), "a" (v));
-	}
-	copy_page(to, from);
-
-	spin_unlock(&tlb_lock);
-
-	/* We need to make sure that i$ and d$ are coherent. */
-
-	clear_bit(PG_cache_clean, &to_page->flags);
-}
-
-
-
-/*
- * Any time the kernel writes to a user page cache page, or it is about to
- * read from a page cache page this routine is called.
- *
- * Note:
- * The kernel currently only provides one architecture bit in the page
- * flags that we use for I$/D$ coherency. Maybe, in future, we can
- * use a sepearte bit for deferred dcache aliasing:
- * If the page is not mapped yet, we only need to set a flag,
- * if mapped, we need to invalidate the page.
- */
-// FIXME: we probably need this for WB caches not only for Page Coloring..
-
-void flush_dcache_page(struct page *page)
-{
-	unsigned long addr = __pa(page_address(page));
-	struct address_space *mapping;
-
-	__flush_invalidate_dcache_page_phys(addr);
-
-	if (!test_bit(PG_cache_clean, &page->flags))
-		return;
-
-	/* If this page hasn't been mapped, yet, handle I$/D$ coherency later.*/
-#if 0
-	/*
-	 * This function is special in that a page struct obtained via
-	 * virt_to_page from a slab object may be passed to it. However, slab
-	 * allocators may use the mapping field for their own purposes. As a
-	 * result mapping may be != NULL although the page is not mapped.
-	 * Slab objects are never mapped into user space so use NULL for that
-	 * special case.
-	 */
-	mapping = PageSlab(page) ? NULL : page_mapping(page);
-	if (mapping && !mapping_mapped(mapping))
-		clear_bit(PG_cache_clean, &page->flags);
-	else
-#endif
-		__invalidate_icache_page_phys(addr);
+	pgtable_cache = kmem_cache_create("pgd",
+			PAGE_SIZE, PAGE_SIZE,
+			SLAB_HWCACHE_ALIGN,
+			pgd_ctor);
 }
-
-void flush_cache_range(struct vm_area_struct* vma, unsigned long s,
-		       unsigned long e)
-{
-	__flush_invalidate_cache_all();
-}
-
-void flush_cache_page(struct vm_area_struct* vma, unsigned long address,
-    		      unsigned long pfn)
-{
-	struct page *page = pfn_to_page(pfn);
-
-	/* Remove any entry for the old mapping. */
-
-	if (current->active_mm == vma->vm_mm) {
-		unsigned long addr = __pa(page_address(page));
-		__flush_invalidate_dcache_page_phys(addr);
-		if ((vma->vm_flags & VM_EXEC) != 0)
-			__invalidate_icache_page_phys(addr);
-	} else {
-		BUG();
-	}
-}
-
-#endif	/* (DCACHE_WAY_SIZE > PAGE_SIZE) */
-
-
-pte_t* pte_alloc_one_kernel (struct mm_struct* mm, unsigned long addr)
-{
-	pte_t* pte = (pte_t*)__get_free_pages(GFP_KERNEL|__GFP_REPEAT, 0);
-	if (likely(pte)) {
-	       	pte_t* ptep = (pte_t*)(pte_val(*pte) + PAGE_OFFSET);
-		int i;
-		for (i = 0; i < 1024; i++, ptep++)
-			pte_clear(mm, addr, ptep);
-	}
-	return pte;
-}
-
-struct page* pte_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	struct page *page;
-
-	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT, 0);
-
-	if (likely(page)) {
-		pte_t* ptep = kmap_atomic(page, KM_USER0);
-		int i;
-
-		for (i = 0; i < 1024; i++, ptep++)
-			pte_clear(mm, addr, ptep);
-
-		kunmap_atomic(ptep, KM_USER0);
-	}
-	return page;
-}
-
-
-/*
- * Handle D$/I$ coherency.
- *
- * Note:
- * We only have one architecture bit for the page flags, so we cannot handle
- * cache aliasing, yet.
- */
-
-void
-update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t pte)
-{
-	unsigned long pfn = pte_pfn(pte);
-	struct page *page;
-	unsigned long vaddr = addr & PAGE_MASK;
-
-	if (!pfn_valid(pfn))
-		return;
-
-	page = pfn_to_page(pfn);
-
-	invalidate_itlb_mapping(addr);
-	invalidate_dtlb_mapping(addr);
-
-	/* We have a new mapping. Use it. */
-
-	write_dtlb_entry(pte, dtlb_probe(addr));
-
-	/* If the processor can execute from this page, synchronize D$/I$. */
-
-	if ((vma->vm_flags & VM_EXEC) != 0) {
-
-		write_itlb_entry(pte, itlb_probe(addr));
-
-		/* Synchronize caches, if not clean. */
-
-		if (!test_and_set_bit(PG_cache_clean, &page->flags)) {
-			__flush_dcache_page(vaddr);
-			__invalidate_icache_page(vaddr);
-		}
-	}
-}
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-ecryptfs-fix-lookup-error-for-special-files.patch
process_zones-fix-recovery-code.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-wireless-printk-fixes.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
git-xfs.patch
git-xtensa.patch
git-xtensa-fixup.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
alloc_pages-permit-get_zeroed_pagegfp_atomic-from-interrupt-context.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
