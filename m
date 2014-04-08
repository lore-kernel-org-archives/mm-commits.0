From: akpm@linux-foundation.org
Subject: [merged] zram-add-multi-stream-functionality.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:07:41 -0700
Message-ID: <5344651d.icbUVrLLnyGLTkpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHVHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-add-multi-stream-functionality.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:07:41 -0700


The patch titled
     Subject: zram: add multi stream functionality
has been removed from the -mm tree.  Its filename was
     zram-add-multi-stream-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add multi stream functionality

Existing zram (zcomp) implementation has only one compression stream
(buffer and algorithm private part), so in order to prevent data
corruption only one write (compress operation) can use this compression
stream, forcing all concurrent write operations to wait for stream lock to
be released.  This patch changes zcomp to keep a compression streams list
of user-defined size (via sysfs device attr).  Each write operation still
exclusively holds compression stream, the difference is that we can have N
write operations (depending on size of streams list) executing in
parallel.  See TEST section later in commit message for performance data.

Introduce struct zcomp_strm_multi and a set of functions to manage
zcomp_strm stream access.  zcomp_strm_multi has a list of idle zcomp_strm
structs, spinlock to protect idle list and wait queue, making it possible
to perform parallel compressions.

The following set of functions added:
- zcomp_strm_multi_find()/zcomp_strm_multi_release()
  find and release a compression stream, implement required locking
- zcomp_strm_multi_create()/zcomp_strm_multi_destroy()
  create and destroy zcomp_strm_multi

zcomp ->strm_find() and ->strm_release() callbacks are set during
initialisation to zcomp_strm_multi_find()/zcomp_strm_multi_release()
correspondingly.

Each time zcomp issues a zcomp_strm_multi_find() call, the following set
of operations performed:

- spin lock strm_lock
- if idle list is not empty, remove zcomp_strm from idle list, spin
  unlock and return zcomp stream pointer to caller
- if idle list is empty, current adds itself to wait queue. it will be
  awaken by zcomp_strm_multi_release() caller.

zcomp_strm_multi_release():
- spin lock strm_lock
- add zcomp stream to idle list
- spin unlock, wake up sleeper

