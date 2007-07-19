From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_device-sysfs-completion-code.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:23 -0700
Message-ID: <200707192007.l6JK7NA5020259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759447AbXGSUQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_device sysfs completion code
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_device-sysfs-completion-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_device sysfs completion code
From: Douglas Thompson <dougthompson@xmission.com>

With feedback, this patch corrects operation of the kobject release operation
on kobjects, attributes and controls for the edac_device.

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h         |   10 
 drivers/edac/edac_device.c       |   37 ++-
 drivers/edac/edac_device_sysfs.c |  341 ++++++++++++++++++++---------
 drivers/edac/edac_module.h       |    4 
 4 files changed, 277 insertions(+), 115 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_device-sysfs-completion-code drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_device-sysfs-completion-code
+++ a/drivers/edac/edac_core.h
@@ -337,6 +337,9 @@ struct mcidev_sysfs_attribute {
  */
 struct mem_ctl_info {
 	struct list_head link;	/* for global list of mem_ctl_info structs */
+
+	struct module *owner;	/* Module owner of this control struct */
+
 	unsigned long mtype_cap;	/* memory types supported by mc */
 	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
 	unsigned long edac_cap;	/* configuration capabilities - this is
@@ -510,7 +513,6 @@ struct edac_device_block {
 
 	/* edac sysfs device control */
 	struct kobject kobj;
-	struct completion kobj_complete;
 };
 
 /* device instance control structure */
@@ -525,7 +527,6 @@ struct edac_device_instance {
 
 	/* edac sysfs device control */
 	struct kobject kobj;
-	struct completion kobj_complete;
 };
 
 
@@ -537,6 +538,8 @@ struct edac_device_ctl_info {
 	/* for global list of edac_device_ctl_info structs */
 	struct list_head link;
 
+	struct module *owner;	/* Module owner of this control struct */
+
 	int dev_idx;
 
 	/* Per instance controls for this edac_device */
@@ -587,7 +590,7 @@ struct edac_device_ctl_info {
 	 * NMI handlers may be traversing list
 	 */
 	struct rcu_head rcu;
-	struct completion complete;
+	struct completion removal_complete;
 
 	/* sysfs top name under 'edac' directory
 	 * and instance name:
@@ -611,7 +614,6 @@ struct edac_device_ctl_info {
 	 * device this structure controls
 	 */
 	struct kobject kobj;
-	struct completion kobj_complete;
 };
 
 /* To get from the instance's wq to the beginning of the ctl structure */
diff -puN drivers/edac/edac_device.c~drivers-edac-fix-edac_device-sysfs-completion-code drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-edac_device-sysfs-completion-code
+++ a/drivers/edac/edac_device.c
@@ -48,6 +48,7 @@ static void edac_device_dump_device(stru
 }
 #endif				/* CONFIG_EDAC_DEBUG */
 
+
 /*
  * edac_device_alloc_ctl_info()
  *	Allocate a new edac device control info structure
@@ -78,6 +79,7 @@ struct edac_device_ctl_info *edac_device
 	unsigned count;
 	unsigned instance, block, attr;
 	void *pvt;
+	int err;
 
 	debugf1("%s() instances=%d blocks=%d\n",
 		__func__, nr_instances, nr_blocks);
@@ -208,6 +210,22 @@ struct edac_device_ctl_info *edac_device
 	/* Mark this instance as merely ALLOCATED */
 	dev_ctl->op_state = OP_ALLOC;
 
+	/*
+	 * Initialize the 'root' kobj for the edac_device controller
+	 */
+	err = edac_device_register_sysfs_main_kobj(dev_ctl);
+	if (err) {
+		kfree(dev_ctl);
+		return NULL;
+	}
+
+	/* at this point, the root kobj is valid, and in order to
+	 * 'free' the object, then the function:
+	 *	edac_device_unregister_sysfs_main_kobj() must be called
+	 * which will perform kobj unregistration and the actual free
+	 * will occur during the kobject callback operation
+	 */
+
 	return dev_ctl;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_info);
@@ -219,7 +237,7 @@ EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_
  */
 void edac_device_free_ctl_info(struct edac_device_ctl_info *ctl_info)
 {
-	kfree(ctl_info);
+	edac_device_unregister_sysfs_main_kobj(ctl_info);
 }
 EXPORT_SYMBOL_GPL(edac_device_free_ctl_info);
 
@@ -315,22 +333,23 @@ static void complete_edac_device_list_de
 
 	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
 	INIT_LIST_HEAD(&edac_dev->link);
-	complete(&edac_dev->complete);
+	complete(&edac_dev->removal_complete);
 }
 
 /*
  * del_edac_device_from_global_list
  *
- *	remove the RCU, setup for a callback call, then wait for the
- *	callback to occur
+ *	remove the RCU, setup for a callback call,
+ *	then wait for the callback to occur
  */
 static void del_edac_device_from_global_list(struct edac_device_ctl_info
 						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
-	init_completion(&edac_device->complete);
+
+	init_completion(&edac_device->removal_complete);
 	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
-	wait_for_completion(&edac_device->complete);
+	wait_for_completion(&edac_device->removal_complete);
 }
 
 /**
@@ -542,14 +561,14 @@ struct edac_device_ctl_info *edac_device
 	/* clear workq processing on this instance */
 	edac_device_workq_teardown(edac_dev);
 
