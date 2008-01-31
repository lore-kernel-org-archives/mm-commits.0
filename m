From: akpm@linux-foundation.org
Subject: + mm-bdi-export-bdi-attributes-in-sysfs.patch added to -mm tree
Date: Wed, 30 Jan 2008 16:39:47 -0800
Message-ID: <200801310039.m0V0drN7000397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbYAaAkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 19:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, greg@kroah.com, kay.sievers@vrfy.org, mszeredi@suse.cz, trond.myklebust@fys.uio.no


The patch titled
     mm: bdi: export BDI attributes in sysfs
has been added to the -mm tree.  Its filename is
     mm-bdi-export-bdi-attributes-in-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Greg KH <greg@kroah.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   50 +++++++++
 block/genhd.c                             |    3 
 include/linux/backing-dev.h               |    8 +
 include/linux/writeback.h                 |    3 
 lib/percpu_counter.c                      |    1 
 mm/backing-dev.c                          |  108 ++++++++++++++++++++
 mm/page-writeback.c                       |    2 
 mm/readahead.c                            |    8 +
 8 files changed, 181 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-bdi
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -0,0 +1,50 @@
+What:		/sys/class/bdi/<bdi>/
+Date:		January 2008
+Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
+Description:
+
+Provide a place in sysfs for the backing_dev_info object.
+This allows us to see and set the various BDI specific variables.
+
+The <bdi> identifyer can take the following forms:
+
+blk-NAME
+
+	Block devices, NAME is 'sda', 'loop0', etc...
+
+FSTYPE-MAJOR:MINOR
+
+	Non-block device backed filesystems which provide their own
+	BDI, such as NFS and FUSE.  MAJOR:MINOR is the value of st_dev
+	for files on this filesystem.
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
@@ -183,6 +183,8 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, NULL,
+		"blk-%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -191,6 +193,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
diff -puN include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/include/linux/backing-dev.h
@@ -11,6 +11,8 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +50,17 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+	struct device *dev;
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...);
+void bdi_unregister(struct backing_dev_info *bdi);
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
diff -puN include/linux/writeback.h~mm-bdi-export-bdi-attributes-in-sysfs include/linux/writeback.h
--- a/include/linux/writeback.h~mm-bdi-export-bdi-attributes-in-sysfs
+++ a/include/linux/writeback.h
@@ -113,6 +113,9 @@ struct file;
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
@@ -4,12 +4,118 @@
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
+
+	bdi->ra_pages = simple_strtoul(buf, &end, 10) >> (PAGE_SHIFT - 10);
+
+	return end - buf;
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
@@ -33,6 +139,8 @@ void bdi_destroy(struct backing_dev_info
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
lockdep-annotate-epoll.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
