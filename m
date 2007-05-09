From: akpm@linux-foundation.org
Subject: - the-scheduled-removal-of-obsolete_oss-options.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:50 -0700
Message-ID: <200705090245.l492jotB008781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031593AbXEICqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     the scheduled removal of OBSOLETE_OSS options
has been removed from the -mm tree.  Its filename was
     the-scheduled-removal-of-obsolete_oss-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
