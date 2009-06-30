From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-net-usb-usbnetc-fix-proc-net-dev-stats.patch removed from -mm tree
Date: Mon, 29 Jun 2009 17:03:39 -0700
Message-ID: <200906300024.n5U0O5oD003491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbZF3AZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 20:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjk@luxsci.net, davem@davemloft.net, david-b@pacbell.net, shemminger@vyatta.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/usb/usbnet.c: fix /proc/net/dev stats
has been removed from the -mm tree.  Its filename was
     drivers-net-usb-usbnetc-fix-proc-net-dev-stats.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/usb/usbnet.c: fix /proc/net/dev stats
From: Ben Kibbey <bjk@luxsci.net>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13589

Commit 805aaa29fa ("usbnet: convert to internal net_device_stats") breaks
device statistics with the usbnet module.

This fixes a 2.6.29->2.6.30 regression.

[akpm@linux-foundation.org: typed it in, wrote changelog, etc]
Cc: David Brownell <david-b@pacbell.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/usbnet.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/usb/usbnet.c~drivers-net-usb-usbnetc-fix-proc-net-dev-stats drivers/net/usb/usbnet.c
--- a/drivers/net/usb/usbnet.c~drivers-net-usb-usbnetc-fix-proc-net-dev-stats
+++ a/drivers/net/usb/usbnet.c
@@ -1142,6 +1142,7 @@ static const struct net_device_ops usbne
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
+	.ndo_get_stats		= usbnet_get_stats,
 	.ndo_change_mtu		= usbnet_change_mtu,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
_

Patches currently in -mm which might be from bjk@luxsci.net are

drivers-net-usb-usbnetc-fix-proc-net-dev-stats.patch

