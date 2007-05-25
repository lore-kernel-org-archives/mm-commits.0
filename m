From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-sound.patch removed from -mm tree
Date: Fri, 25 May 2007 10:28:14 -0700
Message-ID: <200705251728.l4PHSEuX023805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763628AbXEYR3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 May 2007 13:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - sound
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-sound.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use menuconfig objects II - sound
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

CONFIG_SOUND, CONFIG_SND, CONFIG_SOUND_PRIME, ...:
Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

CONFIG_SND_*_DRIVERS:
Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

CONFIG_SOUND_KAHULA:
Move it so that it appears correctly in menuconfig.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/Kconfig             |   31 +++++++--------
 sound/aoa/Kconfig         |   11 ++---
 sound/aoa/fabrics/Kconfig |    1 
 sound/arm/Kconfig         |   16 +++++---
 sound/core/Kconfig        |   18 +--------
 sound/drivers/Kconfig     |   20 ++++------
 sound/isa/Kconfig         |   45 +++++++----------------
 sound/mips/Kconfig        |   13 ++++--
 sound/oss/Kconfig         |   29 +++++---------
 sound/parisc/Kconfig      |   11 +++--
 sound/pci/Kconfig         |   70 +++++-------------------------------
 sound/pcmcia/Kconfig      |   12 +++---
 sound/ppc/Kconfig         |   16 +++++---
 sound/soc/Kconfig         |   10 +++--
 sound/soc/codecs/Kconfig  |    9 ++--
 sound/sparc/Kconfig       |   15 ++++---
 sound/usb/Kconfig         |   15 ++++---
 17 files changed, 134 insertions(+), 208 deletions(-)

diff -puN sound/Kconfig~use-menuconfig-objects-ii-sound sound/Kconfig
--- a/sound/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/Kconfig
@@ -1,10 +1,7 @@
 # sound/Config.in
 #
 
-menu "Sound"
-	depends on HAS_IOMEM
-
-config SOUND
+menuconfig SOUND
 	tristate "Sound card support"
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
@@ -33,14 +30,13 @@ config SOUND
 	  Kernel patches and supporting utilities to do that are in the pcsp
 	  package, available at <ftp://ftp.infradead.org/pub/pcsp/>.
 
+if SOUND
+
 source "sound/oss/dmasound/Kconfig"
 
 if !M68K
 
-menu "Advanced Linux Sound Architecture"
-	depends on SOUND!=n
-
-config SND
+menuconfig SND
 	tristate "Advanced Linux Sound Architecture"
 	depends on SOUND
 	help
@@ -49,6 +45,8 @@ config SND
 
 	  For more information, see <http://www.alsa-project.org/>
 
+if SND
+
 source "sound/core/Kconfig"
 
 source "sound/drivers/Kconfig"
@@ -79,22 +77,23 @@ source "sound/parisc/Kconfig"
 
 source "sound/soc/Kconfig"
 
-endmenu
+endif # SND
 
-menu "Open Sound System"
-	depends on SOUND!=n
-
-config SOUND_PRIME
+menuconfig SOUND_PRIME
 	tristate "Open Sound System (DEPRECATED)"
 	depends on SOUND
 	help
 	  Say 'Y' or 'M' to enable Open Sound System drivers.
 
+if SOUND_PRIME
+
 source "sound/oss/Kconfig"
 
-endmenu
+endif # SOUND_PRIME
 
-endif
+endif # !M68K
+
+endif # SOUND
 
 config AC97_BUS
 	tristate
@@ -103,5 +102,3 @@ config AC97_BUS
 	  sound subsystem and other function drivers completely unrelated to
 	  sound although they're sharing the AC97 bus. Concerned drivers
 	  should "select" this.
-
-endmenu
diff -puN sound/aoa/Kconfig~use-menuconfig-objects-ii-sound sound/aoa/Kconfig
--- a/sound/aoa/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/aoa/Kconfig
@@ -1,18 +1,17 @@
-menu "Apple Onboard Audio driver"
-	depends on SND!=n && PPC_PMAC
-
-config SND_AOA
+menuconfig SND_AOA
 	tristate "Apple Onboard Audio driver"
-	depends on SND
+	depends on PPC_PMAC
 	select SND_PCM
 	---help---
 	This option enables the new driver for the various
 	Apple Onboard Audio components.
 
+if SND_AOA
+
 source "sound/aoa/fabrics/Kconfig"
 
 source "sound/aoa/codecs/Kconfig"
 
 source "sound/aoa/soundbus/Kconfig"
 
-endmenu
+endif # SND_AOA
diff -puN sound/aoa/fabrics/Kconfig~use-menuconfig-objects-ii-sound sound/aoa/fabrics/Kconfig
--- a/sound/aoa/fabrics/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/aoa/fabrics/Kconfig
@@ -1,6 +1,5 @@
 config SND_AOA_FABRIC_LAYOUT
 	tristate "layout-id fabric"
-	depends on SND_AOA
 	select SND_AOA_SOUNDBUS
 	select SND_AOA_SOUNDBUS_I2S
 	---help---
diff -puN sound/arm/Kconfig~use-menuconfig-objects-ii-sound sound/arm/Kconfig
--- a/sound/arm/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/arm/Kconfig
@@ -1,11 +1,15 @@
 # ALSA ARM drivers
 
-menu "ALSA ARM devices"
-	depends on SND!=n && ARM
+menuconfig SND_ARM_DRIVERS
+	bool "ALSA ARM devices"
+	depends on ARM
+	default y
+
+if SND_ARM_DRIVERS
 
 config SND_SA11XX_UDA1341
 	tristate "SA11xx UDA1341TS driver (iPaq H3600)"
