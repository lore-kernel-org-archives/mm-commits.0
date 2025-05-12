Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FA71E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011012; cv=none; b=C5EfrDJUL8KXNqsqyYrl3mMp0v5cVxyelcB/Bv0KLF2kFxt69yyixyDlIj9lGH3OgVBn1SO6PqOnan/HLVfPDnC+MtdXc4Wb1+OOvzWqfeYTpisZPmAyZgWljYKuPlRdoRrXfILm8kzIUXeQaubgxMBMz+NY2c8HEWLYZj5vn9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011012; c=relaxed/simple;
	bh=o9F601V3jn/4yov4oWkSGLwu6RZ9cQVBeH5eZF5g83E=;
	h=Date:To:From:Subject:Message-Id; b=mBRxtJijGD1X7AI6/4CZD7n25lmiDEQuBRSF0iyO33FVWlJ6WuSUB2vUZbbcVFm7+qqTPXEScB/fErKr03/G06I5mZMbfD70SngJkR/A3sk/sHXHLzJkcWsS5kCSfSQbDzf3bY9+HSCv47zsyvoJKc75Azsb+1lK4xz2+AHrohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ay9/nbu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ay9/nbu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97A4C4CEE4;
	Mon, 12 May 2025 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011012;
	bh=o9F601V3jn/4yov4oWkSGLwu6RZ9cQVBeH5eZF5g83E=;
	h=Date:To:From:Subject:From;
	b=Ay9/nbu/xoDKc6H7RdEenLxbWvRq8fk5bbh0zzqV/M324LPtKfGUG69s3itBFlBut
	 zU7krcuWtcjw0jWLUWec8dB80UMB519v+UeaDyPdi20cc+iuO8H+uEE2OdRgXhkDww
	 A6pZvr41S1Z9+A1eNIEb3lusH8BSXvEYKIdkPGmQ=
Date: Sun, 11 May 2025 17:50:12 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,dan.carpenter@linaro.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-modernize-writeback-interface.patch removed from -mm tree
Message-Id: <20250512005012.A97A4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: modernize writeback interface
has been removed from the -mm tree.  Its filename was
     zram-modernize-writeback-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: modernize writeback interface
Date: Thu, 27 Mar 2025 10:58:09 +0900

The writeback interface supports a page_index=N parameter which performs
writeback of the given page.  Since we rarely need to writeback just one
single page, the typical use case involves a number of writeback calls,
each performing writeback of one page:

  echo page_index=100 > zram0/writeback
  ...
  echo page_index=200 > zram0/writeback
  echo page_index=500 > zram0/writeback
  ...
  echo page_index=700 > zram0/writeback

One obvious downside of this is that it increases the number of syscalls. 
Less obvious, but a significantly more important downside, is that when
given only one page to post-process zram cannot perform an optimal target
selection.  This becomes a critical limitation when writeback_limit is
enabled, because under writeback_limit we want to guarantee the highest
memory savings hence we first need to writeback pages that release the
highest amount of zsmalloc pool memory.

This patch adds page_indexes=LOW-HIGH parameter to the writeback
interface:

  echo page_indexes=100-200 page_indexes=500-700 > zram0/writeback

This gives zram a chance to apply an optimal target selection strategy on
each iteration of the writeback loop.

We also now permit multiple page_index parameters per call (previously
zram would recognize only one page_index) and a mix or single pages and
page ranges:

  echo page_index=42 page_index=99 page_indexes=100-200 \
       page_indexes=500-700 > zram0/writeback

Apart from that the patch also unifies parameters passing and resembles
other "modern" zram device attributes (e.g.  recompression), while the old
interface used a mixed scheme: values-less parameters for mode and a
key=value format for page_index.  We still support the "old" value-less
format for compatibility reasons.

[senozhatsky@chromium.org: simplify parse_page_index() range checks, per Brian]
  nk: https://lkml.kernel.org/r/20250404015327.2427684-1-senozhatsky@chromium.org
[sozhatsky@chromium.org: fix uninitialized variable in zram_writeback_slots(), per Dan]
  nk: https://lkml.kernel.org/r/20250409112611.1154282-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20250327015818.4148660-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   17 
 drivers/block/zram/zram_drv.c               |  320 ++++++++++++------
 2 files changed, 232 insertions(+), 105 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-modernize-writeback-interface
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -369,6 +369,23 @@ they could write a page index into the i
 
 	echo "page_index=1251" > /sys/block/zramX/writeback
 
