From: akpm@osdl.org
Subject: + revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch added to -mm tree
Date: Wed, 27 Dec 2006 13:21:06 -0800
Message-ID: <200612272121.kBRLLMSH020516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932763AbWL0VV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 16:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, benh@kernel.crashing.org, greg@kroah.com


The patch titled
     revert gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus
has been added to the -mm tree.  Its filename is
     revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus
From: Andrew Morton <akpm@osdl.org>

drivers/usb/host/Kconfig:121:warning: 'select' used by config symbol 'USB_OHCI_HCD_PPC_OF_BE' refer to undefined symbol 'USB_OHCI_BIG_ENDIAN_DESC'
drivers/usb/host/Kconfig:122:warning: 'select' used by config symbol 'USB_OHCI_HCD_PPC_OF_BE' refer to undefined symbol 'USB_OHCI_BIG_ENDIAN_MMIO'

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/Kconfig       |   23 ---
 drivers/usb/host/ohci-hcd.c    |   20 --
 drivers/usb/host/ohci-ppc-of.c |  232 -------------------------------
 3 files changed, 1 insertion(+), 274 deletions(-)

diff -puN drivers/usb/host/Kconfig~revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus
+++ a/drivers/usb/host/Kconfig
@@ -106,30 +106,9 @@ config USB_OHCI_HCD_PPC_SOC
 	  Enables support for the USB controller on the MPC52xx or
 	  STB03xxx processor chip.  If unsure, say Y.
 
-config USB_OHCI_HCD_PPC_OF
-	bool "OHCI support for PPC USB controller on OF platform bus"
-	depends on USB_OHCI_HCD && PPC_OF
-	default y
-	---help---
-	  Enables support for the USB controller PowerPC present on the
-	  OpenFirmware platform bus.
-
-config USB_OHCI_HCD_PPC_OF_BE
-	bool "Support big endian HC"
-	depends on USB_OHCI_HCD_PPC_OF
-	default y
-	select USB_OHCI_BIG_ENDIAN_DESC
-	select USB_OHCI_BIG_ENDIAN_MMIO
-
-config USB_OHCI_HCD_PPC_OF_LE
-	bool "Support little endian HC"
-	depends on USB_OHCI_HCD_PPC_OF
-	default n
-	select USB_OHCI_LITTLE_ENDIAN
-
 config USB_OHCI_HCD_PCI
 	bool "OHCI support for PCI-bus USB controllers"
-	depends on USB_OHCI_HCD && PCI && (STB03xxx || PPC_MPC52xx || USB_OHCI_HCD_PPC_OF)
+	depends on USB_OHCI_HCD && PCI && (STB03xxx || PPC_MPC52xx)
 	default y
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
diff -puN drivers/usb/host/ohci-hcd.c~revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus
+++ a/drivers/usb/host/ohci-hcd.c
@@ -914,14 +914,8 @@ MODULE_LICENSE ("GPL");
 #endif
 
 
-#ifdef CONFIG_USB_OHCI_HCD_PPC_OF
-#include "ohci-ppc-of.c"
-#define OF_PLATFORM_DRIVER	ohci_hcd_ppc_of_driver
-#endif
-
 #if	!defined(PCI_DRIVER) &&		\
 	!defined(PLATFORM_DRIVER) &&	\
-	!defined(OF_PLATFORM_DRIVER) &&	\
 	!defined(SA1111_DRIVER)
 #error "missing bus glue for ohci-hcd"
 #endif
