From: akpm@linux-foundation.org
Subject: - driver-edac-edac_device-code-tidying.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:59 -0700
Message-ID: <200707192006.l6JK6xAg020214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759402AbXGSUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: edac_device code tidying
has been removed from the -mm tree.  Its filename was
     driver-edac-edac_device-code-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: edac_device code tidying
From: Douglas Thompson <dougthompson@xmission.com>

For the file edac_device.c perform some coding style enhancements
Add some function header comments
Made for better readability commands

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h         |   11 ---
 drivers/edac/edac_device.c       |  105 ++++++++++++++---------------
 drivers/edac/edac_device_sysfs.c |   22 ++----
 3 files changed, 62 insertions(+), 76 deletions(-)

diff -puN drivers/edac/edac_core.h~driver-edac-edac_device-code-tidying drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~driver-edac-edac_device-code-tidying
+++ a/drivers/edac/edac_core.h
@@ -470,8 +470,6 @@ struct edac_device_counter {
 	u32 ce_count;
 };
 
-#define INC_COUNTER(cnt)	(cnt++)
-
 /*
  * An array of these is passed to the alloc() function
  * to specify attributes of the edac_block
@@ -632,15 +630,6 @@ struct edac_device_ctl_info {
 #define to_edac_device_ctl_work(w) \
 		container_of(w,struct edac_device_ctl_info,work)
 
-/* Function to calc the number of delay jiffies from poll_msec */
-static inline void edac_device_calc_delay(struct edac_device_ctl_info *edac_dev)
-{
-	/* convert from msec to jiffies */
-	edac_dev->delay = edac_dev->poll_msec * HZ / 1000;
-}
-
-#define edac_calc_delay(dev) dev->delay = dev->poll_msec * HZ / 1000;
-
 /*
  * The alloc() and free() functions for the 'edac_device' control info
  * structure. A MC driver will allocate one of these for each edac_device
diff -puN drivers/edac/edac_device.c~driver-edac-edac_device-code-tidying drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~driver-edac-edac_device-code-tidying
+++ a/drivers/edac/edac_device.c
@@ -20,6 +20,7 @@
 #include <linux/highmem.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
@@ -31,20 +32,10 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-/* lock to memory controller's control array */
+/* lock to memory controller's control array 'edac_device_list' */
 static DECLARE_MUTEX(device_ctls_mutex);
 static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
 