-	/* Tear down the sysfs entries for this instance */
-	edac_device_remove_sysfs(edac_dev);
-
 	/* deregister from global list */
 	del_edac_device_from_global_list(edac_dev);
 
 	mutex_unlock(&device_ctls_mutex);
 
+	/* Tear down the sysfs entries for this instance */
+	edac_device_remove_sysfs(edac_dev);
+
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n",
 		edac_dev->dev_idx,
diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-fix-edac_device-sysfs-completion-code drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-fix-edac_device-sysfs-completion-code
+++ a/drivers/edac/edac_device_sysfs.c
@@ -1,7 +1,8 @@
 /*
  * file for managing the edac_device class of devices for EDAC
  *
- * (C) 2007 SoftwareBitMaker(http://www.softwarebitmaker.com)
+ * (C) 2007 SoftwareBitMaker (http://www.softwarebitmaker.com)
+ *
  * This file may be distributed under the terms of the
  * GNU General Public License.
  *
@@ -10,6 +11,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/module.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -19,7 +21,6 @@
 #define to_edacdev(k) container_of(k, struct edac_device_ctl_info, kobj)
 #define to_edacdev_attr(a) container_of(a, struct edacdev_attribute, attr)
 
-/************************** edac_device sysfs code and data **************/
 
 /*
  * Set of edac_device_ctl_info attribute store/show functions
@@ -103,8 +104,8 @@ static ssize_t edac_device_ctl_poll_msec
 /* edac_device_ctl_info specific attribute structure */
 struct ctl_info_attribute {
 	struct attribute attr;
-	 ssize_t(*show) (struct edac_device_ctl_info *, char *);
-	 ssize_t(*store) (struct edac_device_ctl_info *, const char *, size_t);
+	ssize_t(*show) (struct edac_device_ctl_info *, char *);
+	ssize_t(*store) (struct edac_device_ctl_info *, const char *, size_t);
 };
 
 #define to_ctl_info(k) container_of(k, struct edac_device_ctl_info, kobj)
@@ -168,45 +169,76 @@ static struct ctl_info_attribute *device
 	NULL,
 };
 
