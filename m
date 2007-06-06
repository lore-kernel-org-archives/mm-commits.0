From: akpm@linux-foundation.org
Subject: + revert-gregkh-driver-block-device.patch added to -mm tree
Date: Wed, 06 Jun 2007 13:15:57 -0700
Message-ID: <200706062015.l56KFvqn005380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbXFFUQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 16:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     revert gregkh-driver-block-device
has been added to the -mm tree.  Its filename is
     revert-gregkh-driver-block-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-driver-block-device
From: Andrew Morton <akpm@linux-foundation.org>

Revert this so people can test stuff.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c              |  430 ++++++++++++++++++++---------------
 block/ll_rw_blk.c          |    4 
 drivers/base/core.c        |   17 -
 drivers/block/aoe/aoeblk.c |   51 ++--
 drivers/block/nbd.c        |   15 -
 drivers/ide/ide-probe.c    |    2 
 drivers/md/dm.c            |    2 
 drivers/md/md.c            |    8 
 fs/block_dev.c             |    8 
 fs/partitions/check.c      |  308 +++++++++++++++----------
 include/linux/genhd.h      |   25 +-
 init/do_mounts.c           |  108 ++++++++
 12 files changed, 605 insertions(+), 373 deletions(-)

diff -puN block/genhd.c~revert-gregkh-driver-block-device block/genhd.c
--- a/block/genhd.c~revert-gregkh-driver-block-device
+++ a/block/genhd.c
@@ -17,12 +17,8 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 
-extern struct class block_class;
-extern struct device_type disk_type;
-extern struct device_type part_type;
-
-static DEFINE_MUTEX(block_class_lock);
-struct kobject block_depr;
+struct kset block_subsys;
+static DEFINE_MUTEX(block_subsys_lock);
 
 /*
  * Can be deleted altogether. Later.
@@ -41,17 +37,19 @@ static inline int major_to_index(int maj
 }
 
 #ifdef CONFIG_PROC_FS
+
 void blkdev_show(struct seq_file *f, off_t offset)
 {
 	struct blk_major_name *dp;
 
 	if (offset < BLKDEV_MAJOR_HASH_SIZE) {
-		mutex_lock(&block_class_lock);
+		mutex_lock(&block_subsys_lock);
 		for (dp = major_names[offset]; dp; dp = dp->next)
 			seq_printf(f, "%3d %s\n", dp->major, dp->name);
-		mutex_unlock(&block_class_lock);
+		mutex_unlock(&block_subsys_lock);
 	}
 }
+
 #endif /* CONFIG_PROC_FS */
 
 int register_blkdev(unsigned int major, const char *name)
@@ -59,7 +57,7 @@ int register_blkdev(unsigned int major, 
 	struct blk_major_name **n, *p;
 	int index, ret = 0;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&block_subsys_lock);
 
 	/* temporary */
 	if (major == 0) {
@@ -104,7 +102,7 @@ int register_blkdev(unsigned int major, 
 		kfree(p);
 	}
 out:
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&block_subsys_lock);
 	return ret;
 }
 
@@ -118,7 +116,7 @@ int unregister_blkdev(unsigned int major
 	int index = major_to_index(major);
 	int ret = 0;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&block_subsys_lock);
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
@@ -128,7 +126,7 @@ int unregister_blkdev(unsigned int major
 		p = *n;
 		*n = p->next;
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&block_subsys_lock);
 	kfree(p);
 
 	return ret;
@@ -143,30 +141,29 @@ static struct kobj_map *bdev_map;
  * range must be nonzero
  * The hash chain is sorted on range, so that subranges can override.
  */
-void blk_register_region(dev_t devt, unsigned long range, struct module *module,
+void blk_register_region(dev_t dev, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
+	kobj_map(bdev_map, dev, range, module, probe, lock, data);
 }
 
 EXPORT_SYMBOL(blk_register_region);
 
-void blk_unregister_region(dev_t devt, unsigned long range)
+void blk_unregister_region(dev_t dev, unsigned long range)
 {
-	kobj_unmap(bdev_map, devt, range);
+	kobj_unmap(bdev_map, dev, range);
 }
 
 EXPORT_SYMBOL(blk_unregister_region);
 
-static struct kobject *exact_match(dev_t devt, int *part, void *data)
+static struct kobject *exact_match(dev_t dev, int *part, void *data)
 {
 	struct gendisk *p = data;
-
-	return &p->dev.kobj;
+	return &p->kobj;
 }
 
-static int exact_lock(dev_t devt, void *data)
+static int exact_lock(dev_t dev, void *data)
 {
 	struct gendisk *p = data;
 
@@ -201,6 +198,8 @@ void unlink_gendisk(struct gendisk *disk
 			      disk->minors);
 }
 
+#define to_disk(obj) container_of(obj,struct gendisk,kobj)
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @dev: device to get partitioning information for
@@ -208,12 +207,10 @@ void unlink_gendisk(struct gendisk *disk
  * This function gets the structure containing partitioning
  * information for the given device @dev.
  */
-struct gendisk *get_gendisk(dev_t devt, int *part)
+struct gendisk *get_gendisk(dev_t dev, int *part)
 {
-	struct kobject *kobj = kobj_lookup(bdev_map, devt, part);
-	struct device *dev = kobj_to_dev(kobj);
-
-	return  kobj ? dev_to_disk(dev) : NULL;
+	struct kobject *kobj = kobj_lookup(bdev_map, dev, part);
+	return  kobj ? to_disk(kobj) : NULL;
 }
 
 /*
@@ -223,18 +220,13 @@ struct gendisk *get_gendisk(dev_t devt, 
  */
 void __init printk_all_partitions(void)
 {
-	struct device *dev;
-	struct gendisk *sgp;
-	char buf[BDEVNAME_SIZE];
 	int n;
+	struct gendisk *sgp;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&block_subsys_lock);
 	/* For each block device... */
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		sgp = dev_to_disk(dev);
-
+	list_for_each_entry(sgp, &block_subsys.list, kobj.entry) {
+		char buf[BDEVNAME_SIZE];
 		/*
 		 * Don't show empty devices or things that have been surpressed
 		 */
@@ -269,44 +261,36 @@ void __init printk_all_partitions(void)
 				disk_name(sgp, n + 1, buf));
 		} /* partition subloop */
 	} /* Block device loop */
-	mutex_unlock(&block_class_lock);
+
+	mutex_unlock(&block_subsys_lock);
+	return;
 }
 
 #ifdef CONFIG_PROC_FS
 /* iterator */
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
-	loff_t k = *pos;
-	struct device *dev;
+	struct list_head *p;
+	loff_t l = *pos;
 
