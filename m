From: akpm@linux-foundation.org
Subject: + the-scheduled-removal-of-obsolete_oss-options.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:54:39 -0800
Message-ID: <200703060354.l263sdG8011129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926AbXCFD54 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:57:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     the scheduled removal of OBSOLETE_OSS options
has been added to the -mm tree.  Its filename is
     the-scheduled-removal-of-obsolete_oss-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: the scheduled removal of OBSOLETE_OSS options
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Kconfig          |   27 ---------------------------
 sound/oss/dmasound/Kconfig |   14 --------------
 2 files changed, 41 deletions(-)

diff -puN sound/oss/dmasound/Kconfig~the-scheduled-removal-of-obsolete_oss-options sound/oss/dmasound/Kconfig
--- a/sound/oss/dmasound/Kconfig~the-scheduled-removal-of-obsolete_oss-options
+++ a/sound/oss/dmasound/Kconfig
@@ -12,20 +12,6 @@ config DMASOUND_ATARI
 	  want). If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.
 
-config DMASOUND_PMAC
-	tristate "PowerMac DMA sound support"
-	depends on PPC32 && PPC_PMAC && SOUND && I2C && OBSOLETE_OSS
- 	select DMASOUND
-	help
-	  If you want to use the internal audio of your PowerMac in Linux,
-	  answer Y to this question. This will provide a Sun-like /dev/audio,
-	  compatible with the Linux/i386 sound system. Otherwise, say N.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you
-	  want). If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.
-
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
 	depends on (AMIGA || APUS) && SOUND
diff -puN sound/oss/Kconfig~the-scheduled-removal-of-obsolete_oss-options sound/oss/Kconfig
--- a/sound/oss/Kconfig~the-scheduled-removal-of-obsolete_oss-options
+++ a/sound/oss/Kconfig
@@ -5,20 +5,6 @@
 #
 # Prompt user for primary drivers.
 
-config OBSOLETE_OSS
-	bool "Obsolete OSS drivers"
-	depends on SOUND_PRIME
-	help
-	  This option enables support for obsolete OSS drivers that
-	  are scheduled for removal in the near future since there
-	  are ALSA drivers for the same hardware.
-
-	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
-	  say Y here because your soundcard is not properly supported
-	  by ALSA.
-
-	  If unsure, say N.
-
 config SOUND_BT878
 	tristate "BT878 audio dma"
 	depends on SOUND_PRIME && PCI
@@ -45,19 +31,6 @@ config SOUND_BCM_CS4297A
 	  note that CONFIG_KGDB should not be enabled at the same
 	  time, since it also attempts to use this UART port.
 
-config SOUND_ES1371
-	tristate "Creative Ensoniq AudioPCI 97 (ES1371)"
-	depends on SOUND_PRIME && PCI && OBSOLETE_OSS
-	help
-	  Say Y or M if you have a PCI sound card utilizing the Ensoniq
-	  ES1371 chipset, such as Ensoniq's AudioPCI97. To find out if
-	  your sound card uses an ES1371 without removing your computer's
-	  cover, use lspci -n and look for the PCI ID 1274:1371. Since
-	  Ensoniq was bought by Creative Labs, Sound Blaster 64/PCI
-	  models are either ES1370 or ES1371 based. This driver differs
-	  slightly from OSS/Free, so PLEASE READ
-	  <file:Documentation/sound/oss/es1371>.
-
 config SOUND_ICH
 	tristate "Intel ICH (i8xx) audio support"
 	depends on SOUND_PRIME && PCI
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
drivers-cpuidle-make-code-static.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
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
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
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
