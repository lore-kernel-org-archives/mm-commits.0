From: akpm@osdl.org
Subject: - the-scheduled-removal-of-some-oss-options.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:18 -0800
Message-ID: <200612072305.kB7N5Iru030138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163736AbWLGXIe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     The scheduled removal of some OSS options
has been removed from the -mm tree.  Its filename was
     the-scheduled-removal-of-some-oss-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: The scheduled removal of some OSS options
From: Adrian Bunk <bunk@stusta.de>

The scheduled removal of the OSS drivers depending on OSS_OBSOLETE_DRIVER.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/radio/Kconfig |   32 ---------
 sound/oss/Kconfig           |  115 ----------------------------------
 2 files changed, 147 deletions(-)

diff -puN drivers/media/radio/Kconfig~the-scheduled-removal-of-some-oss-options drivers/media/radio/Kconfig
--- a/drivers/media/radio/Kconfig~the-scheduled-removal-of-some-oss-options
+++ a/drivers/media/radio/Kconfig
@@ -173,38 +173,6 @@ config RADIO_MAESTRO
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-maestro.
 
-config RADIO_MIROPCM20
-	tristate "miroSOUND PCM20 radio"
-	depends on ISA && VIDEO_V4L1 && SOUND_ACI_MIXER
-	---help---
-	  Choose Y here if you have this FM radio card. You also need to say Y
-	  to "ACI mixer (miroSOUND PCM1-pro/PCM12/PCM20 radio)" (in "Sound")
-	  for this to work.
-
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called miropcm20.
-
-config RADIO_MIROPCM20_RDS
-	tristate "miroSOUND PCM20 radio RDS user interface (EXPERIMENTAL)"
-	depends on RADIO_MIROPCM20 && EXPERIMENTAL
-	---help---
-	  Choose Y here if you want to see RDS/RBDS information like
-	  RadioText, Programme Service name, Clock Time and date, Programme
-	  Type and Traffic Announcement/Programme identification.
-
-	  It's not possible to read the raw RDS packets from the device, so
-	  the driver cant provide an V4L interface for this.  But the
-	  availability of RDS is reported over V4L by the basic driver
-	  already.  Here RDS can be read from files in /dev/v4l/rds.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called miropcm20-rds.
-
 config RADIO_SF16FMI
 	tristate "SF16FMI Radio"
 	depends on ISA && VIDEO_V4L2
diff -puN sound/oss/Kconfig~the-scheduled-removal-of-some-oss-options sound/oss/Kconfig
--- a/sound/oss/Kconfig~the-scheduled-removal-of-some-oss-options
+++ a/sound/oss/Kconfig
@@ -5,20 +5,6 @@
 #
 # Prompt user for primary drivers.
 
-config OSS_OBSOLETE_DRIVER
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
@@ -35,40 +21,6 @@ config SOUND_BT878
 	  To compile this driver as a module, choose M here: the module will
 	  be called btaudio.
 
-config SOUND_EMU10K1
-	tristate "Creative SBLive! (EMU10K1)"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE_DRIVER
-	---help---
-	  Say Y or M if you have a PCI sound card using the EMU10K1 chipset,
-	  such as the Creative SBLive!, SB PCI512 or Emu-APS.
-
-	  For more information on this driver and the degree of support for
-	  the different card models please check:
-
-		<http://sourceforge.net/projects/emu10k1/>
-
-	  It is now possible to load dsp microcode patches into the EMU10K1
-	  chip.  These patches are used to implement real time sound
-	  processing effects which include for example: signal routing,
-	  bass/treble control, AC3 passthrough, ...
-	  Userspace tools to create new patches and load/unload them can be
-	  found in the emu-tools package at the above URL.
-
-config MIDI_EMU10K1
-	bool "Creative SBLive! MIDI (EXPERIMENTAL)"
-	depends on SOUND_EMU10K1 && EXPERIMENTAL && ISA_DMA_API
-	help
-	  Say Y if you want to be able to use the OSS /dev/sequencer
-	  interface.  This code is still experimental.
-
-config SOUND_FUSION
-	tristate "Crystal SoundFusion (CS4280/461x)"
-	depends on SOUND_PRIME && PCI && OSS_OBSOLETE_DRIVER
-	help
-	  This module drives the Crystal SoundFusion devices (CS4280/46xx
-	  series) when wired as native sound drivers with AC97 codecs.  If
-	  this driver does not work try the CS4232 driver.
-
 config SOUND_BCM_CS4297A
 	tristate "Crystal Sound CS4297a (for Swarm)"
 	depends on SOUND_PRIME && SIBYTE_SWARM
