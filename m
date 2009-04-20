From: akpm@linux-foundation.org
Subject: [to-be-updated] alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch removed from -mm tree
Date: Mon, 20 Apr 2009 16:25:35 -0700
Message-ID: <200904202325.n3KNPZ6g031559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZDTXbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 19:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, randy.dunlap@oracle.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: cs5535audio: free OLPC quirks from reliance on MGEODE_LX cpu optimization
has been removed from the -mm tree.  Its filename was
     alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alsa: cs5535audio: free OLPC quirks from reliance on MGEODE_LX cpu optimization
From: Andres Salomon <dilinger@queued.net>

Previously, OLPC support for the mic extensions was only enabled in the
ALSA driver if CONFIG_OLPC and CONFIG_MGEODE_LX were both set.  This was
because the old geode GPIO code was written in a manner that assumed
CONFIG_MGEODE_LX.  With the new cs553x-gpio driver, this is no longer the
case; as such, we can drop the requirement on CONFIG_MGEODE_LX and instead
include a requirement on GPIOLIB.

We use the generic GPIO API rather than the cs553x-specific API.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/olpc.h              |    2 -
 sound/pci/cs5535audio/Makefile           |    2 -
 sound/pci/cs5535audio/cs5535audio.c      |    1 
 sound/pci/cs5535audio/cs5535audio.h      |    4 ++-
 sound/pci/cs5535audio/cs5535audio_olpc.c |   26 +++++++++++++++------
 5 files changed, 24 insertions(+), 11 deletions(-)

diff -puN arch/x86/include/asm/olpc.h~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization
+++ a/arch/x86/include/asm/olpc.h
@@ -120,7 +120,7 @@ extern int olpc_ec_mask_unset(uint8_t bi
 
 /* GPIO assignments */
 
-#define OLPC_GPIO_MIC_AC	geode_gpio(1)
+#define OLPC_GPIO_MIC_AC	1
 #define OLPC_GPIO_DCON_IRQ	geode_gpio(7)
 #define OLPC_GPIO_THRM_ALRM	geode_gpio(10)
 #define OLPC_GPIO_SMB_CLK	geode_gpio(14)
diff -puN sound/pci/cs5535audio/Makefile~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization sound/pci/cs5535audio/Makefile
--- a/sound/pci/cs5535audio/Makefile~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization
+++ a/sound/pci/cs5535audio/Makefile
@@ -4,9 +4,7 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
-ifdef CONFIG_MGEODE_LX
 snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
-endif
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
diff -puN sound/pci/cs5535audio/cs5535audio.c~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization sound/pci/cs5535audio/cs5535audio.c
--- a/sound/pci/cs5535audio/cs5535audio.c~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization
+++ a/sound/pci/cs5535audio/cs5535audio.c
@@ -389,6 +389,7 @@ probefail_out:
 
 static void __devexit snd_cs5535audio_remove(struct pci_dev *pci)
 {
+	olpc_quirks_cleanup();
 	snd_card_free(pci_get_drvdata(pci));
 	pci_set_drvdata(pci, NULL);
 }
diff -puN sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization sound/pci/cs5535audio/cs5535audio.h
--- a/sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization
+++ a/sound/pci/cs5535audio/cs5535audio.h
@@ -99,10 +99,11 @@ int snd_cs5535audio_suspend(struct pci_d
 int snd_cs5535audio_resume(struct pci_dev *pci);
 #endif
 
-#if defined(CONFIG_OLPC) && defined(CONFIG_MGEODE_LX)
+#ifdef CONFIG_OLPC
 void __devinit olpc_prequirks(struct snd_card *card,
 		struct snd_ac97_template *ac97);
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+void __devexit olpc_quirks_cleanup(void);
 void olpc_analog_input(struct snd_ac97 *ac97, int on);
 void olpc_mic_bias(struct snd_ac97 *ac97, int on);
 
@@ -128,6 +129,7 @@ static inline int olpc_quirks(struct snd
 {
 	return 0;
 }
+static inline void olpc_quirks_cleanup(void) { }
 static inline void olpc_analog_input(struct snd_ac97 *ac97, int on) { }
 static inline void olpc_mic_bias(struct snd_ac97 *ac97, int on) { }
 static inline void olpc_capture_open(struct snd_ac97 *ac97) { }
diff -puN sound/pci/cs5535audio/cs5535audio_olpc.c~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization sound/pci/cs5535audio/cs5535audio_olpc.c
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c~alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization
+++ a/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -13,10 +13,13 @@
 #include <sound/info.h>
 #include <sound/control.h>
 #include <sound/ac97_codec.h>
+#include <linux/gpio.h>
 
 #include <asm/olpc.h>
 #include "cs5535audio.h"
 
+#define DRV_NAME "cs5535audio-olpc"
+
 /*
  * OLPC has an additional feature on top of the regular AD1888 codec features.
  * It has an Analog Input mode that is switched into (after disabling the
@@ -38,10 +41,7 @@ void olpc_analog_input(struct snd_ac97 *
 	}
 
 	/* set Analog Input through GPIO */
-	if (on)
-		geode_gpio_set(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
-	else
-		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
+	gpio_set_value(OLPC_GPIO_MIC_AC, on);
 }
 
 /*
@@ -73,8 +73,7 @@ static int olpc_dc_info(struct snd_kcont
 
 static int olpc_dc_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 {
-	v->value.integer.value[0] = geode_gpio_isset(OLPC_GPIO_MIC_AC,
-			GPIO_OUTPUT_VAL);
+	v->value.integer.value[0] = gpio_get_value(OLPC_GPIO_MIC_AC);
 	return 0;
 }
 
@@ -153,6 +152,12 @@ int __devinit olpc_quirks(struct snd_car
 	if (!machine_is_olpc())
 		return 0;
 
+	if (gpio_request(OLPC_GPIO_MIC_AC, DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME ": unable to allocate MIC GPIO\n");
+		return -EIO;
+	}
+	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
 	elem.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
@@ -169,11 +174,18 @@ int __devinit olpc_quirks(struct snd_car
 	for (i = 0; i < ARRAY_SIZE(olpc_cs5535audio_ctls); i++) {
 		err = snd_ctl_add(card, snd_ctl_new1(&olpc_cs5535audio_ctls[i],
 				ac97->private_data));
-		if (err < 0)
+		if (err < 0) {
+			gpio_free(OLPC_GPIO_MIC_AC);
 			return err;
+		}
 	}
 
 	/* turn off the mic by default */
 	olpc_mic_bias(ac97, 0);
 	return 0;
 }
+
+void __devexit olpc_quirks_cleanup(void)
+{
+	gpio_free(OLPC_GPIO_MIC_AC);
+}
_

Patches currently in -mm which might be from dilinger@queued.net are

alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

