Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36EC146A68
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756817; cv=none; b=fX0stnVhy8ZkXuyegii4uXKdDxYUsg8VLDBbkzGZVtxwBpUuLe3WYQq5haAN5ch9a/UwTJ5ZhYOl6M6DhCwmQMIs8VHCoufwwOFMj10c+sgR0U0UE1aWMGazylwtPkCes0pTUeGl1lRZrAe9uUobtS1b1LAtyIg7S+rANhb0OCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756817; c=relaxed/simple;
	bh=XRjoMZ1Xiz9dGt3dnOH+0etg2wwxXJhTI7vgl6douyk=;
	h=Date:To:From:Subject:Message-Id; b=g+gTUU893ySF+ZbEWdR9oUycRkr1vfoJPfNwq8+cYAM7nIE/LqejaQ7ZNRj0USI513bOAB3uPgvX1tbQYLroxUlEYTJfm/I4ts4HGTOWnVWVkc3IIyGfa8ccXJv0eMPa/sCGgTuHiguDsSvGS4f/dw9m5vgXYdyo9/w0zUTFfRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3YPc9Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3YPc9Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775F0C4CEF0;
	Sun,  1 Jun 2025 05:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756817;
	bh=XRjoMZ1Xiz9dGt3dnOH+0etg2wwxXJhTI7vgl6douyk=;
	h=Date:To:From:Subject:From;
	b=o3YPc9FmrsOJ1GHduOFWprjAgNVXqIO5l92tHbAJARS/pJG7qn8upBPLFVnXkLm86
	 qLqWMPErOuzwamD6/l/kdrmE2GyoClmZ0lx7FLGhhABp/P2FNp5nw+m+LtLybKvwQW
	 j3prM9xj/ddF3gFcr3Qzkn3Q7UQVOcHuXUnOEbF8=
Date: Sat, 31 May 2025 22:46:56 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-rename-zcomp_param_no_level.patch removed from -mm tree
Message-Id: <20250601054657.775F0C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: rename ZCOMP_PARAM_NO_LEVEL
has been removed from the -mm tree.  Its filename was
     zram-rename-zcomp_param_no_level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rename ZCOMP_PARAM_NO_LEVEL
Date: Wed, 14 May 2025 11:47:50 +0900

Patch series "zram: support algorithm-specific parameters".

This patchset adds support for algorithm-specific parameters.  For now,
only deflate-specific winbits can be configured, which fixes deflate
support on some s390 setups.


This patch (of 2):

Use more generic name because this will be default "un-set"
value for more params in the future.

Link: https://lkml.kernel.org/r/20250514024825.1745489-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20250514024825.1745489-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_deflate.c |    2 +-
 drivers/block/zram/backend_lz4.c     |    2 +-
 drivers/block/zram/backend_lz4hc.c   |    2 +-
 drivers/block/zram/backend_zstd.c    |    2 +-
 drivers/block/zram/zcomp.h           |    2 +-
 drivers/block/zram/zram_drv.c        |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/backend_deflate.c~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/backend_deflate.c
@@ -22,7 +22,7 @@ static void deflate_release_params(struc
 
 static int deflate_setup_params(struct zcomp_params *params)
 {
-	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
 
 	return 0;
--- a/drivers/block/zram/backend_lz4.c~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/backend_lz4.c
@@ -18,7 +18,7 @@ static void lz4_release_params(struct zc
 
 static int lz4_setup_params(struct zcomp_params *params)
 {
-	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = LZ4_ACCELERATION_DEFAULT;
 
 	return 0;
--- a/drivers/block/zram/backend_lz4hc.c~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -18,7 +18,7 @@ static void lz4hc_release_params(struct
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
-	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = LZ4HC_DEFAULT_CLEVEL;
 
 	return 0;
--- a/drivers/block/zram/backend_zstd.c~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/backend_zstd.c
@@ -58,7 +58,7 @@ static int zstd_setup_params(struct zcom
 		return -ENOMEM;
 
 	params->drv_data = zp;
-	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = zstd_default_clevel();
 
 	zp->cprm = zstd_get_params(params->level, PAGE_SIZE);
--- a/drivers/block/zram/zcomp.h~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/zcomp.h
@@ -5,7 +5,7 @@
 
 #include <linux/mutex.h>
 
-#define ZCOMP_PARAM_NO_LEVEL	INT_MIN
+#define ZCOMP_PARAM_NOT_SET	INT_MIN
 
 /*
  * Immutable driver (backend) parameters. The driver may attach private
--- a/drivers/block/zram/zram_drv.c~zram-rename-zcomp_param_no_level
+++ a/drivers/block/zram/zram_drv.c
@@ -1276,7 +1276,7 @@ static void comp_params_reset(struct zra
 	struct zcomp_params *params = &zram->params[prio];
 
 	vfree(params->dict);
-	params->level = ZCOMP_PARAM_NO_LEVEL;
+	params->level = ZCOMP_PARAM_NOT_SET;
 	params->dict_sz = 0;
 	params->dict = NULL;
 }
@@ -1308,7 +1308,7 @@ static ssize_t algorithm_params_store(st
 				      const char *buf,
 				      size_t len)
 {
-	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NO_LEVEL;
+	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NOT_SET;
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct zram *zram = dev_to_zram(dev);
 	int ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


