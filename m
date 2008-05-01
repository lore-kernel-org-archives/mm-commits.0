From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi-attributes-in-sysfs.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:38 -0700
Message-ID: <200805010931.m419Vcu6030890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757994AbYEAJby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, greg@kroah.com, kay.sievers@vrfy.org, mszeredi@suse.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: export BDI attributes in sysfs
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi-attributes-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: export BDI attributes in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide a place in sysfs (/sys/class/bdi) for the backing_dev_info object. 
This allows us to see and set the various BDI specific variables.

In particular this properly exposes the read-ahead window for all relevant
users and /sys/block/<block>/queue/read_ahead_kb should be deprecated.

With patient help from Kay Sievers and Greg KH

[mszeredi@suse.cz]

 - split off NFS and FUSE changes into separate patches
 - document new sysfs attributes under Documentation/ABI
 - do bdi_class_init as a core_initcall, otherwise the "default" BDI
   won't be initialized
 - remove bdi_init_fmt macro, it's not used very much

[akpm@linux-foundation.org: fix ia64 warning]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Greg KH <greg@kroah.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   46 +++++++
 block/genhd.c                             |    8 +
 include/linux/backing-dev.h               |    9 +
 include/linux/writeback.h                 |    3 
 lib/percpu_counter.c                      |    1 
 mm/backing-dev.c                          |  119 ++++++++++++++++++++
 mm/page-writeback.c                       |    2 
 mm/readahead.c                            |    8 +
 8 files changed, 194 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-bdi
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -0,0 +1,46 @@
+What:		/sys/class/bdi/<bdi>/
+Date:		January 2008
+Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
+Description:
+
+Provide a place in sysfs for the backing_dev_info object.
+This allows us to see and set the various BDI specific variables.
+
+The <bdi> identifier can be either of the following:
+
+MAJOR:MINOR
+
+	Device number for block devices, or value of st_dev on
+	non-block filesystems which provide their own BDI, such as NFS
+	and FUSE.
+
+default
+
+	The default backing dev, used for non-block device backed
+	filesystems which do not provide their own BDI.
+
+Files under /sys/class/bdi/<bdi>/
+---------------------------------
+
+read_ahead_kb (read-write)
+
+	Size of the read-ahead window in kilobytes
+
+reclaimable_kb (read-only)
+
+	Reclaimable (dirty or unstable) memory destined for writeback
+	to this device
+
+writeback_kb (read-only)
+
+	Memory currently under writeback to this device
+
+dirty_kb (read-only)
+
+	Global threshold for reclaimable + writeback memory
+
+bdi_dirty_kb (read-only)
+
+	Current threshold on this BDI for reclaimable + writeback
+	memory
+
diff -puN block/genhd.c~mm-bdi-export-bdi-attributes-in-sysfs block/genhd.c
--- a/block/genhd.c~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/block/genhd.c
@@ -182,11 +182,17 @@ static int exact_lock(dev_t devt, void *
  */
 void add_disk(struct gendisk *disk)
 {
+	struct backing_dev_info *bdi;
+
 	disk->flags |= GENHD_FL_UP;
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+
+	bdi = &disk->queue->backing_dev_info;
+	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
+	sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -194,6 +200,8 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 
 void unlink_gendisk(struct gendisk *disk)
 {
+	sysfs_remove_link(&disk->dev.kobj, "bdi");
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
diff -puN include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/include/linux/backing-dev.h
@@ -11,9 +11,11 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 struct page;
+struct device;
 
 /*
  * Bits in backing_dev_info.state
@@ -48,11 +50,18 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+	struct device *dev;
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...);
+int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
+void bdi_unregister(struct backing_dev_info *bdi);
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
diff -puN include/linux/writeback.h~mm-bdi-export-bdi-attributes-in-sysfs include/linux/writeback.h
--- a/include/linux/writeback.h~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/include/linux/writeback.h
@@ -114,6 +114,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
diff -puN lib/percpu_counter.c~mm-bdi-export-bdi-attributes-in-sysfs lib/percpu_counter.c
--- a/lib/percpu_counter.c~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/lib/percpu_counter.c
@@ -102,6 +102,7 @@ void percpu_counter_destroy(struct percp
 		return;
 
 	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
diff -puN mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/mm/backing-dev.c
@@ -4,12 +4,129 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/device.h>
+
+
+static struct class *bdi_class;
+
+static ssize_t read_ahead_kb_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+	unsigned long read_ahead_kb;
+	ssize_t ret = -EINVAL;
+
+	read_ahead_kb = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
+		ret = count;
+	}
+	return ret;
+}
+
+#define K(pages) ((pages) << (PAGE_SHIFT - 10))
+
+#define BDI_SHOW(name, expr)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
+									\
+	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+}
+
+BDI_SHOW(read_ahead_kb, K(bdi->ra_pages))
+
+BDI_SHOW(reclaimable_kb, K(bdi_stat(bdi, BDI_RECLAIMABLE)))
+BDI_SHOW(writeback_kb, K(bdi_stat(bdi, BDI_WRITEBACK)))
+
+static inline unsigned long get_dirty(struct backing_dev_info *bdi, int i)
+{
+	unsigned long thresh[3];
+
+	get_dirty_limits(&thresh[0], &thresh[1], &thresh[2], bdi);
+
+	return thresh[i];
+}
+
+BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
+BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
+static struct device_attribute bdi_dev_attrs[] = {
+	__ATTR_RW(read_ahead_kb),
+	__ATTR_RO(reclaimable_kb),
+	__ATTR_RO(writeback_kb),
+	__ATTR_RO(dirty_kb),
+	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_NULL,
+};
+
+static __init int bdi_class_init(void)
+{
+	bdi_class = class_create(THIS_MODULE, "bdi");
+	bdi_class->dev_attrs = bdi_dev_attrs;
+	return 0;
+}
+
+core_initcall(bdi_class_init);
+
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...)
+{
+	char *name;
+	va_list args;
+	int ret = 0;
+	struct device *dev;
+
+	va_start(args, fmt);
+	name = kvasprintf(GFP_KERNEL, fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	dev = device_create(bdi_class, parent, MKDEV(0, 0), name);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto exit;
+	}
+
+	bdi->dev = dev;
+	dev_set_drvdata(bdi->dev, bdi);
+
+exit:
+	kfree(name);
+	return ret;
+}
+EXPORT_SYMBOL(bdi_register);
+
+int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
+{
+	return bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
+}
+EXPORT_SYMBOL(bdi_register_dev);
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	if (bdi->dev) {
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+}
+EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i;
 	int err;
 
+	bdi->dev = NULL;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +150,8 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	bdi_unregister(bdi);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
diff -puN mm/page-writeback.c~mm-bdi-export-bdi-attributes-in-sysfs mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/mm/page-writeback.c
@@ -300,7 +300,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
diff -puN mm/readahead.c~mm-bdi-export-bdi-attributes-in-sysfs mm/readahead.c
--- a/mm/readahead.c~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/mm/readahead.c
@@ -235,7 +235,13 @@ unsigned long max_sane_readahead(unsigne
 
 static int __init readahead_init(void)
 {
-	return bdi_init(&default_backing_dev_info);
+	int err;
+
+	err = bdi_init(&default_backing_dev_info);
+	if (!err)
+		bdi_register(&default_backing_dev_info, NULL, "default");
+
+	return err;
 }
 subsys_initcall(readahead_init);
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
git-sched.patch
mutex-debug-check-mutex-magic-before-owner.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch

