From: akpm@osdl.org
Subject: + revert-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch added to -mm tree
Date: Wed, 27 Dec 2006 12:45:20 -0800
Message-ID: <200612272045.kBRKjaF1019840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbWL0Upn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 15:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, benh@kernel.crashing.org, greg@kroah.com


The patch titled
     revert gregkh-usb-usb-implement-support-for-split-endian-ohci
has been added to the -mm tree.  Its filename is
     revert-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-usb-usb-implement-support-for-split-endian-ohci
From: Andrew Morton <akpm@osdl.org>

i386 allmodconfig:

In file included from drivers/usb/host/ohci-hcd.c:78:
drivers/usb/host/ohci.h: In function '_ohci_readl':
drivers/usb/host/ohci.h:509: warning: implicit declaration of function 'readl_be'
drivers/usb/host/ohci.h: In function '_ohci_writel':
drivers/usb/host/ohci.h:517: warning: implicit declaration of function 'writel_be'

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/Kconfig        |   10 --
 drivers/usb/host/ohci-pci.c     |   26 -----
 drivers/usb/host/ohci-ppc-soc.c |    2 
 drivers/usb/host/ohci.h         |  147 ++++++++++--------------------
 4 files changed, 55 insertions(+), 130 deletions(-)

diff -puN drivers/usb/host/Kconfig~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci
+++ a/drivers/usb/host/Kconfig
@@ -106,8 +106,7 @@ config USB_OHCI_HCD_PPC_SOC
 	bool "OHCI support for on-chip PPC USB controller"
 	depends on USB_OHCI_HCD && (STB03xxx || PPC_MPC52xx)
 	default y
-	select USB_OHCI_BIG_ENDIAN_DESC
-	select USB_OHCI_BIG_ENDIAN_MMIO
+	select USB_OHCI_BIG_ENDIAN
 	---help---
 	  Enables support for the USB controller on the MPC52xx or
 	  STB03xxx processor chip.  If unsure, say Y.
@@ -142,12 +141,7 @@ config USB_OHCI_HCD_PCI
 	  Enables support for PCI-bus plug-in USB controller cards.
 	  If unsure, say Y.
 
-config USB_OHCI_BIG_ENDIAN_DESC
-	bool
-	depends on USB_OHCI_HCD
-	default n
-
-config USB_OHCI_BIG_ENDIAN_MMIO
+config USB_OHCI_BIG_ENDIAN
 	bool
 	depends on USB_OHCI_HCD
 	default n
diff -puN drivers/usb/host/ohci-pci.c~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci drivers/usb/host/ohci-pci.c
--- a/drivers/usb/host/ohci-pci.c~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci
+++ a/drivers/usb/host/ohci-pci.c
@@ -85,27 +85,6 @@ static int __devinit ohci_quirk_zfmicro(
 	return 0;
 }
 
-/* Check for Toshiba SCC OHCI which has big endian registers
- * and little endian in memory data structures
- */
-static int __devinit ohci_quirk_toshiba_scc(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
-
-	/* That chip is only present in the southbridge of some
-	 * cell based platforms which are supposed to select
-	 * CONFIG_USB_OHCI_BIG_ENDIAN_MMIO. We verify here if
-	 * that was the case though.
-	 */
-#ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
-	ohci->flags |= OHCI_QUIRK_BE_MMIO;
-	ohci_dbg (ohci, "enabled big endian Toshiba quirk\n");
-	return 0;
-#else
-	ohci_err (ohci, "unsupported big endian Toshiba quirk\n");
-	return -ENXIO;
-#endif
-}
 
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
@@ -125,14 +104,9 @@ static const struct pci_device_id ohci_p
 		PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xa0f8),
 		.driver_data = (unsigned long)ohci_quirk_zfmicro,
 	},
-	{
-		PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA_2, 0x01b6),
-		.driver_data = (unsigned long)ohci_quirk_toshiba_scc,
-	},
 	/* FIXME for some of the early AMD 760 southbridges, OHCI
 	 * won't work at all.  blacklist them.
 	 */
-
 	{},
 };
 
