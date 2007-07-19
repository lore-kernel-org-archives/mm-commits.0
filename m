From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_device-sysfs-corner-case-bug.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:35 -0700
Message-ID: <200707192007.l6JK7Z5t020275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760970AbXGSUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_device sysfs corner case bug
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_device-sysfs-corner-case-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_device sysfs corner case bug
From: Doug Thompson <dougthompson@xmission.com>

Some simple fixes to properly reference counter values from the block
attribute level of edac_device objects.  Properly sequencing the array pointer
was added, resulting in correct identification of block level attributes from
their base class functions.

Added more verbose debug statement for event tracking.

Also during some corner testing, found a bug in the store/show sequence
of operations for the block attribute/controls management.

An old intermediate structure for 'blocks' was still in the processing
pipeline.  This patch removes that old structure and correctly utilizes the
new struct edac_dev_sysfs_block_attribute for passing control from the sysfs
to the low level store/show function of the edac driver.

Now the proper kobj pointer to passed downward to the store/show
functions.

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h         |   11 +++
 drivers/edac/edac_device.c       |   44 ++++++++++-----
 drivers/edac/edac_device_sysfs.c |   81 ++++++++++++++++-------------
 3 files changed, 85 insertions(+), 51 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_device-sysfs-corner-case-bug drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_device-sysfs-corner-case-bug
+++ a/drivers/edac/edac_core.h
@@ -485,7 +485,16 @@ struct edac_dev_sysfs_attribute {
 };
 
 /* edac_dev_sysfs_block_attribute structure
+ *
  *	used in leaf 'block' nodes for adding controls/attributes
+ *
+ *	each block in each instance of the containing control structure
+ *	can have an array of the following. The show and store functions
+ *	will be filled in with the show/store function in the
+ *	low level driver.
+ *
+ *	The 'value' field will be the actual value field used for
+ *	counting
  */
 struct edac_dev_sysfs_block_attribute {
 	struct attribute attr;
@@ -494,8 +503,6 @@ struct edac_dev_sysfs_block_attribute {
 			const char *, size_t);
 	struct edac_device_block *block;
 
-	/* low driver use */
-	void *arg;
 	unsigned int value;
 };
 
diff -puN drivers/edac/edac_device.c~drivers-edac-fix-edac_device-sysfs-corner-case-bug drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-edac_device-sysfs-corner-case-bug
+++ a/drivers/edac/edac_device.c
@@ -83,7 +83,7 @@ struct edac_device_ctl_info *edac_device
 	void *pvt;
 	int err;
 
-	debugf1("%s() instances=%d blocks=%d\n",
+	debugf4("%s() instances=%d blocks=%d\n",
 		__func__, nr_instances, nr_blocks);
 
 	/* Calculate the size of memory we need to allocate AND
@@ -158,6 +158,9 @@ struct edac_device_ctl_info *edac_device
 	/* Name of this edac device */
 	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
+	debugf4("%s() edac_dev=%p next after end=%p\n",
+		__func__, dev_ctl, pvt + sz_private );
+
 	/* Initialize every Instance */
 	for (instance = 0; instance < nr_instances; instance++) {
 		inst = &dev_inst[instance];
@@ -177,8 +180,10 @@ struct edac_device_ctl_info *edac_device
 			snprintf(blk->name, sizeof(blk->name),
 				 "%s%d", edac_block_name, block+offset_value);
 
-			debugf1("%s() instance=%d block=%d name=%s\n",
-				__func__, instance, block, blk->name);
+			debugf4("%s() instance=%d inst_p=%p block=#%d "
+				"block_p=%p name='%s'\n",
+				__func__, instance, inst, block,
+				blk, blk->name);
 
 			/* if there are NO attributes OR no attribute pointer
 			 * then continue on to next block iteration
@@ -191,20 +196,32 @@ struct edac_device_ctl_info *edac_device
 			attrib_p = &dev_attrib[block*nr_instances*nr_attrib];
 			blk->block_attributes = attrib_p;
 
+			debugf4("%s() THIS BLOCK_ATTRIB=%p\n",
+				__func__, blk->block_attributes);
+
 			/* Initialize every user specified attribute in this
 			 * block with the data the caller passed in
+			 * Each block gets its own copy of pointers,
+			 * and its unique 'value'
 			 */
 			for (attr = 0; attr < nr_attrib; attr++) {
 				attrib = &attrib_p[attr];
-				attrib->attr = attrib_spec->attr;
-				attrib->show = attrib_spec->show;
-				attrib->store = attrib_spec->store;
-
-				/* up reference this block */
-				attrib->block = blk;
 
-				/* bump the attrib_spec */
-				attrib_spec++;
+				/* populate the unique per attrib
+				 * with the code pointers and info
+				 */
+				attrib->attr = attrib_spec[attr].attr;
+				attrib->show = attrib_spec[attr].show;
+				attrib->store = attrib_spec[attr].store;
+
+				attrib->block = blk;	/* up link */
+
+				debugf4("%s() alloc-attrib=%p attrib_name='%s' "
+					"attrib-spec=%p spec-name=%s\n",
+					__func__, attrib, attrib->attr.name,
+					&attrib_spec[attr],
+					attrib_spec[attr].attr.name
+					);
 			}
 		}
 	}
