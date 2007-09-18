From: akpm@linux-foundation.org
Subject: - revert-x86_64-mm-cpa-clflush.patch removed from -mm tree
Date: Tue, 18 Sep 2007 01:17:19 -0600
Message-ID: <200709180717.l8I7HKPZ025529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbXIRHRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 03:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-mm-cpa-clflush
has been removed from the -mm tree.  Its filename was
     revert-x86_64-mm-cpa-clflush.patch

This patch was dropped because the iommu patches depend on the busted stuff

------------------------------------------------------
Subject: revert x86_64-mm-cpa-clflush
From: Andrew Morton <akpm@linux-foundation.org>

This makes the Vaio hang when exitting X

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/pageattr.c      |   72 +++++-------------------------
 arch/x86_64/mm/pageattr.c    |   77 +++++++--------------------------
 include/asm-i386/pgtable.h   |    2 
 include/asm-x86_64/pgtable.h |    1 
 4 files changed, 30 insertions(+), 122 deletions(-)

diff -puN arch/i386/mm/pageattr.c~revert-x86_64-mm-cpa-clflush arch/i386/mm/pageattr.c
--- a/arch/i386/mm/pageattr.c~revert-x86_64-mm-cpa-clflush
+++ a/arch/i386/mm/pageattr.c
@@ -14,13 +14,7 @@
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 
-#define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
-#define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
-#define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
-
 static DEFINE_SPINLOCK(cpa_lock);
-/* Both protected by cpa_lock */
-static int full_flush;
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 
 
