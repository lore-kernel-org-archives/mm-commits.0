From: akpm@osdl.org
Subject: - include-asm-h8300-extern-inline-static-inline.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:28 -0800
Message-ID: <200612072316.kB7NGS5I030837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163973AbWLGXTp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     include/asm-h8300/: "extern inline" -> "static inline"
has been removed from the -mm tree.  Its filename was
     include-asm-h8300-extern-inline-static-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/asm-h8300/: "extern inline" -> "static inline"
From: Adrian Bunk <bunk@stusta.de>

"extern inline" generates a warning with -Wmissing-prototypes and I'm
currently working on getting the kernel cleaned up for adding this to the
CFLAGS since it will help us to avoid a nasty class of runtime errors.

If there are places that really need a forced inline, __always_inline would be
the correct solution.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-h8300/delay.h       |    4 ++--
 include/asm-h8300/mmu_context.h |    4 ++--
 include/asm-h8300/pci.h         |    4 ++--
 include/asm-h8300/tlbflush.h    |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/asm-h8300/delay.h~include-asm-h8300-extern-inline-static-inline include/asm-h8300/delay.h
--- a/include/asm-h8300/delay.h~include-asm-h8300-extern-inline-static-inline
+++ a/include/asm-h8300/delay.h
@@ -9,7 +9,7 @@
  * Delay routines, using a pre-computed "loops_per_second" value.
  */
 
-extern __inline__ void __delay(unsigned long loops)
+static inline void __delay(unsigned long loops)
 {
 	__asm__ __volatile__ ("1:\n\t"
 			      "dec.l #1,%0\n\t"
@@ -27,7 +27,7 @@ extern __inline__ void __delay(unsigned 
 
 extern unsigned long loops_per_jiffy;
 
-extern __inline__ void udelay(unsigned long usecs)
+static inline void udelay(unsigned long usecs)
 {
 	usecs *= 4295;		/* 2**32 / 1000000 */
 	usecs /= (loops_per_jiffy*HZ);
diff -puN include/asm-h8300/mmu_context.h~include-asm-h8300-extern-inline-static-inline include/asm-h8300/mmu_context.h
--- a/include/asm-h8300/mmu_context.h~include-asm-h8300-extern-inline-static-inline
+++ a/include/asm-h8300/mmu_context.h
@@ -9,7 +9,7 @@ static inline void enter_lazy_tlb(struct
 {
 }
 
-extern inline int
+static inline int
 init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
 	// mm->context = virt_to_phys(mm->pgd);
@@ -23,7 +23,7 @@ static inline void switch_mm(struct mm_s
 {
 }
 
-extern inline void activate_mm(struct mm_struct *prev_mm,
+static inline void activate_mm(struct mm_struct *prev_mm,
 			       struct mm_struct *next_mm)
 {
 }
diff -puN include/asm-h8300/pci.h~include-asm-h8300-extern-inline-static-inline include/asm-h8300/pci.h
--- a/include/asm-h8300/pci.h~include-asm-h8300-extern-inline-static-inline
+++ a/include/asm-h8300/pci.h
@@ -10,12 +10,12 @@
 #define pcibios_assign_all_busses()	0
 #define pcibios_scan_all_fns(a, b)	0
 
-extern inline void pcibios_set_master(struct pci_dev *dev)
+static inline void pcibios_set_master(struct pci_dev *dev)
 {
 	/* No special bus mastering setup handling */
 }
 
-extern inline void pcibios_penalize_isa_irq(int irq, int active)
+static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't do dynamic PCI IRQ allocation */
 }
diff -puN include/asm-h8300/tlbflush.h~include-asm-h8300-extern-inline-static-inline include/asm-h8300/tlbflush.h
--- a/include/asm-h8300/tlbflush.h~include-asm-h8300-extern-inline-static-inline
+++ a/include/asm-h8300/tlbflush.h
@@ -47,12 +47,12 @@ static inline void flush_tlb_range(struc
 	BUG();
 }
 
-extern inline void flush_tlb_kernel_page(unsigned long addr)
+static inline void flush_tlb_kernel_page(unsigned long addr)
 {
 	BUG();
 }
 
-extern inline void flush_tlb_pgtables(struct mm_struct *mm,
+static inline void flush_tlb_pgtables(struct mm_struct *mm,
 				      unsigned long start, unsigned long end)
 {
 	BUG();
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

