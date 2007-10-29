From: akpm@linux-foundation.org
Subject: + dca-convert-struct-class_device-to-struct-device.patch added to -mm tree
Date: Mon, 29 Oct 2007 15:28:00 -0700
Message-ID: <200710292228.l9TMS0IA029059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXJ2W2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dan.j.williams@intel.com, greg@kroah.com, shannon.nelson@intel.com


The patch titled
     DCA: convert struct class_device to struct device.
has been added to the -mm tree.  Its filename is
     dca-convert-struct-class_device-to-struct-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DCA: convert struct class_device to struct device.
From: Kay Sievers <kay.sievers@vrfy.org>

Thanks to Kay for keeping us honest.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/dca-sysfs.c |   15 +++++++--------
 include/linux/dca.h     |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/dca/dca-sysfs.c~dca-convert-struct-class_device-to-struct-device drivers/dca/dca-sysfs.c
--- a/drivers/dca/dca-sysfs.c~dca-convert-struct-class_device-to-struct-device
+++ a/drivers/dca/dca-sysfs.c
@@ -12,10 +12,10 @@ static spinlock_t dca_idr_lock;
 
 int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 {
-	struct class_device *cd;
+	struct device *cd;
 
-	cd = class_device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
-				 dev, "requester%d", slot);
+	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
+			   "requester%d", slot);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	return 0;
@@ -23,12 +23,12 @@ int dca_sysfs_add_req(struct dca_provide
 
 void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
 {
-	class_device_destroy(dca_class, MKDEV(0, slot + 1));
+	device_destroy(dca_class, MKDEV(0, slot + 1));
 }
 
 int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 {
-	struct class_device *cd;
+	struct device *cd;
 	int err = 0;
 
 idr_try_again:
@@ -46,8 +46,7 @@ idr_try_again:
 		return err;
 	}
 
-	cd = class_device_create(dca_class, NULL, MKDEV(0, 0),
-				 dev, "dca%d", dca->id);
+	cd = device_create(dca_class, dev, MKDEV(0, 0), "dca%d", dca->id);
 	if (IS_ERR(cd)) {
 		spin_lock(&dca_idr_lock);
 		idr_remove(&dca_idr, dca->id);
@@ -60,7 +59,7 @@ idr_try_again:
 
 void dca_sysfs_remove_provider(struct dca_provider *dca)
 {
-	class_device_unregister(dca->cd);
+	device_unregister(dca->cd);
 	dca->cd = NULL;
 	spin_lock(&dca_idr_lock);
 	idr_remove(&dca_idr, dca->id);
diff -puN include/linux/dca.h~dca-convert-struct-class_device-to-struct-device include/linux/dca.h
--- a/include/linux/dca.h~dca-convert-struct-class_device-to-struct-device
+++ a/include/linux/dca.h
@@ -11,7 +11,7 @@ void dca_unregister_notify(struct notifi
 
 struct dca_provider {
 	struct dca_ops		*ops;
-	struct class_device 	*cd;
+	struct device 		*cd;
 	int			 id;
 };
 
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

fs-partitions-checkc-add-error-handling-for.patch
git-scsi-misc.patch
dcdbas-add-dmi-based-module-autloading.patch
dca-convert-struct-class_device-to-struct-device.patch
