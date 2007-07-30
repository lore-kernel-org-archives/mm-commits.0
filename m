From: akpm@linux-foundation.org
Subject: + parisc-extern-inline-static-inline.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:05 -0700
Message-ID: <200707302247.l6UMl5Ur002480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbXG3Wsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, kyle@mcmartin.ca, willy@debian.org


The patch titled
     parisc: "extern inline" -> "static inline"
has been added to the -mm tree.  Its filename is
     parisc-extern-inline-static-inline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parisc: "extern inline" -> "static inline"
From: Adrian Bunk <bunk@stusta.de>

"extern inline" will have different semantics with gcc 4.3, and "static
inline" is correct here.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/lib/memcpy.c       |    4 +--
 include/asm-parisc/io.h        |    2 -
 include/asm-parisc/pci.h       |    2 -
 include/asm-parisc/pgtable.h   |   32 +++++++++++++++----------------
 include/asm-parisc/prefetch.h  |    4 +--
 include/asm-parisc/semaphore.h |   10 ++++-----
 include/asm-parisc/tlbflush.h  |    2 -
 7 files changed, 28 insertions(+), 28 deletions(-)

diff -puN arch/parisc/lib/memcpy.c~parisc-extern-inline-static-inline arch/parisc/lib/memcpy.c
--- a/arch/parisc/lib/memcpy.c~parisc-extern-inline-static-inline
+++ a/arch/parisc/lib/memcpy.c
@@ -139,12 +139,12 @@ DECLARE_PER_CPU(struct exception_data, e
 #define stw(_s,_t,_o,_a,_e) 	def_store_insn(stw,"r",_s,_t,_o,_a,_e)
 
 #ifdef  CONFIG_PREFETCH
-extern inline void prefetch_src(const void *addr)
+static inline void prefetch_src(const void *addr)
 {
 	__asm__("ldw 0(" s_space ",%0), %%r0" : : "r" (addr));
 }
 
-extern inline void prefetch_dst(const void *addr)
+static inline void prefetch_dst(const void *addr)
 {
 	__asm__("ldd 0(" d_space ",%0), %%r0" : : "r" (addr));
 }
diff -puN include/asm-parisc/io.h~parisc-extern-inline-static-inline include/asm-parisc/io.h
--- a/include/asm-parisc/io.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/io.h
@@ -128,7 +128,7 @@ extern void __iomem * __ioremap(unsigned
 /* Most machines react poorly to I/O-space being cacheable... Instead let's
  * define ioremap() in terms of ioremap_nocache().
  */
-extern inline void __iomem * ioremap(unsigned long offset, unsigned long size)
+static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
 {
 	return __ioremap(offset, size, _PAGE_NO_CACHE);
 }
diff -puN include/asm-parisc/pci.h~parisc-extern-inline-static-inline include/asm-parisc/pci.h
--- a/include/asm-parisc/pci.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/pci.h
@@ -207,7 +207,7 @@ extern struct pci_bios_ops *pci_bios;
 extern void pcibios_register_hba(struct pci_hba_data *);
 extern void pcibios_set_master(struct pci_dev *);
 #else
-extern inline void pcibios_register_hba(struct pci_hba_data *x)
+static inline void pcibios_register_hba(struct pci_hba_data *x)
 {
 }
 #endif
diff -puN include/asm-parisc/pgtable.h~parisc-extern-inline-static-inline include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/pgtable.h
@@ -325,27 +325,27 @@ static inline void pgd_clear(pgd_t *pgd)
  * setup: the pgd is never bad, and a pmd always exists (as it's folded
  * into the pgd entry)
  */
-extern inline int pgd_none(pgd_t pgd)		{ return 0; }
-extern inline int pgd_bad(pgd_t pgd)		{ return 0; }
-extern inline int pgd_present(pgd_t pgd)	{ return 1; }
-extern inline void pgd_clear(pgd_t * pgdp)	{ }
+static inline int pgd_none(pgd_t pgd)		{ return 0; }
+static inline int pgd_bad(pgd_t pgd)		{ return 0; }
+static inline int pgd_present(pgd_t pgd)	{ return 1; }
+static inline void pgd_clear(pgd_t * pgdp)	{ }
 #endif
 
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
-extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
-extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-extern inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
-extern inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
-
-extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
-extern inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
-extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_WRITE; return pte; }
-extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
-extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
-extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
+static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
+static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
+static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
+
+static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
+static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~_PAGE_WRITE; return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
@@ -369,7 +369,7 @@ static inline pte_t pfn_pte(unsigned lon
 	return pte;
 }
 
-extern inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 { pte_val(pte) = (pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot); return pte; }
 
 /* Permanent address of a page.  On parisc we don't have highmem. */
diff -puN include/asm-parisc/prefetch.h~parisc-extern-inline-static-inline include/asm-parisc/prefetch.h
--- a/include/asm-parisc/prefetch.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/prefetch.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_PREFETCH
 
 #define ARCH_HAS_PREFETCH
-extern inline void prefetch(const void *addr)
+static inline void prefetch(const void *addr)
 {
 	__asm__("ldw 0(%0), %%r0" : : "r" (addr));
 }
@@ -27,7 +27,7 @@ extern inline void prefetch(const void *
 /* LDD is a PA2.0 addition. */
 #ifdef CONFIG_PA20
 #define ARCH_HAS_PREFETCHW
-extern inline void prefetchw(const void *addr)
+static inline void prefetchw(const void *addr)
 {
 	__asm__("ldd 0(%0), %%r0" : : "r" (addr));
 }
diff -puN include/asm-parisc/semaphore.h~parisc-extern-inline-static-inline include/asm-parisc/semaphore.h
--- a/include/asm-parisc/semaphore.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/semaphore.h
@@ -54,7 +54,7 @@ struct semaphore {
 
 #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)
 
-extern inline void sema_init (struct semaphore *sem, int val)
+static inline void sema_init (struct semaphore *sem, int val)
 {
 	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
 }
@@ -82,7 +82,7 @@ asmlinkage void __up(struct semaphore * 
  * interrupts while we're messing with the semaphore.  Sorry.
  */
 
-extern __inline__ void down(struct semaphore * sem)
+static inline void down(struct semaphore * sem)
 {
 	might_sleep();
 	spin_lock_irq(&sem->sentry);
@@ -94,7 +94,7 @@ extern __inline__ void down(struct semap
 	spin_unlock_irq(&sem->sentry);
 }
 
-extern __inline__ int down_interruptible(struct semaphore * sem)
+static inline int down_interruptible(struct semaphore * sem)
 {
 	int ret = 0;
 	might_sleep();
@@ -112,7 +112,7 @@ extern __inline__ int down_interruptible
  * down_trylock returns 0 on success, 1 if we failed to get the lock.
  * May not sleep, but must preserve irq state
  */
-extern __inline__ int down_trylock(struct semaphore * sem)
+static inline int down_trylock(struct semaphore * sem)
 {
 	unsigned long flags;
 	int count;
@@ -129,7 +129,7 @@ extern __inline__ int down_trylock(struc
  * Note! This is subtle. We jump to wake people up only if
  * the semaphore was negative (== somebody was waiting on it).
  */
-extern __inline__ void up(struct semaphore * sem)
+static inline void up(struct semaphore * sem)
 {
 	unsigned long flags;
 
diff -puN include/asm-parisc/tlbflush.h~parisc-extern-inline-static-inline include/asm-parisc/tlbflush.h
--- a/include/asm-parisc/tlbflush.h~parisc-extern-inline-static-inline
+++ a/include/asm-parisc/tlbflush.h
@@ -57,7 +57,7 @@ static inline void flush_tlb_mm(struct m
 #endif
 }
 
-extern __inline__ void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
+static inline void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 }
  
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-scsi-scsi_errorc-should-include.patch
include-linux-kbuild-remove-duplicate-entries.patch
parisc-extern-inline-static-inline.patch
remove-fs-jffs2-ioctlc.patch
drivers-scsi-constantsc-make-2-functions-static.patch
fs-afs-possible-cleanups.patch
ppc-remove-apus-support.patch
lib-ioremapc-should-include-linux-ioh.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
ipc-shmc-make-2-functions-static.patch
kernel-schedc-make-code-static.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
