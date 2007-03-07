From: akpm@linux-foundation.org
Subject: + sound-strlcpy-is-smart-enough.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:16:17 -0800
Message-ID: <200703070116.l271GHlQ015214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41728 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161092AbXCGBQi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, perex@suse.cz, tiwai@suse.de


The patch titled
     sound: strlcpy is smart enough
has been added to the -mm tree.  Its filename is
     sound-strlcpy-is-smart-enough.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-dvb.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
s390-strlcpy-is-smart-enough.patch
sound-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
xtensa-strlcpy-is-smart-enough.patch
ehea-strlcpy-is-smart-enough.patch
