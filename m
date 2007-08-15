From: akpm@linux-foundation.org
Subject: + introduce-config_check_signature-was-re-uninline.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:19:56 -0700
Message-ID: <200708152119.l7FLJucL015621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758250AbXHOVUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, alan@lxorguk.ukuu.org.uk, heiko.carstens@de.ibm.com, jdike@addtoit.com, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, zippel@linux-m68k.org


The patch titled
     Introduce CONFIG_CHECK_SIGNATURE
has been added to the -mm tree.  Its filename is
     introduce-config_check_signature-was-re-uninline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce CONFIG_CHECK_SIGNATURE
From: Geert Uytterhoeven <geert@linux-m68k.org>

Introduce CONFIG_CHECK_SIGNATURE to control inclusion of check_signature()
and avoid problems on platforms that don't have readb().

Let the few legacy (ISA || PCI || X86) drivers that need check_signature()
select CONFIG_CHECK_SIGNATURE.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig      |    1 +
 drivers/input/misc/Kconfig |    1 +
 drivers/scsi/Kconfig       |    6 ++++++
 lib/Kconfig                |    3 +++
 lib/Makefile               |    3 ++-
 5 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/block/Kconfig~introduce-config_check_signature-was-re-uninline drivers/block/Kconfig
--- a/drivers/block/Kconfig~introduce-config_check_signature-was-re-uninline
+++ a/drivers/block/Kconfig
@@ -62,6 +62,7 @@ config AMIGA_Z2RAM
 config BLK_DEV_XD
 	tristate "XT hard disk support"
 	depends on ISA && ISA_DMA_API
+	select CHECK_SIGNATURE
 	help
 	  Very old 8 bit hard disk controllers used in the IBM XT computer
 	  will be supported if you say Y here.
diff -puN drivers/input/misc/Kconfig~introduce-config_check_signature-was-re-uninline drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~introduce-config_check_signature-was-re-uninline
+++ a/drivers/input/misc/Kconfig
@@ -68,6 +68,7 @@ config INPUT_WISTRON_BTNS
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
+	select CHECK_SIGNATURE
 	help
 	  Say Y here for support of Winstron laptop button interface, used on
 	  laptops of various brands, including Acer and Fujitsu-Siemens. If
diff -puN drivers/scsi/Kconfig~introduce-config_check_signature-was-re-uninline drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~introduce-config_check_signature-was-re-uninline
+++ a/drivers/scsi/Kconfig
@@ -367,6 +367,7 @@ config SCSI_3W_9XXX
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
 	depends on ISA && SCSI && ISA_DMA_API
+	select CHECK_SIGNATURE
 	help
 	  This driver supports the Western Digital 7000 SCSI host adapter
 	  family.  Some information is in the source:
@@ -388,6 +389,7 @@ config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI && !64BIT
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
@@ -583,6 +585,7 @@ config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
@@ -657,6 +660,7 @@ config SCSI_EATA_PIO
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
 	depends on (ISA || PCI) && SCSI
+	select CHECK_SIGNATURE
 	---help---
 	  This is support for Future Domain's 16-bit SCSI host adapters
 	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
@@ -1324,6 +1328,7 @@ config SCSI_LPFC
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
 	depends on X86 && ISA && SCSI
+	select CHECK_SIGNATURE
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
@@ -1397,6 +1402,7 @@ config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
 	  3.11 of the SCSI-HOWTO, available from
diff -puN lib/Kconfig~introduce-config_check_signature-was-re-uninline lib/Kconfig
--- a/lib/Kconfig~introduce-config_check_signature-was-re-uninline
+++ a/lib/Kconfig
@@ -138,4 +138,7 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config CHECK_SIGNATURE
+	bool
+
 endmenu
diff -puN lib/Makefile~introduce-config_check_signature-was-re-uninline lib/Makefile
--- a/lib/Makefile~introduce-config_check_signature-was-re-uninline
+++ a/lib/Makefile
@@ -21,7 +21,8 @@ CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
-obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
+obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
+obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
introduce-config_check_signature-was-re-uninline.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
