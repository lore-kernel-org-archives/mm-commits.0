Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC9C2E0939
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 02:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851603; cv=none; b=mqe0CAwZkKFs/HWDtEdfOOKmeRsBTMBnvqOU297CPiyNKa02aP7YMamR7SlavnoCvQq1fxixau6teL56Y6onnmELu/SN3WUbYyKffC1hocti5jj8BThgTEvBJ+6AkSRcbSS8/ukRM4mM4fM17lBSBGHnVRF+zgY54s18YpDgF8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851603; c=relaxed/simple;
	bh=yjVwAV93NdqeVad9NWbRiDYBQbt7eVY3FmBgyGSFsZI=;
	h=Date:To:From:Subject:Message-Id; b=p6LCkqC95R5ORRADdQfaxQuiRWzxb4wspfCtnEFZYTACnmVqpDMhSkOmqNTJm3RafTvceg9S1wokMVOAjNHXAxA79dpCLO84HP3KoZ4Fg7mxkvhitSyz/USKHwRNmxesUYjppsR+nKdFlGLBp0A6uujIiHmiHtqyWq6aQJ33/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OnELZwDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OnELZwDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA0BC4CEF5;
	Tue, 16 Dec 2025 02:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765851602;
	bh=yjVwAV93NdqeVad9NWbRiDYBQbt7eVY3FmBgyGSFsZI=;
	h=Date:To:From:Subject:From;
	b=OnELZwDLlSnZP/75EFz8keD1Zh6h6jKqSGBBMyJwewyJVR2qXRGH48cFh20exNJ05
	 dVf0r6AaiYxf/V2FpU8niF1JpFvdObTlkq9rijiQ3PomTOn53fl1laCg+avygEia4a
	 jKUKsQKu/Jl5+ibQBJ3DPvClOq5PbUvrXdx9vRhI=
Date: Mon, 15 Dec 2025 18:20:02 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-bd_stat-to-writeback-section.patch added to mm-new branch
Message-Id: <20251216022002.AAA0BC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: move bd_stat to writeback section
has been added to the -mm mm-new branch.  Its filename is
     zram-move-bd_stat-to-writeback-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-bd_stat-to-writeback-section.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: move bd_stat to writeback section
Date: Mon, 1 Dec 2025 18:47:51 +0900

Move bd_stat function and attribute declaration to
existing CONFIG_WRITEBACK ifdef-sections.

Link: https://lkml.kernel.org/r/20251201094754.4149975-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   48 ++++++++++++++------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-move-bd_stat-to-writeback-section
+++ a/drivers/block/zram/zram_drv.c
@@ -539,6 +539,24 @@ struct zram_rb_req {
 	u32 index;
 };
 
+#define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
+static ssize_t bd_stat_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	ret = sysfs_emit(buf,
+			 "%8llu %8llu %8llu\n",
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_reads)),
+			 FOUR_K((u64)atomic64_read(&zram->stats.bd_writes)));
+	up_read(&zram->init_lock);
+
+	return ret;
+}
+
 static ssize_t writeback_compressed_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t len)
@@ -1976,28 +1994,8 @@ static ssize_t mm_stat_show(struct devic
 	return ret;
 }
 
-#ifdef CONFIG_ZRAM_WRITEBACK
-#define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
-static ssize_t bd_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-	ssize_t ret;
-
-	down_read(&zram->init_lock);
-	ret = sysfs_emit(buf,
-			"%8llu %8llu %8llu\n",
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_reads)),
-			FOUR_K((u64)atomic64_read(&zram->stats.bd_writes)));
-	up_read(&zram->init_lock);
-
-	return ret;
-}
-#endif
-
 static ssize_t debug_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+			       struct device_attribute *attr, char *buf)
 {
 	int version = 1;
 	struct zram *zram = dev_to_zram(dev);
@@ -2015,9 +2013,6 @@ static ssize_t debug_stat_show(struct de
 
 static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
-#ifdef CONFIG_ZRAM_WRITEBACK
-static DEVICE_ATTR_RO(bd_stat);
-#endif
 static DEVICE_ATTR_RO(debug_stat);
 
 static void zram_meta_free(struct zram *zram, u64 disksize)
@@ -3079,6 +3074,7 @@ static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_WO(idle);
 static DEVICE_ATTR_RW(comp_algorithm);
 #ifdef CONFIG_ZRAM_WRITEBACK
+static DEVICE_ATTR_RO(bd_stat);
 static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
@@ -3102,6 +3098,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_idle.attr,
 	&dev_attr_comp_algorithm.attr,
 #ifdef CONFIG_ZRAM_WRITEBACK
+	&dev_attr_bd_stat.attr,
 	&dev_attr_backing_dev.attr,
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
@@ -3111,9 +3108,6 @@ static struct attribute *zram_disk_attrs
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
-#ifdef CONFIG_ZRAM_WRITEBACK
-	&dev_attr_bd_stat.attr,
-#endif
 	&dev_attr_debug_stat.attr,
 #ifdef CONFIG_ZRAM_MULTI_COMP
 	&dev_attr_recomp_algorithm.attr,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch

