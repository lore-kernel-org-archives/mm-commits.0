Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290D1613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849213; cv=none; b=oA8n801AwPoUk0dTucw5ghfAQONun6932p5i4tLdd+m6tNbIOqdZiA95nm23U1Cz6CMfwu+NXaliszegpYJjUt6ro9RlKZaz7dG2SoIXa8qmuCDKNAM7dQiX03Mg0SxQskqye/mPmKhkS89LUYV5WHqYp3FoTu2ANhR4mrKn07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849213; c=relaxed/simple;
	bh=lmJTFhdQ2NtTrpfRUDE+PR/jdmibSjMGdLOmgN7YUYc=;
	h=Date:To:From:Subject:Message-Id; b=Is17YZU4/HQX19By8y07CHxKiy7i/eklhQTWffEcaSkYuJBN6HypjxnIR9x1HDVfcih427D4EvUf3tdscNvOw94T1smnWo+Lg4vcpULlOqT2AoekU+wcR0SDTpThVoODFN1lG+R44ZH7/1mU9xv3gj3rO45QL+zqhJ3uLA8pQTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kpB+rpKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kpB+rpKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4182C32781;
	Wed, 24 Jul 2024 19:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849213;
	bh=lmJTFhdQ2NtTrpfRUDE+PR/jdmibSjMGdLOmgN7YUYc=;
	h=Date:To:From:Subject:From;
	b=kpB+rpKiEv780Qbc9uyPeWWXaEt9UQywbqBVHgWMLB4BjExmvIefj932FOIZ8jBbR
	 jgSqeTAIIPecqMPERkObsxqxQhTKrd0I/aJLh2Ji5MJAZBp5Y2F3+0DHHJmAqZTEZS
	 QCGQtWebg0xEcf7KObvn77LxEoKxDWRcb30O6Uiw=
Date: Wed, 24 Jul 2024 12:26:52 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-support-for-dict-comp-config.patch added to mm-unstable branch
Message-Id: <20240724192652.F4182C32781@smtp.kernel.org>
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
Date: Fri, 12 Jul 2024 14:18:27 +0900

Handle dict=path param so that we can read a pre-trained
compression algorithm dictionary which we then pass to the
backend configuration.

Link: https://lkml.kernel.org/r/20240712051850.484318-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   60 ++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 14 deletions(-)

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
@@ -1020,7 +1047,7 @@ static ssize_t comp_algorithm_store(stru
 {
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val;
-	char *alg = NULL;
+	char *alg = NULL, *dict_path = NULL;
 	s32 level = ZCOMP_PARAM_NO_LEVEL;
 	int ret;
 
@@ -1048,12 +1075,17 @@ static ssize_t comp_algorithm_store(stru
 				return ret;
 			continue;
 		}
+
+		if (!strcmp(param, "dict")) {
+			dict_path = val;
+			continue;
+		}
 	}
 
 	if (!alg)
 		return -EINVAL;
 
-	ret = comp_params_store(zram, ZRAM_PRIMARY_COMP, level);
+	ret = comp_params_store(zram, ZRAM_PRIMARY_COMP, level, dict_path);
 	if (!ret)
 		ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, alg);
 	return ret ? ret : len;
@@ -1087,7 +1119,7 @@ static ssize_t recomp_algorithm_store(st
 	struct zram *zram = dev_to_zram(dev);
 	int prio = ZRAM_SECONDARY_COMP;
 	char *args, *param, *val;
-	char *alg = NULL;
+	char *alg = NULL, *dict_path = NULL;
 	s32 level = ZCOMP_PARAM_NO_LEVEL;
 	int ret;
 
@@ -1116,6 +1148,11 @@ static ssize_t recomp_algorithm_store(st
 				return ret;
 			continue;
 		}
+
+		if (!strcmp(param, "dict")) {
+			dict_path = val;
+			continue;
+		}
 	}
 
 	if (!alg)
@@ -1124,7 +1161,7 @@ static ssize_t recomp_algorithm_store(st
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
-	ret = comp_params_store(zram, prio, level);
+	ret = comp_params_store(zram, prio, level, dict_path);
 	if (!ret)
 		ret = __comp_algorithm_store(zram, prio, alg);
 	return ret ? ret : len;
@@ -2029,17 +2066,12 @@ static void zram_slot_free_notify(struct
 	zram_slot_unlock(zram, index);
 }
 
-static void zram_reset_comp_params(struct zram *zram)
+static void zram_comp_params_reset(struct zram *zram)
 {
 	u32 prio;
 
 	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
-		struct zcomp_params *params = &zram->params[prio];
-
-		vfree(params->dict);
-		params->level = ZCOMP_PARAM_NO_LEVEL;
-		params->dict_sz = 0;
-		params->dict = NULL;
+		comp_params_reset(zram, prio);
 	}
 }
 
@@ -2057,7 +2089,7 @@ static void zram_destroy_comps(struct zr
 		zram->num_active_comps--;
 	}
 
-	zram_reset_comp_params(zram);
+	zram_comp_params_reset(zram);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2321,7 +2353,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	zram_reset_comp_params(zram);
+	zram_comp_params_reset(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
 	zram_debugfs_register(zram);
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
zram-extend-comp_algorithm-attr-write-handling.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