Minchan Kim reported that spinlock-based locking scheme has demonstrated a
severe perfomance regression for single compression stream case, comparing
to mutex-based (see https://lkml.org/lkml/2014/2/18/16)

base                      spinlock                    mutex

==Initial write           ==Initial write             ==Initial  write
records:  5               records:  5                 records:   5
avg:      1642424.35      avg:      699610.40         avg:       1655583.71
std:      39890.95(2.43%) std:      232014.19(33.16%) std:       52293.96
max:      1690170.94      max:      1163473.45        max:       1697164.75
min:      1568669.52      min:      573429.88         min:       1553410.23
==Rewrite                 ==Rewrite                   ==Rewrite
records:  5               records:  5                 records:   5
avg:      1611775.39      avg:      501406.64         avg:       1684419.11
std:      17144.58(1.06%) std:      15354.41(3.06%)   std:       18367.42
max:      1641800.95      max:      531356.78         max:       1706445.84
min:      1593515.27      min:      488817.78         min:       1655335.73

When only one compression stream available, mutex with spin on owner tends
to perform much better than frequent wait_event()/wake_up().  This is why
single stream implemented as a special case with mutex locking.

Introduce and document zram device attribute max_comp_streams.  This attr
shows and stores current zcomp's max number of zcomp streams (max_strm). 
Extend zcomp's zcomp_create() with `max_strm' parameter.  `max_strm'
limits the number of zcomp_strm structs in compression backend's idle list
(max_comp_streams).

max_comp_streams used during initialisation as follows:
-- passing to zcomp_create() max_strm equals to 1 will initialise zcomp
using single compression stream zcomp_strm_single (mutex-based locking).
-- passing to zcomp_create() max_strm greater than 1 will initialise zcomp
using multi compression stream zcomp_strm_multi (spinlock-based locking).

default max_comp_streams value is 1, meaning that zram with single stream
will be initialised.

Later patch will introduce configuration knob to change max_comp_streams
on already initialised and used zcomp.

TEST
iozone -t 3 -R -r 16K -s 60M -I +Z

       test           base       1 strm (mutex)     3 strm (spinlock)
-----------------------------------------------------------------------
 Initial write      589286.78       583518.39          718011.05
       Rewrite      604837.97       596776.38         1515125.72
  Random write      584120.11       595714.58         1388850.25
        Pwrite      535731.17       541117.38          739295.27
        Fwrite     1418083.88      1478612.72         1484927.06

Usage example:
set max_comp_streams to 4
        echo 4 > /sys/block/zram0/max_comp_streams

show current max_comp_streams (default value is 1).
        cat /sys/block/zram0/max_comp_streams

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    9 +
 Documentation/blockdev/zram.txt            |   31 +++-
 drivers/block/zram/zcomp.c                 |  124 ++++++++++++++++++-
 drivers/block/zram/zcomp.h                 |    4 
 drivers/block/zram/zram_drv.c              |   42 ++++++
 drivers/block/zram/zram_drv.h              |    2 
 6 files changed, 201 insertions(+), 11 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-add-multi-stream-functionality Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-add-multi-stream-functionality
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -50,7 +50,6 @@ Description:
 		The failed_reads file is read-only and specifies the number of
 		failed reads happened on this device.
 
-
 What:		/sys/block/zram<id>/failed_writes
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
@@ -58,6 +57,14 @@ Description:
 		The failed_writes file is read-only and specifies the number of
 		failed writes happened on this device.
 
+What:		/sys/block/zram<id>/max_comp_streams
+Date:		February 2014
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The max_comp_streams file is read-write and specifies the
+		number of backend's zcomp_strm compression streams (number of
+		concurrent compress operations).
+
 What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
diff -puN Documentation/blockdev/zram.txt~zram-add-multi-stream-functionality Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-multi-stream-functionality
+++ a/Documentation/blockdev/zram.txt
@@ -21,7 +21,28 @@ Following shows a typical sequence of st
 	This creates 4 devices: /dev/zram{0,1,2,3}
 	(num_devices parameter is optional. Default: 1)
 
-2) Set Disksize
+2) Set max number of compression streams
+	Compression backend may use up to max_comp_streams compression streams,
+	thus allowing up to max_comp_streams concurrent compression operations.
+	By default, compression backend uses single compression stream.
+
+	Examples:
+	#show max compression streams number
+	cat /sys/block/zram0/max_comp_streams
+
+	#set max compression streams number to 3
+	echo 3 > /sys/block/zram0/max_comp_streams
+
+Note:
+In order to enable compression backend's multi stream support max_comp_streams
+must be initially set to desired concurrency level before ZRAM device
+initialisation. Once the device initialised as a single stream compression
+backend (max_comp_streams equals to 0) changing the value of max_comp_streams
+will not take any effect, because single stream compression backend implemented
+as a special case and does not support dynamic max_comp_streams. Only multi
+stream backend supports dynamic max_comp_streams adjustment.
+
+3) Set Disksize
         Set disk size by writing the value to sysfs node 'disksize'.
         The value can be either in bytes or you can use mem suffixes.
         Examples:
@@ -38,14 +59,14 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-3) Activate:
+4) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
 
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-4) Stats:
+5) Stats:
 	Per-device statistics are exported as various nodes under
 	/sys/block/zram<id>/
 		disksize
@@ -60,11 +81,11 @@ size of the disk when not in use so a hu
 		compr_data_size
 		mem_used_total
 
-5) Deactivate:
+6) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-6) Reset:
+7) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
diff -puN drivers/block/zram/zcomp.c~zram-add-multi-stream-functionality drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-multi-stream-functionality
+++ a/drivers/block/zram/zcomp.c
@@ -24,6 +24,21 @@ struct zcomp_strm_single {
 	struct zcomp_strm *zstrm;
 };
 
+/*
+ * multi zcomp_strm backend
+ */
+struct zcomp_strm_multi {
+	/* protect strm list */
+	spinlock_t strm_lock;
+	/* max possible number of zstrm streams */
+	int max_strm;
+	/* number of available zstrm streams */
+	int avail_strm;
+	/* list of available strms */
+	struct list_head idle_strm;
+	wait_queue_head_t strm_wait;
+};
+
 static struct zcomp_backend *find_backend(const char *compress)
 {
 	if (strncmp(compress, "lzo", 3) == 0)
@@ -62,6 +77,107 @@ static struct zcomp_strm *zcomp_strm_all
 	return zstrm;
 }
 
+/*
+ * get idle zcomp_strm or wait until other process release
+ * (zcomp_strm_release()) one for us
+ */
+static struct zcomp_strm *zcomp_strm_multi_find(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	while (1) {
+		spin_lock(&zs->strm_lock);
+		if (!list_empty(&zs->idle_strm)) {
+			zstrm = list_entry(zs->idle_strm.next,
+					struct zcomp_strm, list);
+			list_del(&zstrm->list);
+			spin_unlock(&zs->strm_lock);
+			return zstrm;
+		}
+		/* zstrm streams limit reached, wait for idle stream */
+		if (zs->avail_strm >= zs->max_strm) {
+			spin_unlock(&zs->strm_lock);
+			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
+			continue;
+		}
+		/* allocate new zstrm stream */
+		zs->avail_strm++;
+		spin_unlock(&zs->strm_lock);
+
+		zstrm = zcomp_strm_alloc(comp);
+		if (!zstrm) {
+			spin_lock(&zs->strm_lock);
+			zs->avail_strm--;
+			spin_unlock(&zs->strm_lock);
+			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
+			continue;
+		}
+		break;
+	}
+	return zstrm;
+}
+
+/* add stream back to idle list and wake up waiter or free the stream */
+static void zcomp_strm_multi_release(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+
+	spin_lock(&zs->strm_lock);
+	if (zs->avail_strm <= zs->max_strm) {
+		list_add(&zstrm->list, &zs->idle_strm);
+		spin_unlock(&zs->strm_lock);
+		wake_up(&zs->strm_wait);
+		return;
+	}
+
+	zs->avail_strm--;
+	spin_unlock(&zs->strm_lock);
+	zcomp_strm_free(comp, zstrm);
+}
+
+static void zcomp_strm_multi_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	while (!list_empty(&zs->idle_strm)) {
+		zstrm = list_entry(zs->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+	}
+	kfree(zs);
+}
+
+static int zcomp_strm_multi_create(struct zcomp *comp, int max_strm)
+{
+	struct zcomp_strm *zstrm;
+	struct zcomp_strm_multi *zs;
+
+	comp->destroy = zcomp_strm_multi_destroy;
+	comp->strm_find = zcomp_strm_multi_find;
+	comp->strm_release = zcomp_strm_multi_release;
+	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
+	if (!zs)
+		return -ENOMEM;
+
+	comp->stream = zs;
+	spin_lock_init(&zs->strm_lock);
+	INIT_LIST_HEAD(&zs->idle_strm);
+	init_waitqueue_head(&zs->strm_wait);
+	zs->max_strm = max_strm;
+	zs->avail_strm = 1;
+
+	zstrm = zcomp_strm_alloc(comp);
+	if (!zstrm) {
+		kfree(zs);
+		return -ENOMEM;
+	}
+	list_add(&zstrm->list, &zs->idle_strm);
+	return 0;
+}
+
 static struct zcomp_strm *zcomp_strm_single_find(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -139,7 +255,7 @@ void zcomp_destroy(struct zcomp *comp)
  * if requested algorithm is not supported or in case
  * of init error
  */
-struct zcomp *zcomp_create(const char *compress)
+struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
 	struct zcomp *comp;
 	struct zcomp_backend *backend;
@@ -153,7 +269,11 @@ struct zcomp *zcomp_create(const char *c
 		return NULL;
 
 	comp->backend = backend;
-	if (zcomp_strm_single_create(comp) != 0) {
+	if (max_strm > 1)
+		zcomp_strm_multi_create(comp, max_strm);
+	else
+		zcomp_strm_single_create(comp);
+	if (!comp->stream) {
 		kfree(comp);
 		return NULL;
 	}
diff -puN drivers/block/zram/zcomp.h~zram-add-multi-stream-functionality drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-add-multi-stream-functionality
+++ a/drivers/block/zram/zcomp.h
@@ -21,6 +21,8 @@ struct zcomp_strm {
 	 * working memory)
 	 */
 	void *private;
+	/* used in multi stream backend, protected by backend strm_lock */
+	struct list_head list;
 };
 
 /* static compression backend */
@@ -47,7 +49,7 @@ struct zcomp {
 	void (*destroy)(struct zcomp *comp);
 };
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *comp, int max_strm);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
diff -puN drivers/block/zram/zram_drv.c~zram-add-multi-stream-functionality drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-multi-stream-functionality
+++ a/drivers/block/zram/zram_drv.c
@@ -108,6 +108,40 @@ static ssize_t mem_used_total_show(struc
 	return sprintf(buf, "%llu\n", val);
 }
 
+static ssize_t max_comp_streams_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->max_comp_streams;
+	up_read(&zram->init_lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t max_comp_streams_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int num;
+	struct zram *zram = dev_to_zram(dev);
+
+	if (kstrtoint(buf, 0, &num))
+		return -EINVAL;
+	if (num < 1)
+		return -EINVAL;
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		pr_info("Can't set max_comp_streams for initialized device\n");
+		return -EBUSY;
+	}
+	zram->max_comp_streams = num;
+	up_write(&zram->init_lock);
+	return len;
+}
+
 /* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -502,6 +536,8 @@ static void zram_reset_device(struct zra
 	}
 
 	zcomp_destroy(zram->comp);
+	zram->max_comp_streams = 1;
+
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -537,7 +573,7 @@ static ssize_t disksize_store(struct dev
 		goto out_free_meta;
 	}
 
-	zram->comp = zcomp_create(default_compressor);
+	zram->comp = zcomp_create(default_compressor, zram->max_comp_streams);
 	if (!zram->comp) {
 		pr_info("Cannot initialise %s compressing backend\n",
 				default_compressor);
@@ -698,6 +734,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, i
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
+		max_comp_streams_show, max_comp_streams_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -722,6 +760,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_max_comp_streams.attr,
 	NULL,
 };
 
@@ -784,6 +823,7 @@ static int create_device(struct zram *zr
 	}
 
 	zram->meta = NULL;
+	zram->max_comp_streams = 1;
 	return 0;
 
 out_free_disk:
diff -puN drivers/block/zram/zram_drv.h~zram-add-multi-stream-functionality drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-add-multi-stream-functionality
+++ a/drivers/block/zram/zram_drv.h
@@ -99,7 +99,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
