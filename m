From: akpm@linux-foundation.org
Subject: + md-software-raid-autodetect-dev-list-not-array.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:16:24 -0700
Message-ID: <200708311916.l7VJGOn6022540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850AbXHaTQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjevans1983@gmail.com, neilb@suse.de


The patch titled
     md: software Raid autodetect dev list not array
has been added to the -mm tree.  Its filename is
     md-software-raid-autodetect-dev-list-not-array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: software Raid autodetect dev list not array
From: Michael J. Evans <mjevans1983@gmail.com>

In current release kernels the md module (Software RAID) uses a static
array (dev_t[128]) to store partition/device info temporarily for
autostart.

I discovered this (and that the devices are added as disks/partitions are
discovered at boot) while I was debugging why only one of my MD arrays would
come up whole, while all the others were short a disk.

I eventually discovered that it was enumerating through all of 9 of my 11 hds
(2 had only 4 partitions apiece) while the other 9 have 15 partitions (I
wanted 64 per drive...).  The last partition of the 8th drive in my 9 drive
raid 5 sets wasn't added, thus making the final md array short both a parity
and data disk, and it was started later, elsewhere.

This patch replaces that static array with a list.

Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff -puN drivers/md/md.c~md-software-raid-autodetect-dev-list-not-array drivers/md/md.c
--- a/drivers/md/md.c~md-software-raid-autodetect-dev-list-not-array
+++ a/drivers/md/md.c
@@ -5780,26 +5780,48 @@ static int __init md_init(void)
  * Searches all registered partitions for autorun RAID arrays
  * at boot time.
  */
-static dev_t detected_devices[128];
-static int dev_cnt;
+
+static LIST_HEAD(all_detected_devices);
+struct detected_devices_node {
+	struct list_head list;
+	dev_t dev;
+};
 
 void md_autodetect_dev(dev_t dev)
 {
-	if (dev_cnt >= 0 && dev_cnt < 127)
-		detected_devices[dev_cnt++] = dev;
+	struct detected_devices_node *node_detected_dev;
+	char strbuf[BDEVNAME_SIZE];
+
+	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);
+	if (node_detected_dev) {
+		node_detected_dev->dev = dev;
+		list_add_tail(&node_detected_dev->list, &all_detected_devices);
+	} else {
+		printk(KERN_CRIT "md: md_autodetect_dev: kzAlloc node failed"
+			", skipping dev(%d,%d)\n", MAJOR(dev), MINOR(dev));
+	}
 }
 
 
 static void autostart_arrays(int part)
 {
 	mdk_rdev_t *rdev;
-	int i;
+	struct detected_devices_node *node_detected_dev;
+	dev_t dev;
+	int i_scanned, i_passed;
 
-	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
+	i_scanned = 0;
+	i_passed = 0;
 
-	for (i = 0; i < dev_cnt; i++) {
-		dev_t dev = detected_devices[i];
+	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
 
+	while (!list_empty(&all_detected_devices) && i_scanned < INT_MAX) {
+		i_scanned++;
+		node_detected_dev = list_entry(all_detected_devices.next,
+					struct detected_devices_node, list);
+		list_del(&node_detected_dev->list);
+		dev = node_detected_dev->dev;
+		kfree(node_detected_dev);
 		rdev = md_import_device(dev,0, 90);
 		if (IS_ERR(rdev))
 			continue;
@@ -5809,8 +5831,11 @@ static void autostart_arrays(int part)
 			continue;
 		}
 		list_add(&rdev->same_set, &pending_raid_disks);
+		i_passed++;
 	}
-	dev_cnt = 0;
+
+	printk(KERN_INFO "md: Scanned %d and added %d devices.\n",
+						i_scanned, i_passed);
 
 	autorun_devices(part);
 }
_

Patches currently in -mm which might be from mjevans1983@gmail.com are

md-software-raid-autodetect-dev-list-not-array.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
