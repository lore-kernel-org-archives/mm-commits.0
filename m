From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-block-device.patch removed from -mm tree
Date: Mon, 05 Nov 2007 22:19:02 -0800
Message-ID: <200711060625.lA66Pru0010043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019AbXKFGZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 01:25:58 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lA66PrPC025587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 5 Nov 2007 22:25:54 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-block-device
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-block-device.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert gregkh-driver-block-device
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c              |  412 +++++++++++++++++++----------------
 block/ll_rw_blk.c          |    4 
 drivers/base/core.c        |   19 -
 drivers/block/aoe/aoeblk.c |   51 ++--
 drivers/block/nbd.c        |   15 -
 drivers/ide/ide-probe.c    |    2 
 drivers/md/dm.c            |    4 
 drivers/md/md.c            |    8 
 fs/block_dev.c             |    8 
 fs/partitions/check.c      |  315 +++++++++++++++++---------
 include/linux/genhd.h      |   29 +-
 init/do_mounts.c           |  108 ++++++++-
 12 files changed, 603 insertions(+), 372 deletions(-)

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
 
@@ -116,7 +114,7 @@ void unregister_blkdev(unsigned int majo
 	struct blk_major_name *p = NULL;
 	int index = major_to_index(major);
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&block_subsys_lock);
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
@@ -126,7 +124,7 @@ void unregister_blkdev(unsigned int majo
 		p = *n;
 		*n = p->next;
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&block_subsys_lock);
 	kfree(p);
 }
 
@@ -139,30 +137,29 @@ static struct kobj_map *bdev_map;
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
 
@@ -197,6 +194,8 @@ void unlink_gendisk(struct gendisk *disk
 			      disk->minors);
 }
 
