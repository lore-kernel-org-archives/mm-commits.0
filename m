From: akpm@linux-foundation.org
Subject: + bluetooth-simplify-l2cap-streaming-mode-sending.patch added to -mm tree
Date: Fri, 17 Sep 2010 15:35:05 -0700
Message-ID: <201009172235.o8HMZ52H013938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab0IQWfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 18:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padovan@profusion.mobi, marcel@holtmann.org


The patch titled
     bluetooth: simplify L2CAP Streaming mode sending
has been added to the -mm tree.  Its filename is
     bluetooth-simplify-l2cap-streaming-mode-sending.patch

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
Subject: bluetooth: simplify L2CAP Streaming mode sending
From: "Gustavo F. Padovan" <padovan@profusion.mobi>

As we don't have any error control on the Streaming mode, i.e., we don't
need to keep a copy of the skb for later resending we don't need to call
skb_clone() on it.

Then we can go one further here, and dequeue the skb before sending it,
that also means we don't need to look to sk->sk_send_head anymore.

The patch saves memory and time when sending Streaming mode data.

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/l2cap.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff -puN net/bluetooth/l2cap.c~bluetooth-simplify-l2cap-streaming-mode-sending net/bluetooth/l2cap.c
--- a/net/bluetooth/l2cap.c~bluetooth-simplify-l2cap-streaming-mode-sending
+++ a/net/bluetooth/l2cap.c
@@ -1441,33 +1441,23 @@ static inline void l2cap_do_send(struct 
 
 static void l2cap_streaming_send(struct sock *sk)
 {
-	struct sk_buff *skb, *tx_skb;
+	struct sk_buff *skb;
 	struct l2cap_pinfo *pi = l2cap_pi(sk);
 	u16 control, fcs;
 
-	while ((skb = sk->sk_send_head)) {
-		tx_skb = skb_clone(skb, GFP_ATOMIC);
-
-		control = get_unaligned_le16(tx_skb->data + L2CAP_HDR_SIZE);
+	while ((skb = skb_dequeue(TX_QUEUE(sk)))) {
+		control = get_unaligned_le16(skb->data + L2CAP_HDR_SIZE);
 		control |= pi->next_tx_seq << L2CAP_CTRL_TXSEQ_SHIFT;
-		put_unaligned_le16(control, tx_skb->data + L2CAP_HDR_SIZE);
+		put_unaligned_le16(control, skb->data + L2CAP_HDR_SIZE);
 
 		if (pi->fcs == L2CAP_FCS_CRC16) {
-			fcs = crc16(0, (u8 *)tx_skb->data, tx_skb->len - 2);
-			put_unaligned_le16(fcs, tx_skb->data + tx_skb->len - 2);
+			fcs = crc16(0, (u8 *)skb->data, skb->len - 2);
+			put_unaligned_le16(fcs, skb->data + skb->len - 2);
 		}
 
-		l2cap_do_send(sk, tx_skb);
+		l2cap_do_send(sk, skb);
 
 		pi->next_tx_seq = (pi->next_tx_seq + 1) % 64;
-
-		if (skb_queue_is_last(TX_QUEUE(sk), skb))
-			sk->sk_send_head = NULL;
-		else
-			sk->sk_send_head = skb_queue_next(TX_QUEUE(sk), skb);
