From: akpm@linux-foundation.org
Subject: - schedule-obsolete-oss-drivers-for-removal-3rd-round.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:53:21 -0800
Message-ID: <200702112253.l1BMrL0b016092@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXBKW7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, sailer@ife.ee.ethz.ch, mm-commits@vger.kernel.org


The patch titled
     schedule obsolete OSS drivers for removal, 3rd round
has been removed from the -mm tree.  Its filename was
     schedule-obsolete-oss-drivers-for-removal-3rd-round.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: schedule obsolete OSS drivers for removal, 3rd round
From: Adrian Bunk <bunk@stusta.de>

Schedule obsolete OSS drivers (with ALSA drivers that support the same
hardware) for removal.

A rationale of the patch is in
  http://lkml.org/lkml/2006/12/18/305

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-By: Thomas Sailer <sailer@ife.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    7 +++++++
 sound/oss/Kconfig                          |   16 +++++++++++++++-
 sound/oss/dmasound/Kconfig                 |    2 +-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-3rd-round Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~schedule-obsolete-oss-drivers-for-removal-3rd-round
+++ a/Documentation/feature-removal-schedule.txt
@@ -215,6 +215,13 @@ Who:	Jean Delvare <khali@linux-fr.org>,
 
 ---------------------------
 
+What:  drivers depending on OBSOLETE_OSS
+When:  options in 2.6.22, code in 2.6.24
+Why:   OSS drivers with ALSA replacements
+Who:   Adrian Bunk <bunk@stusta.de>
+
+---------------------------
+
 What:	IPv4 only connection tracking/NAT/helpers
 When:	2.6.22
 Why:	The new layer 3 independant connection tracking replaces the old
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

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
