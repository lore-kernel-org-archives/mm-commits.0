From: akpm@linux-foundation.org
Subject: + fix-random-freezes-with-avm-b1-drivers.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:26:03 -0700
Message-ID: <200710172126.l9HLQ3XR009152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759186AbXJQV0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kkeil@suse.de, stable@kernel.org


The patch titled
     i4l: fix random freezes with AVM B1 drivers
has been added to the -mm tree.  Its filename is
     fix-random-freezes-with-avm-b1-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i4l: fix random freezes with AVM B1 drivers
From: Karsten Keil <kkeil@suse.de>

This fix the same issue which was debbuged for the C4 controller for the B1
versions.

The capilib_ function modify or traverse a linked list without locking.

This patch extends the existing locking to the calls of these function to
prevent access to a list which is in the middle of a modification.

Signed-off-by: Karsten Keil <kkeil@suse.de>
C: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/b1.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/isdn/hardware/avm/b1.c~fix-random-freezes-with-avm-b1-drivers drivers/isdn/hardware/avm/b1.c
--- a/drivers/isdn/hardware/avm/b1.c~fix-random-freezes-with-avm-b1-drivers
+++ a/drivers/isdn/hardware/avm/b1.c
@@ -321,12 +321,15 @@ void b1_reset_ctr(struct capi_ctr *ctrl)
 	avmctrl_info *cinfo = (avmctrl_info *)(ctrl->driverdata);
 	avmcard *card = cinfo->card;
 	unsigned int port = card->port;
+	unsigned long flags;
 
 	b1_reset(port);
 	b1_reset(port);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -361,9 +364,8 @@ void b1_release_appl(struct capi_ctr *ct
 	unsigned int port = card->port;
 	unsigned long flags;
 
-	capilib_release_appl(&cinfo->ncci_head, appl);
-
 	spin_lock_irqsave(&card->lock, flags);
+	capilib_release_appl(&cinfo->ncci_head, appl);
 	b1_put_byte(port, SEND_RELEASE);
 	b1_put_word(port, appl);
 	spin_unlock_irqrestore(&card->lock, flags);
@@ -380,27 +382,27 @@ u16 b1_send_message(struct capi_ctr *ctr
 	u8 subcmd = CAPIMSG_SUBCOMMAND(skb->data);
 	u16 dlen, retval;
 
+	spin_lock_irqsave(&card->lock, flags);
 	if (CAPICMD(cmd, subcmd) == CAPI_DATA_B3_REQ) {
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
 					     CAPIMSG_MSGID(skb->data));
-		if (retval != CAPI_NOERROR) 
+		if (retval != CAPI_NOERROR) {
+			spin_unlock_irqrestore(&card->lock, flags);
 			return retval;
+		}
 
 		dlen = CAPIMSG_DATALEN(skb->data);
 
-	 	spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_DATA_B3_REQ);
 		b1_put_slice(port, skb->data, len);
 		b1_put_slice(port, skb->data + len, dlen);
-		spin_unlock_irqrestore(&card->lock, flags);
 	} else {
-	 	spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_MESSAGE);
 		b1_put_slice(port, skb->data, len);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	dev_kfree_skb_any(skb);
 	return CAPI_NOERROR;
@@ -534,17 +536,17 @@ irqreturn_t b1_interrupt(int interrupt, 
 
 		ApplId = (unsigned) b1_get_word(card->port);
 		MsgLen = b1_get_slice(card->port, card->msgbuf);
-		spin_unlock_irqrestore(&card->lock, flags);
 		if (!(skb = alloc_skb(MsgLen, GFP_ATOMIC))) {
 			printk(KERN_ERR "%s: incoming packet dropped\n",
 					card->name);
+			spin_unlock_irqrestore(&card->lock, flags);
 		} else {
 			memcpy(skb_put(skb, MsgLen), card->msgbuf, MsgLen);
 			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF)
 				capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
 						     CAPIMSG_NCCI(skb->data),
 						     CAPIMSG_MSGID(skb->data));
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			capi_ctr_handle_message(ctrl, ApplId, skb);
 		}
 		break;
@@ -554,21 +556,17 @@ irqreturn_t b1_interrupt(int interrupt, 
 		ApplId = b1_get_word(card->port);
 		NCCI = b1_get_word(card->port);
 		WindowSize = b1_get_word(card->port);
-		spin_unlock_irqrestore(&card->lock, flags);
-
 		capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+		spin_unlock_irqrestore(&card->lock, flags);
 		break;
 
 	case RECEIVE_FREE_NCCI:
 
 		ApplId = b1_get_word(card->port);
 		NCCI = b1_get_word(card->port);
-		spin_unlock_irqrestore(&card->lock, flags);
-
 		if (NCCI != 0xffffffff)
 			capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-	       
+		spin_unlock_irqrestore(&card->lock, flags);
 		break;
 
 	case RECEIVE_START:
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
fix-random-freezes-with-avm-b1-drivers.patch
fix-random-hard-freeze-with-avm-c4-card.patch