-	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
-		if (!k--)
-			return dev_to_disk(dev);
-	}
+	mutex_lock(&block_subsys_lock);
+	list_for_each(p, &block_subsys.list)
+		if (!l--)
+			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
 }
 
 static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct gendisk *gp = v;
-	struct device *dev;
-
+	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
-	return NULL;
+	return p==&block_subsys.list ? NULL :
+		list_entry(p, struct gendisk, kobj.entry);
 }
 
 static void part_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&block_subsys_lock);
 }
 
 static int show_partition(struct seq_file *part, void *v)
@@ -315,7 +299,7 @@ static int show_partition(struct seq_fil
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->dev.node == block_class.devices.next)
+	if (&sgp->kobj.entry == block_subsys.list.next)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
@@ -355,71 +339,100 @@ struct seq_operations partitions_op = {
 
 extern int blk_dev_init(void);
 
-static struct kobject *base_probe(dev_t devt, int *part, void *data)
+static struct kobject *base_probe(dev_t dev, int *part, void *data)
 {
-	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
+	if (request_module("block-major-%d-%d", MAJOR(dev), MINOR(dev)) > 0)
 		/* Make old-style 2.4 aliases work */
-		request_module("block-major-%d", MAJOR(devt));
+		request_module("block-major-%d", MAJOR(dev));
 	return NULL;
 }
 
 static int __init genhd_device_init(void)
 {
-	class_register(&block_class);
-	bdev_map = kobj_map_init(base_probe, &block_class_lock);
-	blk_dev_init();
+	int err;
 
-	/* create top-level block dir */
-	kobject_init(&block_depr);
-	kobject_set_name(&block_depr, "block");
-	kobject_add(&block_depr);
-	return 0;
+	bdev_map = kobj_map_init(base_probe, &block_subsys_lock);
+	blk_dev_init();
+	err = subsystem_register(&block_subsys);
+	if (err < 0)
+		printk(KERN_WARNING "%s: subsystem_register error: %d\n",
+			__FUNCTION__, err);
+	return err;
 }
 
 subsys_initcall(genhd_device_init);
 
-static ssize_t disk_range_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->minors);
-}
 
-static ssize_t disk_removable_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+/*
+ * kobject & sysfs bindings for block devices
+ */
+static ssize_t disk_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
+	struct gendisk *disk = to_disk(kobj);
+	struct disk_attribute *disk_attr =
+		container_of(attr,struct disk_attribute,attr);
+	ssize_t ret = -EIO;
 
-	return sprintf(buf, "%d\n",
-		       (disk->flags & GENHD_FL_REMOVABLE ? 1 : 0));
+	if (disk_attr->show)
+		ret = disk_attr->show(disk,page);
+	return ret;
 }
 
-static ssize_t disk_size_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t disk_attr_store(struct kobject * kobj, struct attribute * attr,
+			       const char *page, size_t count)
 {
-	struct gendisk *disk = dev_to_disk(dev);
+	struct gendisk *disk = to_disk(kobj);
+	struct disk_attribute *disk_attr =
+		container_of(attr,struct disk_attribute,attr);
+	ssize_t ret = 0;
 
-	return sprintf(buf, "%llu\n", (unsigned long long)get_capacity(disk));
+	if (disk_attr->store)
+		ret = disk_attr->store(disk, page, count);
+	return ret;
 }
 
-static ssize_t disk_capability_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
+static struct sysfs_ops disk_sysfs_ops = {
+	.show	= &disk_attr_show,
+	.store	= &disk_attr_store,
+};
 
-	return sprintf(buf, "%x\n", disk->flags);
+static ssize_t disk_uevent_store(struct gendisk * disk,
+				 const char *buf, size_t count)
+{
+	kobject_uevent(&disk->kobj, KOBJ_ADD);
+	return count;
 }
-
-static ssize_t disk_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t disk_dev_read(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
+	dev_t base = MKDEV(disk->major, disk->first_minor); 
+	return print_dev_t(page, base);
+}
+static ssize_t disk_range_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%d\n", disk->minors);
+}
+static ssize_t disk_removable_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%d\n",
+		       (disk->flags & GENHD_FL_REMOVABLE ? 1 : 0));
 