-	depends on ARCH_SA1100 && SND && L3
+	depends on ARCH_SA1100 && L3
 	select SND_PCM
 	help
 	  Say Y here if you have a Compaq iPaq H3x00 handheld computer
@@ -16,7 +20,7 @@ config SND_SA11XX_UDA1341
 
 config SND_ARMAACI
 	tristate "ARM PrimeCell PL041 AC Link support"
-	depends on SND && ARM_AMBA
+	depends on ARM_AMBA
 	select SND_PCM
 	select SND_AC97_CODEC
 
@@ -26,11 +30,11 @@ config SND_PXA2XX_PCM
 
 config SND_PXA2XX_AC97
 	tristate "AC97 driver for the Intel PXA2xx chip"
-	depends on ARCH_PXA && SND
+	depends on ARCH_PXA
 	select SND_PXA2XX_PCM
 	select SND_AC97_CODEC
 	help
 	  Say Y or M if you want to support any AC97 codec attached to
 	  the PXA2xx AC97 interface.
 
-endmenu
+endif # SND_ARM_DRIVERS
diff -puN sound/core/Kconfig~use-menuconfig-objects-ii-sound sound/core/Kconfig
--- a/sound/core/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/core/Kconfig
@@ -1,24 +1,19 @@
 # ALSA soundcard-configuration
 config SND_TIMER
 	tristate
-	depends on SND
 
 config SND_PCM
 	tristate
 	select SND_TIMER
-	depends on SND
 
 config SND_HWDEP
 	tristate
-	depends on SND
 
 config SND_RAWMIDI
 	tristate
-	depends on SND
 
 config SND_SEQUENCER
 	tristate "Sequencer support"
-	depends on SND
 	select SND_TIMER
 	help
 	  Say Y or M to enable MIDI sequencer and router support.  This
@@ -44,11 +39,9 @@ config SND_SEQ_DUMMY
 
 config SND_OSSEMUL
 	bool
-	depends on SND
 
 config SND_MIXER_OSS
 	tristate "OSS Mixer API"
-	depends on SND
 	select SND_OSSEMUL
 	help
 	  To enable OSS mixer API emulation (/dev/mixer*), say Y here
@@ -61,7 +54,6 @@ config SND_MIXER_OSS
 
 config SND_PCM_OSS
 	tristate "OSS PCM (digital audio) API"
-	depends on SND
 	select SND_OSSEMUL
 	select SND_PCM
 	help
@@ -84,7 +76,7 @@ config SND_PCM_OSS_PLUGINS
 
 config SND_SEQUENCER_OSS
 	bool "OSS Sequencer API"