diff -puN drivers/usb/host/ohci-ppc-soc.c~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci drivers/usb/host/ohci-ppc-soc.c
--- a/drivers/usb/host/ohci-ppc-soc.c~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci
+++ a/drivers/usb/host/ohci-ppc-soc.c
@@ -72,7 +72,7 @@ static int usb_hcd_ppc_soc_probe(const s
 	}
 
 	ohci = hcd_to_ohci(hcd);
-	ohci->flags |= OHCI_QUIRK_BE_MMIO | OHCI_QUIRK_BE_DESC;
+	ohci->flags |= OHCI_BIG_ENDIAN;
 	ohci_hcd_init(ohci);
 
 	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED);
diff -puN drivers/usb/host/ohci.h~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci drivers/usb/host/ohci.h
--- a/drivers/usb/host/ohci.h~revert-gregkh-usb-usb-implement-support-for-split-endian-ohci
+++ a/drivers/usb/host/ohci.h
@@ -394,9 +394,8 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_AMD756	0x01			/* erratum #4 */
 #define	OHCI_QUIRK_SUPERIO	0x02			/* natsemi */
 #define	OHCI_QUIRK_INITRESET	0x04			/* SiS, OPTi, ... */
-#define	OHCI_QUIRK_BE_DESC	0x08			/* BE descriptors */
-#define	OHCI_QUIRK_BE_MMIO	0x10			/* BE registers */
-#define	OHCI_QUIRK_ZFMICRO	0x20			/* Compaq ZFMicro chipset*/
+#define	OHCI_BIG_ENDIAN		0x08			/* big endian HC */
+#define	OHCI_QUIRK_ZFMICRO	0x10			/* Compaq ZFMicro chipset*/
 	// there are also chip quirks/bugs in init logic
 
 };
@@ -440,156 +439,117 @@ static inline struct usb_hcd *ohci_to_hc
  * a minority (notably the IBM STB04XXX and the Motorola MPC5200
  * processors) implement them in big endian format.
  *
- * In addition some more exotic implementations like the Toshiba
- * Spider (aka SCC) cell southbridge are "mixed" endian, that is,
- * they have a different endianness for registers vs. in-memory
- * descriptors.
- *
  * This attempts to support either format at compile time without a
  * runtime penalty, or both formats with the additional overhead
  * of checking a flag bit.
- *
- * That leads to some tricky Kconfig rules howevber. There are
- * different defaults based on some arch/ppc platforms, though
- * the basic rules are:
- *
- * Controller type              Kconfig options needed
- * ---------------              ----------------------
- * little endian                CONFIG_USB_OHCI_LITTLE_ENDIAN
- *
- * fully big endian             CONFIG_USB_OHCI_BIG_ENDIAN_DESC _and_
- *                              CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
- *
- * mixed endian                 CONFIG_USB_OHCI_LITTLE_ENDIAN _and_
- *                              CONFIG_USB_OHCI_BIG_ENDIAN_{MMIO,DESC}
- *
- * (If you have a mixed endian controller, you -must- also define
- * CONFIG_USB_OHCI_LITTLE_ENDIAN or things will not work when building
- * both your mixed endian and a fully big endian controller support in
- * the same kernel image).
  */
 
-#ifdef CONFIG_USB_OHCI_BIG_ENDIAN_DESC
-#ifdef CONFIG_USB_OHCI_LITTLE_ENDIAN
-#define big_endian_desc(ohci)	(ohci->flags & OHCI_QUIRK_BE_DESC)
-#else
-#define big_endian_desc(ohci)	1		/* only big endian */
-#endif
-#else
-#define big_endian_desc(ohci)	0		/* only little endian */
-#endif
+#ifdef CONFIG_USB_OHCI_BIG_ENDIAN
 
-#ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
 #ifdef CONFIG_USB_OHCI_LITTLE_ENDIAN
-#define big_endian_mmio(ohci)	(ohci->flags & OHCI_QUIRK_BE_MMIO)
-#else
-#define big_endian_mmio(ohci)	1		/* only big endian */
-#endif
+#define big_endian(ohci)	(ohci->flags & OHCI_BIG_ENDIAN) /* either */
 #else
