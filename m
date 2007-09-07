From: akpm@linux-foundation.org
Subject: - alsa-cs5535audio-drop-unused-bus-master-stuff.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:14 -0700
Message-ID: <200709070042.l870gE0d016026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964853AbXIGAnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jayakumar.alsa@gmail.com, jordan.crouse@amd.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ALSA: cs5535audio: drop unused bus master stuff
has been removed from the -mm tree.  Its filename was
     alsa-cs5535audio-drop-unused-bus-master-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALSA: cs5535audio: drop unused bus master stuff
From: Andres Salomon <dilinger@queued.net>

We really only care about the first two bus masters (playback and capture). 
There's no need to have unused BM code lying around, so let's get rid of it.

If for some reason we trigger an IRQ for some BM that we're not using..  well,
that warrants spitting out an error message (imo).

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio.c |   24 ++------------------
 sound/pci/cs5535audio/cs5535audio.h |   31 --------------------------
 2 files changed, 4 insertions(+), 51 deletions(-)

diff -puN sound/pci/cs5535audio/cs5535audio.c~alsa-cs5535audio-drop-unused-bus-master-stuff sound/pci/cs5535audio/cs5535audio.c
--- a/sound/pci/cs5535audio/cs5535audio.c~alsa-cs5535audio-drop-unused-bus-master-stuff
+++ a/sound/pci/cs5535audio/cs5535audio.c
@@ -206,7 +206,6 @@ static void process_bm1_irq(struct cs553
 static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
 {
 	u16 acc_irq_stat;
-	u8 bm_stat;
 	unsigned char count;
 	struct cs5535audio *cs5535au = dev_id;
 
@@ -217,7 +216,7 @@ static irqreturn_t snd_cs5535audio_inter
 
 	if (!acc_irq_stat)
 		return IRQ_NONE;
-	for (count = 0; count < 10; count++) {
+	for (count = 0; count < 4; count++) {
 		if (acc_irq_stat & (1 << count)) {
 			switch (count) {
 			case IRQ_STS:
@@ -232,26 +231,9 @@ static irqreturn_t snd_cs5535audio_inter
 			case BM1_IRQ_STS:
 				process_bm1_irq(cs5535au);
 				break;
-			case BM2_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM2_STATUS);
-				break;
-			case BM3_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM3_STATUS);
-				break;
-			case BM4_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM4_STATUS);
-				break;
-			case BM5_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM5_STATUS);
-				break;
-			case BM6_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM6_STATUS);
-				break;
-			case BM7_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM7_STATUS);
-				break;
 			default:
-				snd_printk(KERN_ERR "Unexpected irq src\n");
+				snd_printk(KERN_ERR "Unexpected irq src: "
+						"0x%x\n", acc_irq_stat);
 				break;
 			}
 		}
diff -puN sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-drop-unused-bus-master-stuff sound/pci/cs5535audio/cs5535audio.h
--- a/sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-drop-unused-bus-master-stuff
+++ a/sound/pci/cs5535audio/cs5535audio.h
@@ -16,48 +16,19 @@
 #define ACC_IRQ_STATUS			0x12
 #define ACC_BM0_CMD			0x20
 #define ACC_BM1_CMD			0x28
-#define ACC_BM2_CMD			0x30
-#define ACC_BM3_CMD			0x38
-#define ACC_BM4_CMD			0x40
-#define ACC_BM5_CMD			0x48
-#define ACC_BM6_CMD			0x50
-#define ACC_BM7_CMD			0x58
 #define ACC_BM0_PRD			0x24
 #define ACC_BM1_PRD			0x2C
-#define ACC_BM2_PRD			0x34
-#define ACC_BM3_PRD			0x3C
-#define ACC_BM4_PRD			0x44
-#define ACC_BM5_PRD			0x4C
-#define ACC_BM6_PRD			0x54
-#define ACC_BM7_PRD			0x5C
 #define ACC_BM0_STATUS			0x21
 #define ACC_BM1_STATUS			0x29
-#define ACC_BM2_STATUS			0x31
-#define ACC_BM3_STATUS			0x39
-#define ACC_BM4_STATUS			0x41
-#define ACC_BM5_STATUS			0x49
-#define ACC_BM6_STATUS			0x51
-#define ACC_BM7_STATUS			0x59
 #define ACC_BM0_PNTR			0x60
 #define ACC_BM1_PNTR			0x64
-#define ACC_BM2_PNTR			0x68
-#define ACC_BM3_PNTR			0x6C
-#define ACC_BM4_PNTR			0x70
-#define ACC_BM5_PNTR			0x74
-#define ACC_BM6_PNTR			0x78
-#define ACC_BM7_PNTR			0x7C
+
 /* acc_codec bar0 reg bits */
 /* ACC_IRQ_STATUS */
 #define IRQ_STS 			0
 #define WU_IRQ_STS 			1
 #define BM0_IRQ_STS 			2
 #define BM1_IRQ_STS 			3
-#define BM2_IRQ_STS 			4
-#define BM3_IRQ_STS 			5
-#define BM4_IRQ_STS 			6
-#define BM5_IRQ_STS		 	7
-#define BM6_IRQ_STS 			8
-#define BM7_IRQ_STS 			9
 /* ACC_BMX_STATUS */
 #define EOP				(1<<0)
 #define BM_EOP_ERR			(1<<1)
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
