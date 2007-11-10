From: akpm@linux-foundation.org
Subject: + sound-remove-dead-config-symbol-from-sound-code.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:30:13 -0800
Message-ID: <200711100130.lAA1UDCC009189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbXKJBaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:30:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     sound: remove dead config symbol from sound code
has been added to the -mm tree.  Its filename is
     sound-remove-dead-config-symbol-from-sound-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sound: remove dead config symbol from sound code
From: Jiri Olsa <olsajiri@gmail.com>

remove dead config symbols from sound code

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/sound/cs46xx.h        |    3 
 include/sound/driver.h        |    4 -
 sound/pci/cs46xx/cs46xx_lib.c |   99 --------------------------------
 3 files changed, 106 deletions(-)

diff -puN include/sound/cs46xx.h~sound-remove-dead-config-symbol-from-sound-code include/sound/cs46xx.h
--- a/include/sound/cs46xx.h~sound-remove-dead-config-symbol-from-sound-code
+++ a/include/sound/cs46xx.h
@@ -1708,9 +1708,6 @@ struct snd_cs46xx {
 
 	struct gameport *gameport;
 
-#ifdef CONFIG_SND_CS46XX_DEBUG_GPIO
-	int current_gpio;
-#endif
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	struct mutex spos_mutex;
 
diff -puN include/sound/driver.h~sound-remove-dead-config-symbol-from-sound-code include/sound/driver.h
--- a/include/sound/driver.h~sound-remove-dead-config-symbol-from-sound-code
+++ a/include/sound/driver.h
@@ -38,10 +38,6 @@
 #define CONFIG_SND_MAJOR	116
 #endif
 
-#ifndef CONFIG_SND_DEBUG
-#undef CONFIG_SND_DEBUG_MEMORY
-#endif
-
 #ifdef ALSA_BUILD
 #include "adriver.h"
 #endif
diff -puN sound/pci/cs46xx/cs46xx_lib.c~sound-remove-dead-config-symbol-from-sound-code sound/pci/cs46xx/cs46xx_lib.c
--- a/sound/pci/cs46xx/cs46xx_lib.c~sound-remove-dead-config-symbol-from-sound-code
+++ a/sound/pci/cs46xx/cs46xx_lib.c
@@ -2084,71 +2084,6 @@ static int snd_cs46xx_spdif_stream_put(s
 #endif /* CONFIG_SND_CS46XX_NEW_DSP */
 
 
-#ifdef CONFIG_SND_CS46XX_DEBUG_GPIO
-static int snd_cs46xx_egpio_select_info(struct snd_kcontrol *kcontrol, 
-                                        struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	uinfo->value.integer.min = 0;
-	uinfo->value.integer.max = 8;
-	return 0;
-}
-
-static int snd_cs46xx_egpio_select_get(struct snd_kcontrol *kcontrol, 
-                                       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_cs46xx *chip = snd_kcontrol_chip(kcontrol);
-	ucontrol->value.integer.value[0] = chip->current_gpio;
-
-	return 0;
-}
-
-static int snd_cs46xx_egpio_select_put(struct snd_kcontrol *kcontrol, 
-                                       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_cs46xx *chip = snd_kcontrol_chip(kcontrol);
-	int change = (chip->current_gpio != ucontrol->value.integer.value[0]);
-	chip->current_gpio = ucontrol->value.integer.value[0];
-
-	return change;
-}
-
-
-static int snd_cs46xx_egpio_get(struct snd_kcontrol *kcontrol, 
-                                       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_cs46xx *chip = snd_kcontrol_chip(kcontrol);
-	int reg = kcontrol->private_value;
-
-	snd_printdd ("put: reg = %04x, gpio %02x\n",reg,chip->current_gpio);
-	ucontrol->value.integer.value[0] = 
-		(snd_cs46xx_peekBA0(chip, reg) & (1 << chip->current_gpio)) ? 1 : 0;
-  
-	return 0;
-}
-
-static int snd_cs46xx_egpio_put(struct snd_kcontrol *kcontrol, 
-                                       struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_cs46xx *chip = snd_kcontrol_chip(kcontrol);
-	int reg = kcontrol->private_value;
-	int val = snd_cs46xx_peekBA0(chip, reg);
-	int oldval = val;
-	snd_printdd ("put: reg = %04x, gpio %02x\n",reg,chip->current_gpio);
-
-	if (ucontrol->value.integer.value[0])
-		val |= (1 << chip->current_gpio);
-	else
-		val &= ~(1 << chip->current_gpio);
-
-	snd_cs46xx_pokeBA0(chip, reg,val);
-	snd_printdd ("put: val %08x oldval %08x\n",val,oldval);
-
-	return (oldval != val);
-}
-#endif /* CONFIG_SND_CS46XX_DEBUG_GPIO */
-
 static struct snd_kcontrol_new snd_cs46xx_controls[] __devinitdata = {
 {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -2241,40 +2176,6 @@ static struct snd_kcontrol_new snd_cs46x
 },
 
 #endif
-#ifdef CONFIG_SND_CS46XX_DEBUG_GPIO
-{
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "EGPIO select",
-	.info = snd_cs46xx_egpio_select_info,
-	.get = snd_cs46xx_egpio_select_get,
-	.put = snd_cs46xx_egpio_select_put,
-	.private_value = 0,
-},
-{
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "EGPIO Input/Output",
-	.info = snd_mixer_boolean_info,
-	.get = snd_cs46xx_egpio_get,
-	.put = snd_cs46xx_egpio_put,
-	.private_value = BA0_EGPIODR,
-},
-{
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "EGPIO CMOS/Open drain",
-	.info = snd_mixer_boolean_info,
-	.get = snd_cs46xx_egpio_get,
-	.put = snd_cs46xx_egpio_put,
-	.private_value = BA0_EGPIOPTR,
-},
-{
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "EGPIO On/Off",
-	.info = snd_mixer_boolean_info,
-	.get = snd_cs46xx_egpio_get,
-	.put = snd_cs46xx_egpio_put,
-	.private_value = BA0_EGPIOSR,
-},
-#endif
 };
 
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
_

Patches currently in -mm which might be from olsajiri@gmail.com are

sound-remove-dead-config-symbol-from-sound-code.patch
arm-remove-dead-config-symbols-from-arm-code.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
git-net.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
git-sh.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
