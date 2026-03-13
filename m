Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B142FE07D
	for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773371206; cv=none; b=Br9gnsx/ZDHm0aTVBBkcEQXKjWuYtse6nSH7QldXkiqXFObhp1cEv5J5KxlrMHm2XeXFLs0nkYhDdTAsuimx3p/lYxZ1Ugdje3VFyJfWS2Obfo+W6XbOEI4GBM5ZEw9XScHOWWZhjmY/NtGR2czidKgTsAFpfo10Gb2JIhDTx2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773371206; c=relaxed/simple;
	bh=vDoHGHMK31jZzXq900nOQkqHlFXBrmfNEMLGnoG669U=;
	h=Date:To:From:Subject:Message-Id; b=T+RduyM7QDmR7OiLZu6BFbRC8DRTSGZRcVGnzOV/mhF4FDgcE6TsDi71iwxur8t6Qa1vCfIUSj5+WnJz7DVzmnDfbpFPG+KTIcMtIBMfzoZVxPq4TQepsrkT87drZEUgmGplUkkgDXWsagUAzQKmALPwJoaYIHJSB0mHR2ePK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=syc0Xlx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="syc0Xlx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3795EC4CEF7;
	Fri, 13 Mar 2026 03:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773371206;
	bh=vDoHGHMK31jZzXq900nOQkqHlFXBrmfNEMLGnoG669U=;
	h=Date:To:From:Subject:From;
	b=syc0Xlx1dCxCf9OgjLoVEjBpS/ZnRhzwwQQ/0nQI5EPJ2gs7VTWV3jIskql3dssdJ
	 CSZM4FpeWBYYq8vsIsc+M0sokbCDN1tMXmcPbLxKl83muftg92OOHxDrv34UIW+O5D
	 XUfPEP9TiwjF8G92W7myh3/a3zFqNc1hdYms6wVw=
Date: Thu, 12 Mar 2026 20:06:45 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-optimize-lz4-dictionary-compression-performance-v2.patch added to mm-new branch
Message-Id: <20260313030646.3795EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: optimize LZ4 dictionary compression performance
has been added to the -mm mm-new branch.  Its filename is
     zram-optimize-lz4-dictionary-compression-performance-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-optimize-lz4-dictionary-compression-performance-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: gao xu <gaoxu2@honor.com>
Subject: zram: optimize LZ4 dictionary compression performance
Date: Fri, 13 Mar 2026 02:41:14 +0000

Calling `LZ4_loadDict()` repeatedly in Zram causes significant overhead
due to its internal dictionary pre-processing.  This commit introduces a
template stream mechanism to pre-process the dictionary only once when the
dictionary is initially set or modified.  It then efficiently copies this
state for subsequent compressions.

Verification Test Items:
Test Platform: android16-6.12
1. Collect Anonymous Page Dataset
1) Apply the following patch:
static bool zram_meta_alloc(struct zram *zram, u64 disksize)
	if (!huge_class_size)
-		huge_class_size = zs_huge_class_size(zram->mem_pool);
+		huge_class_size = 0;

2）Install multiple apps and monkey testing until SwapFree is close to 0.

3）Execute the following command to export data:
dd if=/dev/block/zram0 of=/data/samples/zram_dump.img bs=4K

2. Train Dictionary
Since LZ4 does not have a dedicated dictionary training tool, the zstd
tool can be used for training[1]. The command is as follows:
zstd --train /data/samples/* --split=4096 --maxdict=64KB -o /vendor/etc/dict_data

3. Test Code
adb shell "dd if=/data/samples/zram_dump.img of=/dev/test_pattern bs=4096 count=131072 conv=fsync"
adb shell "swapoff /dev/block/zram0"
adb shell "echo 1 > /sys/block/zram0/reset"
adb shell "echo lz4 > /sys/block/zram0/comp_algorithm"
adb shell "echo dict=/vendor/etc/dict_data   >  /sys/block/zram0/algorithm_params"
adb shell "echo 6G > /sys/block/zram0/disksize"
echo "Start Compression"
adb shell "taskset 80 dd if=/dev/test_pattern of=/dev/block/zram0 bs=4096 count=131072 conv=fsync"
echo.
echo "Start Decompression"
adb shell "taskset 80 dd if=/dev/block/zram0 of=/dev/output_result bs=4096 count=131072 conv=fsync"
echo "mm_stat:"
adb shell "cat /sys/block/zram0/mm_stat"
echo.
Note: To ensure stable test results, it is best to lock the CPU frequency
before executing the test.

LZ4 supports dictionaries up to 64KB. Below are the test results for
compression rates at various dictionary sizes:
dict_size          base        patch
  4 KB          156M/s      219M/s
  8 KB          136M/s      217M/s
 16KB           98M/s       214M/s
 32KB           66M/s       225M/s
 64KB           38M/s       224M/s

When an LZ4 compression dictionary is enabled, compression speed is
negatively impacted by the dictionary's size; larger dictionaries result
in slower compression.  This patch eliminates the influence of dictionary
size on compression speed, ensuring consistent performance regardless of
dictionary scale.

Link: https://lkml.kernel.org/r/698181478c9c4b10aa21b4a847bdc706@honor.com
Link: https://github.com/lz4/lz4?tab=readme-ov-file [1]
Signed-off-by: gao xu <gaoxu2@honor.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_lz4.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/backend_lz4.c~zram-optimize-lz4-dictionary-compression-performance-v2
+++ a/drivers/block/zram/backend_lz4.c
@@ -14,13 +14,38 @@ struct lz4_ctx {
 
 static void lz4_release_params(struct zcomp_params *params)
 {
+	LZ4_stream_t *dict_stream = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!dict_stream)
+		return;
+
+	kfree(dict_stream);
 }
 
 static int lz4_setup_params(struct zcomp_params *params)
 {
+	LZ4_stream_t *dict_stream;
+	int ret;
+
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = LZ4_ACCELERATION_DEFAULT;
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
+	dict_stream = kzalloc_obj(*dict_stream, GFP_KERNEL);
+	if (!dict_stream)
+		return -ENOMEM;
+
+	ret = LZ4_loadDict(dict_stream,
+			   params->dict, params->dict_sz);
+	if (ret != params->dict_sz) {
+		kfree(dict_stream);
+		return -EINVAL;
+	}
+	params->drv_data = dict_stream;
+
 	return 0;
 }
 
@@ -79,9 +104,7 @@ static int lz4_compress(struct zcomp_par
 					zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		ret = LZ4_loadDict(zctx->cstrm, params->dict, params->dict_sz);
-		if (ret != params->dict_sz)
-			return -EINVAL;
+		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
 		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
 						 req->dst, req->src_len,
 						 req->dst_len, params->level);
_

Patches currently in -mm which might be from gaoxu2@honor.com are

zram-use-statically-allocated-compression-algorithm-names.patch
zram-optimize-lz4-dictionary-compression-performance-v2.patch

