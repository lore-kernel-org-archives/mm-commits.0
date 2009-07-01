From: akpm@linux-foundation.org
Subject: + usbnet-use-netdev-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:33:37 -0700
Message-ID: <200907012233.n61MXbtc015925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbZGAWeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     usbnet: use netdev stats structure
has been added to the -mm tree.  Its filename is
     usbnet-use-netdev-stats-structure.patch

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
Subject: usbnet: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/usbnet.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/net/usb/usbnet.c~usbnet-use-netdev-stats-structure drivers/net/usb/usbnet.c
--- a/drivers/net/usb/usbnet.c~usbnet-use-netdev-stats-structure
+++ a/drivers/net/usb/usbnet.c
@@ -234,8 +234,8 @@ void usbnet_skb_return (struct usbnet *d
 	int	status;
 
 	skb->protocol = eth_type_trans (skb, dev->net);
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
+	dev->net->stats.rx_packets++;
+	dev->net->stats.rx_bytes += skb->len;
 
 	if (netif_msg_rx_status (dev))
 		devdbg (dev, "< rx, len %zu, type 0x%x",
@@ -397,7 +397,7 @@ static inline void rx_process (struct us
 		if (netif_msg_rx_err (dev))
 			devdbg (dev, "drop");
 error:
-		dev->stats.rx_errors++;
+		dev->net->stats.rx_errors++;
 		skb_queue_tail (&dev->done, skb);
 	}
 }
@@ -420,8 +420,8 @@ static void rx_complete (struct urb *urb
 	case 0:
 		if (skb->len < dev->net->hard_header_len) {
 			entry->state = rx_cleanup;
-			dev->stats.rx_errors++;
-			dev->stats.rx_length_errors++;
+			dev->net->stats.rx_errors++;
+			dev->net->stats.rx_length_errors++;
 			if (netif_msg_rx_err (dev))
 				devdbg (dev, "rx length %d", skb->len);
 		}
@@ -433,7 +433,7 @@ static void rx_complete (struct urb *urb
 	 * storm, recovering as needed.
 	 */
 	case -EPIPE:
-		dev->stats.rx_errors++;
+		dev->net->stats.rx_errors++;
 		usbnet_defer_kevent (dev, EVENT_RX_HALT);
 		// FALLTHROUGH
 
@@ -451,7 +451,7 @@ static void rx_complete (struct urb *urb
 	case -EPROTO:
 	case -ETIME:
 	case -EILSEQ:
-		dev->stats.rx_errors++;
+		dev->net->stats.rx_errors++;
 		if (!timer_pending (&dev->delay)) {
 			mod_timer (&dev->delay, jiffies + THROTTLE_JIFFIES);
 			if (netif_msg_link (dev))
@@ -465,12 +465,12 @@ block:
 
 	/* data overrun ... flush fifo? */
 	case -EOVERFLOW:
-		dev->stats.rx_over_errors++;
+		dev->net->stats.rx_over_errors++;
 		// FALLTHROUGH
 
 	default:
 		entry->state = rx_cleanup;
-		dev->stats.rx_errors++;
+		dev->net->stats.rx_errors++;
 		if (netif_msg_rx_err (dev))
 			devdbg (dev, "rx status %d", urb_status);
 		break;
@@ -583,8 +583,8 @@ int usbnet_stop (struct net_device *net)
 
 	if (netif_msg_ifdown (dev))
 		devinfo (dev, "stop stats: rx/tx %ld/%ld, errs %ld/%ld",
-			dev->stats.rx_packets, dev->stats.tx_packets,
-			dev->stats.rx_errors, dev->stats.tx_errors
+			net->stats.rx_packets, net->stats.tx_packets,
+			net->stats.rx_errors, net->stats.tx_errors
 			);
 
 	// ensure there are no more active urbs
@@ -891,10 +891,10 @@ static void tx_complete (struct urb *urb
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
-		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += entry->length;
+		dev->net->stats.tx_packets++;
+		dev->net->stats.tx_bytes += entry->length;
 	} else {
-		dev->stats.tx_errors++;
+		dev->net->stats.tx_errors++;
 
 		switch (urb->status) {
 		case -EPIPE:
@@ -1020,7 +1020,7 @@ int usbnet_start_xmit (struct sk_buff *s
 			devdbg (dev, "drop, code %d", retval);
 drop:
 		retval = NET_XMIT_SUCCESS;
-		dev->stats.tx_dropped++;
+		dev->net->stats.tx_dropped++;
 		if (skb)
 			dev_kfree_skb_any (skb);
 		usb_free_urb (urb);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch
cdc_eem-use-netdev-stats-structure.patch
dm9601-use-netdev-stats-structure.patch
net1080-use-netdev-stats-structure.patch
rndis_host-use-netdev-stats-structure.patch
smsc95xx-use-netdev-stats-structure.patch
usbnet-use-netdev-stats-structure.patch
usbnet-remove-private-stats-structure.patch

