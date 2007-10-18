From: akpm@linux-foundation.org
Subject: + fix-random-hard-freeze-with-avm-t1-cards.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:14:08 -0700
Message-ID: <200710182114.l9ILE8bF031486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758751AbXJRVOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kkeil@suse.de


The patch titled
     isdn: fix random hard freeze with AVM T1 cards
has been added to the -mm tree.  Its filename is
     fix-random-hard-freeze-with-avm-t1-cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn: fix random hard freeze with AVM T1 cards
From: Karsten Keil <kkeil@suse.de>

This fixes the hard freeze debugged for AVM C4 cards for the AVM T1 cards.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/t1isa.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/isdn/hardware/avm/t1isa.c~fix-random-hard-freeze-with-avm-t1-cards drivers/isdn/hardware/avm/t1isa.c
--- a/drivers/isdn/hardware/avm/t1isa.c~fix-random-hard-freeze-with-avm-t1-cards
+++ a/drivers/isdn/hardware/avm/t1isa.c
@@ -180,8 +180,8 @@ static irqreturn_t t1isa_interrupt(int i
 
 			ApplId = (unsigned) b1_get_word(card->port);
 			MsgLen = t1_get_slice(card->port, card->msgbuf);
-			spin_unlock_irqrestore(&card->lock, flags);
 			if (!(skb = alloc_skb(MsgLen, GFP_ATOMIC))) {
+				spin_unlock_irqrestore(&card->lock, flags);
 				printk(KERN_ERR "%s: incoming packet dropped\n",
 						card->name);
 			} else {
@@ -190,7 +190,7 @@ static irqreturn_t t1isa_interrupt(int i
 					capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
 							     CAPIMSG_NCCI(skb->data),
 							     CAPIMSG_MSGID(skb->data));
-
+				spin_unlock_irqrestore(&card->lock, flags);
 				capi_ctr_handle_message(ctrl, ApplId, skb);
 			}
 			break;
@@ -200,21 +200,17 @@ static irqreturn_t t1isa_interrupt(int i
 			ApplId = b1_get_word(card->port);
 			NCCI = b1_get_word(card->port);
 			WindowSize = b1_get_word(card->port);
-			spin_unlock_irqrestore(&card->lock, flags);
-
 			capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			break;
 
 		case RECEIVE_FREE_NCCI:
 
 			ApplId = b1_get_word(card->port);
 			NCCI = b1_get_word(card->port);
-			spin_unlock_irqrestore(&card->lock, flags);
-
 			if (NCCI != 0xffffffff)
 				capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-
+			spin_unlock_irqrestore(&card->lock, flags);
 			break;
 
 		case RECEIVE_START:
@@ -333,13 +329,16 @@ static void t1isa_reset_ctr(struct capi_
 	avmctrl_info *cinfo = (avmctrl_info *)(ctrl->driverdata);
 	avmcard *card = cinfo->card;
 	unsigned int port = card->port;
+	unsigned long flags;
 
 	t1_disable_irq(port);
 	b1_reset(port);
 	b1_reset(port);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -466,29 +465,26 @@ static u16 t1isa_send_message(struct cap
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
-
+		}
 		dlen = CAPIMSG_DATALEN(skb->data);
 
-		spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_DATA_B3_REQ);
 		t1_put_slice(port, skb->data, len);
 		t1_put_slice(port, skb->data + len, dlen);
-		spin_unlock_irqrestore(&card->lock, flags);
 	} else {
-
-		spin_lock_irqsave(&card->lock, flags);
 		b1_put_byte(port, SEND_MESSAGE);
 		t1_put_slice(port, skb->data, len);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
-
+	spin_unlock_irqrestore(&card->lock, flags);
 	dev_kfree_skb_any(skb);
 	return CAPI_NOERROR;
 }
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
fix-random-freezes-with-avm-b1-drivers.patch
fix-random-hard-freeze-with-avm-c4-card.patch
fix-random-hard-freeze-with-avm-c4-card-part-2.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma-checkpatch-fixes.patch
fix-random-hard-freeze-with-avm-t1-cards.patch
