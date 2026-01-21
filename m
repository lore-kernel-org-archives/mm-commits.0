Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A2635C180
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966024; cv=none; b=RqmsnylggfpfrC1PsME7mn5gxfcivXYK6cRtnS0Cijh246/iG/yKaJTjv/cmyed2ybSkN0Dj5s92wJXv4dAQuICaNdHlaTDI5z3U+JZZMzDDFri4m7JvG53P8r7ou+6AMFfSReYu00jBAv+eUg8FxSb1Kg2fz1fDJAbnH56DqLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966024; c=relaxed/simple;
	bh=gbyN+wLgSXtvg16hMxj483bLhXZhPgBTNLlcWqdO1Z8=;
	h=Date:To:From:Subject:Message-Id; b=i6DkNPViqz/JfTwqT/9/aeLPhSARbdXPBhPOyNv74fUUsOWg/7l3TiwQ09zciqLxIVG4hrWfqbXfbm1M5cZyOed8oruA7k6irTz9pSqsnYoQkFnTBarllKikUea8nBa6tdHcq0hUjLpbpkNdXEvA7gfKBxdAkpDZHGCMkjvd3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NqHexFFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NqHexFFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6090C16AAE;
	Wed, 21 Jan 2026 03:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966023;
	bh=gbyN+wLgSXtvg16hMxj483bLhXZhPgBTNLlcWqdO1Z8=;
	h=Date:To:From:Subject:From;
	b=NqHexFFvMVqZwFX58IaEt1+wB5kkZvVxakT0vGHMBgJgZfUBVlios2hNCS7FOFgEY
	 keKrMEB3XrT3zhHiXUlaqlDyiZ5u5jpGJpGjkwHrZTcwJBh2Agxx6ZvHQ7SebWgO8L
	 Zycj11GJtatJiHod/RCzSsJrlS2dRWHikusNPY/k=
Date: Tue, 20 Jan 2026 19:27:03 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,senozhatsky@chromium.org,minchan@google.com,bgeffon@google.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-introduce-writeback_compressed-device-attribute.patch removed from -mm tree
Message-Id: <20260121032703.B6090C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: introduce writeback_compressed device attribute
has been removed from the -mm tree.  Its filename was
     zram-introduce-writeback_compressed-device-attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Richard Chang <richardycc@google.com>
Subject: zram: introduce writeback_compressed device attribute
Date: Mon, 1 Dec 2025 18:47:49 +0900

Introduce witeback_compressed device attribute to toggle compressed
writeback (decompression on demand) feature.

[senozhatsky@chromium.org: rewrote original patch, added documentation]
Link: https://lkml.kernel.org/r/20251201094754.4149975-3-senozhatsky@chromium.org
Signed-off-by: Richard Chang <richardycc@google.com>
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram  |    7 +++
 Documentation/admin-guide/blockdev/zram.rst |   13 ++++++
 drivers/block/zram/zram_drv.c               |   38 ++++++++++++++++++
 3 files changed, 58 insertions(+)

--- a/Documentation/ABI/testing/sysfs-block-zram~zram-introduce-writeback_compressed-device-attribute
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -150,3 +150,10 @@ Contact:	Sergey Senozhatsky <senozhatsky
 Description:
 		The algorithm_params file is write-only and is used to setup
 		compression algorithm parameters.
+
+What:		/sys/block/zram<id>/writeback_compressed
+Date:		Decemeber 2025
+Contact:	Richard Chang <richardycc@google.com>
+Description:
+		The writeback_compressed device atrribute toggles compressed
+		writeback feature.
--- a/Documentation/admin-guide/blockdev/zram.rst~zram-introduce-writeback_compressed-device-attribute
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -214,6 +214,7 @@ mem_limit         	WO	specifies the maxi
 writeback_limit   	WO	specifies the maximum amount of write IO zram
 				can write out to backing device as 4KB unit
 writeback_limit_enable  RW	show and set writeback_limit feature
+writeback_compressed	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
 compact           	WO	trigger memory compaction
@@ -434,6 +435,18 @@ system reboot, echo 1 > /sys/block/zramX
 writeback happened until you reset the zram to allocate extra writeback
 budget in next setting is user's job.
 
+By default zram stores written back pages in decompressed (raw) form, which
+means that writeback operation involves decompression of the page before
+writing it to the backing device.  This behavior can be changed by enabling
+`writeback_compressed` feature, which causes zram to write compressed pages
+to the backing device, thus avoiding decompression overhead.  To enable
+this feature, execute::
+
+	$ echo yes > /sys/block/zramX/writeback_compressed
+
+Note that this feature should be configured before the `zramX` device is
+initialized.
+
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
--- a/drivers/block/zram/zram_drv.c~zram-introduce-writeback_compressed-device-attribute
+++ a/drivers/block/zram/zram_drv.c
@@ -539,6 +539,42 @@ struct zram_rb_req {
 	u32 index;
 };
 
+static ssize_t writeback_compressed_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	bool val;
+
+	if (kstrtobool(buf, &val))
+		return -EINVAL;
+
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		up_write(&zram->init_lock);
+		return -EBUSY;
+	}
+
+	zram->wb_compressed = val;
+	up_write(&zram->init_lock);
+
+	return len;
+}
+
+static ssize_t writeback_compressed_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	bool val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->wb_compressed;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%d\n", val);
+}
+
 static ssize_t writeback_limit_enable_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t len)
@@ -3048,6 +3084,7 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 static DEVICE_ATTR_RW(writeback_batch_size);
+static DEVICE_ATTR_RW(writeback_compressed);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -3070,6 +3107,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
 	&dev_attr_writeback_batch_size.attr,
+	&dev_attr_writeback_compressed.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
_

Patches currently in -mm which might be from richardycc@google.com are


