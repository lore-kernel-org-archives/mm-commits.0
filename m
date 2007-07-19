From: akpm@linux-foundation.org
Subject: - drivers-edac-add-device-sysfs-attributes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:35 -0700
Message-ID: <200707192006.l6JK6Z2H020155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbXGSUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add device sysfs attributes
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-device-sysfs-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add device sysfs attributes
From: Douglas Thompson <dougthompson@xmission.com>

Added new controls for the edac_device and edac_mc sysfs folder.
These can be initialized by the low level driver to provide misc
controls into the low level driver for its use

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h         |   52 ++++++++++++++++++++++++-
 drivers/edac/edac_device_sysfs.c |   51 ++++++++++++++++++++++--
 drivers/edac/edac_mc_sysfs.c     |   60 +++++++++++++++++++++--------
 3 files changed, 141 insertions(+), 22 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-add-device-sysfs-attributes drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-add-device-sysfs-attributes
+++ a/drivers/edac/edac_core.h
@@ -326,6 +326,18 @@ struct csrow_info {
 	struct channel_info *channels;
 };
 
+/* mcidev_sysfs_attribute structure
+ *	used for driver sysfs attributes and in mem_ctl_info
+ * 	sysfs top level entries
+ */
+struct mcidev_sysfs_attribute {
+        struct attribute attr;
+        ssize_t (*show)(struct mem_ctl_info *,char *);
+        ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+};
+
+/* MEMORY controller information structure
+ */
 struct mem_ctl_info {
 	struct list_head link;	/* for global list of mem_ctl_info structs */
 	unsigned long mtype_cap;	/* memory types supported by mc */
@@ -353,6 +365,7 @@ struct mem_ctl_info {
 	 */
 	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 * bw);
 
+
 	/* pointer to edac checking routine */
 	void (*edac_check) (struct mem_ctl_info * mci);
 
@@ -394,6 +407,18 @@ struct mem_ctl_info {
 	struct kobject edac_mci_kobj;
 	struct completion kobj_complete;
 
+	/* Additional top controller level attributes, but specified
+	 * by the low level driver.
+	 *
+	 * Set by the low level driver to provide attributes at the
+	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * An array of structures, NULL terminated
+	 *
+	 * If attributes are desired, then set to array of attributes
+	 * If no attributes are desired, leave NULL
+	 */
+	struct mcidev_sysfs_attribute *mc_driver_sysfs_attributes;
+
 	/* work struct for this MC */
 	struct delayed_work work;
 
@@ -402,7 +427,7 @@ struct mem_ctl_info {
 };
 
 /*
- * The following are the structures to provide for a generice
+ * The following are the structures to provide for a generic
  * or abstract 'edac_device'. This set of structures and the
  * code that implements the APIs for the same, provide for
  * registering EDAC type devices which are NOT standard memory.
@@ -505,6 +530,16 @@ struct edac_device_instance {
 	struct completion kobj_complete;
 };
 
+/* edac_dev_sysfs_attribute structure
+ *     used for driver sysfs attributes and in mem_ctl_info
+ *     sysfs top level entries
+ */
+struct edac_dev_sysfs_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct edac_device_ctl_info *,char *);
+	ssize_t (*store)(struct edac_device_ctl_info *, const char *,size_t);
+};
+
 /*
  * Abstract edac_device control info structure
  *
@@ -522,7 +557,20 @@ struct edac_device_ctl_info {
 	unsigned poll_msec;	/* number of milliseconds to poll interval */
 	unsigned long delay;	/* number of jiffies for poll_msec */
 
-	struct sysdev_class *edac_class;	/* pointer to class */
+	/* Additional top controller level attributes, but specified
+	 * by the low level driver.
+	 *
+	 * Set by the low level driver to provide attributes at the
+	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * An array of structures, NULL terminated
+	 *
+	 * If attributes are desired, then set to array of attributes
+	 * If no attributes are desired, leave NULL
+	 */
+	struct edac_dev_sysfs_attribute *sysfs_attributes;
+
+	/* pointer to main 'edac' class in sysfs */
+	struct sysdev_class *edac_class;
 
 	/* the internal state of this controller instance */
 	int op_state;
diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-add-device-sysfs-attributes drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-add-device-sysfs-attributes
+++ a/drivers/edac/edac_device_sysfs.c
@@ -9,8 +9,6 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/sysdev.h>
 #include <linux/ctype.h>
 
 #include "edac_core.h"
@@ -622,6 +620,34 @@ static void edac_device_delete_instances
 /******************* edac_dev sysfs ctor/dtor  code *************/
 
 /*
+ * edac_device_add_sysfs_attributes
+ *	add some attributes to this instance's main kobject
+ */
+static int edac_device_add_sysfs_attributes(
+			struct edac_device_ctl_info *edac_dev)
+{
+	int err;
+        struct edac_dev_sysfs_attribute *sysfs_attrib;
+
+        /* point to the start of the array and iterate over it
+         * adding each attribute listed to this mci instance's kobject
+         */
+        sysfs_attrib = edac_dev->sysfs_attributes;
+
+        while (sysfs_attrib->attr.name != NULL) {
+                err = sysfs_create_file(&edac_dev->kobj,
+                                        (struct attribute*) sysfs_attrib);
+                if (err) {
+                        return err;
+                }
+
+                sysfs_attrib++;
+        }
+
+	return 0;
+}
+
+/*
  * edac_device_create_sysfs() Constructor
  *
  * Create a new edac_device kobject instance,
@@ -642,6 +668,18 @@ int edac_device_create_sysfs(struct edac
 
 	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
 
+	/* If the low level driver requests some sysfs entries
+	 * then go create them here
+	 */
+	if (edac_dev->sysfs_attributes != NULL) {
+		err = edac_device_add_sysfs_attributes(edac_dev);
+		if (err) {
+			debugf0("%s() failed to add sysfs attribs\n",
+				__func__);
+			goto err_unreg_object;
+		}
+	}
+
 	/* create a symlink from the edac device
 	 * to the platform 'device' being used for this
 	 */
