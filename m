Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366EB223DD3
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747262818; cv=none; b=qARRlHLuAH6BMQNcsZLQst+yyt0y4JfrPjuDNtQCSSpLAaWwQIZcv1Hml6LweCI/wSNr63Chuv5fSMj7vx9tx4hSPLp7hhb9V9q5I9BBZVXg0OyFA4hPMqox6TBg49FPPJ/dTjUcxagKChkF7KbFiY5nNe0TKm2lX3QUX96lq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747262818; c=relaxed/simple;
	bh=yEfxAZNLIPbWH3yDvHxPPn5hCi3z79xpEN5nLUibZXs=;
	h=Date:To:From:Subject:Message-Id; b=pVC3pKViQREcueEb6oHs07Toa8f+j2Oa286IOPmST9NLratzFG/7zhGcGuOE/CtLnlvix2n3Ftr4MCMRVjmaTwBg/ESKtp4N2CoTYEBN6eIvMgbA3RWy03ECl4RYwAq6dwGRClQv2fIWxwkhv7PbtYYFAdogQK1958NtpTgARTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGbK9UmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGbK9UmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B0AC4CEE3;
	Wed, 14 May 2025 22:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747262818;
	bh=yEfxAZNLIPbWH3yDvHxPPn5hCi3z79xpEN5nLUibZXs=;
	h=Date:To:From:Subject:From;
	b=yGbK9UmWl+VCiLvL9360U0TOSRwqohSLdSqhp6ZyQDRC1Ex+07dxzWRjUgun28qie
	 lQSREBeNn5Ug0LnUyVEKS/XzKfF7xSmeQWk6O0cNwDP0KJaLy6Xl08vqSI/g7TOZHA
	 coSB+kXB0vufY49URmVJtK7hZK23pyjPofPn1U6I=
Date: Wed, 14 May 2025 15:46:57 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-support-deflate-specific-params.patch added to mm-new branch
Message-Id: <20250514224657.E8B0AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: support deflate-specific params
has been added to the -mm mm-new branch.  Its filename is
     zram-support-deflate-specific-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-support-deflate-specific-params.patch

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

zram-rename-zcomp_param_no_level.patch
zram-support-deflate-specific-params.patch

