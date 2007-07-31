From: akpm@linux-foundation.org
Subject: - revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:51 -0700
Message-ID: <200707312355.l6VNtp57029277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242AbXHAATF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, ambx1@neo.rr.com, bjorn.helgaas@hp.com, jeff@garzik.org, lenb@kernel.org, michal.k.k.piotrowski@gmail.com, mjg59@srcf.ucam.org, rm


The patch titled
     revert "x86, serial: convert legacy COM ports to platform devices"
has been removed from the -mm tree.  Its filename was
     revert-x86-serial-convert-legacy-com-ports-to-platform-devices.pat=
ch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: revert "x86, serial: convert legacy COM ports to platform devi=
ces"
=46rom: Andrew Morton <akpm@linux-foundation.org>

Revert 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26.  It broke S=E9bastien =
Dugu=E9's
machine and Jeff said (persuasively)

  This seems like it will break decades-long-working stuff, in favor of
  breaking new ground in our favorite area, "trusting the BIOS."

  It's just not worth it for serial ports, IMO.  Serial ports are somet=
hing
  that just shouldn't break at this late stage in the game.  My new Int=
el
  platform boxes don't even have serial ports, so I question the value =
of
  messing with serial port probing even more...  because...  just wait =
a year,
  and your box won't have a serial port either!  :)

  I certainly don't object to the use of platform devices (or isa_drive=
r),
  but the probe change seems questionable.  That's sorta analagous to
  rewriting the floppy driver probe routine.  Sure you could do it...  =
but why
  risk all that damage and go through debugging all over again?

  It seems clear from this report that we cannot, should not, trust BIO=
S for
  something (a) so simple and (b) that has been working for over a deca=
de.

Much discussion ensued and we've decided to have another go at all of t=
his.

Cc: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Sascha Sommer <saschasommer@freenet.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 -
 arch/i386/kernel/Makefile           |    1=20
 arch/i386/kernel/legacy_serial.c    |   67 --------------------------
 arch/x86_64/kernel/Makefile         |    2=20
 drivers/serial/Kconfig              |   14 +----
 include/asm-i386/serial.h           |   16 ++++++
 include/asm-x86_64/serial.h         |   16 ++++++
 7 files changed, 37 insertions(+), 84 deletions(-)

diff -puN Documentation/kernel-parameters.txt~revert-x86-serial-convert=
-legacy-com-ports-to-platform-devices Documentation/kernel-parameters.t=
xt
--- a/Documentation/kernel-parameters.txt~revert-x86-serial-convert-leg=
acy-com-ports-to-platform-devices
+++ a/Documentation/kernel-parameters.txt
@@ -864,11 +864,6 @@ and is between 256 and 4096 characters.=20
 	lasi=3D		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
=20
-	legacy_serial.force [HW,X86-32,X86-64]
-			Probe for COM ports at legacy addresses even
-			if PNPBIOS or ACPI should describe them.  This
-			is for working around firmware defects.
-
 	load_ramdisk=3D	[RAM] List of ramdisks to load from floppy
 			See Documentation/ramdisk.txt.
=20
diff -puN arch/i386/kernel/Makefile~revert-x86-serial-convert-legacy-co=
m-ports-to-platform-devices arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~revert-x86-serial-convert-legacy-com-po=
rts-to-platform-devices
+++ a/arch/i386/kernel/Makefile
@@ -35,7 +35,6 @@ obj-y				+=3D sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+=3D srat.o
 obj-$(CONFIG_EFI) 		+=3D efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+=3D doublefault.o
-obj-$(CONFIG_SERIAL_8250)	+=3D legacy_serial.o
 obj-$(CONFIG_VM86)		+=3D vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+=3D early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+=3D hpet.o
