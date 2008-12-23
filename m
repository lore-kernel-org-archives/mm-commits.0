From: akpm@linux-foundation.org
Subject: + netdev-gianfar-add-mii-ioctl-handler.patch added to -mm tree
Date: Tue, 23 Dec 2008 12:18:47 -0800
Message-ID: <200812232018.mBNKIlka008543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYLWUSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Dec 2008 15:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clifford@clifford.at


The patch titled
     netdev: gianfar: add MII ioctl handler
has been added to the -mm tree.  Its filename is
     netdev-gianfar-add-mii-ioctl-handler.patch

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
Subject: netdev: gianfar: add MII ioctl handler
From: Clifford Wolf <clifford@clifford.at>

This is the same kind of wrapper that can also be found in many
other network device drivers.

Tested with a freescale MPC8349E host CPU:
Toggled the interface LEDs on a DP83865 PHY.

Signed-off-by: Clifford Wolf <clifford@clifford.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/gianfar.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/net/gianfar.c~netdev-gianfar-add-mii-ioctl-handler drivers/net/gianfar.c
--- a/drivers/net/gianfar.c~netdev-gianfar-add-mii-ioctl-handler
+++ a/drivers/net/gianfar.c
@@ -296,6 +296,20 @@ err_out:
 	return err;
 }
 
+/* Ioctl MII Interface */
+static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!priv->phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(priv->phydev, if_mii(rq), cmd);
+}
+
 /* Set up the ethernet device structure, private data,
  * and anything else we need before we start */
 static int gfar_probe(struct of_device *ofdev,
@@ -366,6 +380,7 @@ static int gfar_probe(struct of_device *
 	dev->set_multicast_list = gfar_set_multi;
 
 	dev->ethtool_ops = &gfar_ethtool_ops;
+	dev->do_ioctl = gfar_ioctl;
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
 		priv->rx_csum_enable = 1;
_

Patches currently in -mm which might be from clifford@clifford.at are

i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch
netdev-gianfar-add-mii-ioctl-handler.patch

