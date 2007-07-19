From: akpm@linux-foundation.org
Subject: - drivers-edac-edac_device-sysfs-cleanup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:10 -0700
Message-ID: <200707192006.l6JK6AnI020111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXGSUPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: edac_device sysfs cleanup
has been removed from the -mm tree.  Its filename was
     drivers-edac-edac_device-sysfs-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: edac_device sysfs cleanup
From: Douglas Thompson <dougthompson@xmission.com>

Removal of some old dead and disabled code from the edac_device sysfs code

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device_sysfs.c |  107 -----------------------------
 1 file changed, 107 deletions(-)

diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-edac_device-sysfs-cleanup drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-edac_device-sysfs-cleanup
+++ a/drivers/edac/edac_device_sysfs.c
@@ -21,113 +21,6 @@
 #define to_edacdev(k) container_of(k, struct edac_device_ctl_info, kobj)
 #define to_edacdev_attr(a) container_of(a, struct edacdev_attribute, attr)
 
-#ifdef DKT
-
-static ssize_t edac_dev_ue_count_show(struct edac_device_ctl_info *edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%d\n", edac_dev->ue_count);
-}
-
-static ssize_t edac_dev_ce_count_show(struct edac_device_ctl_info *edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%d\n", edac_dev->ce_count);
-}
-
-static ssize_t edac_dev_seconds_show(struct edac_device_ctl_info *edac_dev,
-				     char *data)
-{
-	return sprintf(data, "%ld\n", (jiffies - edac_dev->start_time) / HZ);
-}
-
-static ssize_t edac_dev_ctl_name_show(struct edac_device_ctl_info *edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%s\n", edac_dev->ctl_name);
-}
-
-struct edacdev_attribute {
-	struct attribute attr;
-	 ssize_t(*show) (struct edac_device_ctl_info *, char *);
-	 ssize_t(*store) (struct edac_device_ctl_info *, const char *, size_t);
-};
-
-/* EDAC DEVICE show/store functions for top most object */
-static ssize_t edacdev_show(struct kobject *kobj, struct attribute *attr,
-			    char *buffer)
-{
-	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
-
-	if (edacdev_attr->show)
-		return edacdev_attr->show(edac_dev, buffer);
-
-	return -EIO;
-}
-
-static ssize_t edacdev_store(struct kobject *kobj, struct attribute *attr,
-			     const char *buffer, size_t count)
-{
-	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
-
-	if (edacdev_attr->store)
-		return edacdev_attr->store(edac_dev, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops edac_dev_ops = {
-	.show = edacdev_show,
-	.store = edacdev_store
-};
-
-#define EDACDEV_ATTR(_name,_mode,_show,_store)			\
-static struct edacdev_attribute edac_dev_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* default Control file */
-EDACDEV_ATTR(reset_counters, S_IWUSR, NULL, edac_dev_reset_counters_store);
-
-/* default Attribute files */
-EDACDEV_ATTR(mc_name, S_IRUGO, edac_dev_ctl_name_show, NULL);
-EDACDEV_ATTR(seconds_since_reset, S_IRUGO, edac_dev_seconds_show, NULL);
-EDACDEV_ATTR(ue_count, S_IRUGO, edac_dev_ue_count_show, NULL);
-EDACDEV_ATTR(ce_count, S_IRUGO, edac_dev_ce_count_show, NULL);
-
-static struct edacdev_attribute *edacdev_attr[] = {
-	&edacdev_attr_reset_counters,
-	&edacdev_attr_mc_name,
-	&edacdev_attr_seconds_since_reset,
-	&edacdev_attr_ue_count,
-	&edacdev_attr_ce_count,
-	NULL
-};
-
-/*
- * Release of a Edac Device controlling instance
- */
-static void edac_dev_instance_release(struct kobject *kobj)
-{
-	struct edac_device_ctl_info *edac_dev;
-
-	edac_dev = to_edacdev(kobj);
-	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
-	complete(&edac_dev->kobj_complete);
-}
-
-static struct kobj_type ktype_device = {
-	.release = edac_dev_instance_release,
-	.sysfs_ops = &edacdev_ops,
-	.default_attrs = (struct attribute **)edacdev_attr,
-};
-
-#endif
-
 /************************** edac_device sysfs code and data **************/
 
 /*
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
