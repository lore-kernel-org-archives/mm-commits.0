From: akpm@osdl.org
Subject: + schedule-obsolete-oss-drivers-for-removal-3rd-round.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:14:38 -0800
Message-ID: <200701042214.l04MEcIQ000545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:59067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965114AbXADWVW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, sailer@ife.ee.ethz.ch


The patch titled
     schedule obsolete OSS drivers for removal, 3rd round
has been added to the -mm tree.  Its filename is
     schedule-obsolete-oss-drivers-for-removal-3rd-round.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: schedule obsolete OSS drivers for removal, 3rd round
From: Adrian Bunk <bunk@stusta.de>

Schedule obsolete OSS drivers (with ALSA drivers that support the same
hardware) for removal.

A rationale of the patch is in
  http://lkml.org/lkml/2006/12/18/305

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-By: Thomas Sailer <sailer@ife.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/feature-removal-schedule.txt |    7 +++++++
 sound/oss/Kconfig                          |   16 +++++++++++++++-
 sound/oss/dmasound/Kconfig                 |    2 +-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-3rd-round Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-3rd-round
+++ a/Documentation/feature-removal-schedule.txt
@@ -257,3 +257,10 @@ Why:	Speedstep-centrino driver with ACPI
 Who:	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 
 ---------------------------
+
+What:  drivers depending on OBSOLETE_OSS
+When:  options in 2.6.22, code in 2.6.24
+Why:   OSS drivers with ALSA replacements
+Who:   Adrian Bunk <bunk@stusta.de>
+
+---------------------------
diff -puN sound/oss/Kconfig~schedule-obsolete-oss-drivers-for-removal-3rd-round sound/oss/Kconfig
--- a/sound/oss/Kconfig~schedule-obsolete-oss-drivers-for-removal-3rd-round
+++ a/sound/oss/Kconfig
@@ -5,6 +5,20 @@
 #
 # Prompt user for primary drivers.
 
+config OBSOLETE_OSS
+	bool "Obsolete OSS drivers"
+	depends on SOUND_PRIME
+	help
+	  This option enables support for obsolete OSS drivers that
+	  are scheduled for removal in the near future since there
+	  are ALSA drivers for the same hardware.
+
+	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
+	  say Y here because your soundcard is not properly supported
+	  by ALSA.
+
+	  If unsure, say N.
+
 config SOUND_BT878
 	tristate "BT878 audio dma"
 	depends on SOUND_PRIME && PCI
@@ -33,7 +47,7 @@ config SOUND_BCM_CS4297A
 
 config SOUND_ES1371
 	tristate "Creative Ensoniq AudioPCI 97 (ES1371)"
-	depends on SOUND_PRIME && PCI
+	depends on SOUND_PRIME && PCI && OBSOLETE_OSS
 	help
 	  Say Y or M if you have a PCI sound card utilizing the Ensoniq
 	  ES1371 chipset, such as Ensoniq's AudioPCI97. To find out if
diff -puN sound/oss/dmasound/Kconfig~schedule-obsolete-oss-drivers-for-removal-3rd-round sound/oss/dmasound/Kconfig
--- a/sound/oss/dmasound/Kconfig~schedule-obsolete-oss-drivers-for-removal-3rd-round
+++ a/sound/oss/dmasound/Kconfig
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PMAC
 	tristate "PowerMac DMA sound support"
-	depends on PPC32 && PPC_PMAC && SOUND && I2C
+	depends on PPC32 && PPC_PMAC && SOUND && I2C && OBSOLETE_OSS
  	select DMASOUND
 	help
 	  If you want to use the internal audio of your PowerMac in Linux,
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
git-net.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