@@ -650,7 +688,7 @@ int edac_device_create_sysfs(struct edac
 	if (err) {
 		debugf0("%s() sysfs_create_link() returned err= %d\n",
 			__func__, err);
-		return err;
+		goto err_unreg_object;
 	}
 
 	debugf0("%s() calling create-instances, idx=%d\n",
@@ -659,14 +697,17 @@ int edac_device_create_sysfs(struct edac
 	/* Create the first level instance directories */
 	err = edac_device_create_instances(edac_dev);
 	if (err) {
-		goto error0;
+		goto err_remove_link;
 	}
 
 	return 0;
 
 	/* Error unwind stack */
+err_remove_link:
+	/* remove the sym link */
+	sysfs_remove_link(&edac_dev->kobj, EDAC_DEVICE_SYMLINK);
 
-      error0:
+err_unreg_object:
 	edac_device_unregister_main_kobj(edac_dev);
 
 	return err;
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-add-device-sysfs-attributes drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-add-device-sysfs-attributes
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -1,15 +1,14 @@
 /*
  * edac_mc kernel module
- * (C) 2005, 2006 Linux Networx (http://lnxi.com)
+ * (C) 2005-2007 Linux Networx (http://lnxi.com)
+ *
  * This file may be distributed under the terms of the
  * GNU General Public License.
  *
- * Written Doug Thompson <norsk5@xmission.com>
+ * Written Doug Thompson <norsk5@xmission.com> www.softwarebitmaker.com
  *
  */
 
-#include <linux/module.h>
-#include <linux/sysdev.h>
 #include <linux/ctype.h>
 
 #include "edac_core.h"
@@ -661,21 +660,15 @@ static ssize_t mci_size_mb_show(struct m
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
 }
 
-struct mcidev_attribute {
-	struct attribute attr;
-	 ssize_t(*show) (struct mem_ctl_info *, char *);
-	 ssize_t(*store) (struct mem_ctl_info *, const char *, size_t);
-};
-
 #define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
-#define to_mcidev_attr(a) container_of(a, struct mcidev_attribute, attr)
+#define to_mcidev_attr(a) container_of(a,struct mcidev_sysfs_attribute,attr)
 
 /* MCI show/store functions for top most object */
 static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
 			   char *buffer)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute *mcidev_attr = to_mcidev_attr(attr);
+	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
 
 	if (mcidev_attr->show)
 		return mcidev_attr->show(mem_ctl_info, buffer);
@@ -687,7 +680,7 @@ static ssize_t mcidev_store(struct kobje
 			    const char *buffer, size_t count)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute *mcidev_attr = to_mcidev_attr(attr);
+	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
 
 	if (mcidev_attr->store)
 		return mcidev_attr->store(mem_ctl_info, buffer, count);
@@ -701,7 +694,7 @@ static struct sysfs_ops mci_ops = {
 };
 
 #define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-static struct mcidev_attribute mci_attr_##_name = {			\
+static struct mcidev_sysfs_attribute mci_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
@@ -723,7 +716,7 @@ MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_co
 MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
 	    mci_sdram_scrub_rate_store);
 
-static struct mcidev_attribute *mci_attr[] = {
+static struct mcidev_sysfs_attribute *mci_attr[] = {
 	&mci_attr_reset_counters,
 	&mci_attr_mc_name,
 	&mci_attr_size_mb,
@@ -757,6 +750,34 @@ static struct kobj_type ktype_mci = {
 #define EDAC_DEVICE_SYMLINK	"device"
 
 /*
+ * edac_create_driver_attributes
+ *	create MC driver specific attributes at the topmost level
+ *	directory of this mci instance.
+ */
+static int edac_create_driver_attributes(struct mem_ctl_info *mci)
+{
+	int err;
+	struct mcidev_sysfs_attribute *sysfs_attrib;
+
+	/* point to the start of the array and iterate over it
+	 * adding each attribute listed to this mci instance's kobject
+	 */
+	sysfs_attrib = mci->mc_driver_sysfs_attributes;
+
+	while (sysfs_attrib->attr.name != NULL) {
+		err = sysfs_create_file(&mci->edac_mci_kobj,
+					(struct attribute*) sysfs_attrib);
+		if (err) {
+			return err;
+		}
+
+		sysfs_attrib++;
+	}
+
+	return 0;
+}
+
+/*
  * Create a new Memory Controller kobject instance,
  *	mc<id> under the 'mc' directory
  *
@@ -794,6 +815,15 @@ int edac_create_sysfs_mci_device(struct 
 	if (err)
 		goto fail0;
 
+	/* If the low level driver desires some attributes,
+	 * then create them now for the driver.
+	 */
+	if (mci->mc_driver_sysfs_attributes) {
+		err = edac_create_driver_attributes(mci);
+		if (err)
+			goto fail0;
+	}
+
 	/* Make directories for each CSROW object
 	 * under the mc<id> kobject
 	 */
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
