From: akpm@linux-foundation.org
Subject: + driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch added to -mm tree
Date: Mon, 18 Aug 2008 21:50:51 -0700
Message-ID: <200808190450.m7J4opW1031423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbYHSEvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 00:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Xiaoming.Zhang@resilience.com, jeff@garzik.org, shemminger@vyatta.com, xiaoming.zhang@resilience.com


The patch titled
     driver/net/skge.c: restart the interface when it's options or pauseparam is set
has been added to the -mm tree.  Its filename is
     driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver/net/skge.c: restart the interface when it's options or pauseparam is set
From: "Xiaoming.Zhang" <Xiaoming.Zhang@resilience.com>

We have an issue of the skge driver: The card won't work when it's options
are changed.  Here's the hardware info:

# lspci -v
05:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit Ethernet Controller (rev 13)
        Subsystem: Marvell Technology Group Ltd. Marvell RDK-8001
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at d042c000 (32-bit, non-prefetchable) [size=16K]
        I/O ports at d000 [size=256]
        [virtual] Expansion ROM at 20400000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data

The happens in both Linux-2.6.26(skge version 1.23) and RHEL5.2(skge
version 1.6).

For example, at first it is set to "speed 1000 duplex full auto-neg on" and
it works, then run

       ethtool -s <ethx> autoneg off
or     ethtool -s <ethx> speed 100 duplex full autoneg off

Then it will stop working. After that if we restart the interface:

	ifconifg <ethx> down
	ifconfig <ethx> up

It will work again. And `ethtool -A' has the same issue.

So we think after setting the options, the interface should be restarted. 

Signed-off-by: Zhang Xiaoming <xiaoming.zhang@resilience.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set drivers/net/skge.c
--- a/drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set
+++ a/drivers/net/skge.c
@@ -353,8 +353,10 @@ static int skge_set_settings(struct net_
 	skge->autoneg = ecmd->autoneg;
 	skge->advertising = ecmd->advertising;
 
-	if (netif_running(dev))
-		skge_phy_reset(skge);
+	if (netif_running(dev)) {
+		skge_down(dev);
+		skge_up(dev);
+	}
 
 	return (0);
 }
@@ -595,8 +597,10 @@ static int skge_set_pauseparam(struct ne
 			skge->flow_control = FLOW_MODE_NONE;
 	}
 
-	if (netif_running(dev))
-		skge_phy_reset(skge);
+	if (netif_running(dev)) {
+		skge_down(dev);
+		skge_up(dev);
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from Xiaoming.Zhang@resilience.com are

driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch

