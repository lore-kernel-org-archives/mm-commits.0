From: akpm@linux-foundation.org
Subject: + sky2-use-debugfs-rename.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:30:00 -0700
Message-ID: <200708311930.l7VJU0hb022992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbXHaTaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:30:02 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7VJU0UW018096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2007 12:30:01 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: use debugfs rename
has been added to the -mm tree.  Its filename is
     sky2-use-debugfs-rename.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: use debugfs rename
From: Stephen Hemminger <shemminger@linux-foundation.org>

Use debugfs rename to handle device neame changes.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |   56 ++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 32 deletions(-)

diff -puN drivers/net/sky2.c~sky2-use-debugfs-rename drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-use-debugfs-rename
+++ a/drivers/net/sky2.c
@@ -3712,42 +3712,34 @@ static int sky2_device_event(struct noti
 			     unsigned long event, void *ptr)
 {
 	struct net_device *dev = ptr;
+	struct sky2_port *sky2 = netdev_priv(dev);
 
-	if (dev->open == sky2_up) {
-		struct sky2_port *sky2 = netdev_priv(dev);
+	if (dev->open != sky2_up || !sky2_debug)
+		return NOTIFY_DONE;
 
-		switch(event) {
-		case NETDEV_CHANGENAME:
-			if (!netif_running(dev))
-				break;
-			/* fallthrough */
-		case NETDEV_DOWN:
-		case NETDEV_GOING_DOWN:
-			if (sky2->debugfs) {
-				printk(KERN_DEBUG PFX "%s: remove debugfs\n",
-				       dev->name);
-				debugfs_remove(sky2->debugfs);
-				sky2->debugfs = NULL;
-			}
+	switch(event) {
+	case NETDEV_CHANGENAME:
+		if (sky2->debugfs) {
+			sky2->debugfs = debugfs_rename(sky2_debug, sky2->debugfs,
+						       sky2_debug, dev->name);
+		}
+		break;
 
-			if (event != NETDEV_CHANGENAME)
-				break;
-			/* fallthrough for changename */
-		case NETDEV_UP:
-			if (sky2_debug) {
-				struct dentry *d;
-				d = debugfs_create_file(dev->name, S_IRUGO,
-							sky2_debug, dev,
-							&sky2_debug_fops);
-				if (d == NULL || IS_ERR(d))
-					printk(KERN_INFO PFX
-					       "%s: debugfs create failed\n",
-					       dev->name);
-				else
-					sky2->debugfs = d;
-			}
-			break;
+	case NETDEV_GOING_DOWN:
+		if (sky2->debugfs) {
+			printk(KERN_DEBUG PFX "%s: remove debugfs\n",
+			       dev->name);
+			debugfs_remove(sky2->debugfs);
+			sky2->debugfs = NULL;
 		}
+		break;
+
+	case NETDEV_UP:
+		sky2->debugfs = debugfs_create_file(dev->name, S_IRUGO,
+						    sky2_debug, dev,
+						    &sky2_debug_fops);
+		if (IS_ERR(sky2->debugfs))
+			sky2->debugfs = NULL;
 	}
 
 	return NOTIFY_DONE;
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-fe-chip-support.patch
sky2-use-debugfs-rename.patch
sky2-document-gphy_ctrl-bits.patch
sky2-dont-restrict-config-space-access.patch
sky2-advanced-error-reporting.patch
sky2-use-pci_config-access-functions.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-hardware-receive-timestamp-counter.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