-#define big_endian_mmio(ohci)	0		/* only little endian */
+#define big_endian(ohci)	1		/* only big endian */
 #endif
 
 /*
  * Big-endian read/write functions are arch-specific.
  * Other arches can be added if/when they're needed.
- *
- * REVISIT: arch/powerpc now has readl/writel_be, so the
- * definition below can die once the STB04xxx support is
- * finally ported over.
  */
-#if defined(CONFIG_PPC) && !defined(CONFIG_PPC_MERGE)
+#if defined(CONFIG_PPC)
 #define readl_be(addr)		in_be32((__force unsigned *)addr)
 #define writel_be(val, addr)	out_be32((__force unsigned *)addr, val)
 #endif
 
-static inline unsigned int _ohci_readl (const struct ohci_hcd *ohci,
-					__hc32 __iomem * regs)
+static inline unsigned int ohci_readl (const struct ohci_hcd *ohci,
+							__hc32 __iomem * regs)
 {
-	return big_endian_mmio(ohci) ?
-		readl_be ((__force u32 *)regs) :
-		readl ((__force u32 *)regs);
+	return big_endian(ohci) ? readl_be (regs) : readl ((__force u32 *)regs);
 }
 
-static inline void _ohci_writel (const struct ohci_hcd *ohci,
-				 const unsigned int val, __hc32 __iomem *regs)
+static inline void ohci_writel (const struct ohci_hcd *ohci,
+				const unsigned int val, __hc32 __iomem *regs)
 {
-	big_endian_mmio(ohci) ?
-		writel_be (val, (__force u32 *)regs) :
-		writel (val, (__force u32 *)regs);
+	big_endian(ohci) ? writel_be (val, regs) :
+			   writel (val, (__force u32 *)regs);
 }
 
+#else	/* !CONFIG_USB_OHCI_BIG_ENDIAN */
+
+#define big_endian(ohci)	0		/* only little endian */
+
 #ifdef CONFIG_ARCH_LH7A404
-/* Marc Singer: at the time this code was written, the LH7A404
- * had a problem reading the USB host registers.  This
- * implementation of the ohci_readl function performs the read
- * twice as a work-around.
- */
-#define ohci_readl(o,r)		(_ohci_readl(o,r),_ohci_readl(o,r))
-#define ohci_writel(o,v,r)	_ohci_writel(o,v,r)
+	/* Marc Singer: at the time this code was written, the LH7A404
+	 * had a problem reading the USB host registers.  This
+	 * implementation of the ohci_readl function performs the read
+	 * twice as a work-around.
+	 */
+static inline unsigned int
+ohci_readl (const struct ohci_hcd *ohci, const __hc32 *regs)
+{
+	*(volatile __force unsigned int*) regs;
+	return *(volatile __force unsigned int*) regs;
+}
 #else
-#define ohci_readl(o,r)		_ohci_readl(o,r)
-#define ohci_writel(o,v,r)	_ohci_writel(o,v,r)
+	/* Standard version of ohci_readl uses standard, platform
+	 * specific implementation. */
+static inline unsigned int
+ohci_readl (const struct ohci_hcd *ohci, __hc32 __iomem * regs)
+{
+	return readl(regs);
+}
 #endif
 
