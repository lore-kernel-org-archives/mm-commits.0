From: akpm@linux-foundation.org
Subject: - schedule-obsolete-oss-drivers-for-removal-4th-round.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:36 -0700
Message-ID: <200705090247.l492laIt008992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031922AbXEICrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     schedule obsolete OSS drivers for removal, 4th round
has been removed from the -mm tree.  Its filename was
     schedule-obsolete-oss-drivers-for-removal-4th-round.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: schedule obsolete OSS drivers for removal, 4th round
From: Adrian Bunk <bunk@stusta.de>

Schedule obsolete OSS drivers for removal.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++
 sound/oss/Kconfig                          |   23 ++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-4th-round Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-4th-round
+++ a/Documentation/feature-removal-schedule.txt
@@ -323,3 +323,11 @@ Why:	Obsolete. The new i2c-gpio driver r
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
+
+What:  drivers depending on OSS_OBSOLETE
+When:  options in 2.6.23, code in 2.6.25
+Why:   obsolete OSS drivers
+Who:   Adrian Bunk <bunk@stusta.de>
+
+---------------------------
+
diff -puN sound/oss/Kconfig~schedule-obsolete-oss-drivers-for-removal-4th-round sound/oss/Kconfig
--- a/sound/oss/Kconfig~schedule-obsolete-oss-drivers-for-removal-4th-round
+++ a/sound/oss/Kconfig
@@ -5,9 +5,22 @@
 #
 # Prompt user for primary drivers.
 
+config OSS_OBSOLETE
+	bool "Obsolete OSS drivers"
+	depends on SOUND_PRIME
+	help
+	  This option enables support for obsolete OSS drivers that
+	  are scheduled for removal in the near future.
+
+	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
+	  say Y here because your hardware is not properly supported
+	  by ALSA.
+
+	  If unsure, say N.
+
 config SOUND_BT878
 	tristate "BT878 audio dma"
-	depends on SOUND_PRIME && PCI
+	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
 	---help---
 	  Audio DMA support for bt878 based grabber boards.  As you might have
 	  already noticed, bt878 is listed with two functions in /proc/pci.
@@ -33,7 +46,7 @@ config SOUND_BCM_CS4297A
 
 config SOUND_ICH
 	tristate "Intel ICH (i8xx) audio support"
-	depends on SOUND_PRIME && PCI
+	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
 	help
 	  Support for integral audio in Intel's I/O Controller Hub (ICH)
 	  chipset, as used on the 810/820/840 motherboards.
@@ -335,7 +348,7 @@ config MSND_FIFOSIZE
 
 config SOUND_VIA82CXXX
 	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI
+	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
 	help
 	  Say Y here to include support for the audio codec found on VIA
 	  82Cxxx-based chips. Typically these are built into a motherboard.
@@ -389,7 +402,7 @@ config SOUND_DMAP
 
 config SOUND_CS4232
 	tristate "Crystal CS4232 based (PnP) cards"
-	depends on SOUND_OSS
+	depends on SOUND_OSS && OSS_OBSOLETE
 	help
 	  Say Y here if you have a card based on the Crystal CS4232 chip set,
 	  which uses its own Plug and Play protocol.
@@ -708,7 +721,7 @@ config SOUND_WAVEARTIST
 
 config SOUND_TVMIXER
 	tristate "TV card (bt848) mixer support"
-	depends on SOUND_PRIME && I2C && VIDEO_V4L1
+	depends on SOUND_PRIME && I2C && VIDEO_V4L1 && OSS_OBSOLETE
 	help
 	  Support for audio mixer facilities on the BT848 TV frame-grabber
 	  card.
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