@@ -945,13 +939,6 @@ static int __init ohci_hcd_mod_init(void
 	ls++;
 #endif
 
-#ifdef OF_PLATFORM_DRIVER
-	retval = of_register_platform_driver(&OF_PLATFORM_DRIVER);
-	if (retval < 0)
-		goto error;
-	ls++;
-#endif
-
 #ifdef SA1111_DRIVER
 	retval = sa1111_driver_register(&SA1111_DRIVER);
 	if (retval < 0)
@@ -974,10 +961,6 @@ error:
 	if (ls--)
 		platform_driver_unregister(&PLATFORM_DRIVER);
 #endif
-#ifdef OF_PLATFORM_DRIVER
-	if (ls--)
-		of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
-#endif
 #ifdef SA1111_DRIVER
 	if (ls--)
 		sa1111_driver_unregister(&SA1111_DRIVER);
@@ -994,9 +977,6 @@ static void __exit ohci_hcd_mod_exit(voi
 #ifdef SA1111_DRIVER
 	sa1111_driver_unregister(&SA1111_DRIVER);
 #endif
-#ifdef OF_PLATFORM_DRIVER
-	of_unregister_platform_driver(&OF_PLATFORM_DRIVER);
-#endif
 #ifdef PLATFORM_DRIVER
 	platform_driver_unregister(&PLATFORM_DRIVER);
 #endif
diff -puN drivers/usb/host/ohci-ppc-of.c~revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus /dev/null
--- a/drivers/usb/host/ohci-ppc-of.c
+++ /dev/null
@@ -1,232 +0,0 @@
-/*
- * OHCI HCD (Host Controller Driver) for USB.
- *
- * (C) Copyright 1999 Roman Weissgaerber <weissg@vienna.at>
- * (C) Copyright 2000-2002 David Brownell <dbrownell@users.sourceforge.net>
- * (C) Copyright 2002 Hewlett-Packard Company
- * (C) Copyright 2006 Sylvain Munaut <tnt@246tNt.com>
- *
- * Bus glue for OHCI HC on the of_platform bus
- *
- * Modified for of_platform bus from ohci-sa1111.c
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/signal.h>
-
-#include <asm/of_platform.h>
-#include <asm/prom.h>
-
-
-static int __devinit
-ohci_ppc_of_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
-	int		ret;
-
-	if ((ret = ohci_init(ohci)) < 0)
-		return ret;
-
-	if ((ret = ohci_run(ohci)) < 0) {
-		err("can't start %s", ohci_to_hcd(ohci)->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static const struct hc_driver ohci_ppc_of_hc_driver = {
-	.description =		hcd_name,
-	.product_desc =		"OF OHCI",
-	.hcd_priv_size =	sizeof(struct ohci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq =			ohci_irq,
-	.flags =		HCD_USB11 | HCD_MEMORY,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.start =		ohci_ppc_of_start,
-	.stop =			ohci_stop,
-	.shutdown = 		ohci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue =		ohci_urb_enqueue,
-	.urb_dequeue =		ohci_urb_dequeue,
-	.endpoint_disable =	ohci_endpoint_disable,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number =	ohci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data =	ohci_hub_status_data,
-	.hub_control =		ohci_hub_control,
-	.hub_irq_enable =	ohci_rhsc_enable,
-#ifdef	CONFIG_PM
-	.bus_suspend =		ohci_bus_suspend,
-	.bus_resume =		ohci_bus_resume,
-#endif
-	.start_port_reset =	ohci_start_port_reset,
-};
-
-
-static int __devinit
-ohci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
-{
-	struct device_node *dn = op->node;
-	struct usb_hcd *hcd;
-	struct ohci_hcd	*ohci;
-	struct resource res;
-	int irq;
-
-	int rv;
-	int is_bigendian;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	is_bigendian =
-		device_is_compatible(dn, "ohci-bigendian") ||
-		device_is_compatible(dn, "ohci-be");;
-
-	dev_dbg(&op->dev, "initializing PPC-OF USB Controller\n");
-
-	rv = of_address_to_resource(dn, 0, &res);
-	if (rv)
-		return rv;
-
-	hcd = usb_create_hcd(&ohci_ppc_of_hc_driver, &op->dev, "PPC-OF USB");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res.start;
-	hcd->rsrc_len = res.end - res.start + 1;
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		printk(KERN_ERR __FILE__ ": request_mem_region failed\n");
-		rv = -EBUSY;
-		goto err_rmr;
-	}
-
-	irq = irq_of_parse_and_map(dn, 0);
-	if (irq == NO_IRQ) {
-		printk(KERN_ERR __FILE__ ": irq_of_parse_and_map failed\n");
-		rv = -EBUSY;
-		goto err_irq;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		printk(KERN_ERR __FILE__ ": ioremap failed\n");
-		rv = -ENOMEM;
-		goto err_ioremap;
-	}
-
-	ohci = hcd_to_ohci(hcd);
-	if (is_bigendian)
-		ohci->flags |= OHCI_QUIRK_BE_MMIO | OHCI_QUIRK_BE_DESC;
-
-	ohci_hcd_init(ohci);
-
-	rv = usb_add_hcd(hcd, irq, 0);
-	if (rv == 0)
-		return 0;
-
-	iounmap(hcd->regs);
-err_ioremap:
-	irq_dispose_mapping(irq);
-err_irq:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err_rmr:
- 	usb_put_hcd(hcd);
-
-	return rv;
-}
-
-static int ohci_hcd_ppc_of_remove(struct of_device *op)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(&op->dev);
-	dev_set_drvdata(&op->dev, NULL);
-
-	dev_dbg(&op->dev, "stopping PPC-OF USB Controller\n");
-
-	usb_remove_hcd(hcd);
-
-	iounmap(hcd->regs);
-	irq_dispose_mapping(hcd->irq);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-
-	usb_put_hcd(hcd);
-
-	return 0;
-}
-
-static int ohci_hcd_ppc_of_shutdown(struct of_device *op)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(&op->dev);
-
-        if (hcd->driver->shutdown)
-                hcd->driver->shutdown(hcd);
-
-	return 0;
-}
-
-
-static struct of_device_id ohci_hcd_ppc_of_match[] = {
-#ifdef CONFIG_USB_OHCI_HCD_PPC_OF_BE
-	{
-		.name = "usb",
-		.compatible = "ohci-bigendian",
-	},
-	{
-		.name = "usb",
-		.compatible = "ohci-be",
-	},
-#endif
-#ifdef CONFIG_USB_OHCI_HCD_PPC_OF_LE
-	{
-		.name = "usb",
-		.compatible = "ohci-littledian",
-	},
-	{
-		.name = "usb",
-		.compatible = "ohci-le",
-	},
-#endif
-	{},
-};
-MODULE_DEVICE_TABLE(of, ohci_hcd_ppc_of_match);
-
-#if	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_BE) && \
-	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_LE)
-#error "No endianess selected for ppc-of-ohci"
-#endif
-
-
-static struct of_platform_driver ohci_hcd_ppc_of_driver = {
-	.name		= "ppc-of-ohci",
-	.match_table	= ohci_hcd_ppc_of_match,
-	.probe		= ohci_hcd_ppc_of_probe,
-	.remove		= ohci_hcd_ppc_of_remove,
-	.shutdown 	= ohci_hcd_ppc_of_shutdown,
-#ifdef CONFIG_PM
-	/*.suspend	= ohci_hcd_ppc_soc_drv_suspend,*/
-	/*.resume	= ohci_hcd_ppc_soc_drv_resume,*/
-#endif
-	.driver		= {
-		.name	= "ppc-of-ohci",
-		.owner	= THIS_MODULE,
-	},
-};
-
_

Patches currently in -mm which might be from akpm@osdl.org are

cpuset-procfs-warning-fix.patch
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
revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch
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
reiser4-test_clear_page_dirty.patch
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

