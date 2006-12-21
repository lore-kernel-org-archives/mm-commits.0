From: akpm@osdl.org
Subject: - alsa-soc-wm8750-fix.patch removed from -mm tree
Date: Thu, 21 Dec 2006 11:57:48 -0800
Message-ID: <200612211957.kBLJvmLU003195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423065AbWLUT57 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 14:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: e.ilkov@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: soc wm8750 fix
has been removed from the -mm tree.  Its filename was
     alsa-soc-wm8750-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: alsa: soc wm8750 fix
From: "Eugene Ilkov" <e.ilkov@gmail.com>

There was some INIT_WORK related changes, here is patch against wm8750
codec driver.  Tested on sharp sl-c1000

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/soc/codecs/wm8750.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN sound/soc/codecs/wm8750.c~alsa-soc-wm8750-fix sound/soc/codecs/wm8750.c
--- a/sound/soc/codecs/wm8750.c~alsa-soc-wm8750-fix
+++ a/sound/soc/codecs/wm8750.c
@@ -51,8 +51,6 @@
 #define warn(format, arg...) \
 	printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)
 
-static struct work_struct wm8750_dapm_work;
-
 /*
  * wm8750 register cache
  * We can't read the WM8750 register space when we
@@ -1000,9 +998,11 @@ struct snd_soc_codec_dai wm8750_dai = {
 };
 EXPORT_SYMBOL_GPL(wm8750_dai);
 
-static void wm8750_work(void *data)
+static void wm8750_work(struct work_struct *work)
 {
-	struct snd_soc_codec *codec = (struct snd_soc_codec *)data;
+	struct snd_soc_device *socdev =
+		container_of(work, struct snd_soc_device, delayed_work.work);
+	struct snd_soc_codec *codec = socdev->codec;
 	wm8750_dapm_event(codec, codec->dapm_state);
 }
 
@@ -1038,7 +1038,7 @@ static int wm8750_resume(struct platform
 	if (codec->suspend_dapm_state == SNDRV_CTL_POWER_D0) {
 		wm8750_dapm_event(codec, SNDRV_CTL_POWER_D2);
 		codec->dapm_state = SNDRV_CTL_POWER_D0;
-		schedule_delayed_work(&wm8750_dapm_work,
+		queue_delayed_work(wm8750_workq, &socdev->delayed_work,
 			 msecs_to_jiffies(1000));
 	}
 
@@ -1083,7 +1083,8 @@ static int wm8750_init(struct snd_soc_de
 	/* charge output caps */
 	wm8750_dapm_event(codec, SNDRV_CTL_POWER_D2);
 	codec->dapm_state = SNDRV_CTL_POWER_D3hot;
-	schedule_delayed_work(&wm8750_dapm_work, msecs_to_jiffies(1000));
+	queue_delayed_work(wm8750_workq, &socdev->delayed_work,
+			msecs_to_jiffies(1000));
 
 	/* set the update bits */
 	reg = wm8750_read_reg_cache(codec, WM8750_LDAC);
@@ -1225,7 +1226,7 @@ static int wm8750_probe(struct platform_
 	INIT_LIST_HEAD(&codec->dapm_widgets);
 	INIT_LIST_HEAD(&codec->dapm_paths);
 	wm8750_socdev = socdev;
-	INIT_WORK(&wm8750_dapm_work, wm8750_work, codec);
+	INIT_DELAYED_WORK(&socdev->delayed_work, wm8750_work);
 #if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE)
 	if (setup->i2c_address) {
 		normal_i2c[0] = setup->i2c_address;
_

Patches currently in -mm which might be from e.ilkov@gmail.com are

alsa-soc-wm8750-fix.patch

