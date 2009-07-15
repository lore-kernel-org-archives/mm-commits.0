From: akpm@linux-foundation.org
Subject: + cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch added to -mm tree
Date: Wed, 15 Jul 2009 15:08:35 -0700
Message-ID: <200907152208.n6FM8atd002249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbZGOWIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 18:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew.patterson@hp.com, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: kick off logical drive topology rescan through sysfs
has been added to the -mm tree.  Its filename is
     cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

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
Subject: cciss: kick off logical drive topology rescan through sysfs
From: Andrew Patterson <andrew.patterson@hp.com>

Added /sys/bus/pci/devices/<dev>/ccissX/rescan sysfs entry used
to kick off a rescan that discovers logical drive topology changes.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-pci-devices-cciss |    7 ++
 drivers/block/cciss.c                                 |   35 +++++++++-
 2 files changed, 39 insertions(+), 3 deletions(-)

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
@@ -461,9 +461,19 @@ static void __devinit cciss_procinit(int
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
@@ -567,6 +577,25 @@ static ssize_t dev_show_rev(struct devic
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

cciss-remove-logical-drive-sysfs-entries-during-driver-cleanup.patch
cciss-use-only-one-scan-thread.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

