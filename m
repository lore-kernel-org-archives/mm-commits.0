From: akpm@linux-foundation.org
Subject: + r8169-fix-rxmissed-register-access.patch added to -mm tree
Date: Wed, 10 Sep 2008 19:21:16 -0700
Message-ID: <200809110221.m8B2LG0k006170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbYIKCWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 22:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, edward_hsu@realtek.com.tw, jeff@garzik.org, stable@kernel.org


The patch titled
     r8169: fix RxMissed register access
has been added to the -mm tree.  Its filename is
     r8169-fix-rxmissed-register-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r8169: fix RxMissed register access
From: Francois Romieu <romieu@fr.zoreil.com>

- the register is defined for the 8169 chipset only and there is
  no 8169 beyond RTL_GIGA_MAC_VER_06.
- only the lower 3 bytes of the register are valid

Fixes:
1. http://bugzilla.kernel.org/show_bug.cgi?id=10180
2. http://bugzilla.kernel.org/show_bug.cgi?id=11062 (bits of)

Tested by Hermann Gausterer and Adam Huffman.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN drivers/net/r8169.c~r8169-fix-rxmissed-register-access drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-fix-rxmissed-register-access
+++ a/drivers/net/r8169.c
@@ -2286,8 +2286,6 @@ static void rtl_hw_start_8168(struct net
 
 	RTL_R8(IntrMask);
 
-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);
 
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -2412,8 +2410,6 @@ static void rtl_hw_start_8101(struct net
 
 	RTL_R8(IntrMask);
 
-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);
 
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -3191,6 +3187,17 @@ static int rtl8169_poll(struct napi_stru
 	return work_done;
 }
 
+static void rtl8169_rx_missed(struct net_device *dev, void __iomem *ioaddr)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	if (tp->mac_version > RTL_GIGA_MAC_VER_06)
+		return;
+
+	dev->stats.rx_missed_errors += (RTL_R32(RxMissed) & 0xffffff);
+	RTL_W32(RxMissed, 0);
+}
+
 static void rtl8169_down(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -3208,9 +3215,7 @@ core_down:
 
 	rtl8169_asic_down(ioaddr);
 
-	/* Update the error counts. */
-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);
 
 	spin_unlock_irq(&tp->lock);
 
@@ -3332,8 +3337,7 @@ static struct net_device_stats *rtl8169_
 
 	if (netif_running(dev)) {
 		spin_lock_irqsave(&tp->lock, flags);
-		dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-		RTL_W32(RxMissed, 0);
+		rtl8169_rx_missed(dev, ioaddr);
 		spin_unlock_irqrestore(&tp->lock, flags);
 	}
 
@@ -3358,8 +3362,7 @@ static int rtl8169_suspend(struct pci_de
 
 	rtl8169_asic_down(ioaddr);
 
-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);
 
 	spin_unlock_irq(&tp->lock);
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

linux-next.patch
r8169-fix-rxmissed-register-access.patch

