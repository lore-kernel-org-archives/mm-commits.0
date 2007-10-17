From: akpm@linux-foundation.org
Subject: + fix-random-hard-freeze-with-avm-c4-card.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:26:05 -0700
Message-ID: <200710172126.l9HLQ6rg009155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758872AbXJQV0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kkeil@suse.de, rainer.brestan@frequentis.com, rsc@runtux.com, stable@kernel.org


The patch titled
     i4l: Fix random hard freeze with AVM c4 card
has been added to the -mm tree.  Its filename is
     fix-random-hard-freeze-with-avm-c4-card.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i4l: Fix random hard freeze with AVM c4 card
From: Karsten Keil <kkeil@suse.de>

The patch
- Includes the call to capilib_data_b3_req in the spinlock. This routine
  in turn calls the offending mq_enqueue routine that triggered the
  freeze if not locked.  This should also fix other indicators of
  incosistent capilib_msgidqueue list, that trigger messages like:
  Oct  5 03:05:57 BERL0 kernel: kcapi: msgid 3019 ncci 0x30301 not on queue
  that we saw several times a day (usually several in a row).
- Fixes all occurrences of c4_dispatch_tx to be called with active
  spinlock, there were some instances where no lock was active. Mostly
  these are in very infrequently called routines, so the additional
  performance penalty is minimal.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Rainer Brestan <rainer.brestan@frequentis.com>
Signed-off-by: Ralf Schlatterbeck <rsc@runtux.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/c4.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/hardware/avm/c4.c~fix-random-hard-freeze-with-avm-c4-card drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c~fix-random-hard-freeze-with-avm-c4-card
+++ a/drivers/isdn/hardware/avm/c4.c
@@ -727,6 +727,7 @@ static void c4_send_init(avmcard *card)
 {
 	struct sk_buff *skb;
 	void *p;
+	unsigned long flags;
 
 	skb = alloc_skb(15, GFP_ATOMIC);
 	if (!skb) {
@@ -744,12 +745,15 @@ static void c4_send_init(avmcard *card)
 	skb_put(skb, (u8 *)p - (u8 *)skb->data);
 
 	skb_queue_tail(&card->dma->send_queue, skb);
+	spin_lock_irqsave(&card->lock, flags);
 	c4_dispatch_tx(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 }
 
 static int queue_sendconfigword(avmcard *card, u32 val)
 {
 	struct sk_buff *skb;
+	unsigned long flags;
 	void *p;
 
 	skb = alloc_skb(3+4, GFP_ATOMIC);
@@ -766,7 +770,9 @@ static int queue_sendconfigword(avmcard 
 	skb_put(skb, (u8 *)p - (u8 *)skb->data);
 
 	skb_queue_tail(&card->dma->send_queue, skb);
+	spin_lock_irqsave(&card->lock, flags);
 	c4_dispatch_tx(card);
+	spin_unlock_irqrestore(&card->lock, flags);
 	return 0;
 }
 
@@ -986,7 +992,9 @@ static void c4_release_appl(struct capi_
 	struct sk_buff *skb;
 	void *p;
 
+	spin_lock_irqsave(&card->lock, flags);
 	capilib_release_appl(&cinfo->ncci_head, appl);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (ctrl->cnr == card->cardnr) {
 		skb = alloc_skb(7, GFP_ATOMIC);
@@ -1019,7 +1027,8 @@ static u16 c4_send_message(struct capi_c
 	u16 retval = CAPI_NOERROR;
 	unsigned long flags;
 
- 	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
+	spin_lock_irqsave(&card->lock, flags);
+	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
 		retval = capilib_data_b3_req(&cinfo->ncci_head,
 					     CAPIMSG_APPID(skb->data),
 					     CAPIMSG_NCCI(skb->data),
@@ -1027,10 +1036,9 @@ static u16 c4_send_message(struct capi_c
 	}
 	if (retval == CAPI_NOERROR) {
 		skb_queue_tail(&card->dma->send_queue, skb);
-		spin_lock_irqsave(&card->lock, flags);
 		c4_dispatch_tx(card);
-		spin_unlock_irqrestore(&card->lock, flags);
 	}
+	spin_unlock_irqrestore(&card->lock, flags);
 	return retval;
 }
 
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
fix-random-freezes-with-avm-b1-drivers.patch
fix-random-hard-freeze-with-avm-c4-card.patch