+In Linux 6.16 this interface underwent some rework.  First, the interface
+now supports `key=value` format for all of its parameters (`type=huge_idle`,
+etc.)  Second, the support for `page_indexes` was introduced, which specify
+`LOW-HIGH` range (or ranges) of pages to be written-back.  This reduces the
+number of syscalls, but more importantly this enables optimal post-processing
+target selection strategy. Usage example::
+
+	echo "type=idle" > /sys/block/zramX/writeback
+	echo "page_indexes=1-100 page_indexes=200-300" > \
+		/sys/block/zramX/writeback
+
+We also now permit multiple page_index params per call and a mix of
+single pages and page ranges::
+
+	echo page_index=42 page_index=99 page_indexes=100-200 \
+		page_indexes=500-700 > /sys/block/zramX/writeback
+
 If there are lots of write IO with flash device, potentially, it has
 flash wearout problem so that admin needs to design write limitation
 to guarantee storage health for entire product life.
--- a/drivers/block/zram/zram_drv.c~zram-modernize-writeback-interface
+++ a/drivers/block/zram/zram_drv.c
@@ -734,114 +734,19 @@ static void read_from_bdev_async(struct
 	submit_bio(bio);
 }
 
-#define PAGE_WB_SIG "page_index="
-
-#define PAGE_WRITEBACK			0
-#define HUGE_WRITEBACK			(1<<0)
-#define IDLE_WRITEBACK			(1<<1)
-#define INCOMPRESSIBLE_WRITEBACK	(1<<2)
-
-static int scan_slots_for_writeback(struct zram *zram, u32 mode,
-				    unsigned long nr_pages,
-				    unsigned long index,
-				    struct zram_pp_ctl *ctl)
+static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 {
-	for (; nr_pages != 0; index++, nr_pages--) {
-		bool ok = true;
-
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
-			goto next;
-
-		if (zram_test_flag(zram, index, ZRAM_WB) ||
-		    zram_test_flag(zram, index, ZRAM_SAME))
-			goto next;
-
-		if (mode & IDLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_IDLE))
-			goto next;
-		if (mode & HUGE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_HUGE))
-			goto next;
-		if (mode & INCOMPRESSIBLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
-			goto next;
-
-		ok = place_pp_slot(zram, ctl, index);
-next:
-		zram_slot_unlock(zram, index);
-		if (!ok)
-			break;
-	}
-
-	return 0;
-}
-
-static ssize_t writeback_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	struct zram *zram = dev_to_zram(dev);
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct zram_pp_ctl *ctl = NULL;
+	unsigned long blk_idx = 0;
+	struct page *page = NULL;
 	struct zram_pp_slot *pps;
-	unsigned long index = 0;
-	struct bio bio;
 	struct bio_vec bio_vec;
-	struct page *page = NULL;
-	ssize_t ret = len;
-	int mode, err;
-	unsigned long blk_idx = 0;
-
-	if (sysfs_streq(buf, "idle"))
-		mode = IDLE_WRITEBACK;
-	else if (sysfs_streq(buf, "huge"))
-		mode = HUGE_WRITEBACK;
-	else if (sysfs_streq(buf, "huge_idle"))
-		mode = IDLE_WRITEBACK | HUGE_WRITEBACK;
-	else if (sysfs_streq(buf, "incompressible"))
-		mode = INCOMPRESSIBLE_WRITEBACK;
-	else {
-		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
-			return -EINVAL;
-
-		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
-				index >= nr_pages)
-			return -EINVAL;
-
-		nr_pages = 1;
-		mode = PAGE_WRITEBACK;
-	}
-
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		ret = -EINVAL;
-		goto release_init_lock;
-	}
-
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1)) {
-		up_read(&zram->init_lock);
-		return -EAGAIN;
-	}
-
-	if (!zram->backing_dev) {
-		ret = -ENODEV;
-		goto release_init_lock;
-	}
+	struct bio bio;
+	int ret = 0, err;
+	u32 index;
 
 	page = alloc_page(GFP_KERNEL);