-/* Main DEVICE kobject release() function */
+/*
+ * edac_device_ctrl_master_release
+ *
+ *	called when the reference count for the 'main' kobj
+ *	for a edac_device control struct reaches zero
+ *
+ *	Reference count model:
+ *		One 'main' kobject for each control structure allocated.
+ *		That main kobj is initially set to one AND
+ *		the reference count for the EDAC 'core' module is
+ *		bumped by one, thus added 'keep in memory' dependency.
+ *
+ *		Each new internal kobj (in instances and blocks) then
+ *		bumps the 'main' kobject.
+ *
+ *		When they are released their release functions decrement
+ *		the 'main' kobj.
+ *
+ *		When the main kobj reaches zero (0) then THIS function
+ *		is called which then decrements the EDAC 'core' module.
+ *		When the module reference count reaches zero then the
+ *		module no longer has dependency on keeping the release
+ *		function code in memory and module can be unloaded.
+ *
+ *		This will support several control objects as well, each
+ *		with its own 'main' kobj.
+ */
 static void edac_device_ctrl_master_release(struct kobject *kobj)
 {
-	struct edac_device_ctl_info *edac_dev;
+	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
 
-	edac_dev = to_edacdev(kobj);
+	debugf1("%s() control index=%d\n", __func__, edac_dev->dev_idx);
 
-	debugf1("%s()\n", __func__);
-	complete(&edac_dev->kobj_complete);
+	/* decrement the EDAC CORE module ref count */
+	module_put(edac_dev->owner);
+
+	/* free the control struct containing the 'main' kobj
+	 * passed in to this routine
+	 */
+	kfree(edac_dev);
 }
 
+/* ktype for the main (master) kobject */
 static struct kobj_type ktype_device_ctrl = {
 	.release = edac_device_ctrl_master_release,
 	.sysfs_ops = &device_ctl_info_ops,
 	.default_attrs = (struct attribute **)device_ctrl_attr,
 };
 
-/**************** edac_device main kobj ctor/dtor code *********************/
-
 /*
- * edac_device_register_main_kobj
+ * edac_device_register_sysfs_main_kobj
  *
  *	perform the high level setup for the new edac_device instance
  *
  * Return:  0 SUCCESS
  *         !0 FAILURE
  */
-static int edac_device_register_main_kobj(struct edac_device_ctl_info *edac_dev)
+int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 {
-	int err = 0;
 	struct sysdev_class *edac_class;
+	int err;
 
 	debugf1("%s()\n", __func__);
 
 	/* get the /sys/devices/system/edac reference */
 	edac_class = edac_get_edac_class();
 	if (edac_class == NULL) {
-		debugf1("%s() no edac_class error=%d\n", __func__, err);
-		return err;
+		debugf1("%s() no edac_class error\n", __func__);
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	/* Point to the 'edac_class' this instance 'reports' to */
@@ -223,42 +255,65 @@ static int edac_device_register_main_kob
 	debugf1("%s() set name of kobject to: %s\n", __func__, edac_dev->name);
 	err = kobject_set_name(&edac_dev->kobj, "%s", edac_dev->name);
 	if (err)
-		return err;
+		goto err_out;
+
+	/* Record which module 'owns' this control structure
+	 * and bump the ref count of the module
+	 */
+	edac_dev->owner = THIS_MODULE;
+
+	if (!try_module_get(edac_dev->owner)) {
+		err = -ENODEV;
+		goto err_out;
+	}
+
+	/* register */
 	err = kobject_register(&edac_dev->kobj);
 	if (err) {
 		debugf1("%s()Failed to register '.../edac/%s'\n",
 			__func__, edac_dev->name);
-		return err;
+		goto err_kobj_reg;
 	}
 
+	/* At this point, to 'free' the control struct,
+	 * edac_device_unregister_sysfs_main_kobj() must be used
+	 */
+
 	debugf1("%s() Registered '.../edac/%s' kobject\n",
 		__func__, edac_dev->name);
 
 	return 0;
+
+	/* Error exit stack */
+err_kobj_reg:
+	module_put(edac_dev->owner);
+
+err_out:
+	return err;
 }
 
 /*
- * edac_device_unregister_main_kobj:
+ * edac_device_unregister_sysfs_main_kobj:
  *	the '..../edac/<name>' kobject
  */
-static void edac_device_unregister_main_kobj(struct edac_device_ctl_info
-					*edac_dev)
+void edac_device_unregister_sysfs_main_kobj(
+					struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 	debugf1("%s() name of kobject is: %s\n",
 		__func__, kobject_name(&edac_dev->kobj));
 
-	init_completion(&edac_dev->kobj_complete);
-
 	/*
 	 * Unregister the edac device's kobject and
-	 * wait for reference count to reach 0.
+	 * allow for reference count to reach 0 at which point
+	 * the callback will be called to:
+	 *   a) module_put() this module
+	 *   b) 'kfree' the memory
 	 */
 	kobject_unregister(&edac_dev->kobj);
-	wait_for_completion(&edac_dev->kobj_complete);
 }
 
-/*************** edac_dev -> instance information ***********/
+/* edac_dev -> instance information */
 
 /*
  * Set of low-level instance attribute show functions
@@ -285,8 +340,11 @@ static void edac_device_ctrl_instance_re
 
 	debugf1("%s()\n", __func__);
 
+	/* map from this kobj to the main control struct
+	 * and then dec the main kobj count
+	 */
 	instance = to_instance(kobj);
-	complete(&instance->kobj_complete);
+	kobject_put(&instance->ctl->kobj);
 }
 
 /* instance specific attribute structure */
@@ -356,7 +414,7 @@ static struct kobj_type ktype_instance_c
 	.default_attrs = (struct attribute **)device_instance_attr,
 };
 
-/*************** edac_dev -> instance -> block information *********/
+/* edac_dev -> instance -> block information */
 
 /*
  * Set of low-level block attribute show functions
@@ -381,8 +439,13 @@ static void edac_device_ctrl_block_relea
 
 	debugf1("%s()\n", __func__);
 
+	/* get the container of the kobj */
 	block = to_block(kobj);
-	complete(&block->kobj_complete);
+
+	/* map from 'block kobj' to 'block->instance->controller->main_kobj'
+	 * now 'release' the block kobject
+	 */
+	kobject_put(&block->instance->ctl->kobj);
 }
 
 /* block specific attribute structure */
@@ -447,49 +510,60 @@ static struct kobj_type ktype_block_ctrl
 	.default_attrs = (struct attribute **)device_block_attr,
 };
 
-/************** block ctor/dtor  code ************/
+/* block ctor/dtor  code */
 
 /*
  * edac_device_create_block
  */
 static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 				struct edac_device_instance *instance,
-				int idx)
+				struct edac_device_block *block)
 {
 	int i;
 	int err;
-	struct edac_device_block *block;
 	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
+	struct kobject *main_kobj;
 
-	block = &instance->blocks[idx];
-
-	debugf1("%s() Instance '%s' block[%d] '%s'\n",
-		__func__, instance->name, idx, block->name);
+	debugf1("%s() Instance '%s' block '%s'\n",
+		__func__, instance->name, block->name);
 
 	/* init this block's kobject */
 	memset(&block->kobj, 0, sizeof(struct kobject));
 	block->kobj.parent = &instance->kobj;
 	block->kobj.ktype = &ktype_block_ctrl;
+	block->instance = instance;
 
 	err = kobject_set_name(&block->kobj, "%s", block->name);
 	if (err)
 		return err;
 
+	/* bump the main kobject's reference count for this controller
+	 * and this instance is dependant on the main
+	 */
+	main_kobj = kobject_get(&edac_dev->kobj);
+	if (!main_kobj) {
+		err = -ENODEV;
+		goto err_out;
+	}
+
+	/* Add this block's kobject */
 	err = kobject_register(&block->kobj);
 	if (err) {
-		debugf1("%s()Failed to register instance '%s'\n",
+		debugf1("%s() Failed to register instance '%s'\n",
 			__func__, block->name);
-		return err;
+		kobject_put(main_kobj);
+		err = -ENODEV;
+		goto err_out;
 	}
 
 	/* If there are driver level block attributes, then added them
 	 * to the block kobject
 	 */
 	sysfs_attrib = block->block_attributes;
-	if (sysfs_attrib != NULL) {
+	if (sysfs_attrib) {
 		for (i = 0; i < block->nr_attribs; i++) {
 			err = sysfs_create_file(&block->kobj,
-				(struct attribute *) &sysfs_attrib[i]);
+				(struct attribute *) sysfs_attrib);
 			if (err)
 				goto err_on_attrib;
 
@@ -499,30 +573,41 @@ static int edac_device_create_block(stru
 
 	return 0;
 
+	/* Error unwind stack */
 err_on_attrib:
 	kobject_unregister(&block->kobj);
 
+err_out:
 	return err;
 }
 
 /*
- * edac_device_delete_block(edac_dev,j);
+ * edac_device_delete_block(edac_dev,block);
  */
 static void edac_device_delete_block(struct edac_device_ctl_info *edac_dev,
-				struct edac_device_instance *instance,
-				int idx)
+				struct edac_device_block *block)
 {
-	struct edac_device_block *block;
+	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
+	int i;
 
-	block = &instance->blocks[idx];
+	/* if this block has 'attributes' then we need to iterate over the list
+	 * and 'remove' the attributes on this block
+	 */
+	sysfs_attrib = block->block_attributes;
+	if (sysfs_attrib && block->nr_attribs) {
+		for (i = 0; i < block->nr_attribs; i++) {
+			sysfs_remove_file(&block->kobj,
+				(struct attribute *) sysfs_attrib);
+		}
+	}
 
-	/* unregister this block's kobject */
-	init_completion(&block->kobj_complete);
+	/* unregister this block's kobject, SEE:
+	 *	edac_device_ctrl_block_release() callback operation
+	 */
 	kobject_unregister(&block->kobj);
-	wait_for_completion(&block->kobj_complete);
 }
 
-/************** instance ctor/dtor  code ************/
+/* instance ctor/dtor code */
 
 /*
  * edac_device_create_instance
@@ -534,6 +619,7 @@ static int edac_device_create_instance(s
 	int i, j;
 	int err;
 	struct edac_device_instance *instance;
+	struct kobject *main_kobj;
 
 	instance = &edac_dev->instances[idx];
 
@@ -543,16 +629,28 @@ static int edac_device_create_instance(s
 	/* set this new device under the edac_device main kobject */
 	instance->kobj.parent = &edac_dev->kobj;
 	instance->kobj.ktype = &ktype_instance_ctrl;
+	instance->ctl = edac_dev;
 
 	err = kobject_set_name(&instance->kobj, "%s", instance->name);
 	if (err)
-		return err;
+		goto err_out;
+
+	/* bump the main kobject's reference count for this controller
+	 * and this instance is dependant on the main
+	 */
+	main_kobj = kobject_get(&edac_dev->kobj);
+	if (!main_kobj) {
+		err = -ENODEV;
+		goto err_out;
+	}
 
+	/* Formally register this instance's kobject */
 	err = kobject_register(&instance->kobj);
 	if (err != 0) {
 		debugf2("%s() Failed to register instance '%s'\n",
 			__func__, instance->name);
-		return err;
+		kobject_put(main_kobj);
+		goto err_out;
 	}
 
 	debugf1("%s() now register '%d' blocks for instance %d\n",
@@ -560,11 +658,14 @@ static int edac_device_create_instance(s
 
 	/* register all blocks of this instance */
 	for (i = 0; i < instance->nr_blocks; i++) {
-		err = edac_device_create_block(edac_dev, instance, i);
+		err = edac_device_create_block(edac_dev, instance,
+						&instance->blocks[i]);
 		if (err) {
+			/* If any fail, remove all previous ones */
 			for (j = 0; j < i; j++)
-				edac_device_delete_block(edac_dev, instance, j);
-			return err;
+				edac_device_delete_block(edac_dev,
+							&instance->blocks[j]);
+			goto err_release_instance_kobj;
 		}
 	}
 
@@ -572,6 +673,13 @@ static int edac_device_create_instance(s
 		__func__, idx, instance->name);
 
 	return 0;
+
+	/* error unwind stack */
+err_release_instance_kobj:
+	kobject_unregister(&instance->kobj);
+
+err_out:
+	return err;
 }
 
 /*
@@ -581,19 +689,19 @@ static int edac_device_create_instance(s
 static void edac_device_delete_instance(struct edac_device_ctl_info *edac_dev,
 					int idx)
 {
-	int i;
 	struct edac_device_instance *instance;
+	int i;
 
 	instance = &edac_dev->instances[idx];
 
 	/* unregister all blocks in this instance */
 	for (i = 0; i < instance->nr_blocks; i++)
-		edac_device_delete_block(edac_dev, instance, i);
+		edac_device_delete_block(edac_dev, &instance->blocks[i]);
 
-	/* unregister this instance's kobject */
-	init_completion(&instance->kobj_complete);
+	/* unregister this instance's kobject, SEE:
+	 *	edac_device_ctrl_instance_release() for callback operation
+	 */
 	kobject_unregister(&instance->kobj);
-	wait_for_completion(&instance->kobj_complete);
 }
 
 /*
@@ -635,39 +743,69 @@ static void edac_device_delete_instances
 		edac_device_delete_instance(edac_dev, i);
 }
 
-/******************* edac_dev sysfs ctor/dtor  code *************/
+/* edac_dev sysfs ctor/dtor  code */
 
 /*
- * edac_device_add_sysfs_attributes
+ * edac_device_add_main_sysfs_attributes
  *	add some attributes to this instance's main kobject
  */
-static int edac_device_add_sysfs_attributes(
+static int edac_device_add_main_sysfs_attributes(
 			struct edac_device_ctl_info *edac_dev)
 {
-	int err;
 	struct edac_dev_sysfs_attribute *sysfs_attrib;
+	int err = 0;
 
-	/* point to the start of the array and iterate over it
-	 * adding each attribute listed to this mci instance's kobject
-	 */
 	sysfs_attrib = edac_dev->sysfs_attributes;
-
-	while (sysfs_attrib->attr.name != NULL) {
-		err = sysfs_create_file(&edac_dev->kobj,
+	if (sysfs_attrib) {
+		/* iterate over the array and create an attribute for each
+		 * entry in the list
+		 */
+		while (sysfs_attrib->attr.name != NULL) {
+			err = sysfs_create_file(&edac_dev->kobj,
 				(struct attribute*) sysfs_attrib);
-		if (err)
-			return err;
+			if (err)
+				goto err_out;
 
-		sysfs_attrib++;
+			sysfs_attrib++;
+		}
 	}
 
-	return 0;
+err_out:
+	return err;
+}
+
+/*
+ * edac_device_remove_main_sysfs_attributes
+ *	remove any attributes to this instance's main kobject
+ */
+static void edac_device_remove_main_sysfs_attributes(
+			struct edac_device_ctl_info *edac_dev)
+{
+	struct edac_dev_sysfs_attribute *sysfs_attrib;
+
+	/* if there are main attributes, defined, remove them. First,
+	 * point to the start of the array and iterate over it
+	 * removing each attribute listed from this device's instance's kobject
+	 */
+	sysfs_attrib = edac_dev->sysfs_attributes;
+	if (sysfs_attrib) {
+		while (sysfs_attrib->attr.name != NULL) {
+			sysfs_remove_file(&edac_dev->kobj,
+					(struct attribute *) sysfs_attrib);
+			sysfs_attrib++;
+		}
+	}
 }
 
 /*
  * edac_device_create_sysfs() Constructor
  *
- * Create a new edac_device kobject instance,
+ * accept a created edac_device control structure
+ * and 'export' it to sysfs. The 'main' kobj should already have been
+ * created. 'instance' and 'block' kobjects should be registered
+ * along with any 'block' attributes from the low driver. In addition,
+ * the main attributes (if any) are connected to the main kobject of
+ * the control structure.
  *
  * Return:
  *	0	Success
@@ -678,23 +816,13 @@ int edac_device_create_sysfs(struct edac
 	int err;
 	struct kobject *edac_kobj = &edac_dev->kobj;
 
-	/* register this instance's main kobj with the edac class kobj */
-	err = edac_device_register_main_kobj(edac_dev);
-	if (err)
-		return err;
-
 	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
 
-	/* If the low level driver requests some sysfs entries
-	 * then go create them here
-	 */
-	if (edac_dev->sysfs_attributes != NULL) {
-		err = edac_device_add_sysfs_attributes(edac_dev);
-		if (err) {
-			debugf0("%s() failed to add sysfs attribs\n",
-				__func__);
-			goto err_unreg_object;
-		}
+	/*  go create any main attributes callers wants */
+	err = edac_device_add_main_sysfs_attributes(edac_dev);
+	if (err) {
+		debugf0("%s() failed to add sysfs attribs\n", __func__);
+		goto err_out;
 	}
 
 	/* create a symlink from the edac device
@@ -705,16 +833,23 @@ int edac_device_create_sysfs(struct edac
 	if (err) {
 		debugf0("%s() sysfs_create_link() returned err= %d\n",
 			__func__, err);
-		goto err_unreg_object;
+		goto err_remove_main_attribs;
 	}
 
-	debugf0("%s() calling create-instances, idx=%d\n",
-		__func__, edac_dev->dev_idx);
-
-	/* Create the first level instance directories */
+	/* Create the first level instance directories
+	 * In turn, the nested blocks beneath the instances will
+	 * be registered as well
+	 */
 	err = edac_device_create_instances(edac_dev);
-	if (err)
+	if (err) {
+		debugf0("%s() edac_device_create_instances() "
+			"returned err= %d\n", __func__, err);
 		goto err_remove_link;
+	}
+
+
+	debugf0("%s() calling create-instances, idx=%d\n",
+		__func__, edac_dev->dev_idx);
 
 	return 0;
 
@@ -723,26 +858,28 @@ err_remove_link:
 	/* remove the sym link */
 	sysfs_remove_link(&edac_dev->kobj, EDAC_DEVICE_SYMLINK);
 
-err_unreg_object:
-	edac_device_unregister_main_kobj(edac_dev);
+err_remove_main_attribs:
+	edac_device_remove_main_sysfs_attributes(edac_dev);
 
+err_out:
 	return err;
 }
 
 /*
  * edac_device_remove_sysfs() destructor
  *
- * remove a edac_device instance
+ * given an edac_device struct, tear down the kobject resources
  */
 void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 
-	edac_device_delete_instances(edac_dev);
+	/* remove any main attributes for this device */
+	edac_device_remove_main_sysfs_attributes(edac_dev);
 
-	/* remove the sym link */
+	/* remove the device sym link */
 	sysfs_remove_link(&edac_dev->kobj, EDAC_DEVICE_SYMLINK);
 
-	/* unregister the instance's main kobj */
-	edac_device_unregister_main_kobj(edac_dev);
+	/* walk the instance/block kobject tree, deconstructing it */
+	edac_device_delete_instances(edac_dev);
 }
diff -puN drivers/edac/edac_module.h~drivers-edac-fix-edac_device-sysfs-completion-code drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~drivers-edac-fix-edac_device-sysfs-completion-code
+++ a/drivers/edac/edac_module.h
@@ -37,6 +37,10 @@ extern int edac_mc_get_panic_on_ue(void)
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
+extern int edac_device_register_sysfs_main_kobj(
+				struct edac_device_ctl_info *edac_dev);
+extern void edac_device_unregister_sysfs_main_kobj(
+				struct edac_device_ctl_info *edac_dev);
 extern int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev);
 extern struct sysdev_class *edac_get_edac_class(void);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
