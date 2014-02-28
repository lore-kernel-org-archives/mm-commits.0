From: akpm@linux-foundation.org
Subject: + zram-make-compression-algorithm-selection-possible.patch added
 to -mm tree
Date: Fri, 28 Feb 2014 15:52:41 -0800
Message-ID: <53112149.BOR473fBtdmCrt2i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaB1Xwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-make-compression-algorithm-selection-possible.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:52:41 -0800


The patch titled
     Subject: zram: make compression algorithm selection possible
has been added to the -mm tree.  Its filename is
     zram-make-compression-algorithm-selection-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-make-compression-algorithm-selection-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-make-compression-algorithm-selection-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: make compression algorithm selection possible

Add and document `comp_algorithm' device attribute.  This attribute allows
to show supported compression and currently selected compression
algorithms:

	cat /sys/block/zram0/comp_algorithm
	[lzo] lz4

and change selected compression algorithm:
	echo lzo > /sys/block/zram0/comp_algorithm

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    8 ++++
 Documentation/blockdev/zram.txt            |   24 +++++++++---
 drivers/block/zram/zcomp.c                 |   32 ++++++++++++++--
 drivers/block/zram/zcomp.h                 |    2 +
 drivers/block/zram/zram_drv.c              |   37 +++++++++++++++++--
 drivers/block/zram/zram_drv.h              |    1 
 6 files changed, 93 insertions(+), 11 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-make-compression-algorithm-selection-possible Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-make-compression-algorithm-selection-possible
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -65,6 +65,14 @@ Description:
 		number of backend's zcomp_strm compression streams (number of
 		concurrent compress operations).
 
+What:		/sys/block/zram<id>/comp_algorithm
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The comp_algorithm file is read-write and lets to show
+		available and selected compression algorithms, change
+		compression algorithm selection.
+
 What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
diff -puN Documentation/blockdev/zram.txt~zram-make-compression-algorithm-selection-possible Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-make-compression-algorithm-selection-possible
+++ a/Documentation/blockdev/zram.txt
@@ -42,7 +42,21 @@ will not take any effect, because single
 as a special case and does not support dynamic max_comp_streams. Only multi
 stream backend supports dynamic max_comp_streams adjustment.
 
-3) Set Disksize
+3) Select compression algorithm
+	Using comp_algorithm device attribute one can see available and
+	currently selected (shown in square brackets) compression algortithms,
+	change selected compression algorithm (once the device is initialised
+	there is no way to change compression algorithm).
+
+	Examples:
+	#show supported compression algorithms
+	cat /sys/block/zram0/comp_algorithm
+	lzo [lz4]
+
+	#select lzo compression algorithm
+	echo lzo > /sys/block/zram0/comp_algorithm
+
+4) Set Disksize
         Set disk size by writing the value to sysfs node 'disksize'.
         The value can be either in bytes or you can use mem suffixes.
         Examples:
@@ -59,14 +73,14 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-4) Activate:
+5) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
 
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-5) Stats:
+6) Stats:
 	Per-device statistics are exported as various nodes under
 	/sys/block/zram<id>/
 		disksize
@@ -81,11 +95,11 @@ size of the disk when not in use so a hu
 		compr_data_size
 		mem_used_total
 
-6) Deactivate:
+7) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-7) Reset:
+8) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
diff -puN drivers/block/zram/zcomp.c~zram-make-compression-algorithm-selection-possible drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-make-compression-algorithm-selection-possible
+++ a/drivers/block/zram/zcomp.c
@@ -39,11 +39,20 @@ struct zcomp_strm_multi {
 	wait_queue_head_t strm_wait;
 };
 
+static struct zcomp_backend *backends[] = {
+	&zcomp_lzo,
+	NULL
+};
+
 static struct zcomp_backend *find_backend(const char *compress)
 {
-	if (strncmp(compress, "lzo", 3) == 0)
-		return &zcomp_lzo;
-	return NULL;
+	int i = 0;
+	while (backends[i]) {
+		if (sysfs_streq(compress, backends[i]->name))
+			break;
+		i++;
+	}
+	return backends[i];
 }
 
 static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
@@ -251,6 +260,23 @@ static int zcomp_strm_single_create(stru
 	return 0;
 }
 
+/* show available compressors */
+ssize_t zcomp_available_show(const char *comp, char *buf)
+{
+	ssize_t sz = 0;
+	int i = 0;
+
+	while (backends[i]) {
+		if (sysfs_streq(comp, backends[i]->name))
+			sz += sprintf(buf + sz, "[%s] ", backends[i]->name);
+		else
+			sz += sprintf(buf + sz, "%s ", backends[i]->name);
+		i++;
+	}
+	sz += sprintf(buf + sz, "\n");
+	return sz;
+}
+
 int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	return comp->set_max_streams(comp, num_strm);
diff -puN drivers/block/zram/zcomp.h~zram-make-compression-algorithm-selection-possible drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-make-compression-algorithm-selection-possible
+++ a/drivers/block/zram/zcomp.h
@@ -50,6 +50,8 @@ struct zcomp {
 	void (*destroy)(struct zcomp *comp);
 };
 
+ssize_t zcomp_available_show(const char *comp, char *buf);
+
 struct zcomp *zcomp_create(const char *comp, int max_strm);
 void zcomp_destroy(struct zcomp *comp);
 
diff -puN drivers/block/zram/zram_drv.c~zram-make-compression-algorithm-selection-possible drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-compression-algorithm-selection-possible
+++ a/drivers/block/zram/zram_drv.c
@@ -141,6 +141,34 @@ static ssize_t max_comp_streams_store(st
 	return len;
 }
 
+static ssize_t comp_algorithm_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	size_t sz;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	sz = zcomp_available_show(zram->compressor, buf);
+	up_read(&zram->init_lock);
+
+	return sz;
+}
+
+static ssize_t comp_algorithm_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		pr_info("Can't change algorithm for initialized device\n");
+		return -EBUSY;
+	}
+	strlcpy(zram->compressor, buf, sizeof(zram->compressor));
+	up_write(&zram->init_lock);
+	return len;
+}
+
 /* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -565,11 +593,11 @@ static ssize_t disksize_store(struct dev
 		return -EBUSY;
 	}
 
-	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
+	zram->comp = zcomp_create(zram->compressor, zram->max_comp_streams);
 	if (!zram->comp) {
 		up_write(&zram->init_lock);
 		pr_info("Cannot initialise %s compressing backend\n",
-				default_compressor);
+				zram->compressor);
 		return -EINVAL;
 	}
 
@@ -730,6 +758,8 @@ static DEVICE_ATTR(orig_data_size, S_IRU
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
 static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
 		max_comp_streams_show, max_comp_streams_store);
+static DEVICE_ATTR(comp_algorithm, S_IRUGO | S_IWUSR,
+		comp_algorithm_show, comp_algorithm_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -755,6 +785,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
 	&dev_attr_max_comp_streams.attr,
+	&dev_attr_comp_algorithm.attr,
 	NULL,
 };
 
@@ -815,7 +846,7 @@ static int create_device(struct zram *zr
 		pr_warn("Error creating sysfs group");
 		goto out_free_disk;
 	}
-
+	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
 	zram->max_comp_streams = 1;
 	return 0;
diff -puN drivers/block/zram/zram_drv.h~zram-make-compression-algorithm-selection-possible drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-make-compression-algorithm-selection-possible
+++ a/drivers/block/zram/zram_drv.h
@@ -101,5 +101,6 @@ struct zram {
 	u64 disksize;	/* bytes */
 	int max_comp_streams;
 	struct zram_stats stats;
+	char compressor[10];
 };
 #endif
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch

