From: akpm@linux-foundation.org
Subject: + drivers-edac-edac_device-sysfs-cleanup.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:12 -0700
Message-ID: <200706060151.l561pCeP007482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933926AbXFFB40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: edac_device sysfs cleanup
has been added to the -mm tree.  Its filename is
     drivers-edac-edac_device-sysfs-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: edac_device sysfs cleanup
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

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
