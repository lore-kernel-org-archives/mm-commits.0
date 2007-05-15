From: akpm@linux-foundation.org
Subject: + oss-trident-fix-locking-around-write_voice_regs.patch added to -mm tree
Date: Mon, 14 May 2007 18:13:01 -0700
Message-ID: <200705150113.l4F1D1ZO030849@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXEOBNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 21:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, bunk@stusta.de, tammy000@gmail.com


The patch titled
     OSS trident: fix locking around write_voice_regs
has been added to the -mm tree.  Its filename is
     oss-trident-fix-locking-around-write_voice_regs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OSS trident: fix locking around write_voice_regs
From: Muli Ben-Yehuda <muli@il.ibm.com>

trident_write_voice_regs() was getting called with the card spinlock held in
only some cases.  Fix it.

Explanation: we allocate a new virtual channel in open, and then we frob some
hardware registers (in write_voice_regs) for that channel.  But the hardware
registers are shared with other channels, which may be trying to frob the some
registers (albeit for another channel) via ioctl(SNDCTL_DSP_SPEED).

Fixed bugzilla.kernel.org bug #8172 (http://bugme.osdl.org/show_bug.cgi?id=8172)

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: <tammy000@gmail.com>
Cc: <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN sound/oss/trident.c~oss-trident-fix-locking-around-write_voice_regs sound/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-fix-locking-around-write_voice_regs
+++ a/sound/oss/trident.c
@@ -2702,6 +2702,7 @@ trident_open(struct inode *inode, struct
 	struct trident_card *card = devs;
 	struct trident_state *state = NULL;
 	struct dmabuf *dmabuf = NULL;
+	unsigned long flags;
 
 	/* Added by Matt Wu 01-05-2001 */
 	/* TODO: there's some redundacy here wrt the check below */
@@ -2779,7 +2780,9 @@ trident_open(struct inode *inode, struct
 			/* set default channel attribute to normal playback */
 			dmabuf->channel->attribute = CHANNEL_PB;
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_dac_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -2797,7 +2800,9 @@ trident_open(struct inode *inode, struct
 			dmabuf->channel->attribute = (CHANNEL_REC | PCM_LR |
 						      MONO_MIX);
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_adc_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 
 		/* Added by Matt Wu 01-05-2001 */
 		if (card->pci_id == PCI_DEVICE_ID_ALI_5451)
_

Patches currently in -mm which might be from muli@il.ibm.com are

git-pciseg.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
