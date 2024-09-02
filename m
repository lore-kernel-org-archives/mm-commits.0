Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589351A4E9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311921; cv=none; b=UCTDTQI9DSr2FVIz213ei5duCiRzFf0ycEEfrO3kl+ErQ7d7K2eeGuXXmac3oxuniZJriD6q6D3mC5kLnzZjzJgVIC55X0YumLl/tfPEZkD0oaWrkBYmjoAoQdVrt+ddgBv92X+fEu+SIwMKMyRy3we6hUDbQytto0U0lqezqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311921; c=relaxed/simple;
	bh=r+p2PYtZ8/doitjFKbOg5rZs7Enbm5qQYyekOmZwSqM=;
	h=Date:To:From:Subject:Message-Id; b=dhPzkgOQtwFDRNN2jEx05FYRoM0qjyuJuBQ/BypLwR8p/p/tM8Bia2lI6qbCPQpO7arL1eoDBg2ZqSDIt/PantLDy2GLHM8IbJnziqK1i606f3ur7NM0R+0aeOQMeXljaZo0fHU0JFaEsALM4+7bFM4WM+wXbJqQ559pEnVkGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XV8V0z07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XV8V0z07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF1FC4CEC2;
	Mon,  2 Sep 2024 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311920;
	bh=r+p2PYtZ8/doitjFKbOg5rZs7Enbm5qQYyekOmZwSqM=;
	h=Date:To:From:Subject:From;
	b=XV8V0z073MXllxZIeFns4DpLSAa7hIK8qA6r16/LsT8PPf1RHQZrbn5khC+MY3x5M
	 hRqktKb/N60WzorO64Ttb8yeWSGQ+8lWWB0GG9RTnq3nihqrUxH2yUazq9zxzDTnlC
	 WDvg6MUXXnHpp/U/Fy54txp07XPXeUEwh5WdIQLg=
Date: Mon, 02 Sep 2024 14:18:40 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-algorithm_params-device-attribute.patch added to mm-unstable branch
Message-Id: <20240902211840.CEF1FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce algorithm_params device attribute
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-algorithm_params-device-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-algorithm_params-device-attribute.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