@@ -448,47 +400,6 @@ config SOUND_DMAP
 
 	  Say Y unless you have 16MB or more RAM or a PCI sound card.
 
-config SOUND_AD1816
-	tristate "AD1816(A) based cards (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SOUND_OSS && OSS_OBSOLETE_DRIVER
-	help
-	  Say M here if you have a sound card based on the Analog Devices
-	  AD1816(A) chip.
-
-	  If you compile the driver into the kernel, you have to add
-	  "ad1816=<io>,<irq>,<dma>,<dma2>" to the kernel command line.
-
-config SOUND_AD1889
-	tristate "AD1889 based cards (AD1819 codec) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SOUND_OSS && PCI && OSS_OBSOLETE_DRIVER
-	help
-	  Say M here if you have a sound card based on the Analog Devices
-	  AD1889 chip.
-
-config SOUND_ADLIB
-	tristate "Adlib Cards"
-	depends on SOUND_OSS && OSS_OBSOLETE_DRIVER
-	help
-	  Includes ASB 64 4D. Information on programming AdLib cards is
-	  available at <http://www.itsnet.com/home/ldragon/Specs/adlib.html>.
-
-config SOUND_ACI_MIXER
-	tristate "ACI mixer (miroSOUND PCM1-pro/PCM12/PCM20)"
-	depends on SOUND_OSS && OSS_OBSOLETE_DRIVER
-	---help---
-	  ACI (Audio Command Interface) is a protocol used to communicate with
-	  the microcontroller on some sound cards produced by miro and
-	  Cardinal Technologies.  The main function of the ACI is to control
-	  the mixer and to get a product identification.
-
-	  This VoxWare ACI driver currently supports the ACI functions on the
-	  miroSOUND PCM1-pro, PCM12 and PCM20 radio. On the PCM20 radio, ACI
-	  also controls the radio tuner. This is supported in the video4linux
-	  miropcm20 driver (say M or Y here and go back to "Multimedia
-	  devices" -> "Radio Adapters").
-
-	  This driver is also available as a module and will be called aci.
-
 config SOUND_CS4232
 	tristate "Crystal CS4232 based (PnP) cards"
 	depends on SOUND_OSS
@@ -594,18 +505,6 @@ config SOUND_MPU401
 	  If you compile the driver into the kernel, you have to add
 	  "mpu401=<io>,<irq>" to the kernel command line.
 
-config SOUND_NM256
-	tristate "NM256AV/NM256ZX audio support"
-	depends on SOUND_OSS && OSS_OBSOLETE_DRIVER
-	help
-	  Say M here to include audio support for the NeoMagic 256AV/256ZX
-	  chipsets. These are the audio chipsets found in the Sony
-	  Z505S/SX/DX, some Sony F-series, and the Dell Latitude CPi and CPt
-	  laptops. It includes support for an AC97-compatible mixer and an
-	  apparently proprietary sound engine.
-
-	  See <file:Documentation/sound/oss/NM256> for further information.
-
 config SOUND_PAS
 	tristate "ProAudioSpectrum 16 support"
 	depends on SOUND_OSS
@@ -714,20 +613,6 @@ config SOUND_YM3812
 
 	  If unsure, say Y.
 
-config SOUND_OPL3SA2
-	tristate "Yamaha OPL3-SA2 and SA3 based PnP cards"
-	depends on SOUND_OSS && OSS_OBSOLETE_DRIVER
-	help
-	  Say Y or M if you have a card based on one of these Yamaha sound
-	  chipsets or the "SAx", which is actually a SA3. Read
-	  <file:Documentation/sound/oss/OPL3-SA2> for more information on
-	  configuring these cards.
-
-	  If you compile the driver into the kernel and do not also
-	  configure in the optional ISA PnP support, you will have to add
-	  "opl3sa2=<io>,<irq>,<dma>,<dma2>,<mssio>,<mpuio>" to the kernel
-	  command line.
-
 config SOUND_UART6850
 	tristate "6850 UART support"
 	depends on SOUND_OSS
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