-	depends on SND && SND_SEQUENCER
+	depends on SND_SEQUENCER
 	select SND_OSSEMUL
 	help
 	  Say Y here to enable OSS sequencer emulation (both
@@ -98,7 +90,7 @@ config SND_SEQUENCER_OSS
 
 config SND_RTCTIMER
 	tristate "RTC Timer support"
-	depends on SND && RTC
+	depends on RTC
 	select SND_TIMER
 	help
 	  Say Y here to enable RTC timer support for ALSA.  ALSA uses
@@ -123,7 +115,6 @@ config SND_SEQ_RTCTIMER_DEFAULT
 
 config SND_DYNAMIC_MINORS
 	bool "Dynamic device file minor numbers"
-	depends on SND
 	help
 	  If you say Y here, the minor numbers of ALSA device files in
 	  /dev/snd/ are allocated dynamically.  This allows you to have
@@ -134,7 +125,6 @@ config SND_DYNAMIC_MINORS
 
 config SND_SUPPORT_OLD_API
 	bool "Support old ALSA API"
-	depends on SND
 	default y
 	help
 	  Say Y here to support the obsolete ALSA PCM API (ver.0.9.0 rc3
@@ -142,7 +132,7 @@ config SND_SUPPORT_OLD_API
 
 config SND_VERBOSE_PROCFS
 	bool "Verbose procfs contents"
-	depends on SND && PROC_FS
+	depends on PROC_FS
 	default y
 	help
 	  Say Y here to include code for verbose procfs contents (provides
@@ -151,7 +141,6 @@ config SND_VERBOSE_PROCFS
 
 config SND_VERBOSE_PRINTK
 	bool "Verbose printk"
-	depends on SND
 	help
 	  Say Y here to enable verbose log messages.  These messages
 	  will help to identify source file and position containing
@@ -161,7 +150,6 @@ config SND_VERBOSE_PRINTK
 
 config SND_DEBUG
 	bool "Debug"
-	depends on SND
 	help
 	  Say Y here to enable ALSA debug code.
 
diff -puN sound/drivers/Kconfig~use-menuconfig-objects-ii-sound sound/drivers/Kconfig
--- a/sound/drivers/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/drivers/Kconfig
@@ -1,9 +1,5 @@
 # ALSA generic drivers
 
-menu "Generic devices"
-	depends on SND!=n
-
-
 config SND_MPU401_UART
         tristate
         select SND_RAWMIDI
@@ -28,9 +24,14 @@ config SND_AC97_CODEC
 	select SND_PCM
 	select AC97_BUS
 
+menuconfig SND_GENERIC_DRIVERS
+	bool "Generic devices"
+	default y
+
+if SND_GENERIC_DRIVERS
+
 config SND_DUMMY
 	tristate "Dummy (/dev/null) soundcard"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include the dummy driver.  This driver does
@@ -59,7 +60,6 @@ config SND_VIRMIDI
 
 config SND_MTPAV
 	tristate "MOTU MidiTimePiece AV multiport MIDI"
-	depends on SND
 	select SND_RAWMIDI
 	help
 	  To use a MOTU MidiTimePiece AV multiport MIDI adapter
@@ -71,7 +71,7 @@ config SND_MTPAV
 
 config SND_MTS64
 	tristate "ESI Miditerminal 4140 driver"
-	depends on SND && PARPORT
+	depends on PARPORT
 	select SND_RAWMIDI
 	help
 	  The ESI Miditerminal 4140 is a 4 In 4 Out MIDI Interface with 
@@ -84,7 +84,6 @@ config SND_MTS64
 
 config SND_SERIAL_U16550
 	tristate "UART16550 serial MIDI driver"
-	depends on SND
 	select SND_RAWMIDI
 	help
 	  To include support for MIDI serial port interfaces, say Y here
@@ -100,7 +99,6 @@ config SND_SERIAL_U16550
 
 config SND_MPU401
 	tristate "Generic MPU-401 UART driver"
-	depends on SND
 	select SND_MPU401_UART
 	help
 	  Say Y here to include support for MIDI ports compatible with
@@ -111,7 +109,7 @@ config SND_MPU401
 
 config SND_PORTMAN2X4
 	tristate "Portman 2x4 driver"
-	depends on SND && PARPORT
+	depends on PARPORT
 	select SND_RAWMIDI
 	help
 	  Say Y here to include support for Midiman Portman 2x4 parallel
@@ -120,4 +118,4 @@ config SND_PORTMAN2X4
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-portman2x4.
 
-endmenu
+endif # SND_GENERIC_DRIVERS
diff -puN sound/isa/Kconfig~use-menuconfig-objects-ii-sound sound/isa/Kconfig
--- a/sound/isa/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/isa/Kconfig
@@ -1,7 +1,11 @@
 # ALSA ISA drivers
 
-menu "ISA devices"
-	depends on SND!=n && ISA && ISA_DMA_API
+menuconfig SND_ISA_DRIVERS
+	bool "ISA devices"
+	depends on ISA && ISA_DMA_API
+	default y
+
+if SND_ISA_DRIVERS
 
 config SND_AD1848_LIB
         tristate
@@ -13,7 +17,6 @@ config SND_CS4231_LIB
 
 config SND_ADLIB
 	tristate "AdLib FM card"
-	depends on SND
 	select SND_OPL3_LIB
 	help
 	  Say Y here to include support for AdLib FM cards.
@@ -23,7 +26,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -37,7 +40,6 @@ config SND_AD1816A
 
 config SND_AD1848
 	tristate "Generic AD1848/CS4248 driver"
-	depends on SND
 	select SND_AD1848_LIB
 	help
 	  Say Y here to include support for AD1848 (Analog Devices) or
@@ -51,7 +53,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Avance Logic ALS100/ALS120"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -65,7 +67,7 @@ config SND_ALS100
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -79,7 +81,6 @@ config SND_AZT2320
 
 config SND_CMI8330
 	tristate "C-Media CMI8330"
-	depends on SND
 	select SND_AD1848_LIB
 	help
 	  Say Y here to include support for soundcards based on the
@@ -90,7 +91,6 @@ config SND_CMI8330
 
 config SND_CS4231
 	tristate "Generic Cirrus Logic CS4231 driver"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
 	help
@@ -102,7 +102,6 @@ config SND_CS4231
 
 config SND_CS4232
 	tristate "Generic Cirrus Logic CS4232 driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -115,7 +114,6 @@ config SND_CS4232
 
 config SND_CS4236
 	tristate "Generic Cirrus Logic CS4236+ driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -128,7 +126,7 @@ config SND_CS4236
 
 config SND_DT019X
 	tristate "Diamond Technologies DT-019X, Avance Logic ALS-007"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -142,7 +140,7 @@ config SND_DT019X
 
 config SND_ES968
 	tristate "Generic ESS ES968 driver"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select ISAPNP
 	select SND_MPU401_UART
 	select SND_PCM
@@ -154,7 +152,6 @@ config SND_ES968
 
 config SND_ES1688
 	tristate "Generic ESS ES688/ES1688 driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -167,7 +164,6 @@ config SND_ES1688
 
 config SND_ES18XX
 	tristate "Generic ESS ES18xx driver"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -182,7 +178,6 @@ config SND_GUS_SYNTH
 
 config SND_GUSCLASSIC
 	tristate "Gravis UltraSound Classic"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_PCM
 	select SND_GUS_SYNTH
@@ -195,7 +190,6 @@ config SND_GUSCLASSIC
 
 config SND_GUSEXTREME
 	tristate "Gravis UltraSound Extreme"
-	depends on SND
 	select SND_HWDEP
 	select SND_MPU401_UART
 	select SND_PCM
@@ -209,7 +203,6 @@ config SND_GUSEXTREME
 
 config SND_GUSMAX
 	tristate "Gravis UltraSound MAX"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -222,7 +215,7 @@ config SND_GUSMAX
 
 config SND_INTERWAVE
 	tristate "AMD InterWave, Gravis UltraSound PnP"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -236,7 +229,7 @@ config SND_INTERWAVE
 
 config SND_INTERWAVE_STB
 	tristate "AMD InterWave + TEA6330T (UltraSound 32-Pro)"
-	depends on SND && PNP && ISA
+	depends on PNP
 	select SND_RAWMIDI
 	select SND_CS4231_LIB
 	select SND_GUS_SYNTH
@@ -250,7 +243,6 @@ config SND_INTERWAVE_STB
 
 config SND_OPL3SA2
 	tristate "Yamaha OPL3-SA2/SA3"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -263,7 +255,6 @@ config SND_OPL3SA2
 
 config SND_OPTI92X_AD1848
 	tristate "OPTi 82C92x - AD1848"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -277,7 +268,6 @@ config SND_OPTI92X_AD1848
 
 config SND_OPTI92X_CS4231
 	tristate "OPTi 82C92x - CS4231"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_OPL4_LIB
 	select SND_MPU401_UART
@@ -291,7 +281,6 @@ config SND_OPTI92X_CS4231
 
 config SND_OPTI93X
 	tristate "OPTi 82C93x"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -304,7 +293,6 @@ config SND_OPTI93X
 
 config SND_MIRO
 	tristate "Miro miroSOUND PCM1pro/PCM12/PCM20radio driver"
-	depends on SND
 	select SND_OPL4_LIB
 	select SND_CS4231_LIB
 	select SND_MPU401_UART
@@ -318,7 +306,6 @@ config SND_MIRO
 
 config SND_SB8
 	tristate "Sound Blaster 1.0/2.0/Pro (8-bit)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_PCM
@@ -331,7 +318,6 @@ config SND_SB8
 
 config SND_SB16
 	tristate "Sound Blaster 16 (PnP)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -344,7 +330,6 @@ config SND_SB16
 
 config SND_SBAWE
 	tristate "Sound Blaster AWE (32,64) (PnP)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -386,7 +371,6 @@ config SND_SGALAXY
 
 config SND_SSCAPE
 	tristate "Ensoniq SoundScape PnP driver"
-	depends on SND
 	select SND_HWDEP
 	select SND_MPU401_UART
 	select SND_CS4231_LIB
@@ -399,7 +383,6 @@ config SND_SSCAPE
 
 config SND_WAVEFRONT
 	tristate "Turtle Beach Maui,Tropez,Tropez+ (Wavefront)"
-	depends on SND
 	select FW_LOADER if !SND_WAVEFRONT_FIRMWARE_IN_KERNEL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -420,4 +403,4 @@ config SND_WAVEFRONT_FIRMWARE_IN_KERNEL
 	  for the Wavefront driver.  If you choose N here, you need to
 	  install the firmware files from the alsa-firmware package.
 
-endmenu
+endif # SND_ISA_DRIVERS
diff -puN sound/mips/Kconfig~use-menuconfig-objects-ii-sound sound/mips/Kconfig
--- a/sound/mips/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/mips/Kconfig
@@ -1,15 +1,18 @@
 # ALSA MIPS drivers
 
-menu "ALSA MIPS devices"
-	depends on SND!=n && MIPS
+menuconfig SND_MIPS_DRIVERS
+	bool "ALSA MIPS devices"
+	depends on MIPS
+	default y
+
+if SND_MIPS_DRIVERS
 
 config SND_AU1X00
 	tristate "Au1x00 AC97 Port Driver"
-	depends on (SOC_AU1000 || SOC_AU1100 || SOC_AU1500) && SND
+	depends on SOC_AU1000 || SOC_AU1100 || SOC_AU1500
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
 	  ALSA Sound driver for the Au1x00's AC97 port.
 
-endmenu
-
+endif # SND_MIPS_DRIVERS
diff -puN sound/oss/Kconfig~use-menuconfig-objects-ii-sound sound/oss/Kconfig
--- a/sound/oss/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/oss/Kconfig
@@ -376,16 +376,16 @@ config SOUND_OSS
 	  driver for your sound card above, then pick your driver from the
 	  list below.
 
+if SOUND_OSS
+
 config SOUND_TRACEINIT
 	bool "Verbose initialisation"
-	depends on SOUND_OSS
 	help
 	  Verbose soundcard initialization -- affects the format of autoprobe
 	  and initialization messages at boot time.
 
 config SOUND_DMAP
 	bool "Persistent DMA buffers"
-	depends on SOUND_OSS
 	---help---
 	  Linux can often have problems allocating DMA buffers for ISA sound
 	  cards on machines with more than 16MB of RAM. This is because ISA
@@ -402,7 +402,7 @@ config SOUND_DMAP
 
 config SOUND_CS4232
 	tristate "Crystal CS4232 based (PnP) cards"
-	depends on SOUND_OSS && OSS_OBSOLETE
+	depends on OSS_OBSOLETE
 	help
 	  Say Y here if you have a card based on the Crystal CS4232 chip set,
 	  which uses its own Plug and Play protocol.
@@ -416,7 +416,6 @@ config SOUND_CS4232
 
 config SOUND_SSCAPE
 	tristate "Ensoniq SoundScape support"
-	depends on SOUND_OSS
 	help
 	  Answer Y if you have a sound card based on the Ensoniq SoundScape
 	  chipset. Such cards are being manufactured at least by Ensoniq, Spea
@@ -429,13 +428,11 @@ config SOUND_SSCAPE
 
 config SOUND_VMIDI
 	tristate "Loopback MIDI device support"
-	depends on SOUND_OSS
 	help
 	  Support for MIDI loopback on port 1 or 2.
 
 config SOUND_TRIX
 	tristate "MediaTrix AudioTrix Pro support"
-	depends on SOUND_OSS
 	help
 	  Answer Y if you have the AudioTriX Pro sound card manufactured
 	  by MediaTrix.
@@ -459,7 +456,6 @@ config TRIX_BOOT_FILE
 
 config SOUND_MSS
 	tristate "Microsoft Sound System support"
-	depends on SOUND_OSS
 	---help---
 	  Again think carefully before answering Y to this question.  It's
 	  safe to answer Y if you have the original Windows Sound System card
@@ -491,7 +487,6 @@ config SOUND_MSS
 
 config SOUND_MPU401
 	tristate "MPU-401 support (NOT for SB16)"
-	depends on SOUND_OSS
 	---help---
 	  Be careful with this question.  The MPU401 interface is supported by
 	  all sound cards.  However, some natively supported cards have their
@@ -507,7 +502,6 @@ config SOUND_MPU401
 
 config SOUND_PAS
 	tristate "ProAudioSpectrum 16 support"
-	depends on SOUND_OSS
 	---help---
 	  Answer Y only if you have a Pro Audio Spectrum 16, ProAudio Studio
 	  16 or Logitech SoundMan 16 sound card. Answer N if you have some
@@ -529,7 +523,6 @@ config PAS_JOYSTICK
 
 config SOUND_PSS
 	tristate "PSS (AD1848, ADSP-2115, ESC614) support"
-	depends on SOUND_OSS
 	help
 	  Answer Y or M if you have an Orchid SW32, Cardinal DSP16, Beethoven
 	  ADSP-16 or some other card based on the PSS chipset (AD1848 codec +
@@ -572,7 +565,6 @@ config PSS_BOOT_FILE
 
 config SOUND_SB
 	tristate "100% Sound Blaster compatibles (SB16/32/64, ESS, Jazz16) support"
-	depends on SOUND_OSS
 	---help---
 	  Answer Y if you have an original Sound Blaster card made by Creative
 	  Labs or a 100% hardware compatible clone (like the Thunderboard or
@@ -597,9 +589,12 @@ config SOUND_SB
 	  You can say M here to compile this driver as a module; the module is
 	  called sb.
 
+config SOUND_KAHLUA
+	tristate "XpressAudio Sound Blaster emulation"
+	depends on SOUND_SB
+
 config SOUND_YM3812
 	tristate "Yamaha FM synthesizer (YM3812/OPL-3) support"
-	depends on SOUND_OSS
 	---help---
 	  Answer Y if your card has a FM chip made by Yamaha (OPL2/OPL3/OPL4).
 	  Answering Y is usually a safe and recommended choice, however some
@@ -615,7 +610,6 @@ config SOUND_YM3812
 
 config SOUND_UART6850
 	tristate "6850 UART support"
-	depends on SOUND_OSS
 	help
 	  This option enables support for MIDI interfaces based on the 6850
 	  UART chip. This interface is rarely found on sound cards. It's safe
@@ -626,7 +620,6 @@ config SOUND_UART6850
 
 config SOUND_AEDSP16
 	tristate "Gallant Audio Cards (SC-6000 and SC-6600 based)"
-	depends on SOUND_OSS
 	---help---
 	  Answer Y if you have a Gallant's Audio Excel DSP 16 card. This
 	  driver supports Audio Excel DSP 16 but not the III nor PnP versions
@@ -707,14 +700,14 @@ endchoice
 
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
-	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500) && SOUND_OSS
+	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500)
 	help
 	  16-bit support for the VIDC onboard sound hardware found on Acorn
 	  machines.
 
 config SOUND_WAVEARTIST
 	tristate "Netwinder WaveArtist"
-	depends on ARM && SOUND_OSS && ARCH_NETWINDER
+	depends on ARM && ARCH_NETWINDER
 	help
 	  Say Y here to include support for the Rockwell WaveArtist sound
 	  system.  This driver is mainly for the NetWinder.
@@ -726,9 +719,7 @@ config SOUND_TVMIXER
 	  Support for audio mixer facilities on the BT848 TV frame-grabber
 	  card.
 
-config SOUND_KAHLUA
-	tristate "XpressAudio Sound Blaster emulation"
-	depends on SOUND_SB
+endif # SOUND_OSS
 
 config SOUND_SH_DAC_AUDIO
 	tristate "SuperH DAC audio support"
diff -puN sound/parisc/Kconfig~use-menuconfig-objects-ii-sound sound/parisc/Kconfig
--- a/sound/parisc/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/parisc/Kconfig
@@ -1,15 +1,18 @@
 # ALSA PA-RISC drivers
 
-menu "GSC devices"
-	depends on SND!=n && GSC
+menuconfig SND_PARISC_DRIVERS
+	bool "GSC devices"
+	depends on GSC
+	default y
+
+if SND_PARISC_DRIVERS
 
 config SND_HARMONY
 	tristate "Harmony/Vivace sound chip"
-	depends on SND
 	select SND_PCM
 	help
 	  Say 'Y' or 'M' to include support for the Harmony/Vivace sound
 	  chip found in most GSC-based PA-RISC workstations.  It's frequently
 	  provided as part of the Lasi multi-function IC.
 
-endmenu
+endif # SND_PARISC_DRIVERS
diff -puN sound/pci/Kconfig~use-menuconfig-objects-ii-sound sound/pci/Kconfig
--- a/sound/pci/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/pci/Kconfig
@@ -1,11 +1,14 @@
 # ALSA PCI drivers
 
-menu "PCI devices"
-	depends on SND!=n && PCI
+menuconfig SND_PCI_DRIVERS
+	bool "PCI devices"
+	depends on PCI
+	default y
+
+if SND_PCI_DRIVERS
 
 config SND_AD1889
 	tristate "Analog Devices AD1889"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -17,7 +20,6 @@ config SND_AD1889
 
 config SND_ALS300
 	tristate "Avance Logic ALS300/ALS300+"
-	depends on SND
 	select SND_PCM
 	select SND_AC97_CODEC
 	select SND_OPL3_LIB
@@ -29,7 +31,7 @@ config SND_ALS300
 
 config SND_ALS4000
 	tristate "Avance Logic ALS4000"
-	depends on SND && ISA_DMA_API
+	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -42,7 +44,6 @@ config SND_ALS4000
 
 config SND_ALI5451
 	tristate "ALi M5451 PCI Audio Controller"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -56,7 +57,6 @@ config SND_ALI5451
 
 config SND_ATIIXP
 	tristate "ATI IXP AC97 Controller"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -68,7 +68,6 @@ config SND_ATIIXP
 
 config SND_ATIIXP_MODEM
 	tristate "ATI IXP Modem"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -79,7 +78,6 @@ config SND_ATIIXP_MODEM
 
 config SND_AU8810
 	tristate "Aureal Advantage"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -94,7 +92,6 @@ config SND_AU8810
 
 config SND_AU8820
 	tristate "Aureal Vortex"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -108,7 +105,6 @@ config SND_AU8820
 
 config SND_AU8830
 	tristate "Aureal Vortex 2"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -123,7 +119,7 @@ config SND_AU8830
 
 config SND_AZT3328
 	tristate "Aztech AZF3328 / PCI168 (EXPERIMENTAL)"
-	depends on SND && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -136,7 +132,6 @@ config SND_AZT3328
 
 config SND_BT87X
 	tristate "Bt87x Audio Capture"
-	depends on SND
 	select SND_PCM
 	help
 	  If you want to record audio from TV cards based on
@@ -158,7 +153,6 @@ config SND_BT87X_OVERCLOCK
 
 config SND_CA0106
 	tristate "SB Audigy LS / Live 24bit"
-	depends on SND
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	help
@@ -170,7 +164,6 @@ config SND_CA0106
 
 config SND_CMIPCI
 	tristate "C-Media 8738, 8338"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -184,7 +177,6 @@ config SND_CMIPCI
 
 config SND_CS4281
 	tristate "Cirrus Logic (Sound Fusion) CS4281"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
@@ -196,7 +188,6 @@ config SND_CS4281
 
 config SND_CS46XX
 	tristate "Cirrus Logic (Sound Fusion) CS4280/CS461x/CS462x/CS463x"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	help
@@ -217,7 +208,7 @@ config SND_CS46XX_NEW_DSP
 
 config SND_CS5535AUDIO
 	tristate "CS5535/CS5536 Audio"
-	depends on SND && X86 && !X86_64
+	depends on X86 && !X86_64
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
@@ -235,7 +226,6 @@ config SND_CS5535AUDIO
 
 config SND_DARLA20
 	tristate "(Echoaudio) Darla20"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -246,7 +236,6 @@ config SND_DARLA20
 
 config SND_GINA20
 	tristate "(Echoaudio) Gina20"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -257,7 +246,6 @@ config SND_GINA20
 
 config SND_LAYLA20
 	tristate "(Echoaudio) Layla20"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -269,7 +257,6 @@ config SND_LAYLA20
 
 config SND_DARLA24
 	tristate "(Echoaudio) Darla24"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -280,7 +267,6 @@ config SND_DARLA24
 
 config SND_GINA24
 	tristate "(Echoaudio) Gina24"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -291,7 +277,6 @@ config SND_GINA24
 
 config SND_LAYLA24
 	tristate "(Echoaudio) Layla24"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -303,7 +288,6 @@ config SND_LAYLA24
 
 config SND_MONA
 	tristate "(Echoaudio) Mona"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -315,7 +299,6 @@ config SND_MONA
 
 config SND_MIA
 	tristate "(Echoaudio) Mia"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -327,7 +310,6 @@ config SND_MIA
 
 config SND_ECHO3G
 	tristate "(Echoaudio) 3G cards"
-	depends on SND
 	select FW_LOADER
 	select SND_RAWMIDI
 	select SND_PCM
@@ -339,7 +321,6 @@ config SND_ECHO3G
 
 config SND_INDIGO
 	tristate "(Echoaudio) Indigo"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -350,7 +331,6 @@ config SND_INDIGO
 
 config SND_INDIGOIO
 	tristate "(Echoaudio) Indigo IO"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -361,7 +341,6 @@ config SND_INDIGOIO
 
 config SND_INDIGODJ
 	tristate "(Echoaudio) Indigo DJ"
-	depends on SND
 	select FW_LOADER
 	select SND_PCM
 	help
@@ -372,7 +351,6 @@ config SND_INDIGODJ
 
 config SND_EMU10K1
 	tristate "Emu10k1 (SB Live!, Audigy, E-mu APS)"
-	depends on SND
 	select FW_LOADER
 	select SND_HWDEP
 	select SND_RAWMIDI
@@ -390,7 +368,6 @@ config SND_EMU10K1
 
 config SND_EMU10K1X
 	tristate "Emu10k1X (Dell OEM Version)"
-	depends on SND
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	help
@@ -402,7 +379,6 @@ config SND_EMU10K1X
 
 config SND_ENS1370
 	tristate "(Creative) Ensoniq AudioPCI 1370"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_PCM
 	help
@@ -413,7 +389,6 @@ config SND_ENS1370
 
 config SND_ENS1371
 	tristate "(Creative) Ensoniq AudioPCI 1371/1373"
-	depends on SND
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	help
@@ -425,7 +400,6 @@ config SND_ENS1371
 
 config SND_ES1938
 	tristate "ESS ES1938/1946/1969 (Solo-1)"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -438,7 +412,6 @@ config SND_ES1938
 
 config SND_ES1968
 	tristate "ESS ES1968/1978 (Maestro-1/2/2E)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -450,7 +423,6 @@ config SND_ES1968
 
 config SND_FM801
 	tristate "ForteMedia FM801"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -480,7 +452,6 @@ config SND_FM801_TEA575X
 
 config SND_HDA_INTEL
 	tristate "Intel HD Audio"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for Intel "High Definition
@@ -491,7 +462,6 @@ config SND_HDA_INTEL
 
 config SND_HDSP
 	tristate "RME Hammerfall DSP Audio"
-	depends on SND
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -504,7 +474,6 @@ config SND_HDSP
 
 config SND_HDSPM
 	tristate "RME Hammerfall DSP MADI"
-	depends on SND
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -517,7 +486,6 @@ config SND_HDSPM
 
 config SND_ICE1712
 	tristate "ICEnsemble ICE1712 (Envy24)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -534,7 +502,6 @@ config SND_ICE1712
 
 config SND_ICE1724
 	tristate "ICE/VT1724/1720 (Envy24HT/PT)"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -551,7 +518,6 @@ config SND_ICE1724
 
 config SND_INTEL8X0
 	tristate "Intel/SiS/nVidia/AMD/ALi AC97 Controller"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated AC97 sound
@@ -564,7 +530,6 @@ config SND_INTEL8X0
 
 config SND_INTEL8X0M
 	tristate "Intel/SiS/nVidia/AMD MC97 Modem"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -575,7 +540,6 @@ config SND_INTEL8X0M
 
 config SND_KORG1212
 	tristate "Korg 1212 IO"
-	depends on SND
 	select FW_LOADER if !SND_KORG1212_FIRMWARE_IN_KERNEL
 	select SND_PCM
 	help
@@ -595,7 +559,6 @@ config SND_KORG1212_FIRMWARE_IN_KERNEL
 
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
-	depends on SND
 	select FW_LOADER if !SND_MAESTRO3_FIRMWARE_IN_KERNEL
 	select SND_AC97_CODEC
 	help
@@ -616,7 +579,6 @@ config SND_MAESTRO3_FIRMWARE_IN_KERNEL
 
 config SND_MIXART
 	tristate "Digigram miXart"
-	depends on SND
 	select SND_HWDEP
 	select SND_PCM
 	help
@@ -628,7 +590,6 @@ config SND_MIXART
 
 config SND_NM256
 	tristate "NeoMagic NM256AV/ZX"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for NeoMagic NM256AV/ZX chips.
@@ -638,7 +599,6 @@ config SND_NM256
 
 config SND_PCXHR
 	tristate "Digigram PCXHR"
-	depends on SND
 	select SND_PCM
 	select SND_HWDEP
 	help
@@ -649,7 +609,6 @@ config SND_PCXHR
 
 config SND_RIPTIDE
 	tristate "Conexant Riptide"
-	depends on SND
 	select FW_LOADER
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -662,7 +621,6 @@ config SND_RIPTIDE
 
 config SND_RME32
 	tristate "RME Digi32, 32/8, 32 PRO"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y to include support for RME Digi32, Digi32 PRO and
@@ -674,7 +632,6 @@ config SND_RME32
 
 config SND_RME96
 	tristate "RME Digi96, 96/8, 96/8 PRO"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for RME Digi96, Digi96/8 and
@@ -685,7 +642,6 @@ config SND_RME96
 
 config SND_RME9652
 	tristate "RME Digi9652 (Hammerfall)"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for RME Hammerfall (RME
@@ -696,7 +652,6 @@ config SND_RME9652
 
 config SND_SONICVIBES
 	tristate "S3 SonicVibes"
-	depends on SND
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -709,7 +664,6 @@ config SND_SONICVIBES
 
 config SND_TRIDENT
 	tristate "Trident 4D-Wave DX/NX; SiS 7018"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -721,7 +675,6 @@ config SND_TRIDENT
 
 config SND_VIA82XX
 	tristate "VIA 82C686A/B, 8233/8235 AC97 Controller"
-	depends on SND
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -733,7 +686,6 @@ config SND_VIA82XX
 
 config SND_VIA82XX_MODEM
 	tristate "VIA 82C686A/B, 8233 based Modems"
-	depends on SND
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -744,7 +696,6 @@ config SND_VIA82XX_MODEM
 
 config SND_VX222
 	tristate "Digigram VX222"
-	depends on SND
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VX222 soundcards.
@@ -754,7 +705,6 @@ config SND_VX222
 
 config SND_YMFPCI
 	tristate "Yamaha YMF724/740/744/754"
-	depends on SND
 	select FW_LOADER if !SND_YMFPCI_FIRMWARE_IN_KERNEL
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -788,4 +738,4 @@ config SND_AC97_POWER_SAVE
 	  snd-ac97-codec driver.  You can toggle it dynamically over
 	  sysfs, too.
 
-endmenu
+endif # SND_PCI_DRIVERS
diff -puN sound/pcmcia/Kconfig~use-menuconfig-objects-ii-sound sound/pcmcia/Kconfig
--- a/sound/pcmcia/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/pcmcia/Kconfig
@@ -1,11 +1,14 @@
 # ALSA PCMCIA drivers
 
-menu "PCMCIA devices"
-	depends on SND!=n && PCMCIA
+menuconfig SND_PCMCIA_DRIVERS
+	bool "PCMCIA devices"
+	depends on PCMCIA
+	default y
+
+if SND_PCMCIA_DRIVERS
 
 config SND_VXPOCKET
 	tristate "Digigram VXpocket"
-	depends on SND && PCMCIA
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VXpocket and
@@ -16,7 +19,6 @@ config SND_VXPOCKET
 
 config SND_PDAUDIOCF
 	tristate "Sound Core PDAudioCF"
-	depends on SND && PCMCIA
 	select SND_PCM
 	help
 	  Say Y here to include support for Sound Core PDAudioCF
@@ -25,4 +27,4 @@ config SND_PDAUDIOCF
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-pdaudiocf.
 
-endmenu
+endif # SND_PCMCIA_DRIVERS
diff -puN sound/ppc/Kconfig~use-menuconfig-objects-ii-sound sound/ppc/Kconfig
--- a/sound/ppc/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/ppc/Kconfig
@@ -1,17 +1,21 @@
 # ALSA PowerMac drivers
 
-menu "ALSA PowerMac devices"
-	depends on SND!=n && PPC
+menuconfig SND_PPC_DRIVERS
+	bool "ALSA PowerMac devices"
+	depends on PPC
+	default y
+
+if SND_PPC_DRIVERS
 
 comment "ALSA PowerMac requires I2C"
-	depends on SND && I2C=n
+	depends on I2C=n
 
 comment "ALSA PowerMac requires INPUT"
-	depends on SND && INPUT=n
+	depends on INPUT=n
 
 config SND_POWERMAC
 	tristate "PowerMac (AWACS, DACA, Burgundy, Tumbler, Keywest)"
-	depends on SND && I2C && INPUT && PPC_PMAC
+	depends on I2C && INPUT && PPC_PMAC
 	select SND_PCM
 	help
 	  Say Y here to include support for the integrated sound device.
@@ -32,4 +36,4 @@ config SND_POWERMAC_AUTO_DRC
 	  Note that you can turn on/off DRC manually even without this
 	  option.
 
-endmenu
+endif # SND_PPC_DRIVERS
diff -puN sound/soc/Kconfig~use-menuconfig-objects-ii-sound sound/soc/Kconfig
--- a/sound/soc/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/soc/Kconfig
@@ -2,15 +2,17 @@
 # SoC audio configuration
 #
 
-menu "System on Chip audio support"
-	depends on SND!=n
+menuconfig SND_SOC_DRIVERS
+	bool "System on Chip audio support"
+	default y
+
+if SND_SOC_DRIVERS
 
 config SND_SOC_AC97_BUS
 	bool
 
 config SND_SOC
 	tristate "ALSA for SoC audio support"
-	depends on SND
 	select SND_PCM
 	---help---
 
@@ -31,4 +33,4 @@ source "sound/soc/s3c24xx/Kconfig"
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
 
-endmenu
+endif # SND_SOC_DRIVERS
diff -puN sound/soc/codecs/Kconfig~use-menuconfig-objects-ii-sound sound/soc/codecs/Kconfig
--- a/sound/soc/codecs/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/soc/codecs/Kconfig
@@ -1,19 +1,18 @@
+if SND_SOC
+
 config SND_SOC_AC97_CODEC
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8731
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8750
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM8753
 	tristate
-	depends on SND_SOC
 
 config SND_SOC_WM9712
 	tristate
-	depends on SND_SOC
+
+endif # SND_SOC
diff -puN sound/sparc/Kconfig~use-menuconfig-objects-ii-sound sound/sparc/Kconfig
--- a/sound/sparc/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/sparc/Kconfig
@@ -1,11 +1,15 @@
 # ALSA Sparc drivers
 
-menu "ALSA Sparc devices"
-	depends on SND!=n && SPARC
+menuconfig SND_SPARC_DRIVERS
+	bool "ALSA Sparc devices"
+	depends on SPARC
+	default y
+
+if SND_SPARC_DRIVERS
 
 config SND_SUN_AMD7930
 	tristate "Sun AMD7930"
-	depends on SBUS && SND
+	depends on SBUS
 	select SND_PCM
 	help
 	  Say Y here to include support for AMD7930 sound device on Sun.
@@ -15,7 +19,6 @@ config SND_SUN_AMD7930
 
 config SND_SUN_CS4231
 	tristate "Sun CS4231"
-	depends on SND
 	select SND_PCM
 	help
 	  Say Y here to include support for CS4231 sound device on Sun.
@@ -25,7 +28,7 @@ config SND_SUN_CS4231
 
 config SND_SUN_DBRI
 	tristate "Sun DBRI"
-	depends on SND && SBUS
+	depends on SBUS
 	select SND_PCM
 	help
 	  Say Y here to include support for DBRI sound device on Sun.
@@ -33,4 +36,4 @@ config SND_SUN_DBRI
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-sun-dbri.
 
-endmenu
+endif # SND_SPARC_DRIVERS
diff -puN sound/usb/Kconfig~use-menuconfig-objects-ii-sound sound/usb/Kconfig
--- a/sound/usb/Kconfig~use-menuconfig-objects-ii-sound
+++ a/sound/usb/Kconfig
@@ -1,11 +1,14 @@
 # ALSA USB drivers
 
-menu "USB devices"
-	depends on SND!=n && USB!=n
+menuconfig SND_USB_DRIVERS
+	bool "USB devices"
+	depends on USB
+	default y
+
+if SND_USB_DRIVERS
 
 config SND_USB_AUDIO
 	tristate "USB Audio/MIDI driver"
-	depends on SND && USB
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -18,7 +21,7 @@ config SND_USB_AUDIO
 
 config SND_USB_USX2Y
 	tristate "Tascam US-122, US-224 and US-428 USB driver"
-	depends on SND && USB && (X86 || PPC || ALPHA)
+	depends on X86 || PPC || ALPHA
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
@@ -31,7 +34,6 @@ config SND_USB_USX2Y
 
 config SND_USB_CAIAQ
 	tristate "Native Instruments USB audio devices"
-	 depends on SND && USB
 	 select SND_HWDEP
 	 select SND_RAWMIDI
 	 select SND_PCM
@@ -57,5 +59,4 @@ config SND_USB_CAIAQ_INPUT
 	   * Native Instruments RigKontrol2
 	   * Native Instruments Audio Kontrol 1
 
-endmenu
-
+endif # SND_USB_DRIVERS
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
