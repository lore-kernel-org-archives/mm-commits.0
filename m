From: akpm@osdl.org
Subject: + infiniband-fix-for-gregkh-driver-network-device.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:40:51 -0800
Message-ID: <200612152240.kBFMep9a003543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030287AbWLOWky (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, greg@kroah.com


The patch titled
     fix infiniband for gregkh-driver-network-device
has been added to the -mm tree.  Its filename is
     infiniband-fix-for-gregkh-driver-network-device.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix infiniband for gregkh-driver-network-device
From: Roland Dreier <rdreier@cisco.com>

This should fix up the netdevice class stuff for IPoIB CM.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/infiniband/ulp/ipoib/ipoib_cm.c~infiniband-fix-for-gregkh-driver-network-device drivers/infiniband/ulp/ipoib/ipoib_cm.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c~infiniband-fix-for-gregkh-driver-network-device
+++ a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1025,10 +1025,10 @@ void ipoib_cm_tx_reap(struct work_struct
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 }
 
-static ssize_t show_mode(struct class_device *cdev, char *buf)
+static ssize_t show_mode(struct device *d, struct device_attribute *attr,
+			 char *buf)
 {
-	struct net_device *dev = container_of(cdev, struct net_device, class_dev);
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(d));
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
 		return sprintf(buf, "connected\n");
@@ -1036,10 +1036,10 @@ static ssize_t show_mode(struct class_de
 		return sprintf(buf, "datagram\n");
 }
 
-static ssize_t set_mode(struct class_device *cdev,
+static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
-	struct net_device *dev = container_of(cdev, struct net_device, class_dev);
+	struct net_device *dev = to_net_dev(d);
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/* flush paths if we switch modes so that connections are restarted */
@@ -1059,11 +1059,11 @@ static ssize_t set_mode(struct class_dev
 	return -EINVAL;
 }
 
-static CLASS_DEVICE_ATTR(mode, S_IWUGO | S_IRUGO, show_mode, set_mode);
+static DEVICE_ATTR(mode, S_IWUGO | S_IRUGO, show_mode, set_mode);
 
 int ipoib_cm_add_mode_attr(struct net_device *dev)
 {
-	return class_device_create_file(&dev->class_dev, &class_device_attr_mode);
+	return device_create_file(&dev->dev, &dev_attr_mode);
 }
 
 int ipoib_cm_dev_init(struct net_device *dev)
_

Patches currently in -mm which might be from rdreier@cisco.com are

infiniband-work-around-gcc-bug-on-sparc64.patch
infiniband-fix-for-gregkh-driver-network-device.patch
hpet-avoid-warning-message-livelock.patch

