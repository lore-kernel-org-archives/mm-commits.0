From: akpm@linux-foundation.org
Subject: + cxgb3-manage-sysfs-attributes-per-port.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:47:33 -0800
Message-ID: <200702272047.l1RKlb5h027969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXB0UsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: manage sysfs attributes per port
has been added to the -mm tree.  Its filename is
     cxgb3-manage-sysfs-attributes-per-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: manage sysfs attributes per port
From: Divy Le Ray <divy@chelsio.com>

sysfs attributes are now managed per port, no longer per adapter.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-manage-sysfs-attributes-per-port drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-manage-sysfs-attributes-per-port
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -434,27 +434,25 @@ static int setup_sge_qsets(struct adapte
 
 static ssize_t attr_show(struct device *d, struct device_attribute *attr,
 			 char *buf,
-			 ssize_t(*format) (struct adapter *, char *))
+			 ssize_t(*format) (struct net_device *, char *))
 {
 	ssize_t len;
-	struct adapter *adap = to_net_dev(d)->priv;
 
 	/* Synchronize with ioctls that may shut down the device */
 	rtnl_lock();
-	len = (*format) (adap, buf);
+	len = (*format) (to_net_dev(d), buf);
 	rtnl_unlock();
 	return len;
 }
 
 static ssize_t attr_store(struct device *d, struct device_attribute *attr,
 			  const char *buf, size_t len,
-			  ssize_t(*set) (struct adapter *, unsigned int),
+			  ssize_t(*set) (struct net_device *, unsigned int),
 			  unsigned int min_val, unsigned int max_val)
 {
 	char *endp;
 	ssize_t ret;
 	unsigned int val;
-	struct adapter *adap = to_net_dev(d)->priv;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -464,7 +462,7 @@ static ssize_t attr_store(struct device 
 		return -EINVAL;
 
 	rtnl_lock();
-	ret = (*set) (adap, val);
+	ret = (*set) (to_net_dev(d), val);
 	if (!ret)
 		ret = len;
 	rtnl_unlock();
@@ -472,8 +470,9 @@ static ssize_t attr_store(struct device 
 }
 
 #define CXGB3_SHOW(name, val_expr) \
-static ssize_t format_##name(struct adapter *adap, char *buf) \
+static ssize_t format_##name(struct net_device *dev, char *buf) \
 { \
+	struct adapter *adap = dev->priv; \
 	return sprintf(buf, "%u\n", val_expr); \
 } \
 static ssize_t show_##name(struct device *d, struct device_attribute *attr, \
@@ -482,8 +481,10 @@ static ssize_t show_##name(struct device
 	return attr_show(d, attr, buf, format_##name); \
 }
 
-static ssize_t set_nfilters(struct adapter *adap, unsigned int val)
+static ssize_t set_nfilters(struct net_device *dev, unsigned int val)
 {
+	struct adapter *adap = dev->priv;
+
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
 	if (val && adap->params.rev == 0)
@@ -500,8 +501,10 @@ static ssize_t store_nfilters(struct dev
 	return attr_store(d, attr, buf, len, set_nfilters, 0, ~0);
 }
 
-static ssize_t set_nservers(struct adapter *adap, unsigned int val)
+static ssize_t set_nservers(struct net_device *dev, unsigned int val)
 {
+	struct adapter *adap = dev->priv;
+
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
 	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nfilters)
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-manage-sysfs-attributes-per-port.patch
cxgb3-private-ioctl-cleanup.patch
cxgb3-fw-version-update.patch
cxgb3-unmap-offload-packets-when-they-are-freed.patch
cxgb3-recovery-from-hw-starvation-of-response-queue.patch
cxgb3-feed-rx-free-list-with-pages.patch
cxgb3-add-sw-lro-support.patch