-static inline void lock_device_list(void)
-{
-	down(&device_ctls_mutex);
-}
-
-static inline void unlock_device_list(void)
-{
-	up(&device_ctls_mutex);
-}
-
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
@@ -58,20 +49,25 @@ static void edac_device_dump_device(stru
 #endif				/* CONFIG_EDAC_DEBUG */
 
 /*
- * The alloc() and free() functions for the 'edac_device' control info
- * structure. A MC driver will allocate one of these for each edac_device
- * it is going to control/register with the EDAC CORE.
+ * edac_device_alloc_ctl_info()
+ *	Allocate a new edac device control info structure
+ *
+ *	The control structure is allocated in complete chunk
+ *	from the OS. It is in turn sub allocated to the
+ *	various objects that compose the struture
+ *
+ *	The structure has a 'nr_instance' array within itself.
+ *	Each instance represents a major component
+ *		Example:  L1 cache and L2 cache are 2 instance components
+ *
+ *	Within each instance is an array of 'nr_blocks' blockoffsets
  */
 struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	unsigned sz_private,
-	char *edac_device_name,
-	unsigned nr_instances,
-	char *edac_block_name,
-	unsigned nr_blocks,
-	unsigned offset_value,
-	struct edac_attrib_spec
-	*attrib_spec,
-	unsigned nr_attribs)
+	char *edac_device_name, unsigned nr_instances,
+	char *edac_block_name, unsigned nr_blocks,
+	unsigned offset_value,		/* zero, 1, or other based offset */
+	struct edac_attrib_spec *attrib_spec, unsigned nr_attribs)
 {
 	struct edac_device_ctl_info *dev_ctl;
 	struct edac_device_instance *dev_inst, *inst;
@@ -90,7 +86,7 @@ struct edac_device_ctl_info *edac_device
 	 * to be at least as stringent as what the compiler would
 	 * provide if we could simply hardcode everything into a single struct.
 	 */
-	dev_ctl = (struct edac_device_ctl_info *)0;
+	dev_ctl = (struct edac_device_ctl_info *)NULL;
 
 	/* Calc the 'end' offset past the ctl_info structure */
 	dev_inst = (struct edac_device_instance *)
@@ -114,7 +110,8 @@ struct edac_device_ctl_info *edac_device
 	total_size = ((unsigned long)pvt) + sz_private;
 
 	/* Allocate the amount of memory for the set of control structures */
-	if ((dev_ctl = kmalloc(total_size, GFP_KERNEL)) == NULL)
+	dev_ctl = kzalloc(total_size, GFP_KERNEL);
+	if (dev_ctl == NULL)
 		return NULL;
 
 	/* Adjust pointers so they point within the memory we just allocated
@@ -128,14 +125,12 @@ struct edac_device_ctl_info *edac_device
 		(((char *)dev_ctl) + ((unsigned long)dev_attrib));
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
-	memset(dev_ctl, 0, total_size);	/* clear all fields */
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
 
-	/* Name of this edac device, ensure null terminated */
-	snprintf(dev_ctl->name, sizeof(dev_ctl->name), "%s", edac_device_name);
-	dev_ctl->name[sizeof(dev_ctl->name) - 1] = '\0';
+	/* Name of this edac device */
+	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
 	/* Initialize every Instance */
 	for (instance = 0; instance < nr_instances; instance++) {
@@ -148,7 +143,6 @@ struct edac_device_ctl_info *edac_device
 		/* name of this instance */
 		snprintf(inst->name, sizeof(inst->name),
 			 "%s%u", edac_device_name, instance);
-		inst->name[sizeof(inst->name) - 1] = '\0';
 
 		/* Initialize every block in each instance */
 		for (block = 0; block < nr_blocks; block++) {
@@ -159,7 +153,6 @@ struct edac_device_ctl_info *edac_device
 			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
 				 "%s%d", edac_block_name, block+offset_value);
-			blk->name[sizeof(blk->name) - 1] = '\0';
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
 				__func__, instance, block, blk->name);
@@ -186,7 +179,6 @@ struct edac_device_ctl_info *edac_device
 
 	return dev_ctl;
 }
