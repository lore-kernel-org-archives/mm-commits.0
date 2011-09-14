From: akpm@linux-foundation.org
Subject: + ipw2x00-fix-rtnl-mutex-deadlock.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:49:57 -0700
Message-ID: <201109142049.p8EKnvFm005908@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:25737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, baryluk@smp.if.uj.edu.pl, dcbw@redhat.com, mfwitten@gmail.com


The patch titled
     ipw2x00: fix rtnl mutex deadlock
has been added to the -mm tree.  Its filename is
     ipw2x00-fix-rtnl-mutex-deadlock.patch

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
Subject: ipw2x00: fix rtnl mutex deadlock
From: Stanislaw Gruszka <sgruszka@redhat.com>

This fixes a regression introduced by:

commit: ecb4433550f0620f3d1471ae7099037ede30a91e
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Aug 12 14:00:59 2011 +0200

    mac80211: fix suspend/resume races with unregister hw

Above commit add rtnl_lock() into wiphy_register(), what cause deadlock
when initializing ipw2x00 driver, which itself call wiphy_register() from
register_netdev() internal callback with rtnl mutex taken.

To fix move wiphy_register() outside register_netdev().  This solution
have side effect of not creating /sys/class/net/wlanX/phy80211 link, but
that's a minor issue we can live with.

Bisected-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Bisected-by: Michael Witten <mfwitten@gmail.com>
Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Tested-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/ipw2100.c |   21 ++++++++----
 drivers/net/wireless/ipw2x00/ipw2200.c |   39 +++++++++++++++--------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff -puN drivers/net/wireless/ipw2x00/ipw2100.c~ipw2x00-fix-rtnl-mutex-deadlock drivers/net/wireless/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/ipw2x00/ipw2100.c~ipw2x00-fix-rtnl-mutex-deadlock
+++ a/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1903,15 +1903,17 @@ static void ipw2100_down(struct ipw2100_
 static int ipw2100_net_init(struct net_device *dev)
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
+
+	return ipw2100_up(priv, 1);
+}
+
+static int ipw2100_wdev_init(struct net_device *dev)
+{
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct wireless_dev *wdev = &priv->ieee->wdev;
-	int ret;
 	int i;
 
-	ret = ipw2100_up(priv, 1);
-	if (ret)
-		return ret;
-
 	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
 
 	/* fill-out priv->ieee->bg_band */
@@ -6350,9 +6352,13 @@ static int ipw2100_pci_init_one(struct p
 		       "Error calling register_netdev.\n");
 		goto fail;
 	}
+	registered = 1;
+
+	err = ipw2100_wdev_init(dev);
+	if (err)
+		goto fail;
 
 	mutex_lock(&priv->action_mutex);
-	registered = 1;
 
 	IPW_DEBUG_INFO("%s: Bound to %s\n", dev->name, pci_name(pci_dev));
 
@@ -6389,7 +6395,8 @@ static int ipw2100_pci_init_one(struct p
 
       fail_unlock:
 	mutex_unlock(&priv->action_mutex);
-
+	wiphy_unregister(priv->ieee->wdev.wiphy);
+	kfree(priv->ieee->bg_band.channels);
       fail:
 	if (dev) {
 		if (registered)
diff -puN drivers/net/wireless/ipw2x00/ipw2200.c~ipw2x00-fix-rtnl-mutex-deadlock drivers/net/wireless/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/ipw2x00/ipw2200.c~ipw2x00-fix-rtnl-mutex-deadlock
+++ a/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11426,16 +11426,23 @@ static void ipw_bg_down(struct work_stru
 /* Called by register_netdev() */
 static int ipw_net_init(struct net_device *dev)
 {
+	int rc = 0;
+	struct ipw_priv *priv = libipw_priv(dev);
+
+	mutex_lock(&priv->mutex);
+	if (ipw_up(priv))
+		rc = -EIO;
+	mutex_unlock(&priv->mutex);
+
+	return rc;
+}
+
+static int ipw_wdev_init(struct net_device *dev)
+{
 	int i, rc = 0;
 	struct ipw_priv *priv = libipw_priv(dev);
 	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct wireless_dev *wdev = &priv->ieee->wdev;
-	mutex_lock(&priv->mutex);
-
-	if (ipw_up(priv)) {
-		rc = -EIO;
-		goto out;
-	}
 
 	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
 
@@ -11520,13 +11527,9 @@ static int ipw_net_init(struct net_devic
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */
-	if (wiphy_register(wdev->wiphy)) {
+	if (wiphy_register(wdev->wiphy))
 		rc = -EIO;
-		goto out;
-	}
-
 out:
-	mutex_unlock(&priv->mutex);
 	return rc;
 }
 
@@ -11833,14 +11836,22 @@ static int __devinit ipw_pci_probe(struc
 		goto out_remove_sysfs;
 	}
 
+	err = ipw_wdev_init(net_dev);
+	if (err) {
+		IPW_ERROR("failed to register wireless device\n");
+		goto out_unregister_netdev;
+	}
+
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 	if (rtap_iface) {
 	        err = ipw_prom_alloc(priv);
 		if (err) {
 			IPW_ERROR("Failed to register promiscuous network "
 				  "device (error %d).\n", err);
-			unregister_netdev(priv->net_dev);
-			goto out_remove_sysfs;
+			wiphy_unregister(priv->ieee->wdev.wiphy);
+			kfree(priv->ieee->a_band.channels);
+			kfree(priv->ieee->bg_band.channels);
+			goto out_unregister_netdev;
 		}
 	}
 #endif
@@ -11852,6 +11863,8 @@ static int __devinit ipw_pci_probe(struc
 
 	return 0;
 
+      out_unregister_netdev:
+	unregister_netdev(priv->net_dev);
       out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &ipw_attribute_group);
       out_release_irq:
_

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch
ipw2x00-fix-rtnl-mutex-deadlock.patch

