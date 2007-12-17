From: akpm@linux-foundation.org
Subject: - bridge-assign-random-address.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:41:14 -0800
Message-ID: <200712172341.lBHNfET4008370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937340AbXLQXvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:51:47 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBHNpj34007844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2007 15:51:46 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     bridge: assign random address
has been removed from the -mm tree.  Its filename was
     bridge-assign-random-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bridge: assign random address
From: Stephen Hemminger <shemminger@linux-foundation.org>

Assigning a valid random address to bridge device solves problems when
bridge device is brought up before adding real device to bridge.  When the
first real device is added to the bridge, it's address will overide the
bridges random address.

Note: any device added to a bridge must already have a valid
ethernet address.
 br_add_if -> br_fdb_insert -> fdb_insert -> is_valid_ether_addr

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/bridge/br_device.c~bridge-assign-random-address net/bridge/br_device.c
--- a/net/bridge/br_device.c~bridge-assign-random-address
+++ a/net/bridge/br_device.c
@@ -157,8 +157,7 @@ static struct ethtool_ops br_ethtool_ops
 
 void br_dev_setup(struct net_device *dev)
 {
-	memset(dev->dev_addr, 0, ETH_ALEN);
-
+	random_ether_addr(dev->dev_addr);
 	ether_setup(dev);
 
 	dev->do_ioctl = br_dev_ioctl;
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-input.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
