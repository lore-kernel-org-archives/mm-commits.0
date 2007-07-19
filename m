From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_device-init-apis.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:18 -0700
Message-ID: <200707192007.l6JK7ISc020253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760713AbXGSUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_device init apis
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_device-init-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_device init apis
From: Doug Thompson <dougthompson@xmission.com>

Refactoring of sysfs code necessitated the refactoring of the
edac_device_alloc() and edac_device_add_device() apis, of moving the index
value to the alloc() function.  This patch alters the in tree drivers to
utilize this new api signature.

Having the index value performed later created a chicken-and-the-egg issue. 
Moving it to the alloc() function allows for creating the necessary sysfs
entries with the proper index number

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    6 +++---
 drivers/edac/edac_device.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_device-init-apis drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_device-init-apis
+++ a/drivers/edac/edac_core.h
@@ -634,7 +634,8 @@ extern struct edac_device_ctl_info *edac
 		char *edac_block_name, unsigned nr_blocks,
 		unsigned offset_value,
 		struct edac_dev_sysfs_block_attribute *block_attributes,
-		unsigned nr_attribs);
+		unsigned nr_attribs,
+		int device_index);
 
 /* The offset value can be:
  *	-1 indicating no offset value
@@ -806,8 +807,7 @@ extern void edac_mc_handle_fbd_ce(struct
 /*
  * edac_device APIs
  */
-extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev,
-				int dev_idx);
+extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev);
 extern struct edac_device_ctl_info *edac_device_del_device(struct device *dev);
 extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
diff -puN drivers/edac/edac_device.c~drivers-edac-fix-edac_device-init-apis drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-edac_device-init-apis
+++ a/drivers/edac/edac_device.c
@@ -67,7 +67,8 @@ struct edac_device_ctl_info *edac_device
 	char *edac_device_name, unsigned nr_instances,
 	char *edac_block_name, unsigned nr_blocks,
 	unsigned offset_value,		/* zero, 1, or other based offset */
-	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib)
+	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib,
+	int device_index)
 {
 	struct edac_device_ctl_info *dev_ctl;
 	struct edac_device_instance *dev_inst, *inst;
@@ -145,6 +146,7 @@ struct edac_device_ctl_info *edac_device
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
 	/* Begin storing the information into the control info structure */
+	dev_ctl->dev_idx = device_index;
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
@@ -441,18 +443,16 @@ void edac_device_reset_delay_period(stru
  * edac_device global list and create sysfs entries associated with
  * edac_device structure.
  * @edac_device: pointer to the edac_device structure to be added to the list
- * @edac_idx: A unique numeric identifier to be assigned to the
  * 'edac_device' structure.
  *
  * Return:
  *	0	Success
  *	!0	Failure
  */
-int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx)
+int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 
-	edac_dev->dev_idx = edac_idx;
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_device_dump_device(edac_dev);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
