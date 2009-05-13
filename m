From: akpm@linux-foundation.org
Subject: + riptide-postfix-increment-and-off-by-one.patch added to -mm tree
Date: Wed, 13 May 2009 13:00:19 -0700
Message-ID: <200905132000.n4DK0Jsq013369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbZEMUA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 16:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, tiwai@suse.de


The patch titled
     riptide: postfix increment and off by one
has been added to the -mm tree.  Its filename is
     riptide-postfix-increment-and-off-by-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: riptide: postfix increment and off by one
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix increment these variables are incremented beyond
CMDIF_TIMEOUT / MAX_WRITE_RETRY.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/riptide/riptide.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN sound/pci/riptide/riptide.c~riptide-postfix-increment-and-off-by-one sound/pci/riptide/riptide.c
--- a/sound/pci/riptide/riptide.c~riptide-postfix-increment-and-off-by-one
+++ a/sound/pci/riptide/riptide.c
@@ -889,7 +889,7 @@ static int sendcmd(struct cmdif *cif, u3
 	spin_lock_irqsave(&cif->lock, irqflags);
 	while (i++ < CMDIF_TIMEOUT && !IS_READY(cif->hwport))
 		udelay(10);
-	if (i >= CMDIF_TIMEOUT) {
+	if (i > CMDIF_TIMEOUT) {
 		err = -EBUSY;
 		goto errout;
 	}
@@ -907,8 +907,10 @@ static int sendcmd(struct cmdif *cif, u3
 			WRITE_PORT_ULONG(cmdport->data1, cmd);	/* write cmd */
 			if ((flags & RESP) && ret) {
 				while (!IS_DATF(cmdport) &&
-				       time++ < CMDIF_TIMEOUT)
+				       time < CMDIF_TIMEOUT) {
 					udelay(10);
+					time++;
+				}
 				if (time < CMDIF_TIMEOUT) {	/* read response */
 					ret->retlongs[0] =
 					    READ_PORT_ULONG(cmdport->data1);
@@ -1454,7 +1456,7 @@ static int snd_riptide_trigger(struct sn
 			SEND_GPOS(cif, 0, data->id, &rptr);
 			udelay(1);
 		} while (i != rptr.retlongs[1] && j++ < MAX_WRITE_RETRY);
-		if (j >= MAX_WRITE_RETRY)
+		if (j > MAX_WRITE_RETRY)
 			snd_printk(KERN_ERR "Riptide: Could not stop stream!");
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
@@ -1783,7 +1785,7 @@ snd_riptide_codec_write(struct snd_ac97 
 		SEND_SACR(cif, val, reg);
 		SEND_RACR(cif, reg, &rptr);
 	} while (rptr.retwords[1] != val && i++ < MAX_WRITE_RETRY);
-	if (i == MAX_WRITE_RETRY)
+	if (i > MAX_WRITE_RETRY)
 		snd_printdd("Write AC97 reg failed\n");
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch
nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch
riptide-postfix-increment-and-off-by-one.patch