+#define to_disk(obj) container_of(obj,struct gendisk,kobj)
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @dev: device to get partitioning information for
@@ -204,12 +203,10 @@ void unlink_gendisk(struct gendisk *disk
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
@@ -219,18 +216,13 @@ struct gendisk *get_gendisk(dev_t devt, 
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
@@ -265,44 +257,36 @@ void __init printk_all_partitions(void)
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
@@ -311,7 +295,7 @@ static int show_partition(struct seq_fil
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->dev.node == block_class.devices.next)
+	if (&sgp->kobj.entry == block_subsys.list.next)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
@@ -351,71 +335,100 @@ struct seq_operations partitions_op = {
 
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
+{
+	dev_t base = MKDEV(disk->major, disk->first_minor); 
+	return print_dev_t(page, base);
+}
+static ssize_t disk_range_read(struct gendisk * disk, char *page)
 {
-	struct gendisk *disk = dev_to_disk(dev);
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
@@ -432,21 +445,40 @@ static ssize_t disk_stat_show(struct dev
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
-
-	return sprintf(buf, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
-}
 
-static ssize_t disk_fail_store(struct device *dev,
-			       struct device_attribute *attr,
+static ssize_t disk_fail_store(struct gendisk * disk,
 			       const char *buf, size_t count)
 {
-	struct gendisk *disk = dev_to_disk(dev);
 	int i;
 
 	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
@@ -458,101 +490,136 @@ static ssize_t disk_fail_store(struct de
 
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
+	NULL,
 };
 
-static struct attribute_group *disk_attr_groups[] = {
-	&disk_attr_group,
-	NULL
-};
-
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
+static int block_uevent(struct kset *kset, struct kobject *kobj,
+			struct kobj_uevent_env *env)
+{
+	struct kobj_type *ktype = get_ktype(kobj);
+	struct device *physdev;
+	struct gendisk *disk;
+	struct hd_struct *part;
+
+	if (ktype == &ktype_block) {
+		disk = container_of(kobj, struct gendisk, kobj);
+		add_uevent_var(env, "MINOR=%u", disk->first_minor);
+	} else if (ktype == &ktype_part) {
+		disk = container_of(kobj->parent, struct gendisk, kobj);
+		part = container_of(kobj, struct hd_struct, kobj);
+		add_uevent_var(env, "MINOR=%u",
+			       disk->first_minor + part->partno);
+	} else
+		return 0;
+
+	add_uevent_var(env, "MAJOR=%u", disk->major);
+
+	/* add physical device, backing this device  */
+	physdev = disk->driverfs_dev;
+	if (physdev) {
+		char *path = kobject_get_path(&physdev->kobj, GFP_KERNEL);
+
+		add_uevent_var(env, "PHYSDEVPATH=%s", path);
+		kfree(path);
+
+		if (physdev->bus)
+			add_uevent_var(env, "PHYSDEVBUS=%s", physdev->bus->name);
+
+		if (physdev->driver)
+			add_uevent_var(env, physdev->driver->name);
+	}
+
+	return 0;
+}
+
+static struct kset_uevent_ops block_uevent_ops = {
+	.filter		= block_uevent_filter,
+	.uevent		= block_uevent,
 };
 
+decl_subsys(block, &block_uevent_ops);
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
@@ -562,7 +629,7 @@ static int diskstats_show(struct seq_fil
 	int n = 0;
 
 	/*
-	if (&gp->dev.kobj.entry == block_class.devices.next)
+	if (&sgp->kobj.entry == block_subsys.kset.list.next)
 		seq_puts(s,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
@@ -616,7 +683,7 @@ static void media_change_notify_thread(s
 	 * set enviroment vars to indicate which event this is for
 	 * so that user space will know to go check the media status.
 	 */
-	kobject_uevent_env(&gd->dev.kobj, KOBJ_CHANGE, envp);
+	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
 	put_device(gd->driverfs_dev);
 }
 
@@ -627,25 +694,6 @@ void genhd_media_change_notify(struct ge
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
@@ -672,10 +720,10 @@ struct gendisk *alloc_disk_node(int mino
 			}
 		}
 		disk->minors = minors;
+		kobject_init(&disk->kobj);
+		disk->kobj.kset = &block_subsys;
+		disk->kobj.ktype = &ktype_block;
 		rand_initialize_disk(disk);
-		device_initialize(&disk->dev);
-		disk->dev.class = &block_class;
-		disk->dev.type = &disk_type;
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
 	}
@@ -695,7 +743,7 @@ struct kobject *get_disk(struct gendisk 
 	owner = disk->fops->owner;
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj = kobject_get(&disk->dev.kobj);
+	kobj = kobject_get(&disk->kobj);
 	if (kobj == NULL) {
 		module_put(owner);
 		return NULL;
@@ -709,7 +757,7 @@ EXPORT_SYMBOL(get_disk);
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
@@ -4210,7 +4210,7 @@ int blk_register_queue(struct gendisk *d
 	if (!q || !q->request_fn)
 		return -ENXIO;
 
-	q->kobj.parent = kobject_get(&disk->dev.kobj);
+	q->kobj.parent = kobject_get(&disk->kobj);
 
 	ret = kobject_add(&q->kobj);
 	if (ret < 0)
@@ -4237,6 +4237,6 @@ void blk_unregister_queue(struct gendisk
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
-		kobject_put(&disk->dev.kobj);
+		kobject_put(&disk->kobj);
 	}
 }
diff -puN drivers/base/core.c~revert-gregkh-driver-block-device drivers/base/core.c
--- a/drivers/base/core.c~revert-gregkh-driver-block-device
+++ a/drivers/base/core.c
@@ -18,7 +18,7 @@
 #include <linux/string.h>
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
-#include <linux/genhd.h>
+
 #include <asm/semaphore.h>
 
 #include "base.h"
@@ -543,21 +543,14 @@ void device_initialize(struct device *de
 static struct kobject * get_device_parent(struct device *dev,
 					  struct device *parent)
 {
-	/* partitions are childs of the disk */
-	if (dev->type == &part_type)
-		return &dev->parent->kobj;
-	/* disks live in its own top-level directory */
-	else if (dev->type == &disk_type)
-		return &block_depr;
 	/*
 	 * Set the parent to the class, not the parent device
 	 * for topmost devices in class hierarchy.
 	 * This keeps sysfs from having a symlink to make old
 	 * udevs happy
 	 */
-	else if (dev->class && (!parent || parent->class != dev->class))
+	if (dev->class && (!parent || parent->class != dev->class))
 		return &dev->class->subsys.kobj;
-	/* all other devices keep their parent */
 	else if (parent)
 		return &parent->kobj;
 
@@ -649,7 +642,7 @@ static int device_add_class_symlinks(str
 	}
 	if (dev->parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
-		if (dev->parent && dev->type != &part_type) {
+		{
 			struct device *parent = dev->parent;
 			char *class_name;
 
@@ -686,7 +679,7 @@ static int device_add_class_symlinks(str
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 out_device:
-	if (dev->parent && dev->type != &part_type)
+	if (dev->parent)
 		sysfs_remove_link(&dev->kobj, "device");
 #endif
 out_busid:
@@ -830,7 +823,7 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_remove_link(&dev->class->subsys.kobj,
 					  dev->bus_id);
-		if (parent && dev->type != &part_type) {
+		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
@@ -929,7 +922,7 @@ void device_del(struct device * dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_remove_link(&dev->class->subsys.kobj,
 					  dev->bus_id);
-		if (parent && dev->type != &part_type) {
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
@@ -374,17 +374,14 @@ harderror:
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
 
@@ -396,7 +393,7 @@ static int nbd_do_it(struct nbd_device *
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	ret = sysfs_create_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
 		return ret;
@@ -405,7 +402,7 @@ static int nbd_do_it(struct nbd_device *
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&lo->disk->dev.kobj, &pid_attr.attr);
+	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
 	return 0;
 }
 
diff -puN drivers/ide/ide-probe.c~revert-gregkh-driver-block-device drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~revert-gregkh-driver-block-device
+++ a/drivers/ide/ide-probe.c
@@ -1179,7 +1179,7 @@ static struct kobject *exact_match(dev_t
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
@@ -1097,7 +1097,7 @@ static void event_callback(void *context
 	list_splice_init(&md->uevent_list, &uevents);
 	spin_unlock_irqrestore(&md->uevent_lock, flags);
 
-	dm_send_uevents(&uevents, &md->disk->dev.kobj);
+	dm_send_uevents(&uevents, &md->disk->kobj);
 
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
@@ -1502,7 +1502,7 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
-	kobject_uevent(&md->disk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
 
 	r = 0;
 
diff -puN drivers/md/md.c~revert-gregkh-driver-block-device drivers/md/md.c
--- a/drivers/md/md.c~revert-gregkh-driver-block-device
+++ a/drivers/md/md.c
@@ -1396,9 +1396,9 @@ static int bind_rdev_to_array(mdk_rdev_t
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
@@ -3082,7 +3082,7 @@ static struct kobject *md_probe(dev_t de
 	add_disk(disk);
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
-	mddev->kobj.parent = &disk->dev.kobj;
+	mddev->kobj.parent = &disk->kobj;
 	kobject_set_name(&mddev->kobj, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
 	if (kobject_register(&mddev->kobj))
@@ -3359,7 +3359,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
-	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
+	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
diff -puN fs/block_dev.c~revert-gregkh-driver-block-device fs/block_dev.c
--- a/fs/block_dev.c~revert-gregkh-driver-block-device
+++ a/fs/block_dev.c
@@ -738,9 +738,9 @@ EXPORT_SYMBOL(bd_release);
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
@@ -1176,7 +1176,7 @@ static int do_open(struct block_device *
 				ret = -ENXIO;
 				goto out_first;
 			}
-			kobject_get(&p->dev.kobj);
+			kobject_get(&p->kobj);
 			bdev->bd_part = p;
 			bd_set_size(bdev, (loff_t) p->nr_sects << 9);
 		}
@@ -1299,7 +1299,7 @@ static int __blkdev_put(struct block_dev
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
+extern struct kset block_subsys;
 
-static struct attribute_group *part_attr_groups[] = {
-	&part_attr_group,
-	NULL
-};
-
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
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -336,37 +381,93 @@ void add_partition(struct gendisk *disk,
 	p->partno = part;
 	p->policy = disk->policy;
 
-	if (isdigit(disk->dev.bus_id[strlen(disk->dev.bus_id)-1]))
-		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-			 "%sp%d", disk->dev.bus_id, part);
+	if (isdigit(disk->kobj.k_name[strlen(disk->kobj.k_name)-1]))
+		kobject_set_name(&p->kobj, "%sp%d",
+				 kobject_name(&disk->kobj), part);
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
+		kobject_set_name(&p->kobj, "%s%d",
+				 kobject_name(&disk->kobj),part);
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
+
+static char *make_block_name(struct gendisk *disk)
+{
+	char *name;
+	static char *block_str = "block:";
+	int size;
+	char *s;
 
-	/* suppress uevent if the disk supresses it */
-	if (!disk->dev.uevent_suppress)
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
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
+}
+
+static int disk_sysfs_symlinks(struct gendisk *disk)
+{
+	struct device *target = get_device(disk->driverfs_dev);
+	int err;
+	char *disk_name = NULL;
+
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
+		put_device(target);
+	}
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
@@ -378,28 +479,18 @@ void register_disk(struct gendisk *disk)
 	struct hd_struct *p;
 	int err;
 
-	disk->dev.parent = disk->driverfs_dev;
-	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
-
-	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
-	/* ewww... some of these buggers have / in the name... */
-	s = strchr(disk->dev.bus_id, '/');
+	kobject_set_name(&disk->kobj, "%s", disk->disk_name);
+	/* ewww... some of these buggers have / in name... */
+	s = strchr(disk->kobj.k_name, '/');
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
-	err = sysfs_create_link(&block_depr, &disk->dev.kobj,
-				kobject_name(&disk->dev.kobj));
+	err = disk_sysfs_symlinks(disk);
 	if (err) {
-		device_del(&disk->dev);
+		kobject_del(&disk->kobj);
 		return;
 	}
-#endif
  	disk_sysfs_add_subdirs(disk);
 
 	/* No minors to use for partitions */
@@ -414,23 +505,25 @@ void register_disk(struct gendisk *disk)
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
 
@@ -509,11 +602,19 @@ void del_gendisk(struct gendisk *disk)
 	disk_stat_set_all(disk, 0);
 	disk->stamp = 0;
 
+	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
 	kobject_unregister(disk->holder_dir);
 	kobject_unregister(disk->slave_dir);
-	disk->driverfs_dev = NULL;
-#ifndef CONFIG_SYSFS_DEPRECATED
-	sysfs_remove_link(&block_depr, disk->dev.bus_id);
-#endif
-	device_del(&disk->dev);
+	if (disk->driverfs_dev) {
+		char *disk_name = make_block_name(disk);
+		sysfs_remove_link(&disk->kobj, "device");
+		if (disk_name) {
+			sysfs_remove_link(&disk->driverfs_dev->kobj, disk_name);
+			kfree(disk_name);
+		}
+		put_device(disk->driverfs_dev);
+		disk->driverfs_dev = NULL;
+	}
+	sysfs_remove_link(&disk->kobj, "subsystem");
+	kobject_del(&disk->kobj);
 }
diff -puN include/linux/genhd.h~revert-gregkh-driver-block-device include/linux/genhd.h
--- a/include/linux/genhd.h~revert-gregkh-driver-block-device
+++ a/include/linux/genhd.h
@@ -13,14 +13,6 @@
 
 #ifdef CONFIG_BLOCK
 
-#define kobj_to_dev(kobj) container_of(kobj, struct device, kobj)
-#define dev_to_disk(device) container_of(device, struct gendisk, dev)
-#define dev_to_part(device) container_of(device, struct hd_struct, dev)
-
-extern struct device_type disk_type;
-extern struct device_type part_type;
-extern struct kobject block_depr;
-
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
    confused about extended/logical partitions starting past cylinder 1023. */
@@ -92,7 +84,7 @@ struct partition {
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
-	struct device dev;
+	struct kobject kobj;
 	struct kobject *holder_dir;
 	unsigned ios[2], sectors[2];	/* READs and WRITEs */
 	int policy, partno;
@@ -125,14 +117,15 @@ struct gendisk {
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
 
@@ -150,6 +143,13 @@ struct gendisk {
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
@@ -411,8 +411,7 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name);
-extern char *disk_name (struct gendisk *hd, int part, char *buf);
+char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
@@ -424,12 +423,12 @@ extern struct gendisk *alloc_disk(int mi
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
@@ -55,6 +55,69 @@ static int __init readwrite(char *str)
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
@@ -66,10 +129,12 @@ __setup("rw", readwrite);
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
@@ -77,6 +142,13 @@ dev_t name_to_dev_t(char *name)
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
@@ -92,7 +164,6 @@ dev_t name_to_dev_t(char *name)
 		}
 		goto done;
 	}
-
 	name += 5;
 	res = Root_NFS;
 	if (strcmp(name, "nfs") == 0)
@@ -107,14 +178,35 @@ dev_t name_to_dev_t(char *name)
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

origin.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
revert-gregkh-driver-block-device.patch
git-dvb-fixup.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int-checkpatch-fixes.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-make-i8259_64-more-_32-like-checkpatch-fixes.patch
git-perfmon-fixup.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
remove-__attribute_used__-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
