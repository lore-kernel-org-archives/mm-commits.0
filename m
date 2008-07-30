From: akpm@linux-foundation.org
Subject: - configure-out-ethtool-support-fix.patch removed from -mm tree
Date: Wed, 30 Jul 2008 14:45:09 -0700
Message-ID: <200807302145.m6ULj9wL018990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYG3Vpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 17:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.petazzoni@free-electrons.com, davem@davemloft.net, jeff@garzik.org, mpm@selenic.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     configure-out-ethtool-support-fix
has been removed from the -mm tree.  Its filename was
     configure-out-ethtool-support-fix.patch

This patch was dropped because it was folded into configure-out-ethtool-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: configure-out-ethtool-support-fix
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Make sure ETHTOOL support is selected when bonding and bridging are
requested.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 net/bridge/Kconfig  |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/net/Kconfig~configure-out-ethtool-support-fix drivers/net/Kconfig
--- a/drivers/net/Kconfig~configure-out-ethtool-support-fix
+++ a/drivers/net/Kconfig
@@ -61,6 +61,7 @@ config DUMMY
 config BONDING
 	tristate "Bonding driver support"
 	depends on INET
+	select ETHTOOL
 	---help---
 	  Say 'Y' or 'M' if you wish to be able to 'bond' multiple Ethernet
 	  Channels together. This is called 'Etherchannel' by Cisco,
diff -puN net/bridge/Kconfig~configure-out-ethtool-support-fix net/bridge/Kconfig
--- a/net/bridge/Kconfig~configure-out-ethtool-support-fix
+++ a/net/bridge/Kconfig
@@ -6,6 +6,7 @@ config BRIDGE
 	tristate "802.1d Ethernet Bridging"
 	select LLC
 	select STP
+	select ETHTOOL
 	---help---
 	  If you say Y here, then your Linux box will be able to act as an
 	  Ethernet bridge, which means that the different Ethernet segments it
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

origin.patch
configure-out-igmp-support.patch
configure-out-ethtool-support.patch
configure-out-ethtool-support-fix.patch
configure-out-file-locking-features.patch
configure-out-aio-support.patch

