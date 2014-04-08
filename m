From: akpm@linux-foundation.org
Subject: [merged] zram-use-scnprintf-in-attrs-show-methods.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:11:25 -0700
Message-ID: <534465fd.M9TGhyhFYyqnXBtQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaDHVLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-use-scnprintf-in-attrs-show-methods.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:11:25 -0700


The patch titled
     Subject: zram: use scnprintf() in attrs show() methods
has been removed from the -mm tree.  Its filename was
     zram-use-scnprintf-in-attrs-show-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use scnprintf() in attrs show() methods

sysfs.txt documentation lists the following requirements:

 - The buffer will always be PAGE_SIZE bytes in length. On i386, this
   is 4096.

 - show() methods should return the number of bytes printed into the
   buffer. This is the return value of scnprintf().

 - show() should always use scnprintf().

Use scnprintf() in show() functions.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    8 +++++---
 drivers/block/zram/zram_drv.c |   12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-use-scnprintf-in-attrs-show-methods drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-use-scnprintf-in-attrs-show-methods
+++ a/drivers/block/zram/zcomp.c
@@ -275,12 +275,14 @@ ssize_t zcomp_available_show(const char
 
 	while (backends[i]) {
 		if (sysfs_streq(comp, backends[i]->name))
-			sz += sprintf(buf + sz, "[%s] ", backends[i]->name);
+			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
+					"[%s] ", backends[i]->name);
 		else
-			sz += sprintf(buf + sz, "%s ", backends[i]->name);
+			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
+					"%s ", backends[i]->name);
 		i++;
 	}
-	sz += sprintf(buf + sz, "\n");
+	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
 	return sz;
 }
 
diff -puN drivers/block/zram/zram_drv.c~zram-use-scnprintf-in-attrs-show-methods drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-scnprintf-in-attrs-show-methods
+++ a/drivers/block/zram/zram_drv.c
@@ -48,7 +48,7 @@ static ssize_t zram_attr_##name##_show(s
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
-	return sprintf(b, "%llu\n",					\
+	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
 		(u64)atomic64_read(&zram->stats.name));			\
 }									\
 static struct device_attribute dev_attr_##name =			\
@@ -69,7 +69,7 @@ static ssize_t disksize_show(struct devi
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n", zram->disksize);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
 }
 
 static ssize_t initstate_show(struct device *dev,
@@ -82,7 +82,7 @@ static ssize_t initstate_show(struct dev
 	val = init_done(zram);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%u\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -90,7 +90,7 @@ static ssize_t orig_data_size_show(struc
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
@@ -106,7 +106,7 @@ static ssize_t mem_used_total_show(struc
 		val = zs_get_total_size_bytes(meta->mem_pool);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%llu\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
 }
 
 static ssize_t max_comp_streams_show(struct device *dev,
@@ -119,7 +119,7 @@ static ssize_t max_comp_streams_show(str
 	val = zram->max_comp_streams;
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%d\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
 static ssize_t max_comp_streams_store(struct device *dev,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