diff -puN arch/i386/kernel/legacy_serial.c~revert-x86-serial-convert-le=
gacy-com-ports-to-platform-devices /dev/null
--- a/arch/i386/kernel/legacy_serial.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Legacy COM port devices for x86 platforms without PNPBIOS or ACPI.
- * Data taken from include/asm-i386/serial.h.
- *
- * (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
- *	Bjorn Helgaas <bjorn.helgaas@hp.com>
- *
- * This program is free software; you can redistribute it and/or modif=
y
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pnp.h>
-#include <linux/serial_8250.h>
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) *=
/
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_AUTO_IRQ)
-#define COM4_FLAGS (UPF_BOOT_AUTOCONF | UPF_AUTO_IRQ)
-#else
-#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST)
-#define COM4_FLAGS UPF_BOOT_AUTOCONF
-#endif
-
-#define PORT(_base,_irq,_flags)				\
-	{						\
-		.iobase		=3D _base,		\
-		.irq		=3D _irq,			\
-		.uartclk	=3D 1843200,		\
-		.iotype		=3D UPIO_PORT,		\
-		.flags		=3D _flags,		\
-	}
-
-static struct plat_serial8250_port x86_com_data[] =3D {
-	PORT(0x3F8, 4, COM_FLAGS),
-	PORT(0x2F8, 3, COM_FLAGS),
-	PORT(0x3E8, 4, COM_FLAGS),
-	PORT(0x2E8, 3, COM4_FLAGS),
-	{ },
-};
-
-static struct platform_device x86_com_device =3D {
-	.name			=3D "serial8250",
-	.id			=3D PLAT8250_DEV_PLATFORM,
-	.dev			=3D {
-		.platform_data	=3D x86_com_data,
-	},
-};
-
-static int force_legacy_probe;
-module_param_named(force, force_legacy_probe, bool, 0);
-MODULE_PARM_DESC(force, "Force legacy serial port probe");
-
-static int __init serial8250_x86_com_init(void)
-{
-	if (pnp_platform_devices && !force_legacy_probe)
-		return -ENODEV;
-
-	return platform_device_register(&x86_com_device);
-}
-
-module_init(serial8250_x86_com_init);
-
-MODULE_AUTHOR("Bjorn Helgaas");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic 8250/16x50 legacy probe module");
diff -puN arch/x86_64/kernel/Makefile~revert-x86-serial-convert-legacy-=
com-ports-to-platform-devices arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~revert-x86-serial-convert-legacy-com-=
ports-to-platform-devices
+++ a/arch/x86_64/kernel/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+=3D early_prin
 obj-$(CONFIG_IOMMU)		+=3D pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+=3D pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+=3D pci-swiotlb.o
-obj-$(CONFIG_SERIAL_8250)	+=3D legacy_serial.o
 obj-$(CONFIG_KPROBES)		+=3D kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+=3D pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+=3D vsmp.o
@@ -51,7 +50,6 @@ CFLAGS_vsyscall.o		:=3D $(PROFILING) -g0
=20
 therm_throt-y                   +=3D ../../i386/kernel/cpu/mcheck/ther=
m_throt.o
 bootflag-y			+=3D ../../i386/kernel/bootflag.o
-legacy_serial-y			+=3D ../../i386/kernel/legacy_serial.o
 cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  +=3D ../../i386/kernel/cpuid.o
 topology-y                     +=3D ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  +=3D ../../i386/kernel/mic=
rocode.o
diff -puN drivers/serial/Kconfig~revert-x86-serial-convert-legacy-com-p=
orts-to-platform-devices drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~revert-x86-serial-convert-legacy-com-ports=
-to-platform-devices
+++ a/drivers/serial/Kconfig
@@ -88,21 +88,17 @@ config SERIAL_8250_PCI
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
-	  Say Y here if you have PCI serial ports.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_pci.
+	  This builds standard PCI serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
+	  Saves about 9K.
=20
 config SERIAL_8250_PNP
 	tristate "8250/16550 PNP device support" if EMBEDDED
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
-	  Say Y here if you have serial ports described by PNPBIOS or ACPI.
-	  These are typically ports built into the system board.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_pnp.
+	  This builds standard PNP serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
=20
 config SERIAL_8250_HP300
 	tristate
diff -puN include/asm-i386/serial.h~revert-x86-serial-convert-legacy-co=
m-ports-to-platform-devices include/asm-i386/serial.h
--- a/include/asm-i386/serial.h~revert-x86-serial-convert-legacy-com-po=
rts-to-platform-devices
+++ a/include/asm-i386/serial.h
@@ -11,3 +11,19 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) *=
/
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_A=
UTO_IRQ)
+#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+#else
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
+#endif
+
+#define SERIAL_PORT_DFNS			\
+	/* UART CLK   PORT IRQ     FLAGS        */			\
+	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
+	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
+	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
+	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
diff -puN include/asm-x86_64/serial.h~revert-x86-serial-convert-legacy-=
com-ports-to-platform-devices include/asm-x86_64/serial.h
--- a/include/asm-x86_64/serial.h~revert-x86-serial-convert-legacy-com-=
ports-to-platform-devices
+++ a/include/asm-x86_64/serial.h
@@ -11,3 +11,19 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) *=
/
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_A=
UTO_IRQ)
+#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+#else
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
+#endif
+
+#define SERIAL_PORT_DFNS			\
+	/* UART CLK   PORT IRQ     FLAGS        */			\
+	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
+	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
+	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
+	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
remove-the-arm26-port-fix.patch
genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-mark_tsc_unstable-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb.patch
git-dvb-fixup.patch
git-hwmon.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
fix-ide-ide-add-platform-ide-driver.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.pat=
ch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=3Dassign-busses-warning.patch
scsi-fix-build-for-config_scsi_tgt=3Dn.patch
aacraid-rename-check_reset.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-unionfs-build-fix.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-watchdog.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fi=
x.patch
acpi_battery_add-use-after-free.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix=
=2Epatch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix=
-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_or=
der_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuf=
f.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.pat=
ch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.p=
atch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.p=
atch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.p=
atch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patc=
h
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch
