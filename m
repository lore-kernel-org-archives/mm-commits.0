From: akpm@linux-foundation.org
Subject: [merged]
 zram-use-device_attr_-to-define-zram-sys-device-attribute.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:09:01 -0800
Message-ID: <548d0d5d.MWkko+okajbHVYY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaLNEIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use DEVICE_ATTR_[RW|RO|WO] to define zram sys device attribute
has been removed from the -mm tree.  Its filename was
     zram-use-device_attr_-to-define-zram-sys-device-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: zram: use DEVICE_ATTR_[RW|RO|WO] to define zram sys device attribute

In current zram, we use DEVICE_ATTR() to define sys device attributes. 
SO, we need to set (S_IRUGO | S_IWUSR) permission and other arguments
manually.  Linux already provids the macro DEVICE_ATTR_[RW|RO|WO] to
define sys device attribute.  It is simple and readable.

This patch uses kernel defined macro DEVICE_ATTR_[RW|RO|WO] to define
zram device attribute.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-device_attr_-to-define-zram-sys-device-attribute drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-device_attr_-to-define-zram-sys-device-attribute
+++ a/drivers/block/zram/zram_drv.c
@@ -44,15 +44,14 @@ static const char *default_compressor =
 static unsigned int num_devices = 1;
 
 #define ZRAM_ATTR_RO(name)						\
-static ssize_t zram_attr_##name##_show(struct device *d,		\
+static ssize_t name##_show(struct device *d,		\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
 	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
 		(u64)atomic64_read(&zram->stats.name));			\
 }									\
-static struct device_attribute dev_attr_##name =			\
-	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
+static DEVICE_ATTR_RO(name);
 
 static inline int init_done(struct zram *zram)
 {
@@ -994,20 +993,15 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
-static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
-		disksize_show, disksize_store);
-static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
-static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
-static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
-static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
-static DEVICE_ATTR(mem_limit, S_IRUGO | S_IWUSR, mem_limit_show,
-		mem_limit_store);
-static DEVICE_ATTR(mem_used_max, S_IRUGO | S_IWUSR, mem_used_max_show,
-		mem_used_max_store);
-static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
-		max_comp_streams_show, max_comp_streams_store);
-static DEVICE_ATTR(comp_algorithm, S_IRUGO | S_IWUSR,
-		comp_algorithm_show, comp_algorithm_store);
+static DEVICE_ATTR_RW(disksize);
+static DEVICE_ATTR_RO(initstate);
+static DEVICE_ATTR_WO(reset);
+static DEVICE_ATTR_RO(orig_data_size);
+static DEVICE_ATTR_RO(mem_used_total);
+static DEVICE_ATTR_RW(mem_limit);
+static DEVICE_ATTR_RW(mem_used_max);
+static DEVICE_ATTR_RW(max_comp_streams);
+static DEVICE_ATTR_RW(comp_algorithm);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

