From: akpm@osdl.org
Subject: - fault-injection-capability-for-disk-io.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:19 -0800
Message-ID: <200612082011.kB8KBJF9002894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946599AbWLHULZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@suse.de, mm-commits@vger.kernel.org


The patch titled
     fault-injection capability for disk IO
has been removed from the -mm tree.  Its filename was
     fault-injection-capability-for-disk-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection capability for disk IO
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides fault-injection capability for disk IO.

Boot option:

fail_make_request=<probability>,<interval>,<space>,<times>

	<interval> -- specifies the interval of failures.

	<probability> -- specifies how often it should fail in percent.

	<space> -- specifies the size of free space where disk IO can be issued
		   safely in bytes.

	<times> -- specifies how many times failures may happen at most.

Debugfs:

/debug/fail_make_request/interval
/debug/fail_make_request/probability
/debug/fail_make_request/specifies
/debug/fail_make_request/times

Example:

	fail_make_request=10,100,0,-1
	echo 1 > /sys/blocks/hda/hda1/make-it-fail

generic_make_request() on /dev/hda1 fails once per 10 times.

Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/genhd.c         |   31 +++++++++++++++++++++++++++++++
 block/ll_rw_blk.c     |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c |   27 +++++++++++++++++++++++++++
 include/linux/genhd.h |    4 ++++
 lib/Kconfig.debug     |    7 +++++++
 5 files changed, 109 insertions(+)

diff -puN block/genhd.c~fault-injection-capability-for-disk-io block/genhd.c
--- a/block/genhd.c~fault-injection-capability-for-disk-io
+++ a/block/genhd.c
@@ -417,6 +417,34 @@ static struct disk_attribute disk_attr_s
 	.show	= disk_stats_read
 };
 
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+
+static ssize_t disk_fail_store(struct gendisk * disk,
+			       const char *buf, size_t count)
+{
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
+		if (i == 0)
+			disk->flags &= ~GENHD_FL_FAIL;
+		else
+			disk->flags |= GENHD_FL_FAIL;
+	}
+
+	return count;
+}
+static ssize_t disk_fail_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
+}
+static struct disk_attribute disk_attr_fail = {
+	.attr = {.name = "make-it-fail", .mode = S_IRUGO | S_IWUSR },
+	.store	= disk_fail_store,
+	.show	= disk_fail_read
+};
+
+#endif
+
 static struct attribute * default_attrs[] = {
 	&disk_attr_uevent.attr,
 	&disk_attr_dev.attr,
@@ -424,6 +452,9 @@ static struct attribute * default_attrs[
 	&disk_attr_removable.attr,
 	&disk_attr_size.attr,
 	&disk_attr_stat.attr,
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	&disk_attr_fail.attr,
+#endif
 	NULL,
 };
 
diff -puN block/ll_rw_blk.c~fault-injection-capability-for-disk-io block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~fault-injection-capability-for-disk-io
+++ a/block/ll_rw_blk.c
@@ -28,6 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/blktrace_api.h>
+#include <linux/fault-inject.h>
 
 /*
  * for max sense size
@@ -3056,6 +3057,42 @@ static void handle_bad_sector(struct bio
 	set_bit(BIO_EOF, &bio->bi_flags);
 }
 
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_make_request);
+
+static int __init setup_fail_make_request(char *str)
+{
+	return setup_fault_attr(&fail_make_request, str);
+}
+__setup("fail_make_request=", setup_fail_make_request);
+
+static int should_fail_request(struct bio *bio)
+{
+	if ((bio->bi_bdev->bd_disk->flags & GENHD_FL_FAIL) ||
+	    (bio->bi_bdev->bd_part && bio->bi_bdev->bd_part->make_it_fail))
+		return should_fail(&fail_make_request, bio->bi_size);
+
+	return 0;
+}
+
+static int __init fail_make_request_debugfs(void)
+{
+	return init_fault_attr_dentries(&fail_make_request,
+					"fail_make_request");
+}
+
+late_initcall(fail_make_request_debugfs);
+
+#else /* CONFIG_FAIL_MAKE_REQUEST */
+
+static inline int should_fail_request(struct bio *bio)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FAIL_MAKE_REQUEST */
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3141,6 +3178,9 @@ end_io:
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
 
+		if (should_fail_request(bio))
+			goto end_io;
+
 		/*
 		 * If this device has partitions, remap block n
 		 * of partition p to block n+start(p) of the disk.
diff -puN fs/partitions/check.c~fault-injection-capability-for-disk-io fs/partitions/check.c
--- a/fs/partitions/check.c~fault-injection-capability-for-disk-io
+++ a/fs/partitions/check.c
@@ -276,12 +276,39 @@ static struct part_attribute part_attr_s
 	.show	= part_stat_read
 };
 
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+
+static ssize_t part_fail_store(struct hd_struct * p,
+			       const char *buf, size_t count)
+{
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0)
+		p->make_it_fail = (i == 0) ? 0 : 1;
+
+	return count;
+}
+static ssize_t part_fail_read(struct hd_struct * p, char *page)
+{
+	return sprintf(page, "%d\n", p->make_it_fail);
+}
+static struct part_attribute part_attr_fail = {
+	.attr = {.name = "make-it-fail", .mode = S_IRUGO | S_IWUSR },
+	.store	= part_fail_store,
+	.show	= part_fail_read
+};
+
+#endif
+
 static struct attribute * default_attrs[] = {
 	&part_attr_uevent.attr,
 	&part_attr_dev.attr,
 	&part_attr_start.attr,
 	&part_attr_size.attr,
 	&part_attr_stat.attr,
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	&part_attr_fail.attr,
+#endif
 	NULL,
 };
 
diff -puN include/linux/genhd.h~fault-injection-capability-for-disk-io include/linux/genhd.h
--- a/include/linux/genhd.h~fault-injection-capability-for-disk-io
+++ a/include/linux/genhd.h
@@ -83,6 +83,9 @@ struct hd_struct {
 	struct kobject *holder_dir;
 	unsigned ios[2], sectors[2];	/* READs and WRITEs */
 	int policy, partno;
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	int make_it_fail;
+#endif
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -90,6 +93,7 @@ struct hd_struct {
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
+#define GENHD_FL_FAIL				64
 
 struct disk_stats {
 	unsigned long sectors[2];	/* READs and WRITEs */
diff -puN lib/Kconfig.debug~fault-injection-capability-for-disk-io lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-capability-for-disk-io
+++ a/lib/Kconfig.debug
@@ -431,6 +431,13 @@ config FAIL_PAGE_ALLOC
 	help
 	  This option provides fault-injection capabilitiy for alloc_pages().
 
+config FAIL_MAKE_REQUEST
+	bool "Fault-injection capabilitiy for disk IO"
+	depends on DEBUG_KERNEL
+	select FAULT_INJECTION
+	help
+	  This option provides fault-injection capabilitiy to disk IO.
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