@@ -74,11 +68,6 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-struct flush_arg {
-	int full_flush;
-	struct list_head l;
-};
-
 static void cache_flush_page(struct page *p)
 { 
 	void *adr = page_address(p);
@@ -89,14 +78,13 @@ static void cache_flush_page(struct page
 
 static void flush_kernel_map(void *arg)
 {
-	struct flush_arg *a = (struct flush_arg *)arg;
+	struct list_head *lh = (struct list_head *)arg;
 	struct page *p;
 
-	if (!a->full_flush && cpu_has_clflush) {
-		list_for_each_entry (p, &a->l, lru) {
-			if (PageFlush(p))
-				cache_flush_page(p);
-		}
+	/* High level code is not ready for clflush yet */
+	if (0 && cpu_has_clflush) {
+		list_for_each_entry (p, lh, lru)
+			cache_flush_page(p);
 	} else if (boot_cpu_data.x86_model >= 4)
 		wbinvd();
 
@@ -148,28 +136,10 @@ static inline void revert_page(struct pa
 			    ref_prot));
 }
 
-static inline void save_page(struct page *fpage, int data)
+static inline void save_page(struct page *kpte_page)
 {
-	if (test_and_set_bit(PG_arch_1, &fpage->flags))
-		return;
-	BUG_ON(PageFlush(fpage));
-	if (data) {
-		if (!cpu_has_clflush)
-			return;
-		SetPageFlush(fpage);
-	}
-	list_add(&fpage->lru, &df_list);
-}
-
-static struct page *flush_page(unsigned long address)
-{
-	struct page *p;
-	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
-		return NULL;
-	p = virt_to_page(address);
-	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
-		return NULL;
-	return p;
+	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
+		list_add(&kpte_page->lru, &df_list);
 }
 
 static int
@@ -188,18 +158,6 @@ __change_page_attr(struct page *page, pg
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
-	BUG_ON(PageLRU(kpte_page));
-
-	/* Do caching attributes change?
-	   Note: this will need changes if the PAT bit is used (it isn't
-   	   currently) because that one varies between 2MB and 4K pages. */
-	if ((pte_val(*kpte)&_PAGE_CACHE) != (pgprot_val(prot)&_PAGE_CACHE)) {
-		struct page *p = flush_page(address);
-		if (!p)
-			full_flush = 1;
-		else
-			save_page(p, 1);
-	}
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
 		if (!pte_huge(*kpte)) {
@@ -231,7 +189,7 @@ __change_page_attr(struct page *page, pg
 	 * replace it with a largepage.
 	 */
 
-	save_page(kpte_page, 0);
+	save_page(kpte_page);
 	if (!PageReserved(kpte_page)) {
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
 			paravirt_release_pt(page_to_pfn(kpte_page));
@@ -277,22 +235,18 @@ int change_page_attr(struct page *page, 
 
 void global_flush_tlb(void)
 {
-	struct flush_arg arg;
+	struct list_head l;
 	struct page *pg, *next;
 
 	BUG_ON(irqs_disabled());
 
 	spin_lock_irq(&cpa_lock);
-	arg.full_flush = full_flush;
-	full_flush = 0;
-	list_replace_init(&df_list, &arg.l);
+	list_replace_init(&df_list, &l);
 	spin_unlock_irq(&cpa_lock);
-	flush_map(&arg);
-	list_for_each_entry_safe(pg, next, &arg.l, lru) {
+	flush_map(&l);
+	list_for_each_entry_safe(pg, next, &l, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
-		if (TestClearPageFlush(pg))
-			continue;
 		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
diff -puN arch/x86_64/mm/pageattr.c~revert-x86_64-mm-cpa-clflush arch/x86_64/mm/pageattr.c
--- a/arch/x86_64/mm/pageattr.c~revert-x86_64-mm-cpa-clflush
+++ a/arch/x86_64/mm/pageattr.c
@@ -13,10 +13,6 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
-#define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
-#define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
-#define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
-
 pte_t *lookup_address(unsigned long address)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -65,11 +61,6 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-struct flush_arg {
-	int full_flush;
-	struct list_head l;
-};
-
 static void cache_flush_page(void *adr)
 {
 	int i;
@@ -79,16 +70,17 @@ static void cache_flush_page(void *adr)
 
 static void flush_kernel_map(void *arg)
 {
-	struct flush_arg *a = (struct flush_arg *)arg;
+	struct list_head *l = (struct list_head *)arg;
 	struct page *pg;
 
-	/* When clflush is available use it because it is
+	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if (a->full_flush || !cpu_has_clflush)
+	/* clflush is still broken. Disable for now. */
+	if (1 || !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
-	else list_for_each_entry(pg, &a->l, lru) {
-		if (PageFlush(pg))
-			cache_flush_page(page_address(pg));
+	else list_for_each_entry(pg, l, lru) {
+		void *adr = page_address(pg);
+		cache_flush_page(adr);
 	}
 	__flush_tlb_all();
 }
@@ -98,21 +90,12 @@ static inline void flush_map(struct list
 	on_each_cpu(flush_kernel_map, l, 1, 1);
 }
 
-/* both protected by init_mm.mmap_sem */
-static int full_flush;
-static LIST_HEAD(deferred_pages);
+static LIST_HEAD(deferred_pages); /* protected by init_mm.mmap_sem */
 
-static inline void save_page(struct page *fpage, int data)
+static inline void save_page(struct page *fpage)
 {
-	if (test_and_set_bit(PG_arch_1, &fpage->flags))
-		return;
-	BUG_ON(PageFlush(fpage));
-	if (data) {
-		if (!cpu_has_clflush)
-			return;
-		SetPageFlush(fpage);
-	}
-	list_add(&fpage->lru, &deferred_pages);
+	if (!test_and_set_bit(PG_arch_1, &fpage->flags))
+		list_add(&fpage->lru, &deferred_pages);
 }
 
 /* 
@@ -139,17 +122,6 @@ static void revert_page(unsigned long ad
 	set_pte((pte_t *)pmd, large_pte);
 }      
 
-static struct page *flush_page(unsigned long address)
-{
-	struct page *p;
-	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
-		return NULL;
-	p = virt_to_page(address);
-	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
-		return NULL;
-	return p;
-}
-
 static int
 __change_page_attr(unsigned long address, unsigned long pfn, pgprot_t prot,
 				   pgprot_t ref_prot)
@@ -161,19 +133,8 @@ __change_page_attr(unsigned long address
 	kpte = lookup_address(address);
 	if (!kpte) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
-	BUG_ON(PageCompound(kpte_page));
 	BUG_ON(PageLRU(kpte_page));
-
-	/* Do caching attributes change?
-	   Note: this will need changes if the PAT bit is used (it isn't
-   	   currently) because that one varies between 2MB and 4K pages. */
-	if ((pte_val(*kpte)&_PAGE_CACHE) != (pgprot_val(prot)&_PAGE_CACHE)) {
-		struct page *p = flush_page(address);
-		if (!p)
-			full_flush = 1;
-		else
-			save_page(p, 1);
-	}
+	BUG_ON(PageCompound(kpte_page));
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
 			set_pte(kpte, pfn_pte(pfn, prot));
@@ -201,7 +162,7 @@ __change_page_attr(unsigned long address
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
  	BUG_ON(PageReserved(kpte_page));
 
-	save_page(kpte_page, 0);
+	save_page(kpte_page);
 	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
@@ -266,21 +227,17 @@ int change_page_attr(struct page *page, 
 void global_flush_tlb(void)
 { 
 	struct page *pg, *next;
-	struct flush_arg arg;
+	struct list_head l;
 
 	down_read(&init_mm.mmap_sem);
-	arg.full_flush = full_flush;
-	full_flush = 0;
-	list_replace_init(&deferred_pages, &arg.l);
+	list_replace_init(&deferred_pages, &l);
 	up_read(&init_mm.mmap_sem);
 
-	flush_map(&arg);
+	flush_map(&l);
 
-	list_for_each_entry_safe(pg, next, &arg.l, lru) {
+	list_for_each_entry_safe(pg, next, &l, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);
-		if (TestClearPageFlush(pg))
-			continue;
 		if (page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
diff -puN include/asm-i386/pgtable.h~revert-x86_64-mm-cpa-clflush include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~revert-x86_64-mm-cpa-clflush
+++ a/include/asm-i386/pgtable.h
@@ -128,8 +128,6 @@ void paging_init(void);
 #else
 #define _PAGE_NX	0
 #endif
-#define _PAGE_CACHE	(_PAGE_PCD|_PAGE_PWT)
-
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
diff -puN include/asm-x86_64/pgtable.h~revert-x86_64-mm-cpa-clflush include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~revert-x86_64-mm-cpa-clflush
+++ a/include/asm-x86_64/pgtable.h
@@ -165,7 +165,6 @@ static inline pte_t ptep_get_and_clear_f
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
 #define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
-#define _PAGE_CACHE	(_PAGE_PCD|_PAGE_PWT)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
disable-sys_timerfd-for-2623.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
alsa-procfs-fix.patch
git-alsa-sc6000-build-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-sysfs-spit-a-warning-to-users-when-they-try-to-create-a-duplicate-sysfs-file.patch
fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-jg-misc-fix.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mips-fixup.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fixup.patch
git-net-fix-2.patch
nit-net-skge-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
net-atm-lecc-printk-warning-fix.patch
git-net-af_iucv-fixes.patch
git-net-sgiseeq-fix.patch
git-net-fix-ibmveth.patch
git-net-broke-ipg-add-ip1000a-driver-to-kernel-tree.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-block-fix-u14-34f.patch
git-block-fix-qlogicpti-build.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-net-vs-git-wireless.patch
git-net-vs-git-wireless-2.patch
net-add-ath5k-wireless-driver-fix.patch
git-net-vs-git-wireless-3.patch
git-net-broke-git-wireless.patch
iwl3945-is-bust.patch
more-wireless-borkage.patch
more-wireless-borkage-2.patch
more-wireless-borkage-3.patch
p54pci-terminate-pci-table.patch
git-wireless-fix-99.patch
git-wireless-b44-is-bust.patch
revert-x86_64-mm-cpa-clflush.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
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
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
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
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
