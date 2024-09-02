Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DF51A2644
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311924; cv=none; b=qMb+LBrrzv/uH8IawFpvhqemT+5Mg/BOTed/xgmwaNNp+ZzJ/R8xmrfhoSvRBhjsmbsCtgLhj7A+jyaTj16GN9ytxN0roPOQSRy3q4o3wIpIGdde4cEgX5na4owSGDgvgS3WCbq/nYNVNNMdN63cEfd+/HGIakRqwYJddBYK3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311924; c=relaxed/simple;
	bh=lk+NYzTmWCHTIwXQq8PnMKYzsyET4PQOI/YbnmderFY=;
	h=Date:To:From:Subject:Message-Id; b=XP7X8pG4I9uCPuBJlcMC27z4+fezO1TwxSlMx8DMZrBa8sPc5KkZaxCT3/Z64BhXuIjCcztK/4lDS5bgBq8OqSMGw7LreJyjIbh+M5skv8c0z/clLJ21TOYegHG0AxdkolOkX/xWxKtx1jyWVpLTD4U0YGiK3DhAP3Cojoo8e7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRXLl3qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRXLl3qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E068C4CEC2;
	Mon,  2 Sep 2024 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311923;
	bh=lk+NYzTmWCHTIwXQq8PnMKYzsyET4PQOI/YbnmderFY=;
	h=Date:To:From:Subject:From;
	b=hRXLl3qs0QutPS7Eo2KqrB2DXr+33Cnwex1iLdiBvmSaDFpLJoTRN5jdGpTtXUxpJ
	 varXRNNlSlLNy1JCNTHE0pLzPOWv3U2PyIlRxu9QnQH9KlKag409s1+pEFVe0DRZ1J
	 C2DdysvnDuoAEgQLpdZmyk/xuxBq1UyxOOY+YxX0=
Date: Mon, 02 Sep 2024 14:18:42 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-support-for-dict-comp-config.patch added to mm-unstable branch
Message-Id: <20240902211843.6E068C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add support for dict comp config
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-support-for-dict-comp-config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-support-for-dict-comp-config.patch

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
Subject: zram: add support for dict comp config
Date: Mon, 2 Sep 2024 19:56:04 +0900

Handle dict=path algorithm param so that we can read a pre-trained
compression algorithm dictionary which we then pass to the backend
configuration.

Link: https://lkml.kernel.org/r/20240902105656.1383858-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   45 +++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-support-for-dict-comp-config
+++ a/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/debugfs.h>
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
+#include <linux/kernel_read_file.h>
 
 #include "zram_drv.h"
 
@@ -998,8 +999,34 @@ static int __comp_algorithm_store(struct
 	return 0;
 }
 
-static int comp_params_store(struct zram *zram, u32 prio, s32 level)
+static void comp_params_reset(struct zram *zram, u32 prio)
 {
+	struct zcomp_params *params = &zram->params[prio];
+
+	vfree(params->dict);
+	params->level = ZCOMP_PARAM_NO_LEVEL;
+	params->dict_sz = 0;
+	params->dict = NULL;
+}
+
+static int comp_params_store(struct zram *zram, u32 prio, s32 level,
+			     const char *dict_path)
+{
+	ssize_t sz = 0;
+
+	comp_params_reset(zram, prio);
+
+	if (dict_path) {
+		sz = kernel_read_file_from_path(dict_path, 0,
+						&zram->params[prio].dict,
+						INT_MAX,
+						NULL,
+						READING_POLICY);
+		if (sz < 0)
+			return -EINVAL;
+	}
+
+	zram->params[prio].dict_sz = sz;
 	zram->params[prio].level = level;
 	return 0;
 }
@@ -1010,7 +1037,7 @@ static ssize_t algorithm_params_store(st
 				      size_t len)
 {
 	s32 prio = ZRAM_PRIMARY_COMP, level = ZCOMP_PARAM_NO_LEVEL;
-	char *args, *param, *val, *algo = NULL;
+	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct zram *zram = dev_to_zram(dev);
 	int ret;
 
@@ -1039,6 +1066,11 @@ static ssize_t algorithm_params_store(st
 			algo = val;
 			continue;
 		}
+
+		if (!strcmp(param, "dict")) {
+			dict_path = val;
+			continue;
+		}
 	}
 
 	/* Lookup priority by algorithm name */
@@ -1060,7 +1092,7 @@ static ssize_t algorithm_params_store(st
 	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
-	ret = comp_params_store(zram, prio, level);
+	ret = comp_params_store(zram, prio, level, dict_path);
 	return ret ? ret : len;
 }
 
@@ -2050,12 +2082,7 @@ static void zram_comp_params_reset(struc
 	u32 prio;
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		struct zcomp_params *params = &zram->params[prio];
-
-		vfree(params->dict);
-		params->level = ZCOMP_PARAM_NO_LEVEL;
-		params->dict_sz = 0;
-		params->dict = NULL;
+		comp_params_reset(zram, prio);
 	}
 }
 
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

