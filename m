From: akpm@linux-foundation.org
Subject: [merged] riptide-postfix-increment-and-off-by-one.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:18 -0700
Message-ID: <200905171654.n4HGsIUx017054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbZEQQyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     riptide: postfix increment and off by one
has been removed from the -mm tree.  Its filename was
     riptide-postfix-increment-and-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch
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