+}
+static ssize_t disk_size_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)get_capacity(disk));
+}
+static ssize_t disk_capability_read(struct gendisk *disk, char *page)
+{
+	return sprintf(page, "%x\n", disk->flags);
+}
+static ssize_t disk_stats_read(struct gendisk * disk, char *page)
+{
 	preempt_disable();
 	disk_round_stats(disk);
 	preempt_enable();
-	return sprintf(buf,
+	return sprintf(page,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
 		"%8u %8u %8u"
@@ -436,21 +449,40 @@ static ssize_t disk_stat_show(struct dev
 		jiffies_to_msecs(disk_stat_read(disk, io_ticks)),
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
+static struct disk_attribute disk_attr_uevent = {
+	.attr = {.name = "uevent", .mode = S_IWUSR },
+	.store	= disk_uevent_store
+};
+static struct disk_attribute disk_attr_dev = {
+	.attr = {.name = "dev", .mode = S_IRUGO },
+	.show	= disk_dev_read
+};
+static struct disk_attribute disk_attr_range = {
+	.attr = {.name = "range", .mode = S_IRUGO },
+	.show	= disk_range_read
+};
+static struct disk_attribute disk_attr_removable = {
+	.attr = {.name = "removable", .mode = S_IRUGO },
+	.show	= disk_removable_read
+};
+static struct disk_attribute disk_attr_size = {
+	.attr = {.name = "size", .mode = S_IRUGO },
+	.show	= disk_size_read
+};
+static struct disk_attribute disk_attr_capability = {
+	.attr = {.name = "capability", .mode = S_IRUGO },
+	.show	= disk_capability_read
+};
+static struct disk_attribute disk_attr_stat = {
+	.attr = {.name = "stat", .mode = S_IRUGO },
+	.show	= disk_stats_read
+};
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t disk_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
-}
-
-static ssize_t disk_fail_store(struct device *dev,
-			       struct device_attribute *attr,
+static ssize_t disk_fail_store(struct gendisk * disk,
 			       const char *buf, size_t count)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	int i;
 
 	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
@@ -462,101 +494,155 @@ static ssize_t disk_fail_store(struct de
 
 	return count;
 }
+static ssize_t disk_fail_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
+}
+static struct disk_attribute disk_attr_fail = {
+	.attr = {.name = "make-it-fail", .mode = S_IRUGO | S_IWUSR },
+	.store	= disk_fail_store,
+	.show	= disk_fail_read
+};
 
 #endif
 
-static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
-static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
-static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
-static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, disk_fail_show, disk_fail_store);
-#endif
-
-static struct attribute *disk_attrs[] = {
-	&dev_attr_range.attr,
-	&dev_attr_removable.attr,
-	&dev_attr_size.attr,
-	&dev_attr_capability.attr,
-	&dev_attr_stat.attr,
+static struct attribute * default_attrs[] = {
+	&disk_attr_uevent.attr,
+	&disk_attr_dev.attr,
+	&disk_attr_range.attr,
+	&disk_attr_removable.attr,
+	&disk_attr_size.attr,
+	&disk_attr_stat.attr,
+	&disk_attr_capability.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-	&dev_attr_fail.attr,
+	&disk_attr_fail.attr,
 #endif
-	NULL
-};
-
-static struct attribute_group disk_attr_group = {
-	.attrs = disk_attrs,
-};
-
-static struct attribute_group *disk_attr_groups[] = {
-	&disk_attr_group,
-	NULL
+	NULL,
 };
 
-static void disk_release(struct device *dev)
+static void disk_release(struct kobject * kobj)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-
+	struct gendisk *disk = to_disk(kobj);
 	kfree(disk->random);
 	kfree(disk->part);
 	free_disk_stats(disk);
 	kfree(disk);
 }
 
-struct class block_class = {
-	.name		= "block",
+static struct kobj_type ktype_block = {
+	.release	= disk_release,
+	.sysfs_ops	= &disk_sysfs_ops,
+	.default_attrs	= default_attrs,
 };
 
-struct device_type disk_type = {
-	.name		= "disk",
-	.groups		= disk_attr_groups,
-	.release	= disk_release,
+extern struct kobj_type ktype_part;
+
+static int block_uevent_filter(struct kset *kset, struct kobject *kobj)
+{
+	struct kobj_type *ktype = get_ktype(kobj);
+
+	return ((ktype == &ktype_block) || (ktype == &ktype_part));
+}
+
+static int block_uevent(struct kset *kset, struct kobject *kobj, char **envp,
+			 int num_envp, char *buffer, int buffer_size)
+{
+	struct kobj_type *ktype = get_ktype(kobj);
+	struct device *physdev;
+	struct gendisk *disk;
+	struct hd_struct *part;
+	int length = 0;
+	int i = 0;
+
+	if (ktype == &ktype_block) {
+		disk = container_of(kobj, struct gendisk, kobj);
+		add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
+			       &length, "MINOR=%u", disk->first_minor);
+	} else if (ktype == &ktype_part) {
+		disk = container_of(kobj->parent, struct gendisk, kobj);
+		part = container_of(kobj, struct hd_struct, kobj);
+		add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
+			       &length, "MINOR=%u",
+			       disk->first_minor + part->partno);
+	} else
+		return 0;
+
+	add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &length,
+		       "MAJOR=%u", disk->major);
+
+	/* add physical device, backing this device  */
+	physdev = disk->driverfs_dev;
+	if (physdev) {
+		char *path = kobject_get_path(&physdev->kobj, GFP_KERNEL);
+
+		add_uevent_var(envp, num_envp, &i, buffer, buffer_size,
+			       &length, "PHYSDEVPATH=%s", path);
+		kfree(path);
+
+		if (physdev->bus)
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVBUS=%s",
+				       physdev->bus->name);
+
+		if (physdev->driver)
+			add_uevent_var(envp, num_envp, &i,
+				       buffer, buffer_size, &length,
+				       "PHYSDEVDRIVER=%s",
+				       physdev->driver->name);
+	}
+
+	/* terminate, set to next free slot, shrink available space */
+	envp[i] = NULL;
+	envp = &envp[i];
+	num_envp -= i;
+	buffer = &buffer[length];
+	buffer_size -= length;
+
+	return 0;
+}
+
+static struct kset_uevent_ops block_uevent_ops = {
+	.filter		= block_uevent_filter,
+	.uevent		= block_uevent,
 };
 
+decl_subsys(block, &ktype_block, &block_uevent_ops);
+
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
+ * Watching a few disks may be efficient through sysfs, but watching
+ * all of them will be more efficient through this interface.
  *
  * The output looks suspiciously like /proc/partitions with a bunch of
  * extra fields.
  */
 
+/* iterator */
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
 	loff_t k = *pos;
-	struct device *dev;
+	struct list_head *p;
 
-	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (dev->type != &disk_type)
-			continue;
+	mutex_lock(&block_subsys_lock);
+	list_for_each(p, &block_subsys.list)
 		if (!k--)
-			return dev_to_disk(dev);
-	}
+			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
 }
 
 static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct gendisk *gp = v;
-	struct device *dev;
-
+	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
-	return NULL;
+	return p==&block_subsys.list ? NULL :
+		list_entry(p, struct gendisk, kobj.entry);
 }
 
 static void diskstats_stop(struct seq_file *part, void *v)
 {
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&block_subsys_lock);
 }
 
 static int diskstats_show(struct seq_file *s, void *v)
@@ -566,7 +652,7 @@ static int diskstats_show(struct seq_fil
 	int n = 0;
 
 	/*
-	if (&gp->dev.kobj.entry == block_class.devices.next)
+	if (&sgp->kobj.entry == block_subsys.kset.list.next)
 		seq_puts(s,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
@@ -620,7 +706,7 @@ static void media_change_notify_thread(s
 	 * set enviroment vars to indicate which event this is for
 	 * so that user space will know to go check the media status.
 	 */
-	kobject_uevent_env(&gd->dev.kobj, KOBJ_CHANGE, envp);
+	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
 	put_device(gd->driverfs_dev);
 }
 
@@ -631,25 +717,6 @@ void genhd_media_change_notify(struct ge
 }
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 
-dev_t blk_lookup_devt(const char *name)
-{
-	struct device *dev;
-	dev_t devt = MKDEV(0, 0);
-
-	mutex_lock(&block_class_lock);
-	list_for_each_entry(dev, &block_class.devices, node) {
-		if (strcmp(dev->bus_id, name) == 0) {
-			devt = dev->devt;
-			break;
-		}
-	}
-	mutex_unlock(&block_class_lock);
-
-	return devt;
-}
-
-EXPORT_SYMBOL(blk_lookup_devt);
-
 struct gendisk *alloc_disk(int minors)
 {
 	return alloc_disk_node(minors, -1);
@@ -676,10 +743,9 @@ struct gendisk *alloc_disk_node(int mino
 			memset(disk->part, 0, size);
 		}
 		disk->minors = minors;
+		kobj_set_kset_s(disk,block_subsys);
+		kobject_init(&disk->kobj);
 		rand_initialize_disk(disk);
-		device_initialize(&disk->dev);
-		disk->dev.class = &block_class;
-		disk->dev.type = &disk_type;
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
 	}
