From: akpm@linux-foundation.org
Subject: + 8139too-fix-irq-problem-with-napi-netpoll.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:47:29 -0800
Message-ID: <200702272047.l1RKlXKu027966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXB0Urs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, jeff@garzik.org, romieu@fr.zoreil.com


The patch titled
     8139too.c: fix irq problem with NAPI + NETPOLL
has been added to the -mm tree.  Its filename is
     8139too-fix-irq-problem-with-napi-netpoll.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 8139too.c: fix irq problem with NAPI + NETPOLL
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

It seems netif_receive_skb() was designed not to call from irq context, but
NAPI + NETPOLL break this rule.  If netif_receive_skb() was called from irq
context, redirect to netif_rx() instead of processing the skb in that
context.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN net/core/dev.c~8139too-fix-irq-problem-with-napi-netpoll net/core/dev.c
--- a/net/core/dev.c~8139too-fix-irq-problem-with-napi-netpoll
+++ a/net/core/dev.c
@@ -1769,8 +1769,15 @@ int netif_receive_skb(struct sk_buff *sk
 	__be16 type;
 
 	/* if we've gotten here through NAPI, check netpoll */
-	if (skb->dev->poll && netpoll_rx(skb))
-		return NET_RX_DROP;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	if (skb->dev->poll && skb->dev->poll_controller) {
+		/* NAPI poll might be called in irq context on NETPOLL */
+		if (in_irq() || irqs_disabled())
+			return netif_rx(skb);
+		if (netpoll_rx(skb))
+			return NET_RX_DROP;
+	}
+#endif
 
 	if (!skb->tstamp.off_sec)
 		net_timestamp(skb);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-mips.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
serial-serial_txx9-driver-update-3.patch
x86_64-fix-section-mismatch-warnings.patch