@@ -258,7 +275,7 @@ static struct edac_device_ctl_info *find
 	struct edac_device_ctl_info *edac_dev;
 	struct list_head *item;
 
-	debugf3("%s()\n", __func__);
+	debugf0("%s()\n", __func__);
 
 	list_for_each(item, &edac_device_list) {
 		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
@@ -402,7 +419,6 @@ static void edac_device_workq_function(s
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_device_ctl_info *edac_dev = to_edac_device_ctl_work(d_work);
 
-	//debugf0("%s() here and running\n", __func__);
 	mutex_lock(&device_ctls_mutex);
 
 	/* Only poll controllers that are running polled and have a check */
@@ -582,7 +598,7 @@ struct edac_device_ctl_info *edac_device
 {
 	struct edac_device_ctl_info *edac_dev;
 
-	debugf0("MC: %s()\n", __func__);
+	debugf0("%s()\n", __func__);
 
 	mutex_lock(&device_ctls_mutex);
 
diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-fix-edac_device-sysfs-corner-case-bug drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-fix-edac_device-sysfs-corner-case-bug
+++ a/drivers/edac/edac_device_sysfs.c
@@ -200,7 +200,7 @@ static void edac_device_ctrl_master_rele
 {
 	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
 
-	debugf1("%s() control index=%d\n", __func__, edac_dev->dev_idx);
+	debugf4("%s() control index=%d\n", __func__, edac_dev->dev_idx);
 
 	/* decrement the EDAC CORE module ref count */
 	module_put(edac_dev->owner);
@@ -252,7 +252,7 @@ int edac_device_register_sysfs_main_kobj
 	edac_dev->kobj.parent = &edac_class->kset.kobj;
 
 	/* generate sysfs "..../edac/<name>"   */
-	debugf1("%s() set name of kobject to: %s\n", __func__, edac_dev->name);
+	debugf4("%s() set name of kobject to: %s\n", __func__, edac_dev->name);
 	err = kobject_set_name(&edac_dev->kobj, "%s", edac_dev->name);
 	if (err)
 		goto err_out;
@@ -279,7 +279,7 @@ int edac_device_register_sysfs_main_kobj
 	 * edac_device_unregister_sysfs_main_kobj() must be used
 	 */
 
-	debugf1("%s() Registered '.../edac/%s' kobject\n",
+	debugf4("%s() Registered '.../edac/%s' kobject\n",
 		__func__, edac_dev->name);
 
 	return 0;
@@ -300,7 +300,7 @@ void edac_device_unregister_sysfs_main_k
 					struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
-	debugf1("%s() name of kobject is: %s\n",
+	debugf4("%s() name of kobject is: %s\n",
 		__func__, kobject_name(&edac_dev->kobj));
 
 	/*
@@ -416,22 +416,29 @@ static struct kobj_type ktype_instance_c
 
 /* edac_dev -> instance -> block information */
 
+#define to_block(k) container_of(k, struct edac_device_block, kobj)
+#define to_block_attr(a) \
+	container_of(a, struct edac_dev_sysfs_block_attribute, attr)
+
 /*
  * Set of low-level block attribute show functions
  */
-static ssize_t block_ue_count_show(struct edac_device_block *block, char *data)
+static ssize_t block_ue_count_show(struct kobject *kobj,
+					struct attribute *attr, char *data)
 {
+	struct edac_device_block *block = to_block(kobj);
+
 	return sprintf(data, "%u\n", block->counters.ue_count);
 }
 
-static ssize_t block_ce_count_show(struct edac_device_block *block, char *data)
+static ssize_t block_ce_count_show(struct kobject *kobj,
+					struct attribute *attr, char *data)
 {
+	struct edac_device_block *block = to_block(kobj);
+
 	return sprintf(data, "%u\n", block->counters.ce_count);
 }
 
-#define to_block(k) container_of(k, struct edac_device_block, kobj)
-#define to_block_attr(a) container_of(a,struct block_attribute,attr)
-
 /* DEVICE block kobject release() function */
 static void edac_device_ctrl_block_release(struct kobject *kobj)
 {
@@ -448,22 +455,16 @@ static void edac_device_ctrl_block_relea
 	kobject_put(&block->instance->ctl->kobj);
 }
 
-/* block specific attribute structure */
-struct block_attribute {
-	struct attribute attr;
-	 ssize_t(*show) (struct edac_device_block *, char *);
-	 ssize_t(*store) (struct edac_device_block *, const char *, size_t);
-};
 
 /* Function to 'show' fields from the edac_dev 'block' structure */
 static ssize_t edac_dev_block_show(struct kobject *kobj,
 				struct attribute *attr, char *buffer)
 {
-	struct edac_device_block *block = to_block(kobj);
-	struct block_attribute *block_attr = to_block_attr(attr);
+	struct edac_dev_sysfs_block_attribute *block_attr =
+						to_block_attr(attr);
 
 	if (block_attr->show)
-		return block_attr->show(block, buffer);
+		return block_attr->show(kobj, attr, buffer);
 	return -EIO;
 }
 
@@ -472,11 +473,12 @@ static ssize_t edac_dev_block_store(stru
 				struct attribute *attr,
 				const char *buffer, size_t count)
 {
-	struct edac_device_block *block = to_block(kobj);
-	struct block_attribute *block_attr = to_block_attr(attr);
+	struct edac_dev_sysfs_block_attribute *block_attr;
+
+	block_attr = to_block_attr(attr);
 
 	if (block_attr->store)
-		return block_attr->store(block, buffer, count);
+		return block_attr->store(kobj, attr, buffer, count);
 	return -EIO;
 }
 
@@ -487,7 +489,7 @@ static struct sysfs_ops device_block_ops
 };
 
 #define BLOCK_ATTR(_name,_mode,_show,_store)        \
-static struct block_attribute attr_block_##_name = {                       \
+static struct edac_dev_sysfs_block_attribute attr_block_##_name = {	\
 	.attr = {.name = __stringify(_name), .mode = _mode },   \
 	.show   = _show,                                        \
 	.store  = _store,                                       \
@@ -497,7 +499,7 @@ BLOCK_ATTR(ce_count, S_IRUGO, block_ce_c
 BLOCK_ATTR(ue_count, S_IRUGO, block_ue_count_show, NULL);
 
 /* list of edac_dev 'block' attributes */
-static struct block_attribute *device_block_attr[] = {
+static struct edac_dev_sysfs_block_attribute *device_block_attr[] = {
 	&attr_block_ce_count,
 	&attr_block_ue_count,
 	NULL,
@@ -524,14 +526,15 @@ static int edac_device_create_block(stru
 	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
 	struct kobject *main_kobj;
 
-	debugf1("%s() Instance '%s' block '%s'\n",
-		__func__, instance->name, block->name);
+	debugf4("%s() Instance '%s' inst_p=%p  block '%s'  block_p=%p\n",
+		__func__, instance->name, instance, block->name, block);
+	debugf4("%s() block kobj=%p  block kobj->parent=%p\n",
+		__func__, &block->kobj, &block->kobj.parent);
 
 	/* init this block's kobject */
 	memset(&block->kobj, 0, sizeof(struct kobject));
 	block->kobj.parent = &instance->kobj;
 	block->kobj.ktype = &ktype_block_ctrl;
-	block->instance = instance;
 
 	err = kobject_set_name(&block->kobj, "%s", block->name);
 	if (err)
@@ -560,14 +563,20 @@ static int edac_device_create_block(stru
 	 * to the block kobject
 	 */
 	sysfs_attrib = block->block_attributes;
-	if (sysfs_attrib) {
-		for (i = 0; i < block->nr_attribs; i++) {
+	if (sysfs_attrib && block->nr_attribs) {
+		for (i = 0; i < block->nr_attribs; i++, sysfs_attrib++) {
+
+			debugf4("%s() creating block attrib='%s' "
+				"attrib->%p to kobj=%p\n",
+				__func__,
+				sysfs_attrib->attr.name,
+				sysfs_attrib, &block->kobj);
+
+			/* Create each block_attribute file */
 			err = sysfs_create_file(&block->kobj,
-				(struct attribute *) sysfs_attrib);
+				&sysfs_attrib->attr);
 			if (err)
 				goto err_on_attrib;
-
-			sysfs_attrib++;
 		}
 	}
 
@@ -595,7 +604,9 @@ static void edac_device_delete_block(str
 	 */
 	sysfs_attrib = block->block_attributes;
 	if (sysfs_attrib && block->nr_attribs) {
-		for (i = 0; i < block->nr_attribs; i++) {
+		for (i = 0; i < block->nr_attribs; i++, sysfs_attrib++) {
+
+			/* remove each block_attrib file */
 			sysfs_remove_file(&block->kobj,
 				(struct attribute *) sysfs_attrib);
 		}
@@ -653,7 +664,7 @@ static int edac_device_create_instance(s
 		goto err_out;
 	}
 
-	debugf1("%s() now register '%d' blocks for instance %d\n",
+	debugf4("%s() now register '%d' blocks for instance %d\n",
 		__func__, instance->nr_blocks, idx);
 
 	/* register all blocks of this instance */
@@ -669,7 +680,7 @@ static int edac_device_create_instance(s
 		}
 	}
 
-	debugf1("%s() Registered instance %d '%s' kobject\n",
+	debugf4("%s() Registered instance %d '%s' kobject\n",
 		__func__, idx, instance->name);
 
 	return 0;
@@ -848,7 +859,7 @@ int edac_device_create_sysfs(struct edac
 	}
 
 
-	debugf0("%s() calling create-instances, idx=%d\n",
+	debugf4("%s() create-instances done, idx=%d\n",
 		__func__, edac_dev->dev_idx);
 
 	return 0;
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
