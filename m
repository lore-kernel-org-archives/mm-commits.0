From: akpm@linux-foundation.org
Subject: - sound-use-bug_on.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:13 -0700
Message-ID: <200803111842.m2BIgDcw021435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbYCKSmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     sound: Use BUG_ON
has been removed from the -mm tree.  Its filename was
     sound-use-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound: Use BUG_ON
From: Julia Lawall <julia@diku.dk>


if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN sound/core/seq/oss/seq_oss_synth.c~sound-use-bug_on sound/core/seq/oss/seq_oss_synth.c
diff -puN sound/oss/trident.c~sound-use-bug_on sound/oss/trident.c
--- a/sound/oss/trident.c~sound-use-bug_on
+++ a/sound/oss/trident.c
@@ -3076,8 +3076,7 @@ ali_ac97_get(struct trident_card *card, 
 	u16 wcontrol;
 	unsigned long flags;
 
-	if (!card)
-		BUG();
+	BUG_ON(!card);
 
 	address = ALI_AC97_READ;
 	if (card->revision == ALI_5451_V02) {
@@ -3148,8 +3147,7 @@ ali_ac97_set(struct trident_card *card, 
 
 	data = ((u32) val) << 16;
 
-	if (!card)
-		BUG();
+	BUG_ON(!card);
 
 	address = ALI_AC97_WRITE;
 	mask = ALI_AC97_WRITE_ACTION | ALI_AC97_AUDIO_BUSY;
@@ -3213,8 +3211,7 @@ ali_ac97_read(struct ac97_codec *codec, 
 	struct trident_card *card = NULL;
 
 	/* Added by Matt Wu */
-	if (!codec)
-		BUG();
+	BUG_ON(!codec);
 
 	card = (struct trident_card *) codec->private_data;
 
@@ -3240,8 +3237,7 @@ ali_ac97_write(struct ac97_codec *codec,
 	struct trident_card *card;
 
 	/*  Added by Matt Wu */
-	if (!codec)
-		BUG();
+	BUG_ON(!codec);
 
 	card = (struct trident_card *) codec->private_data;
 
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

