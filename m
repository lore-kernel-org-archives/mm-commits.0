From: akpm@linux-foundation.org
Subject: + snd_mixer_oss_build_input-fix-for-__you_cannot_kmalloc_that_much-failure-with-gcc-32.patch added to -mm tree
Date: Tue, 08 Jan 2008 14:06:34 -0800
Message-ID: <200801082206.m08M6YYd001567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYAHWHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 17:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, perex@suse.cz, tiwai@suse.de


The patch titled
     snd_mixer_oss_build_input(): fix for __you_cannot_kmalloc_that_much failure with gcc-3.2
has been added to the -mm tree.  Its filename is
     snd_mixer_oss_build_input-fix-for-__you_cannot_kmalloc_that_much-failure-with-gcc-32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: snd_mixer_oss_build_input(): fix for __you_cannot_kmalloc_that_much failure with gcc-3.2
From: Jean Delvare <khali@linux-fr.org>

Rework this functions so that gcc-3.2 can successfully perform
constant-folding.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/oss/mixer_oss.c |  101 +++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 38 deletions(-)

diff -puN sound/core/oss/mixer_oss.c~snd_mixer_oss_build_input-fix-for-__you_cannot_kmalloc_that_much-failure-with-gcc-32 sound/core/oss/mixer_oss.c
--- a/sound/core/oss/mixer_oss.c~snd_mixer_oss_build_input-fix-for-__you_cannot_kmalloc_that_much-failure-with-gcc-32
+++ a/sound/core/oss/mixer_oss.c
@@ -925,6 +925,68 @@ static void mixer_slot_clear(struct snd_
 	rslot->number = idx;
 }
 
+/* In a separate function to keep gcc 3.2 happy - do NOT merge this in
+   snd_mixer_oss_build_input! */
+static int snd_mixer_oss_build_test_all(struct snd_mixer_oss *mixer,
+					struct snd_mixer_oss_assign_table *ptr,
+					struct slot *slot)
+{
+	char str[64];
+	int err;
+
+	err = snd_mixer_oss_build_test(mixer, slot, ptr->name, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GLOBAL);
+	if (err)
+		return err;
+	sprintf(str, "%s Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GVOLUME);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PVOLUME);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CVOLUME);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 /*
  * build an OSS mixer element.
  * ptr_allocated means the entry is dynamically allocated (change via proc file).
@@ -944,44 +1006,7 @@ static int snd_mixer_oss_build_input(str
 
 	memset(&slot, 0, sizeof(slot));
 	memset(slot.numid, 0xff, sizeof(slot.numid)); /* ID_UNKNOWN */
-	if (snd_mixer_oss_build_test(mixer, &slot, ptr->name, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GLOBAL))
-		return 0;
-	sprintf(str, "%s Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GSWITCH))
-		return 0;
-	sprintf(str, "%s Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GROUTE))
-		return 0;
-	sprintf(str, "%s Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GVOLUME))
-		return 0;
-	sprintf(str, "%s Playback Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PSWITCH))
-		return 0;
-	sprintf(str, "%s Playback Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PROUTE))
-		return 0;
-	sprintf(str, "%s Playback Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PVOLUME))
-		return 0;
-	sprintf(str, "%s Capture Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CSWITCH))
-		return 0;
-	sprintf(str, "%s Capture Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CROUTE))
-		return 0;
-	sprintf(str, "%s Capture Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CVOLUME))
+	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	down_read(&mixer->card->controls_rwsem);
 	if (ptr->index == 0 && (kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0)) != NULL) {
_

Patches currently in -mm which might be from khali@linux-fr.org are

dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure.patch
snd_mixer_oss_build_input-fix-for-__you_cannot_kmalloc_that_much-failure-with-gcc-32.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-arm.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
git-hwmon.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