@@ -699,7 +765,7 @@ struct kobject *get_disk(struct gendisk 
 	owner = disk->fops->owner;
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj = kobject_get(&disk->dev.kobj);
+	kobj = kobject_get(&disk->kobj);
 	if (kobj == NULL) {
 		module_put(owner);
 		return NULL;
@@ -713,7 +779,7 @@ EXPORT_SYMBOL(get_disk);
 void put_disk(struct gendisk *disk)
 {
 	if (disk)
-		kobject_put(&disk->dev.kobj);
+		kobject_put(&disk->kobj);
 }
 
 EXPORT_SYMBOL(put_disk);
diff -puN block/ll_rw_blk.c~revert-gregkh-driver-block-device block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~revert-gregkh-driver-block-device
+++ a/block/ll_rw_blk.c
@@ -4076,7 +4076,7 @@ int blk_register_queue(struct gendisk *d
 	if (!q || !q->request_fn)
 		return -ENXIO;
 
-	q->kobj.parent = kobject_get(&disk->dev.kobj);
+	q->kobj.parent = kobject_get(&disk->kobj);
 
 	ret = kobject_add(&q->kobj);
 	if (ret < 0)
@@ -4103,6 +4103,6 @@ void blk_unregister_queue(struct gendisk
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
-		kobject_put(&disk->dev.kobj);
+		kobject_put(&disk->kobj);
 	}
 }
diff -puN drivers/base/core.c~revert-gregkh-driver-block-device drivers/base/core.c
--- a/drivers/base/core.c~revert-gregkh-driver-block-device
+++ a/drivers/base/core.c
@@ -567,20 +567,12 @@ void device_initialize(struct device *de
 }
 
 #ifdef CONFIG_SYSFS_DEPRECATED
-extern struct kobject block_depr;
-extern struct device_type disk_type;
-extern struct device_type part_type;
-
 static struct kobject * get_device_parent(struct device *dev,
 					  struct device *parent)
 {
 	/* Set the parent to the class, not the parent device */
 	/* this keeps sysfs from having a symlink to make old udevs happy */
-	if (dev->type == &part_type)
-		return &dev->parent->kobj;
-	else if (dev->type == &disk_type)
-		return &block_depr;
-	else if (dev->class)
+	if (dev->class)
 		return &dev->class->subsys.kobj;
 	else if (parent)
 		return &parent->kobj;
@@ -713,8 +705,7 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_create_link(&dev->class->subsys.kobj,
 					  &dev->kobj, dev->bus_id);
-		/* only bus-device parents get a "device"-link */
-		if (parent && parent->bus) {
+		if (parent) {
 			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 							"device");
 #ifdef CONFIG_SYSFS_DEPRECATED
@@ -771,7 +762,7 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_remove_link(&dev->class->subsys.kobj,
 					  dev->bus_id);
-		if (parent && parent->bus) {
+		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
@@ -871,7 +862,7 @@ void device_del(struct device * dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_remove_link(&dev->class->subsys.kobj,
 					  dev->bus_id);
-		if (parent && parent->bus) {
+		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
diff -puN drivers/block/aoe/aoeblk.c~revert-gregkh-driver-block-device drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~revert-gregkh-driver-block-device
+++ a/drivers/block/aoe/aoeblk.c
@@ -14,10 +14,8 @@
 
 static struct kmem_cache *buf_pool_cache;
 
-static ssize_t aoedisk_show_state(struct device *dev,
-				  struct device_attribute *attr, char *page)
+static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
 
 	return snprintf(page, PAGE_SIZE,
@@ -27,47 +25,50 @@ static ssize_t aoedisk_show_state(struct
 			(d->nopen && !(d->flags & DEVFL_UP)) ? ",closewait" : "");
 	/* I'd rather see nopen exported so we can ditch closewait */
 }
-static ssize_t aoedisk_show_mac(struct device *dev,
-				struct device_attribute *attr, char *page)
+static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
 
 	return snprintf(page, PAGE_SIZE, "%012llx\n",
 			(unsigned long long)mac_addr(d->addr));
 }
-static ssize_t aoedisk_show_netif(struct device *dev,
-				  struct device_attribute *attr, char *page)
+static ssize_t aoedisk_show_netif(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
 
 	return snprintf(page, PAGE_SIZE, "%s\n", d->ifp->name);
 }
 /* firmware version */
-static ssize_t aoedisk_show_fwver(struct device *dev,
-				  struct device_attribute *attr, char *page)
+static ssize_t aoedisk_show_fwver(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
 
 	return snprintf(page, PAGE_SIZE, "0x%04x\n", (unsigned int) d->fw_ver);
 }
 
-static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
-static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
-static DEVICE_ATTR(netif, S_IRUGO, aoedisk_show_netif, NULL);
-static struct device_attribute dev_attr_firmware_version = {
-	.attr = { .name = "firmware-version", .mode = S_IRUGO, .owner = THIS_MODULE },
-	.show = aoedisk_show_fwver,
+static struct disk_attribute disk_attr_state = {
+	.attr = {.name = "state", .mode = S_IRUGO },
+	.show = aoedisk_show_state
+};
+static struct disk_attribute disk_attr_mac = {
+	.attr = {.name = "mac", .mode = S_IRUGO },
+	.show = aoedisk_show_mac
+};
+static struct disk_attribute disk_attr_netif = {
+	.attr = {.name = "netif", .mode = S_IRUGO },
+	.show = aoedisk_show_netif
+};
+static struct disk_attribute disk_attr_fwver = {
+	.attr = {.name = "firmware-version", .mode = S_IRUGO },
+	.show = aoedisk_show_fwver
 };
 
 static struct attribute *aoe_attrs[] = {
-	&dev_attr_state.attr,
-	&dev_attr_mac.attr,
-	&dev_attr_netif.attr,
-	&dev_attr_firmware_version.attr,
-	NULL,
+	&disk_attr_state.attr,
+	&disk_attr_mac.attr,
+	&disk_attr_netif.attr,
+	&disk_attr_fwver.attr,
+	NULL
 };
 
 static const struct attribute_group attr_group = {
@@ -77,12 +78,12 @@ static const struct attribute_group attr
 static int
 aoedisk_add_sysfs(struct aoedev *d)
 {
-	return sysfs_create_group(&d->gd->dev.kobj, &attr_group);
+	return sysfs_create_group(&d->gd->kobj, &attr_group);
 }
 void
 aoedisk_rm_sysfs(struct aoedev *d)
 {
-	sysfs_remove_group(&d->gd->dev.kobj, &attr_group);
+	sysfs_remove_group(&d->gd->kobj, &attr_group);
 }
 
 static int
diff -puN drivers/block/nbd.c~revert-gregkh-driver-block-device drivers/block/nbd.c
--- a/drivers/block/nbd.c~revert-gregkh-driver-block-device
+++ a/drivers/block/nbd.c
@@ -355,17 +355,14 @@ harderror:
 	return NULL;
 }
 
-static ssize_t pid_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
+static ssize_t pid_show(struct gendisk *disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
-
-	return sprintf(buf, "%ld\n",
+	return sprintf(page, "%ld\n",
 		(long) ((struct nbd_device *)disk->private_data)->pid);
 }
 
-static struct device_attribute pid_attr = {
-	.attr = { .name = "pid", .mode = S_IRUGO, .owner = THIS_MODULE },
+static struct disk_attribute pid_attr = {
+	.attr = { .name = "pid", .mode = S_IRUGO },
 	.show = pid_show,
 };
 
@@ -377,7 +374,7 @@ static int nbd_do_it(struct nbd_device *
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	ret = sysfs_create_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
 		return ret;
@@ -386,7 +383,7 @@ static int nbd_do_it(struct nbd_device *
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
 	return 0;
 }
 
diff -puN drivers/ide/ide-probe.c~revert-gregkh-driver-block-device drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~revert-gregkh-driver-block-device
+++ a/drivers/ide/ide-probe.c
@@ -1213,7 +1213,7 @@ static struct kobject *exact_match(dev_t
 {
 	struct gendisk *p = data;
 	*part &= (1 << PARTN_BITS) - 1;
-	return &p->dev.kobj;
+	return &p->kobj;
 }
 
 static int exact_lock(dev_t dev, void *data)
diff -puN drivers/md/dm.c~revert-gregkh-driver-block-device drivers/md/dm.c
--- a/drivers/md/dm.c~revert-gregkh-driver-block-device
+++ a/drivers/md/dm.c
@@ -1490,7 +1490,7 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
-	kobject_uevent(&md->disk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
 
 	r = 0;
 
diff -puN drivers/md/md.c~revert-gregkh-driver-block-device drivers/md/md.c
--- a/drivers/md/md.c~revert-gregkh-driver-block-device
+++ a/drivers/md/md.c
@@ -1405,9 +1405,9 @@ static int bind_rdev_to_array(mdk_rdev_t
 		goto fail;
 
 	if (rdev->bdev->bd_part)
-		ko = &rdev->bdev->bd_part->dev.kobj;
+		ko = &rdev->bdev->bd_part->kobj;
 	else
-		ko = &rdev->bdev->bd_disk->dev.kobj;
+		ko = &rdev->bdev->bd_disk->kobj;
 	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
 		kobject_del(&rdev->kobj);
 		goto fail;
@@ -3083,7 +3083,7 @@ static struct kobject *md_probe(dev_t de
 	add_disk(disk);
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
-	mddev->kobj.parent = &disk->dev.kobj;
+	mddev->kobj.parent = &disk->kobj;
 	mddev->kobj.k_name = NULL;
 	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
@@ -3341,7 +3341,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
-	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
diff -puN fs/block_dev.c~revert-gregkh-driver-block-device fs/block_dev.c
--- a/fs/block_dev.c~revert-gregkh-driver-block-device
+++ a/fs/block_dev.c
@@ -728,9 +728,9 @@ EXPORT_SYMBOL(bd_release);
 static struct kobject *bdev_get_kobj(struct block_device *bdev)
 {
 	if (bdev->bd_contains != bdev)
-		return kobject_get(&bdev->bd_part->dev.kobj);
+		return kobject_get(&bdev->bd_part->kobj);
 	else
-		return kobject_get(&bdev->bd_disk->dev.kobj);
+		return kobject_get(&bdev->bd_disk->kobj);
 }
 
 static struct kobject *bdev_get_holder(struct block_device *bdev)
@@ -1163,7 +1163,7 @@ static int do_open(struct block_device *
 				ret = -ENXIO;
 				goto out_first;
 			}
-			kobject_get(&p->dev.kobj);
+			kobject_get(&p->kobj);
 			bdev->bd_part = p;
 			bd_set_size(bdev, (loff_t) p->nr_sects << 9);
 		}
@@ -1286,7 +1286,7 @@ static int __blkdev_put(struct block_dev
 		module_put(owner);
 
 		if (bdev->bd_contains != bdev) {
-			kobject_put(&bdev->bd_part->dev.kobj);
+			kobject_put(&bdev->bd_part->kobj);
 			bdev->bd_part = NULL;
 		}
 		bdev->bd_disk = NULL;
diff -puN fs/partitions/check.c~revert-gregkh-driver-block-device fs/partitions/check.c
--- a/fs/partitions/check.c~revert-gregkh-driver-block-device
+++ a/fs/partitions/check.c
@@ -36,9 +36,6 @@
 #include "karma.h"
 #include "sysv68.h"
 
-extern struct kobject block_depr;
-extern struct class block_class;
-
 #ifdef CONFIG_BLK_DEV_MD
 extern void md_autodetect_dev(dev_t dev);
 #endif
@@ -198,45 +195,96 @@ check_partition(struct gendisk *hd, stru
 	return ERR_PTR(res);
 }
 
-static ssize_t part_start_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+/*
+ * sysfs bindings for partitions
+ */
+
+struct part_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct hd_struct *,char *);
+	ssize_t (*store)(struct hd_struct *,const char *, size_t);
+};
+
+static ssize_t 
+part_attr_show(struct kobject * kobj, struct attribute * attr, char * page)
 {
-	struct hd_struct *p = dev_to_part(dev);
+	struct hd_struct * p = container_of(kobj,struct hd_struct,kobj);
+	struct part_attribute * part_attr = container_of(attr,struct part_attribute,attr);
+	ssize_t ret = 0;
+	if (part_attr->show)
+		ret = part_attr->show(p, page);
+	return ret;
+}
+static ssize_t
+part_attr_store(struct kobject * kobj, struct attribute * attr,
+		const char *page, size_t count)
+{
+	struct hd_struct * p = container_of(kobj,struct hd_struct,kobj);
+	struct part_attribute * part_attr = container_of(attr,struct part_attribute,attr);
+	ssize_t ret = 0;
+
+	if (part_attr->store)
+		ret = part_attr->store(p, page, count);
+	return ret;
+}
+
+static struct sysfs_ops part_sysfs_ops = {
+	.show	=	part_attr_show,
+	.store	=	part_attr_store,
+};
 
-	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
+static ssize_t part_uevent_store(struct hd_struct * p,
+				 const char *page, size_t count)
+{
+	kobject_uevent(&p->kobj, KOBJ_ADD);
+	return count;
 }
-
-static ssize_t part_size_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t part_dev_read(struct hd_struct * p, char *page)
 {
-	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	struct gendisk *disk = container_of(p->kobj.parent,struct gendisk,kobj);
+	dev_t dev = MKDEV(disk->major, disk->first_minor + p->partno); 
+	return print_dev_t(page, dev);
 }
-
-static ssize_t part_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t part_start_read(struct hd_struct * p, char *page)
 {
-	struct hd_struct *p = dev_to_part(dev);
-
-	return sprintf(buf, "%8u %8llu %8u %8llu\n",
+	return sprintf(page, "%llu\n",(unsigned long long)p->start_sect);
+}
+static ssize_t part_size_read(struct hd_struct * p, char *page)
+{
+	return sprintf(page, "%llu\n",(unsigned long long)p->nr_sects);
+}
+static ssize_t part_stat_read(struct hd_struct * p, char *page)
+{
+	return sprintf(page, "%8u %8llu %8u %8llu\n",
 		       p->ios[0], (unsigned long long)p->sectors[0],
 		       p->ios[1], (unsigned long long)p->sectors[1]);
 }
+static struct part_attribute part_attr_uevent = {
+	.attr = {.name = "uevent", .mode = S_IWUSR },
+	.store	= part_uevent_store
+};
+static struct part_attribute part_attr_dev = {
+	.attr = {.name = "dev", .mode = S_IRUGO },
+	.show	= part_dev_read
+};
+static struct part_attribute part_attr_start = {
+	.attr = {.name = "start", .mode = S_IRUGO },
+	.show	= part_start_read
+};
+static struct part_attribute part_attr_size = {
+	.attr = {.name = "size", .mode = S_IRUGO },
+	.show	= part_size_read
+};
+static struct part_attribute part_attr_stat = {
+	.attr = {.name = "stat", .mode = S_IRUGO },
+	.show	= part_stat_read
+};
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t part_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%d\n", p->make_it_fail);
-}
-
-static ssize_t part_fail_store(struct device *dev,
-			       struct device_attribute *attr,
+static ssize_t part_fail_store(struct hd_struct * p,
 			       const char *buf, size_t count)
 {
-	struct hd_struct *p = dev_to_part(dev);
 	int i;
 
 	if (count > 0 && sscanf(buf, "%d", &i) > 0)
@@ -244,52 +292,49 @@ static ssize_t part_fail_store(struct de
 
 	return count;
 }
-#endif
+static ssize_t part_fail_read(struct hd_struct * p, char *page)
+{
+	return sprintf(page, "%d\n", p->make_it_fail);
+}
+static struct part_attribute part_attr_fail = {
+	.attr = {.name = "make-it-fail", .mode = S_IRUGO | S_IWUSR },
+	.store	= part_fail_store,
+	.show	= part_fail_read
+};
 
-static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
-static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
 
-static struct attribute *part_attrs[] = {
-	&dev_attr_start.attr,
-	&dev_attr_size.attr,
-	&dev_attr_stat.attr,
+static struct attribute * default_attrs[] = {
+	&part_attr_uevent.attr,
+	&part_attr_dev.attr,
+	&part_attr_start.attr,
+	&part_attr_size.attr,
+	&part_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-	&dev_attr_fail.attr,
+	&part_attr_fail.attr,
 #endif
-	NULL
+	NULL,
 };
 
-static struct attribute_group part_attr_group = {
-	.attrs = part_attrs,
-};
-
-static struct attribute_group *part_attr_groups[] = {
-	&part_attr_group,
-	NULL
-};
+extern struct kset block_subsys;
 
-static void part_release(struct device *dev)
+static void part_release(struct kobject *kobj)
 {
-	struct hd_struct *p = dev_to_part(dev);
+	struct hd_struct * p = container_of(kobj,struct hd_struct,kobj);
 	kfree(p);
 }
 
-struct device_type part_type = {
-	.name		= "partition",
-	.groups		= part_attr_groups,
+struct kobj_type ktype_part = {
 	.release	= part_release,
+	.default_attrs	= default_attrs,
+	.sysfs_ops	= &part_sysfs_ops,
 };
 
 static inline void partition_sysfs_add_subdir(struct hd_struct *p)
 {
 	struct kobject *k;
 
-	k = kobject_get(&p->dev.kobj);
+	k = kobject_get(&p->kobj);
 	p->holder_dir = kobject_add_dir(k, "holders");
 	kobject_put(k);
 }
@@ -298,7 +343,7 @@ static inline void disk_sysfs_add_subdir
 {
 	struct kobject *k;
 
-	k = kobject_get(&disk->dev.kobj);
+	k = kobject_get(&disk->kobj);
 	disk->holder_dir = kobject_add_dir(k, "holders");
 	disk->slave_dir = kobject_add_dir(k, "slaves");
 	kobject_put(k);
@@ -307,7 +352,6 @@ static inline void disk_sysfs_add_subdir
 void delete_partition(struct gendisk *disk, int part)
 {
 	struct hd_struct *p = disk->part[part-1];
-
 	if (!p)
 		return;
 	if (!p->nr_sects)
@@ -317,15 +361,16 @@ void delete_partition(struct gendisk *di
 	p->nr_sects = 0;
 	p->ios[0] = p->ios[1] = 0;
 	p->sectors[0] = p->sectors[1] = 0;
+	sysfs_remove_link(&p->kobj, "subsystem");
 	kobject_unregister(p->holder_dir);
-	device_del(&p->dev);
-	put_device(&p->dev);
+	kobject_uevent(&p->kobj, KOBJ_REMOVE);
+	kobject_del(&p->kobj);
+	kobject_put(&p->kobj);
 }
 
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
-	int err;
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -337,52 +382,92 @@ void add_partition(struct gendisk *disk,
 	p->partno = part;
 	p->policy = disk->policy;
 
-	if (isdigit(disk->dev.bus_id[strlen(disk->dev.bus_id)-1]))
-		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-			 "%sp%d", disk->dev.bus_id, part);
+	if (isdigit(disk->kobj.name[strlen(disk->kobj.name)-1]))
+		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
 	else
-		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-			 "%s%d", disk->dev.bus_id, part);
-
-	device_initialize(&p->dev);
-	p->dev.devt = MKDEV(disk->major, disk->first_minor + part);
-	p->dev.class = &block_class;
-	p->dev.type = &part_type;
-	p->dev.parent = &disk->dev;
-	disk->part[part-1] = p;
-
-	/* delay uevent until 'holders' subdir is created */
-	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
-	partition_sysfs_add_subdir(p);
-	p->dev.uevent_suppress = 0;
+		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
+	p->kobj.parent = &disk->kobj;
+	p->kobj.ktype = &ktype_part;
+	kobject_init(&p->kobj);
+	kobject_add(&p->kobj);
+	if (!disk->part_uevent_suppress)
+		kobject_uevent(&p->kobj, KOBJ_ADD);
+	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		err = sysfs_create_file(&p->dev.kobj, &addpartattr);
+		sysfs_create_file(&p->kobj, &addpartattr);
 	}
+	partition_sysfs_add_subdir(p);
+	disk->part[part-1] = p;
+}
 
-	/* suppress uevent if the disk supresses it */
-	if (!disk->dev.uevent_suppress)
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+static char *make_block_name(struct gendisk *disk)
+{
+	char *name;
+	static char *block_str = "block:";
+	int size;
+	char *s;
+
+	size = strlen(block_str) + strlen(disk->disk_name) + 1;
+	name = kmalloc(size, GFP_KERNEL);
+	if (!name)
+		return NULL;
+	strcpy(name, block_str);
+	strcat(name, disk->disk_name);
+	/* ewww... some of these buggers have / in name... */
+	s = strchr(name, '/');
+	if (s)
+		*s = '!';
+	return name;
 }
 
-#ifndef CONFIG_SYSFS_DEPRECATED
 static int disk_sysfs_symlinks(struct gendisk *disk)
 {
-	int err = 0;
-	struct device *target = get_device(disk->dev.parent);
+	struct device *target = get_device(disk->driverfs_dev);
+	int err;
+	char *disk_name = NULL;
 
-	err = sysfs_create_link(&block_depr, &disk->dev.kobj,
-				disk->dev.kobj.name);
-	if (err && target)
+	if (target) {
+		disk_name = make_block_name(disk);
+		if (!disk_name) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+
+		err = sysfs_create_link(&disk->kobj, &target->kobj, "device");
+		if (err)
+			goto err_out_disk_name;
+
+		err = sysfs_create_link(&target->kobj, &disk->kobj, disk_name);
+		if (err)
+			goto err_out_dev_link;
+	}
+
+	err = sysfs_create_link(&disk->kobj, &block_subsys.kobj,
+				"subsystem");
+	if (err)
+		goto err_out_disk_name_lnk;
+
+	kfree(disk_name);
+
+	return 0;
+
+err_out_disk_name_lnk:
+	if (target) {
+		sysfs_remove_link(&target->kobj, disk_name);
+err_out_dev_link:
+		sysfs_remove_link(&disk->kobj, "device");
+err_out_disk_name:
+		kfree(disk_name);
+err_out:
 		put_device(target);
+	}
 	return err;
 }
-#endif
 
 /* Not exported, helper to add_disk(). */
 void register_disk(struct gendisk *disk)
@@ -393,27 +478,18 @@ void register_disk(struct gendisk *disk)
 	struct hd_struct *p;
 	int err;
 
-	disk->dev.parent = disk->driverfs_dev;
-	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
-
-	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
-	/* ewww... some of these buggers have / in the name... */
-	s = strchr(disk->dev.bus_id, '/');
+	strlcpy(disk->kobj.name,disk->disk_name,KOBJ_NAME_LEN);
+	/* ewww... some of these buggers have / in name... */
+	s = strchr(disk->kobj.name, '/');
 	if (s)
 		*s = '!';
-
-	/* delay uevents, until we scanned partition table */
-	disk->dev.uevent_suppress = 1;
-
-	if (device_add(&disk->dev))
+	if ((err = kobject_add(&disk->kobj)))
 		return;
-#ifndef CONFIG_SYSFS_DEPRECATED
 	err = disk_sysfs_symlinks(disk);
 	if (err) {
-		device_del(&disk->dev);
+		kobject_del(&disk->kobj);
 		return;
 	}
-#endif
  	disk_sysfs_add_subdirs(disk);
 
 	/* No minors to use for partitions */
@@ -428,23 +504,25 @@ void register_disk(struct gendisk *disk)
 	if (!bdev)
 		goto exit;
 
+	/* scan partition table, but suppress uevents */
 	bdev->bd_invalidated = 1;
+	disk->part_uevent_suppress = 1;
 	err = blkdev_get(bdev, FMODE_READ, 0);
+	disk->part_uevent_suppress = 0;
 	if (err < 0)
 		goto exit;
 	blkdev_put(bdev);
 
 exit:
-	/* announce disk after possible partitions are created */
-	disk->dev.uevent_suppress = 0;
-	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);
+	/* announce disk after possible partitions are already created */
+	kobject_uevent(&disk->kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
 	for (i = 1; i < disk->minors; i++) {
 		p = disk->part[i-1];
 		if (!p || !p->nr_sects)
 			continue;
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+		kobject_uevent(&p->kobj, KOBJ_ADD);
 	}
 }
 
@@ -523,15 +601,19 @@ void del_gendisk(struct gendisk *disk)
 	disk_stat_set_all(disk, 0);
 	disk->stamp = 0;
 
+	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
 	kobject_unregister(disk->holder_dir);
 	kobject_unregister(disk->slave_dir);
 	if (disk->driverfs_dev) {
-		put_device(disk->dev.parent);
-		disk->dev.parent = NULL;
+		char *disk_name = make_block_name(disk);
+		sysfs_remove_link(&disk->kobj, "device");
+		if (disk_name) {
+			sysfs_remove_link(&disk->driverfs_dev->kobj, disk_name);
+			kfree(disk_name);
+		}
+		put_device(disk->driverfs_dev);
 		disk->driverfs_dev = NULL;
 	}
-#ifndef CONFIG_SYSFS_DEPRECATED
-	sysfs_remove_link(&block_depr, disk->dev.bus_id);
-#endif
-	device_del(&disk->dev);
+	sysfs_remove_link(&disk->kobj, "subsystem");
+	kobject_del(&disk->kobj);
 }
diff -puN include/linux/genhd.h~revert-gregkh-driver-block-device include/linux/genhd.h
--- a/include/linux/genhd.h~revert-gregkh-driver-block-device
+++ a/include/linux/genhd.h
@@ -13,10 +13,6 @@
 
 #ifdef CONFIG_BLOCK
 
-#define kobj_to_dev(kobj) container_of(kobj, struct device, kobj)
-#define dev_to_disk(device) container_of(device, struct gendisk, dev)
-#define dev_to_part(device) container_of(device, struct hd_struct, dev)
-
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
    confused about extended/logical partitions starting past cylinder 1023. */
@@ -88,7 +84,7 @@ struct partition {
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
-	struct device dev;
+	struct kobject kobj;
 	struct kobject *holder_dir;
 	unsigned ios[2], sectors[2];	/* READs and WRITEs */
 	int policy, partno;
@@ -121,14 +117,15 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 	char disk_name[32];		/* name of major driver */
 	struct hd_struct **part;	/* [indexed by minor] */
+	int part_uevent_suppress;
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
 	sector_t capacity;
 
 	int flags;
-	struct device *driverfs_dev;  // FIXME: remove
-	struct device dev;
+	struct device *driverfs_dev;
+	struct kobject kobj;
 	struct kobject *holder_dir;
 	struct kobject *slave_dir;
 
@@ -146,6 +143,13 @@ struct gendisk {
 	struct work_struct async_notify;
 };
 
+/* Structure for sysfs attributes on block devices */
+struct disk_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct gendisk *, char *);
+	ssize_t (*store)(struct gendisk *, const char *, size_t);
+};
+
 /* 
  * Macros to operate on percpu disk statistics:
  *
@@ -407,8 +411,7 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name);
-extern char *disk_name (struct gendisk *hd, int part, char *buf);
+char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
@@ -420,12 +423,12 @@ extern struct gendisk *alloc_disk(int mi
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
 extern void genhd_media_change_notify(struct gendisk *disk);
-extern void blk_register_region(dev_t devt, unsigned long range,
+extern void blk_register_region(dev_t dev, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),
 			int (*lock)(dev_t, void *),
 			void *data);
-extern void blk_unregister_region(dev_t devt, unsigned long range);
+extern void blk_unregister_region(dev_t dev, unsigned long range);
 
 static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
 {
diff -puN init/do_mounts.c~revert-gregkh-driver-block-device init/do_mounts.c
--- a/init/do_mounts.c~revert-gregkh-driver-block-device
+++ a/init/do_mounts.c
@@ -54,6 +54,69 @@ static int __init readwrite(char *str)
 __setup("ro", readonly);
 __setup("rw", readwrite);
 
+static dev_t try_name(char *name, int part)
+{
+	char path[64];
+	char buf[32];
+	int range;
+	dev_t res;
+	char *s;
+	int len;
+	int fd;
+	unsigned int maj, min;
+
+	/* read device number from .../dev */
+
+	sprintf(path, "/sys/block/%s/dev", name);
+	fd = sys_open(path, 0, 0);
+	if (fd < 0)
+		goto fail;
+	len = sys_read(fd, buf, 32);
+	sys_close(fd);
+	if (len <= 0 || len == 32 || buf[len - 1] != '\n')
+		goto fail;
+	buf[len - 1] = '\0';
+	if (sscanf(buf, "%u:%u", &maj, &min) == 2) {
+		/*
+		 * Try the %u:%u format -- see print_dev_t()
+		 */
+		res = MKDEV(maj, min);
+		if (maj != MAJOR(res) || min != MINOR(res))
+			goto fail;
+	} else {
+		/*
+		 * Nope.  Try old-style "0321"
+		 */
+		res = new_decode_dev(simple_strtoul(buf, &s, 16));
+		if (*s)
+			goto fail;
+	}
+
+	/* if it's there and we are not looking for a partition - that's it */
+	if (!part)
+		return res;
+
+	/* otherwise read range from .../range */
+	sprintf(path, "/sys/block/%s/range", name);
+	fd = sys_open(path, 0, 0);
+	if (fd < 0)
+		goto fail;
+	len = sys_read(fd, buf, 32);
+	sys_close(fd);
+	if (len <= 0 || len == 32 || buf[len - 1] != '\n')
+		goto fail;
+	buf[len - 1] = '\0';
+	range = simple_strtoul(buf, &s, 10);
+	if (*s)
+		goto fail;
+
+	/* if partition is within range - we got it */
+	if (part < range)
+		return res + part;
+fail:
+	return 0;
+}
+
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
@@ -65,10 +128,12 @@ __setup("rw", readwrite);
  *	5) /dev/<disk_name>p<decimal> - same as the above, that form is
  *	   used when disk name of partitioned disk ends on a digit.
  *
- *	If name doesn't have fall into the categories above, we return (0,0).
- *	block_class is used to check if something is a disk name. If the disk
- *	name contains slashes, the device name has them replaced with
- *	bangs.
+ *	If name doesn't have fall into the categories above, we return 0.
+ *	Sysfs is used to check if something is a disk name - it has
+ *	all known disks under bus/block/devices.  If the disk name
+ *	contains slashes, name of sysfs node has them replaced with
+ *	bangs.  try_name() does the actual checks, assuming that sysfs
+ *	is mounted on rootfs /sys.
  */
 
 dev_t name_to_dev_t(char *name)
@@ -76,6 +141,13 @@ dev_t name_to_dev_t(char *name)
 	char s[32];
 	char *p;
 	dev_t res = 0;
+	int part;
+
+#ifdef CONFIG_SYSFS
+	int mkdir_err = sys_mkdir("/sys", 0700);
+	if (sys_mount("sysfs", "/sys", "sysfs", 0, NULL) < 0)
+		goto out;
+#endif
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
@@ -91,7 +163,6 @@ dev_t name_to_dev_t(char *name)
 		}
 		goto done;
 	}
-
 	name += 5;
 	res = Root_NFS;
 	if (strcmp(name, "nfs") == 0)
@@ -106,14 +177,35 @@ dev_t name_to_dev_t(char *name)
 	for (p = s; *p; p++)
 		if (*p == '/')
 			*p = '!';
-	res = blk_lookup_devt(s);
+	res = try_name(s, 0);
 	if (res)
 		goto done;
 
-fail:
-	return 0;
+	while (p > s && isdigit(p[-1]))
+		p--;
+	if (p == s || !*p || *p == '0')
+		goto fail;
+	part = simple_strtoul(p, NULL, 10);
+	*p = '\0';
+	res = try_name(s, part);
+	if (res)
+		goto done;
+
+	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
+		goto fail;
+	p[-1] = '\0';
+	res = try_name(s, part);
 done:
+#ifdef CONFIG_SYSFS
+	sys_umount("/sys", 0);
+out:
+	if (!mkdir_err)
+		sys_rmdir("/sys");
+#endif
 	return res;
+fail:
+	res = 0;
+	goto done;
 }
 
 static int __init root_dev_setup(char *line)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

document-acked-by.patch
git-acpi.patch
git-acpi-tickh-needs-hrtimerh.patch
git-acpi-add-exports.patch
git-acpi-disable-acpi_processor_throttling_seq_show.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
bugfix-cpufreq-in-combination-with-performance-governor-fix.patch
8xx-mpc885ads-pcmcia-support.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-input-fixup.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-md-accel.patch
git-md-accel-fixup.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
sundance-phy-address-form-0-only-for-device-id-0x0200-fix.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-scsi-misc.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
revert-x86_64-mm-verify-cpu-rename.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
revert-x86_64-mm-cpa-cache-flush.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
git-xfs.patch
git-cryptodev.patch
git-xtensa.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c-fix-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
atmel_serial-fix-break-handling.patch
lib-add-idr_for_each-fix.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
taskstats-add-context-switch-counters-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
lguest-the-net-driver-include-fix.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer-fix.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
cfs-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
