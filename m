From: akpm@linux-foundation.org
Subject: + zram-use-scnprintf-in-attrs-show-methods.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 12:40:46 -0700
Message-ID: <531e153e.Yphi/jcZswzsHVRJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaCJTkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-use-scnprintf-in-attrs-show-methods.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:40:46 -0700


The patch titled
     Subject: zram: use scnprintf() in attrs show() methods
has been added to the -mm tree.  Its filename is
     zram-use-scnprintf-in-attrs-show-methods.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-scnprintf-in-attrs-show-methods.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-scnprintf-in-attrs-show-methods.patch

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
@@ -274,12 +274,14 @@ ssize_t zcomp_available_show(const char
 
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
@@ -47,7 +47,7 @@ static ssize_t zram_attr_##name##_show(s
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
-	return sprintf(b, "%llu\n",					\
+	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
 		(u64)atomic64_read(&zram->stats.name));			\
 }									\
 static struct device_attribute dev_attr_##name =			\
@@ -68,7 +68,7 @@ static ssize_t disksize_show(struct devi
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n", zram->disksize);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
 }
 
 static ssize_t initstate_show(struct device *dev,
@@ -81,7 +81,7 @@ static ssize_t initstate_show(struct dev
 	val = init_done(zram);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%u\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -89,7 +89,7 @@ static ssize_t orig_data_size_show(struc
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
@@ -105,7 +105,7 @@ static ssize_t mem_used_total_show(struc
 		val = zs_get_total_size_bytes(meta->mem_pool);
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%llu\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
 }
 
 static ssize_t max_comp_streams_show(struct device *dev,
@@ -118,7 +118,7 @@ static ssize_t max_comp_streams_show(str
 	val = zram->max_comp_streams;
 	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%d\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
 static ssize_t max_comp_streams_store(struct device *dev,
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
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user.patch
zram-use-scnprintf-in-attrs-show-methods.patch
linux-next.patch

