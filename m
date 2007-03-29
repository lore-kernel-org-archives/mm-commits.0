From: akpm@linux-foundation.org
Subject: - sound-strlcpy-is-smart-enough.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:56 -0700
Message-ID: <200703290742.l2T7guE6030345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965055AbXC2HnR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: strlcpy is smart enough
has been removed from the -mm tree.  Its filename was
     sound-strlcpy-is-smart-enough.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound: strlcpy is smart enough
From: Jean Delvare <khali@linux-fr.org>

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/aoa/codecs/snd-aoa-codec-onyx.c |    4 ++--
 sound/aoa/codecs/snd-aoa-codec-tas.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN sound/aoa/codecs/snd-aoa-codec-onyx.c~sound-strlcpy-is-smart-enough sound/aoa/codecs/snd-aoa-codec-onyx.c
--- a/sound/aoa/codecs/snd-aoa-codec-onyx.c~sound-strlcpy-is-smart-enough
+++ a/sound/aoa/codecs/snd-aoa-codec-onyx.c
@@ -1018,7 +1018,7 @@ static int onyx_create(struct i2c_adapte
 	onyx->i2c.driver = &onyx_driver;
 	onyx->i2c.adapter = adapter;
 	onyx->i2c.addr = addr & 0x7f;
-	strlcpy(onyx->i2c.name, "onyx audio codec", I2C_NAME_SIZE-1);
+	strlcpy(onyx->i2c.name, "onyx audio codec", I2C_NAME_SIZE);
 
 	if (i2c_attach_client(&onyx->i2c)) {
 		printk(KERN_ERR PFX "failed to attach to i2c\n");
@@ -1033,7 +1033,7 @@ static int onyx_create(struct i2c_adapte
 		goto fail;
 	}
 
-	strlcpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN-1);
+	strlcpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN);
 	onyx->codec.owner = THIS_MODULE;
 	onyx->codec.init = onyx_init_codec;
 	onyx->codec.exit = onyx_exit_codec;
diff -puN sound/aoa/codecs/snd-aoa-codec-tas.c~sound-strlcpy-is-smart-enough sound/aoa/codecs/snd-aoa-codec-tas.c
--- a/sound/aoa/codecs/snd-aoa-codec-tas.c~sound-strlcpy-is-smart-enough
+++ a/sound/aoa/codecs/snd-aoa-codec-tas.c
@@ -899,14 +899,14 @@ static int tas_create(struct i2c_adapter
 	tas->i2c.addr = addr;
 	/* seems that half is a saner default */
 	tas->drc_range = TAS3004_DRC_MAX / 2;
-	strlcpy(tas->i2c.name, "tas audio codec", I2C_NAME_SIZE-1);
+	strlcpy(tas->i2c.name, "tas audio codec", I2C_NAME_SIZE);
 
 	if (i2c_attach_client(&tas->i2c)) {
 		printk(KERN_ERR PFX "failed to attach to i2c\n");
 		goto fail;
 	}
 
-	strlcpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN-1);
+	strlcpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN);
 	tas->codec.owner = THIS_MODULE;
 	tas->codec.init = tas_init_codec;
 	tas->codec.exit = tas_exit_codec;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
ehea-strlcpy-is-smart-enough.patch
git-net.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
