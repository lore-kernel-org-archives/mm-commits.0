From: akpm@linux-foundation.org
Subject: - driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:02 -0700
Message-ID: <200810092228.m99MS2k7006038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYJIW20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Xiaoming.Zhang@resilience.com, jeff@garzik.org, shemminger@vyatta.com, xiaoming.zhang@resilience.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/skge.c: restart the interface when it's options or pauseparam is set
has been removed from the -mm tree.  Its filename was
     driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/skge.c: restart the interface when it's options or pauseparam is set
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
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Garzik <jeff@garzik.org>

On Tue, 23 Sep 2008 16:47:18 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:
> Since skge_up can fail because of out of memory, this code needs to
> check the return value. And then if it fails the "limbo state" needs
> to be handled in skge_down.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set drivers/net/skge.c
--- a/drivers/net/skge.c~driver-net-skgec-restart-the-interface-when-its-options-or-pauseparam-is-set
+++ a/drivers/net/skge.c
@@ -367,8 +367,10 @@ static int skge_set_settings(struct net_
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
@@ -609,8 +611,10 @@ static int skge_set_pauseparam(struct ne
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

git-net.patch

