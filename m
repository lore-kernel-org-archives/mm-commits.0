From: akpm@linux-foundation.org
Subject: - remove-options-depending-on-oss_obsolete.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:09 -0700
Message-ID: <200707172306.l6HN69lZ011988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44631 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935450AbXGQXPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     remove options depending on OSS_OBSOLETE
has been removed from the -mm tree.  Its filename was
     remove-options-depending-on-oss_obsolete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove options depending on OSS_OBSOLETE
From: Adrian Bunk <bunk@stusta.de>

This patch contains the scheduled removal of options depending on
OSS_OBSOLETE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Kconfig |   77 --------------------------------------------
 1 file changed, 77 deletions(-)

diff -puN sound/oss/Kconfig~remove-options-depending-on-oss_obsolete sound/oss/Kconfig
--- a/sound/oss/Kconfig~remove-options-depending-on-oss_obsolete
+++ a/sound/oss/Kconfig
@@ -5,35 +5,6 @@
 #
 # Prompt user for primary drivers.
 
-config OSS_OBSOLETE
-	bool "Obsolete OSS drivers"
-	depends on SOUND_PRIME
-	help
-	  This option enables support for obsolete OSS drivers that
-	  are scheduled for removal in the near future.
-
-	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
-	  say Y here because your hardware is not properly supported
-	  by ALSA.
-
-	  If unsure, say N.
-
-config SOUND_BT878
-	tristate "BT878 audio dma"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
-	---help---
-	  Audio DMA support for bt878 based grabber boards.  As you might have
-	  already noticed, bt878 is listed with two functions in /proc/pci.
-	  Function 0 does the video stuff (bt848 compatible), function 1 does
-	  the same for audio data.  This is a driver for the audio part of
-	  the chip.  If you say 'Y' here you get a oss-compatible dsp device
-	  where you can record from.  If you want just watch TV you probably
-	  don't need this driver as most TV cards handle sound with a short
-	  cable from the TV card to your sound card's line-in.
-
-	  To compile this driver as a module, choose M here: the module will
-	  be called btaudio.
-
 config SOUND_BCM_CS4297A
 	tristate "Crystal Sound CS4297a (for Swarm)"
 	depends on SOUND_PRIME && SIBYTE_SWARM
@@ -44,13 +15,6 @@ config SOUND_BCM_CS4297A
 	  note that CONFIG_KGDB should not be enabled at the same
 	  time, since it also attempts to use this UART port.
 
-config SOUND_ICH
-	tristate "Intel ICH (i8xx) audio support"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE
-	help
-	  Support for integral audio in Intel's I/O Controller Hub (ICH)
-	  chipset, as used on the 810/820/840 motherboards.
-
 config SOUND_VWSND
 	tristate "SGI Visual Workstation Sound"
 	depends on SOUND_PRIME && X86_VISWS
@@ -346,26 +310,6 @@ config MSND_FIFOSIZE
 	  and Pinnacle). Larger values reduce the chance of data overruns at
 	  the expense of overall latency. If unsure, use the default.
 
-config SOUND_VIA82CXXX
-	tristate "VIA 82C686 Audio Codec"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE && VIRT_TO_BUS
-	help
-	  Say Y here to include support for the audio codec found on VIA
-	  82Cxxx-based chips. Typically these are built into a motherboard.
-
-	  DO NOT select Sound Blaster or Adlib with this driver, unless
-	  you have a Sound Blaster or Adlib card in addition to your VIA
-	  audio chip.
-
-config MIDI_VIA82CXXX
-	bool "VIA 82C686 MIDI"
-	depends on SOUND_VIA82CXXX && ISA_DMA_API
-	help
-	  Answer Y to use the MIDI interface of the Via686. You may need to
-	  enable this in the BIOS before it will work. This is for connection
-	  to external MIDI hardware, and is not required for software playback
-	  of MIDI files.
-
 config SOUND_OSS
 	tristate "OSS sound modules"
 	depends on SOUND_PRIME && ISA_DMA_API && VIRT_TO_BUS
@@ -400,20 +344,6 @@ config SOUND_DMAP
 
 	  Say Y unless you have 16MB or more RAM or a PCI sound card.
 
-config SOUND_CS4232
-	tristate "Crystal CS4232 based (PnP) cards"
-	depends on SOUND_OSS && OSS_OBSOLETE
-	help
-	  Say Y here if you have a card based on the Crystal CS4232 chip set,
-	  which uses its own Plug and Play protocol.
-
-	  If you compile the driver into the kernel, you have to add
-	  "cs4232=<io>,<irq>,<dma>,<dma2>,<mpuio>,<mpuirq>" to the kernel
-	  command line.
-
-	  See <file:Documentation/sound/oss/CS4232> for more information on
-	  configuring this card.
-
 config SOUND_SSCAPE
 	tristate "Ensoniq SoundScape support"
 	depends on SOUND_OSS
@@ -720,13 +650,6 @@ config SOUND_WAVEARTIST
 	  Say Y here to include support for the Rockwell WaveArtist sound
 	  system.  This driver is mainly for the NetWinder.
 
-config SOUND_TVMIXER
-	tristate "TV card (bt848) mixer support"
-	depends on SOUND_PRIME && I2C && VIDEO_V4L1 && OSS_OBSOLETE
-	help
-	  Support for audio mixer facilities on the BT848 TV frame-grabber
-	  card.
-
 config SOUND_KAHLUA
 	tristate "XpressAudio Sound Blaster emulation"
 	depends on SOUND_SB
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
