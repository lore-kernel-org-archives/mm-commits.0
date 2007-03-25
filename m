From: akpm@linux-foundation.org
Subject: + schedule-obsolete-oss-drivers-for-removal-4th-round.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:23:04 -0800
Message-ID: <200703250923.l2P9N4L3024606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXCYJ0X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:26:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     schedule obsolete OSS drivers for removal, 4th round
has been added to the -mm tree.  Its filename is
     schedule-obsolete-oss-drivers-for-removal-4th-round.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -312,3 +312,11 @@ Why:	Broken. It depends on i2c-algo-8xx 
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
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
