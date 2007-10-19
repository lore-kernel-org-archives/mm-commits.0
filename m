From: akpm@linux-foundation.org
Subject: - fix-random-hard-freeze-with-avm-cards-using-b1dma.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:26 -0700
Message-ID: <200710192249.l9JMnQ3h023965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566AbXJSWta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: fix random hard freeze with AVM cards using b1dma
has been removed from the -mm tree.  Its filename was
     fix-random-hard-freeze-with-avm-cards-using-b1dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: fix random hard freeze with AVM cards using b1dma
From: Karsten Keil <kkeil@suse.de>

This fixes the hard freeze debugded for AVM C4 cards using the b1dma
interface.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/b1dma.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN drivers/isdn/hardware/avm/b1dma.c~fix-random-hard-freeze-with-avm-cards-using-b1dma drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c~fix-random-hard-freeze-with-avm-cards-using-b1dma
+++ a/drivers/isdn/hardware/avm/b1dma.c
@@ -486,11 +486,13 @@ static void b1dma_handle_rx(avmcard *car
 					card->name);
 		} else {
 			memcpy(skb_put(skb, MsgLen), card->msgbuf, MsgLen);
-			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF)
+			if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_CONF) {
+				spin_lock(&card->lock);
 				capilib_data_b3_conf(&cinfo->ncci_head, ApplId,
-						     CAPIMSG_NCCI(skb->data),
-						     CAPIMSG_MSGID(skb->data));
-
+					CAPIMSG_NCCI(skb->data),
+					CAPIMSG_MSGID(skb->data));
+				spin_unlock(&card->lock);
+			}
 			capi_ctr_handle_message(ctrl, ApplId, skb);
 		}
 		break;
@@ -500,9 +502,9 @@ static void b1dma_handle_rx(avmcard *car
 		ApplId = _get_word(&p);
 		NCCI = _get_word(&p);
 		WindowSize = _get_word(&p);
-
+		spin_lock(&card->lock);
 		capilib_new_ncci(&cinfo->ncci_head, ApplId, NCCI, WindowSize);
-
+		spin_unlock(&card->lock);
 		break;
 
 	case RECEIVE_FREE_NCCI:
@@ -510,9 +512,11 @@ static void b1dma_handle_rx(avmcard *car
 		ApplId = _get_word(&p);
 		NCCI = _get_word(&p);
 
-		if (NCCI != 0xffffffff)
+		if (NCCI != 0xffffffff) {
+			spin_lock(&card->lock);
 			capilib_free_ncci(&cinfo->ncci_head, ApplId, NCCI);
-
+			spin_unlock(&card->lock);
+		}
 		break;
 
 	case RECEIVE_START:
@@ -751,10 +755,10 @@ void b1dma_reset_ctr(struct capi_ctr *ct
 
 	spin_lock_irqsave(&card->lock, flags);
  	b1dma_reset(card);
-	spin_unlock_irqrestore(&card->lock, flags);
 
 	memset(cinfo->version, 0, sizeof(cinfo->version));
 	capilib_release(&cinfo->ncci_head);
+	spin_unlock_irqrestore(&card->lock, flags);
 	capi_ctr_reseted(ctrl);
 }
 
@@ -803,8 +807,11 @@ void b1dma_release_appl(struct capi_ctr 
 	avmcard *card = cinfo->card;
 	struct sk_buff *skb;
 	void *p;
+	unsigned long flags;
 
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release_appl(&cinfo->ncci_head, appl);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	skb = alloc_skb(7, GFP_ATOMIC);
 	if (!skb) {
@@ -832,10 +839,13 @@ u16 b1dma_send_message(struct capi_ctr *
 	u16 retval = CAPI_NOERROR;
 
  	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
+		unsigned long flags;
+		spin_lock_irqsave(&card->lock, flags);
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
 					     CAPIMSG_MSGID(skb->data));
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 	if (retval == CAPI_NOERROR) 
 		b1dma_queue_tx(card, skb);
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
