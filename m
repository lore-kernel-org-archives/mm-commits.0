Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E2B13DDAE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756818; cv=none; b=heuAxAOpLl3NiUV0Ga/SbcgkrgOLViwsnLcr2Wuc6u7MwQhLGwASlM+rF0ahpsN4DOQBVQ+7v1fCj7n1UQCi6IoSsRVFvD2jiI24kl2IZfTX+5VE+nj4iYQxfSnLLjkit4ZFvuhyYJG8CVVT3hIbOtb9ebmJaGHIGf09ECchCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756818; c=relaxed/simple;
	bh=L5iNP8KvPc/CwfHu94SqFb4ga0HaCLKd27oBU3z3tP8=;
	h=Date:To:From:Subject:Message-Id; b=Vqk+tA6tPSz09ijOaG66dbnlqCojlwSPwzSZ+wegNidKw0bOkD57pJ4QGoEYnaw5JibkH/H9hHbHqt9SVTqV6l/kLo1ddDCKNDlju1WWN30+jfm1VcM6dDA6W83daMsTnL1boNxLe6yJiMMop/nKEtOoxOdSuabF32dWdJFQTiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bd8aW+He; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bd8aW+He"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1BFC4CEED;
	Sun,  1 Jun 2025 05:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756818;
	bh=L5iNP8KvPc/CwfHu94SqFb4ga0HaCLKd27oBU3z3tP8=;
	h=Date:To:From:Subject:From;
	b=Bd8aW+HeqIuHXvGCsehJx7n1PS0UCo/JmABI3hqLOWo+82t/d0FfQN/mW+E5zZf0N
	 NaGMaoEif9S9clyAqmkjLlvNZXPbDYXZQ5vaF3P3654iopY69veMTBD1e08L+vU+4m
	 TGO6HsjuvfGJBgKrbvyjkiQdU2UfqZ4gibmJVxJE=
Date: Sat, 31 May 2025 22:46:58 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-support-deflate-specific-params.patch removed from -mm tree
Message-Id: <20250601054658.8E1BFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: support deflate-specific params
has been removed from the -mm tree.  Its filename was
     zram-support-deflate-specific-params.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: support deflate-specific params
Date: Wed, 14 May 2025 11:47:51 +0900

Introduce support of algorithm specific parameters in algorithm_params
device attribute.  The expected format is algorithm.param=value.

For starters, add support for deflate.winbits parameter.

Link: https://lkml.kernel.org/r/20250514024825.1745489-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_deflate.c |   10 ++++++----
 drivers/block/zram/zcomp.h           |    7 +++++++
 drivers/block/zram/zram_drv.c        |   17 +++++++++++++++--
 3 files changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/backend_deflate.c~zram-support-deflate-specific-params
+++ a/drivers/block/zram/backend_deflate.c
@@ -8,7 +8,7 @@
 #include "backend_deflate.h"
 
 /* Use the same value as crypto API */
-#define DEFLATE_DEF_WINBITS		11
+#define DEFLATE_DEF_WINBITS		(-11)
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
 
 struct deflate_ctx {
@@ -24,6 +24,8 @@ static int deflate_setup_params(struct z
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+		params->deflate.winbits = DEFLATE_DEF_WINBITS;
 
 	return 0;
 }
@@ -57,13 +59,13 @@ static int deflate_create(struct zcomp_p
 		return -ENOMEM;
 
 	ctx->context = zctx;
-	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
+	sz = zlib_deflate_workspacesize(params->deflate.winbits, MAX_MEM_LEVEL);
 	zctx->cctx.workspace = vzalloc(sz);
 	if (!zctx->cctx.workspace)
 		goto error;
 
 	ret = zlib_deflateInit2(&zctx->cctx, params->level, Z_DEFLATED,
-				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
+				params->deflate.winbits, DEFLATE_DEF_MEMLEVEL,
 				Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK)
 		goto error;
@@ -73,7 +75,7 @@ static int deflate_create(struct zcomp_p
 	if (!zctx->dctx.workspace)
 		goto error;
 
-	ret = zlib_inflateInit2(&zctx->dctx, -DEFLATE_DEF_WINBITS);
+	ret = zlib_inflateInit2(&zctx->dctx, params->deflate.winbits);
 	if (ret != Z_OK)
 		goto error;
 
--- a/drivers/block/zram/zcomp.h~zram-support-deflate-specific-params
+++ a/drivers/block/zram/zcomp.h
@@ -7,6 +7,10 @@
 
 #define ZCOMP_PARAM_NOT_SET	INT_MIN
 
+struct deflate_params {
+	s32 winbits;
+};
+
 /*
  * Immutable driver (backend) parameters. The driver may attach private
  * data to it (e.g. driver representation of the dictionary, etc.).
@@ -17,6 +21,9 @@ struct zcomp_params {
 	void *dict;
 	size_t dict_sz;
 	s32 level;
+	union {
+		struct deflate_params deflate;
+	};
 
 	void *drv_data;
 };
--- a/drivers/block/zram/zram_drv.c~zram-support-deflate-specific-params
+++ a/drivers/block/zram/zram_drv.c
@@ -1277,12 +1277,14 @@ static void comp_params_reset(struct zra
 
 	vfree(params->dict);
 	params->level = ZCOMP_PARAM_NOT_SET;
+	params->deflate.winbits = ZCOMP_PARAM_NOT_SET;
 	params->dict_sz = 0;
 	params->dict = NULL;
 }
 
 static int comp_params_store(struct zram *zram, u32 prio, s32 level,
-			     const char *dict_path)
+			     const char *dict_path,
+			     struct deflate_params *deflate_params)
 {
 	ssize_t sz = 0;
 
@@ -1300,6 +1302,7 @@ static int comp_params_store(struct zram
 
 	zram->params[prio].dict_sz = sz;
 	zram->params[prio].level = level;
+	zram->params[prio].deflate.winbits = deflate_params->winbits;
 	return 0;
 }
 
@@ -1310,9 +1313,12 @@ static ssize_t algorithm_params_store(st
 {
 	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NOT_SET;
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
+	struct deflate_params deflate_params;
 	struct zram *zram = dev_to_zram(dev);
 	int ret;
 
+	deflate_params.winbits = ZCOMP_PARAM_NOT_SET;
+
 	args = skip_spaces(buf);
 	while (*args) {
 		args = next_arg(args, &param, &val);
@@ -1343,6 +1349,13 @@ static ssize_t algorithm_params_store(st
 			dict_path = val;
 			continue;
 		}
+
+		if (!strcmp(param, "deflate.winbits")) {
+			ret = kstrtoint(val, 10, &deflate_params.winbits);
+			if (ret)
+				return ret;
+			continue;
+		}
 	}
 
 	/* Lookup priority by algorithm name */
@@ -1364,7 +1377,7 @@ static ssize_t algorithm_params_store(st
 	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
-	ret = comp_params_store(zram, prio, level, dict_path);
+	ret = comp_params_store(zram, prio, level, dict_path, &deflate_params);
 	return ret ? ret : len;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


