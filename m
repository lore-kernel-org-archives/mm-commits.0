Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860023587B0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966026; cv=none; b=PQ6KL5o8kaHxXep6BmaX1SFe5XkgMxe2b/Xl7WSQFpU2RZxOneUu63yB18EYgfoPuRiG84gg6DshZin21y0keD3hJcrZtjy3QLVB5OofG2qg+kMTzEOgcskbolZsFWQBpYY78CfuhsSO9WPeOCWlEC+fz3uO40XoiUpm92T0dhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966026; c=relaxed/simple;
	bh=hPoNp7uhsqmL9YFy+uu63tTOFVssxDpTa9BRbmeZz0g=;
	h=Date:To:From:Subject:Message-Id; b=XeLAn/KFAUhFs65C2bjwphhft2ikaYBAYV46SBS1SZfBHZ5MrUrCcuvBZsrWhYpG2XhoqsgD/1aOoCT511wkCvkp81w6OztcEFDTVYJssrYPlbGTXh4SX0ByLarCWOuebZLnymqIQyqIITrU2zPKH36CnC2Ct4UNmvT5ND7RQ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tSi+XJzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tSi+XJzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2AAC16AAE;
	Wed, 21 Jan 2026 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966026;
	bh=hPoNp7uhsqmL9YFy+uu63tTOFVssxDpTa9BRbmeZz0g=;
	h=Date:To:From:Subject:From;
	b=tSi+XJzCy0q+/DLKNfLr0A58g+di/MB7D8OXKM3XZeT9e+a/UlN4i9+00IvKsFfTl
	 KFbmeBcvUwIgFk76pF81xdYAQyVASFxHpkxIyTvSfyU2I/4VjGYx3cv4eRdHE78nCE
	 s1CMwqoNK0Nt1uA+jIYqounOyh+cqEQM/Qqs0vK8=
Date: Tue, 20 Jan 2026 19:27:05 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-move-bd_stat-to-writeback-section.patch removed from -mm tree
Message-Id: <20260121032706.0F2AAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: move bd_stat to writeback section
has been removed from the -mm tree.  Its filename was
     zram-move-bd_stat-to-writeback-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