-
 EXPORT_SYMBOL_GPL(edac_device_alloc_ctl_info);
 
 /*
@@ -198,12 +190,17 @@ void edac_device_free_ctl_info(struct ed
 {
 	kfree(ctl_info);
 }
-
 EXPORT_SYMBOL_GPL(edac_device_free_ctl_info);
 
 /*
  * find_edac_device_by_dev
  *	scans the edac_device list for a specific 'struct device *'
+ *
+ *	lock to be held prior to call:	device_ctls_mutex
+ *
+ *	Return:
+ *		pointer to control structure managing 'dev'
+ *		NULL if not found on list
  */
 static struct edac_device_ctl_info *find_edac_device_by_dev(struct device *dev)
 {
@@ -226,6 +223,9 @@ static struct edac_device_ctl_info *find
  * add_edac_dev_to_global_list
  *	Before calling this function, caller must
  *	assign a unique value to edac_dev->dev_idx.
+ *
+ *	lock to be held prior to call:	device_ctls_mutex
+ *
  *	Return:
  *		0 on success
  *		1 on failure.
@@ -238,7 +238,8 @@ static int add_edac_dev_to_global_list(s
 	insert_before = &edac_device_list;
 
 	/* Determine if already on the list */
-	if (unlikely((rover = find_edac_device_by_dev(edac_dev->dev)) != NULL))
+	rover = find_edac_device_by_dev(edac_dev->dev);
+	if (unlikely(rover != NULL))
 		goto fail0;
 
 	/* Insert in ascending order by 'dev_idx', so find position */
@@ -274,6 +275,8 @@ fail1:
 
 /*
  * complete_edac_device_list_del
+ *
+ *	callback function when reference count is zero
  */
 static void complete_edac_device_list_del(struct rcu_head *head)
 {
@@ -286,6 +289,9 @@ static void complete_edac_device_list_de
 
 /*
  * del_edac_device_from_global_list
+ *
+ *	remove the RCU, setup for a callback call, then wait for the
+ *	callback to occur
  */
 static void del_edac_device_from_global_list(struct edac_device_ctl_info
 						*edac_device)
@@ -325,8 +331,7 @@ struct edac_device_ctl_info *edac_device
 
 	return NULL;
 }
-
-EXPORT_SYMBOL(edac_device_find);
+EXPORT_SYMBOL_GPL(edac_device_find);
 
 /*
  * edac_device_workq_function
@@ -338,7 +343,7 @@ static void edac_device_workq_function(s
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
 	//debugf0("%s() here and running\n", __func__);
-	lock_device_list();
+	down(&device_ctls_mutex);
 
 	/* Only poll controllers that are running polled and have a check */
 	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
@@ -346,7 +351,7 @@ static void edac_device_workq_function(s
 			edac_dev->edac_check(edac_dev);
 	}
 
-	unlock_device_list();
+	up(&device_ctls_mutex);
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
@@ -363,7 +368,7 @@ void edac_device_workq_setup(struct edac
 	debugf0("%s()\n", __func__);
 
 	edac_dev->poll_msec = msec;
-	edac_calc_delay(edac_dev);	/* Calc delay jiffies */
+	edac_dev->delay = msecs_to_jiffies(msec);	/* Calc delay jiffies */
 
 	INIT_DELAYED_WORK(&edac_dev->work, edac_device_workq_function);
 	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
@@ -391,7 +396,7 @@ void edac_device_workq_teardown(struct e
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
 					unsigned long value)
 {
-	lock_device_list();
+	down(&device_ctls_mutex);
 
 	/* cancel the current workq request */
 	edac_device_workq_teardown(edac_dev);
@@ -399,7 +404,7 @@ void edac_device_reset_delay_period(stru
 	/* restart the workq request, with new delay value */
 	edac_device_workq_setup(edac_dev, value);
 
-	unlock_device_list();
+	up(&device_ctls_mutex);
 }
 
 /**
@@ -423,7 +428,7 @@ int edac_device_add_device(struct edac_d
 	if (edac_debug_level >= 3)
 		edac_device_dump_device(edac_dev);
 #endif
-	lock_device_list();
+	down(&device_ctls_mutex);
 
 	if (add_edac_dev_to_global_list(edac_dev))
 		goto fail0;
@@ -461,7 +466,7 @@ int edac_device_add_device(struct edac_d
 				dev_name(edac_dev),
 				edac_op_state_toString(edac_dev->op_state));
 
-	unlock_device_list();
+	up(&device_ctls_mutex);
 	return 0;
 
 fail1:
@@ -469,10 +474,9 @@ fail1:
 	del_edac_device_from_global_list(edac_dev);
 
 fail0:
-	unlock_device_list();
+	up(&device_ctls_mutex);
 	return 1;
 }
-
 EXPORT_SYMBOL_GPL(edac_device_add_device);
 
 /**
@@ -494,10 +498,12 @@ struct edac_device_ctl_info *edac_device
 
 	debugf0("MC: %s()\n", __func__);
 
-	lock_device_list();
+	down(&device_ctls_mutex);
 
-	if ((edac_dev = find_edac_device_by_dev(dev)) == NULL) {
-		unlock_device_list();
+	/* Find the structure on the list, if not there, then leave */
+	edac_dev = find_edac_device_by_dev(dev);
+	if (edac_dev == NULL) {
+		up(&device_ctls_mutex);
 		return NULL;
 	}
 
@@ -513,7 +519,7 @@ struct edac_device_ctl_info *edac_device
 	/* deregister from global list */
 	del_edac_device_from_global_list(edac_dev);
 
-	unlock_device_list();
+	up(&device_ctls_mutex);
 
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n",
@@ -522,7 +528,6 @@ struct edac_device_ctl_info *edac_device
 
 	return edac_dev;
 }
-
 EXPORT_SYMBOL_GPL(edac_device_del_device);
 
 static inline int edac_device_get_log_ce(struct edac_device_ctl_info *edac_dev)
@@ -585,7 +590,6 @@ void edac_device_handle_ce(struct edac_d
 				edac_dev->ctl_name, instance->name,
 				block ? block->name : "N/A", msg);
 }
-
 EXPORT_SYMBOL_GPL(edac_device_handle_ce);
 
 /*
@@ -637,5 +641,4 @@ void edac_device_handle_ue(struct edac_d
 			edac_dev->ctl_name, instance->name,
 			block ? block->name : "N/A", msg);
 }
-
 EXPORT_SYMBOL_GPL(edac_device_handle_ue);
diff -puN drivers/edac/edac_device_sysfs.c~driver-edac-edac_device-code-tidying drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~driver-edac-edac_device-code-tidying
+++ a/drivers/edac/edac_device_sysfs.c
@@ -292,8 +292,8 @@ static void edac_device_ctrl_instance_re
 /* instance specific attribute structure */
 struct instance_attribute {
 	struct attribute attr;
-	 ssize_t(*show) (struct edac_device_instance *, char *);
-	 ssize_t(*store) (struct edac_device_instance *, const char *, size_t);
+	ssize_t(*show) (struct edac_device_instance *, char *);
+	ssize_t(*store) (struct edac_device_instance *, const char *, size_t);
 };
 
 /* Function to 'show' fields from the edac_dev 'instance' structure */
@@ -540,9 +540,8 @@ static int edac_device_create_instance(s
 	for (i = 0; i < instance->nr_blocks; i++) {
 		err = edac_device_create_block(edac_dev, instance, i);
 		if (err) {
-			for (j = 0; j < i; j++) {
+			for (j = 0; j < i; j++)
 				edac_device_delete_block(edac_dev, instance, j);
-			}
 			return err;
 		}
 	}
@@ -566,9 +565,8 @@ static void edac_device_delete_instance(
 	instance = &edac_dev->instances[idx];
 
 	/* unregister all blocks in this instance */
-	for (i = 0; i < instance->nr_blocks; i++) {
+	for (i = 0; i < instance->nr_blocks; i++)
 		edac_device_delete_block(edac_dev, instance, i);
-	}
 
 	/* unregister this instance's kobject */
 	init_completion(&instance->kobj_complete);
@@ -593,9 +591,8 @@ static int edac_device_create_instances(
 		err = edac_device_create_instance(edac_dev, i);
 		if (err) {
 			/* unwind previous instances on error */
-			for (j = 0; j < i; j++) {
+			for (j = 0; j < i; j++)
 				edac_device_delete_instance(edac_dev, j);
-			}
 			return err;
 		}
 	}
@@ -612,9 +609,8 @@ static void edac_device_delete_instances
 	int i;
 
 	/* iterate over creation of the instances */
-	for (i = 0; i < edac_dev->nr_instances; i++) {
+	for (i = 0; i < edac_dev->nr_instances; i++)
 		edac_device_delete_instance(edac_dev, i);
-	}
 }
 
 /******************* edac_dev sysfs ctor/dtor  code *************/
@@ -637,9 +633,8 @@ static int edac_device_add_sysfs_attribu
 	while (sysfs_attrib->attr.name != NULL) {
 		err = sysfs_create_file(&edac_dev->kobj,
 				(struct attribute*) sysfs_attrib);
-		if (err) {
+		if (err)
 			return err;
-		}
 
 		sysfs_attrib++;
 	}
@@ -696,9 +691,8 @@ int edac_device_create_sysfs(struct edac
 
 	/* Create the first level instance directories */
 	err = edac_device_create_instances(edac_dev);
-	if (err) {
+	if (err)
 		goto err_remove_link;
-	}
 
 	return 0;
 
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
