From: akpm@linux-foundation.org
Subject: + sound-use-bug_on.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:55 -0800
Message-ID: <200802230729.m1N7TiYc017913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbYBWHaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     sound: Use BUG_ON
has been added to the -mm tree.  Its filename is
     sound-use-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 sound/core/seq/oss/seq_oss_synth.c |    3 +--
 sound/oss/trident.c                |   12 ++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN sound/core/seq/oss/seq_oss_synth.c~sound-use-bug_on sound/core/seq/oss/seq_oss_synth.c
--- a/sound/core/seq/oss/seq_oss_synth.c~sound-use-bug_on
+++ a/sound/core/seq/oss/seq_oss_synth.c
@@ -245,8 +245,7 @@ snd_seq_oss_synth_setup(struct seq_oss_d
 		info->nr_voices = rec->nr_voices;
 		if (info->nr_voices > 0) {
 			info->ch = kcalloc(info->nr_voices, sizeof(struct seq_oss_chinfo), GFP_KERNEL);
-			if (!info->ch)
-				BUG();
+			BUG_ON(!info->ch);
 			reset_channels(info);
 		}
 		debug_printk(("synth %d assigned\n", i));
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

sound-use-bug_on.patch
git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
fs-ocfs2-use-bug_on.patch
s390-use-div_round_up.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