+static inline void ohci_writel (const struct ohci_hcd *ohci,
+				const unsigned int val, __hc32 __iomem *regs)
+{
+	writel (val, regs);
+}
+
+#endif	/* !CONFIG_USB_OHCI_BIG_ENDIAN */
 
 /*-------------------------------------------------------------------------*/
 
 /* cpu to ohci */
 static inline __hc16 cpu_to_hc16 (const struct ohci_hcd *ohci, const u16 x)
 {
-	return big_endian_desc(ohci) ?
-		(__force __hc16)cpu_to_be16(x) :
-		(__force __hc16)cpu_to_le16(x);
+	return big_endian(ohci) ? (__force __hc16)cpu_to_be16(x) : (__force __hc16)cpu_to_le16(x);
 }
 
 static inline __hc16 cpu_to_hc16p (const struct ohci_hcd *ohci, const u16 *x)
 {
-	return big_endian_desc(ohci) ?
-		cpu_to_be16p(x) :
-		cpu_to_le16p(x);
+	return big_endian(ohci) ? cpu_to_be16p(x) : cpu_to_le16p(x);
 }
 
 static inline __hc32 cpu_to_hc32 (const struct ohci_hcd *ohci, const u32 x)
 {
-	return big_endian_desc(ohci) ?
-		(__force __hc32)cpu_to_be32(x) :
-		(__force __hc32)cpu_to_le32(x);
+	return big_endian(ohci) ? (__force __hc32)cpu_to_be32(x) : (__force __hc32)cpu_to_le32(x);
 }
 
 static inline __hc32 cpu_to_hc32p (const struct ohci_hcd *ohci, const u32 *x)
 {
-	return big_endian_desc(ohci) ?
-		cpu_to_be32p(x) :
-		cpu_to_le32p(x);
+	return big_endian(ohci) ? cpu_to_be32p(x) : cpu_to_le32p(x);
 }
 
 /* ohci to cpu */
 static inline u16 hc16_to_cpu (const struct ohci_hcd *ohci, const __hc16 x)
 {
-	return big_endian_desc(ohci) ?
-		be16_to_cpu((__force __be16)x) :
-		le16_to_cpu((__force __le16)x);
+	return big_endian(ohci) ? be16_to_cpu((__force __be16)x) : le16_to_cpu((__force __le16)x);
 }
 
 static inline u16 hc16_to_cpup (const struct ohci_hcd *ohci, const __hc16 *x)
 {
-	return big_endian_desc(ohci) ?
-		be16_to_cpup((__force __be16 *)x) :
-		le16_to_cpup((__force __le16 *)x);
+	return big_endian(ohci) ? be16_to_cpup((__force __be16 *)x) : le16_to_cpup((__force __le16 *)x);
 }
 
 static inline u32 hc32_to_cpu (const struct ohci_hcd *ohci, const __hc32 x)
 {
-	return big_endian_desc(ohci) ?
-		be32_to_cpu((__force __be32)x) :
-		le32_to_cpu((__force __le32)x);
+	return big_endian(ohci) ? be32_to_cpu((__force __be32)x) : le32_to_cpu((__force __le32)x);
 }
 
 static inline u32 hc32_to_cpup (const struct ohci_hcd *ohci, const __hc32 *x)
 {
-	return big_endian_desc(ohci) ?
-		be32_to_cpup((__force __be32 *)x) :
-		le32_to_cpup((__force __le32 *)x);
+	return big_endian(ohci) ? be32_to_cpup((__force __be32 *)x) : le32_to_cpup((__force __le32 *)x);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -597,9 +557,6 @@ static inline u32 hc32_to_cpup (const st
 /* HCCA frame number is 16 bits, but is accessed as 32 bits since not all
  * hardware handles 16 bit reads.  That creates a different confusion on
  * some big-endian SOC implementations.  Same thing happens with PSW access.
- *
- * FIXME: Deal with that as a runtime quirk when STB03xxx is ported over
- * to arch/powerpc
  */
 
 #ifdef CONFIG_STB03xxx
@@ -611,7 +568,7 @@ static inline u32 hc32_to_cpup (const st
 static inline u16 ohci_frame_no(const struct ohci_hcd *ohci)
 {
 	u32 tmp;
-	if (big_endian_desc(ohci)) {
+	if (big_endian(ohci)) {
 		tmp = be32_to_cpup((__force __be32 *)&ohci->hcca->frame_no);
 		tmp >>= OHCI_BE_FRAME_NO_SHIFT;
 	} else
@@ -623,7 +580,7 @@ static inline u16 ohci_frame_no(const st
 static inline __hc16 *ohci_hwPSWp(const struct ohci_hcd *ohci,
                                  const struct td *td, int index)
 {
-	return (__hc16 *)(big_endian_desc(ohci) ?
+	return (__hc16 *)(big_endian(ohci) ?
 			&td->hwPSW[index ^ 1] : &td->hwPSW[index]);
 }
 
_

Patches currently in -mm which might be from akpm@osdl.org are

down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
revert-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