-	if (!page) {
-		ret = -ENOMEM;
-		goto release_init_lock;
-	}
-
-	ctl = init_pp_ctl();
-	if (!ctl) {
-		ret = -ENOMEM;
-		goto release_init_lock;
-	}
-
-	scan_slots_for_writeback(zram, mode, nr_pages, index, ctl);
+	if (!page)
+		return -ENOMEM;
 
 	while ((pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
@@ -929,10 +834,215 @@ next:
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-
-release_init_lock:
 	if (page)
 		__free_page(page);
+
+	return ret;
+}
+
+#define PAGE_WRITEBACK			0
+#define HUGE_WRITEBACK			(1 << 0)
+#define IDLE_WRITEBACK			(1 << 1)
+#define INCOMPRESSIBLE_WRITEBACK	(1 << 2)
+
+static int parse_page_index(char *val, unsigned long nr_pages,
+			    unsigned long *lo, unsigned long *hi)
+{
+	int ret;
+
+	ret = kstrtoul(val, 10, lo);
+	if (ret)
+		return ret;
+	if (*lo >= nr_pages)
+		return -ERANGE;
+	*hi = *lo + 1;
+	return 0;
+}
+
+static int parse_page_indexes(char *val, unsigned long nr_pages,
+			      unsigned long *lo, unsigned long *hi)
+{
+	char *delim;
+	int ret;
+
+	delim = strchr(val, '-');
+	if (!delim)
+		return -EINVAL;
+
+	*delim = 0x00;
+	ret = kstrtoul(val, 10, lo);
+	if (ret)
+		return ret;
+	if (*lo >= nr_pages)
+		return -ERANGE;
+
+	ret = kstrtoul(delim + 1, 10, hi);
+	if (ret)
+		return ret;
+	if (*hi >= nr_pages || *lo > *hi)
+		return -ERANGE;
+	*hi += 1;
+	return 0;
+}
+
+static int parse_mode(char *val, u32 *mode)
+{
+	*mode = 0;
+
+	if (!strcmp(val, "idle"))
+		*mode = IDLE_WRITEBACK;
+	if (!strcmp(val, "huge"))
+		*mode = HUGE_WRITEBACK;
+	if (!strcmp(val, "huge_idle"))
+		*mode = IDLE_WRITEBACK | HUGE_WRITEBACK;
+	if (!strcmp(val, "incompressible"))
+		*mode = INCOMPRESSIBLE_WRITEBACK;
+
+	if (*mode == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int scan_slots_for_writeback(struct zram *zram, u32 mode,
+				    unsigned long lo, unsigned long hi,
+				    struct zram_pp_ctl *ctl)
+{
+	u32 index = lo;
+
+	while (index < hi) {
+		bool ok = true;
+
+		zram_slot_lock(zram, index);
+		if (!zram_allocated(zram, index))
+			goto next;
+
+		if (zram_test_flag(zram, index, ZRAM_WB) ||
+		    zram_test_flag(zram, index, ZRAM_SAME))
+			goto next;
+
+		if (mode & IDLE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_IDLE))
+			goto next;
+		if (mode & HUGE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_HUGE))
+			goto next;
+		if (mode & INCOMPRESSIBLE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+			goto next;
+
+		ok = place_pp_slot(zram, ctl, index);
+next:
+		zram_slot_unlock(zram, index);
+		if (!ok)
+			break;
+		index++;
+	}
+
+	return 0;
+}
+
+static ssize_t writeback_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long lo = 0, hi = nr_pages;
+	struct zram_pp_ctl *ctl = NULL;
+	char *args, *param, *val;
+	ssize_t ret = len;
+	int err, mode = 0;
+
+	down_read(&zram->init_lock);
+	if (!init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
+
+	/* Do not permit concurrent post-processing actions. */
+	if (atomic_xchg(&zram->pp_in_progress, 1)) {
+		up_read(&zram->init_lock);
+		return -EAGAIN;
+	}
+
+	if (!zram->backing_dev) {
+		ret = -ENODEV;
+		goto release_init_lock;
+	}
+
+	ctl = init_pp_ctl();
+	if (!ctl) {
+		ret = -ENOMEM;
+		goto release_init_lock;
+	}
+
+	args = skip_spaces(buf);
+	while (*args) {
+		args = next_arg(args, &param, &val);
+
+		/*
+		 * Workaround to support the old writeback interface.
+		 *
+		 * The old writeback interface has a minor inconsistency and
+		 * requires key=value only for page_index parameter, while the
+		 * writeback mode is a valueless parameter.
+		 *
+		 * This is not the case anymore and now all parameters are
+		 * required to have values, however, we need to support the
+		 * legacy writeback interface format so we check if we can
+		 * recognize a valueless parameter as the (legacy) writeback
+		 * mode.
+		 */
+		if (!val || !*val) {
+			err = parse_mode(param, &mode);
+			if (err) {
+				ret = err;
+				goto release_init_lock;
+			}
+
+			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			break;
+		}
+
+		if (!strcmp(param, "type")) {
+			err = parse_mode(val, &mode);
+			if (err) {
+				ret = err;
+				goto release_init_lock;
+			}
+
+			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			break;
+		}
+
+		if (!strcmp(param, "page_index")) {
+			err = parse_page_index(val, nr_pages, &lo, &hi);
+			if (err) {
+				ret = err;
+				goto release_init_lock;
+			}
+
+			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			continue;
+		}
+
+		if (!strcmp(param, "page_indexes")) {
+			err = parse_page_indexes(val, nr_pages, &lo, &hi);
+			if (err) {
+				ret = err;
+				goto release_init_lock;
+			}
+
+			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			continue;
+		}
+	}
+
+	err = zram_writeback_slots(zram, ctl);
+	if (err)
+		ret = err;
+
+release_init_lock:
 	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


