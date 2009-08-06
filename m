From: akpm@linux-foundation.org
Subject: [to-be-updated] cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:27:46 -0700
Message-ID: <200908062327.n76NRkAT010174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbZHFX1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: kick off logical drive topology rescan through sysfs
has been removed from the -mm tree.  Its filename was
     cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: kick off logical drive topology rescan through sysfs
From: Andrew Patterson <andrew.patterson@hp.com>

Added /sys/bus/pci/devices/<dev>/ccissX/rescan sysfs entry used
to kick off a rescan that discovers logical drive topology changes.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-pci-devices-cciss |    7 +
 drivers/block/cciss.c                                 |   36 +++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-bus-pci-devices-cciss~cciss-kick-off-logical-drive-topology-rescan-through-sysfs Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss~cciss-kick-off-logical-drive-topology-rescan-through-sysfs
+++ a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -31,3 +31,10 @@ Date:		March 2009
 Kernel Version: 2.6.30
 Contact:	iss_storagedev@hp.com
 Description:	A symbolic link to /sys/block/cciss!cXdY
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/rescan
+Date:		July 2009
+Kernel Version:	2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Kicks of a rescan of the controller to discovery logical
+		drive topology changes.
diff -puN drivers/block/cciss.c~cciss-kick-off-logical-drive-topology-rescan-through-sysfs drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-kick-off-logical-drive-topology-rescan-through-sysfs
+++ a/drivers/block/cciss.c
@@ -194,6 +194,7 @@ static int sendcmd_withirq_core(ctlr_inf
 static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int add_to_scan_list(struct ctlr_info *h);
 static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 
@@ -459,9 +460,19 @@ static void __devinit cciss_procinit(int
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
 #define to_drv(n) container_of(n, drive_info_struct, dev)
 
-static struct device_type cciss_host_type = {
-	.name		= "cciss_host",
-};
+static ssize_t host_store_rescan(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct ctlr_info *h = to_hba(dev);
+
+	add_to_scan_list(h);
+	wake_up_process(cciss_scan_thread);
+	wait_for_completion_interruptible(&h->scan_wait);
+
+	return count;
+}
+DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
@@ -565,6 +576,25 @@ static ssize_t dev_show_rev(struct devic
 }
 DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 
+static struct attribute *cciss_host_attrs[] = {
+	&dev_attr_rescan.attr,
+	NULL
+};
+
+static struct attribute_group cciss_host_attr_group = {
+	.attrs = cciss_host_attrs,
+};
+
+static struct attribute_group *cciss_host_attr_groups[] = {
+	&cciss_host_attr_group,
+	NULL
+};
+
+static struct device_type cciss_host_type = {
+	.name		= "cciss_host",
+	.groups		= cciss_host_attr_groups,
+};
+
 static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_unique_id.attr,
 	&dev_attr_model.attr,
_

Patches currently in -mm which might be from andrew.patterson@hp.com are

origin.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

