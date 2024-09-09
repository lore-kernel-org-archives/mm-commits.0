Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6D218E345
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925276; cv=none; b=YZZunR6M1gXTcVKpAO4tvFbGqi8UVKTvZfPa/IVmp+Y2cgNJobmZTKh/Klk7JZOMPV4O++yQEO75ovIqTfHTK7HMDP3b8fsoK4bAGoXsDhHlmNesqFFaBYXVC4+8mUNIqzCFk/HcokZQdbveoSCaWqmJPDSQsagM2qfjwB+1R9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925276; c=relaxed/simple;
	bh=8jexZfzsFE0nuUYNLfo6Tn0lA2lKl5jW3fWt63yd/eY=;
	h=Date:To:From:Subject:Message-Id; b=X9IaotkHkpjvyYCfXc/HdI7qCgRwniJyGOzGXXMGidfJEJN+Rkf9tdHdYVhAKRTtRgGbiutjyrLcFy754UoE+EGsUMPYZFfw87miF9hcIa5qaaAj/x3G7WP8N1/89PJLU6Cof2wnZEbsY8VUVLA9X6POX5uYpGLggj0doC5UrME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QcijXrRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QcijXrRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BBDC4CEC5;
	Mon,  9 Sep 2024 23:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925276;
	bh=8jexZfzsFE0nuUYNLfo6Tn0lA2lKl5jW3fWt63yd/eY=;
	h=Date:To:From:Subject:From;
	b=QcijXrRlgHhCLxtgTFIgjARCBHTO6MZjiNQsCtkx9Y4GDACHbQTXSqf8QPXcO89zh
	 hAec+DKbh3RK1/HAqtlSyLbCQhZ0KH2yoDm9y3qYR0r0rPdfV6iz6doQ1bsEDdntSb
	 J9CWioYpNhO8RXe9sdT8VdYEEoR4OrAxN26cnWLQ=
Date: Mon, 09 Sep 2024 16:41:16 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-introduce-algorithm_params-device-attribute.patch removed from -mm tree
Message-Id: <20240909234116.B5BBDC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: introduce algorithm_params device attribute
has been removed from the -mm tree.  Its filename was
     zram-introduce-algorithm_params-device-attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: introduce algorithm_params device attribute
Date: Mon, 2 Sep 2024 19:56:03 +0900

This attribute is used to setup compression algorithms' parameters, so we
can tweak algorithms' characteristics.  At this point only 'level' is
supported (to be extended in the future).

Each call sets up parameters for one particular algorithm, which should be
specified either by the algorithm's priority or algo name.  This is
expected to be called after corresponding algorithm is selected via
comp_algorithm or recomp_algorithm.

 echo "priority=0 level=1" > /sys/block/zram0/algorithm_params
or
 echo "algo=zstd level=1" > /sys/block/zram0/algorithm_params

Link: https://lkml.kernel.org/r/20240902105656.1383858-16-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram  |    7 +
 Documentation/admin-guide/blockdev/zram.rst |    1 
 drivers/block/zram/zram_drv.c               |   68 ++++++++++++++++++
 3 files changed, 76 insertions(+)

--- a/Documentation/ABI/testing/sysfs-block-zram~zram-introduce-algorithm_params-device-attribute
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -151,3 +151,10 @@ Contact:	Sergey Senozhatsky <senozhatsky
 Description:
 		The recompress file is write-only and triggers re-compression
 		with secondary compression algorithms.
+
+What:		/sys/block/zram<id>/algorithm_params
+Date:		August 2024
+Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
+Description:
+		The algorithm_params file is write-only and is used to setup
+		compression algorithm parameters.
--- a/Documentation/admin-guide/blockdev/zram.rst~zram-introduce-algorithm_params-device-attribute
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -198,6 +198,7 @@ writeback_limit_enable  RW	show and set
 max_comp_streams  	RW	the number of possible concurrent compress
 				operations
 comp_algorithm    	RW	show and change the compression algorithm
+algorithm_params	WO	setup compression algorithm parameters
 compact           	WO	trigger memory compaction
 debug_stat        	RO	this file is used for zram debugging purposes
 backing_dev	  	RW	set up backend storage for zram to write out
--- a/drivers/block/zram/zram_drv.c~zram-introduce-algorithm_params-device-attribute
+++ a/drivers/block/zram/zram_drv.c
@@ -998,6 +998,72 @@ static int __comp_algorithm_store(struct
 	return 0;
 }
 
+static int comp_params_store(struct zram *zram, u32 prio, s32 level)
+{
+	zram->params[prio].level = level;
+	return 0;
+}
+
+static ssize_t algorithm_params_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NO_LEVEL;
+	char *args, *param, *val, *algo = NULL;
+	struct zram *zram = dev_to_zram(dev);
+	int ret;
+
+	args = skip_spaces(buf);
+	while (*args) {
+		args = next_arg(args, &param, &val);
+
+		if (!val || !*val)
+			return -EINVAL;
+
+		if (!strcmp(param, "priority")) {
+			ret = kstrtoint(val, 10, &prio);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		if (!strcmp(param, "level")) {
+			ret = kstrtoint(val, 10, &level);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		if (!strcmp(param, "algo")) {
+			algo = val;
+			continue;
+		}
+	}
+
+	/* Lookup priority by algorithm name */
+	if (algo) {
+		s32 p;
+
+		prio = -EINVAL;
+		for (p = ZRAM_PRIMARY_COMP; p < ZRAM_MAX_COMPS; p++) {
+			if (!zram->comp_algs[p])
+				continue;
+
+			if (!strcmp(zram->comp_algs[p], algo)) {
+				prio = p;
+				break;
+			}
+		}
+	}
+
+	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
+		return -EINVAL;
+
+	ret = comp_params_store(zram, prio, level);
+	return ret ? ret : len;
+}
+
 static ssize_t comp_algorithm_show(struct device *dev,
 				   struct device_attribute *attr,
 				   char *buf)
@@ -2169,6 +2235,7 @@ static DEVICE_ATTR_RW(writeback_limit_en
 static DEVICE_ATTR_RW(recomp_algorithm);
 static DEVICE_ATTR_WO(recompress);
 #endif
+static DEVICE_ATTR_WO(algorithm_params);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -2196,6 +2263,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_recomp_algorithm.attr,
 	&dev_attr_recompress.attr,
 #endif
+	&dev_attr_algorithm_params.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

