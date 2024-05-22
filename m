Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03A142910
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417127; cv=none; b=hHW+wK78cMkaEfbi7FNjdKQJgibD61XeyWOK6aRaKaIuXHRZ+68u4qvFgvpmy3OK37qmm3R1HibrR72EumOVWYqCDT+e4UxsD15Lo7h59DqljSvUAAEoMUvnKhc6ivfqKPwNExbnHg2QEz2pSXmfDvYT2hVkCV5Ak8Op+Tkg/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417127; c=relaxed/simple;
	bh=gOCqkkASyXjVmQiaIFvvE0JVuaRo5kBZiCc8oyyalW0=;
	h=Date:To:From:Subject:Message-Id; b=F14JgyzmXLEuFvmWEiDjCtFIgwEs0+5e63VLEssk3V0rcEcKRs6T8o41ftp4nISRXeQj7rGl3mqgQKsPF8QHkaiodRgnT9t+706EwYO6SNbHxwyybsEadURxcE8sKtXJPgua69Fz/i1AtvpmIreqbLqKU1Muv54K1+4yZUN1W7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kx/bYbyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kx/bYbyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8324DC2BBFC;
	Wed, 22 May 2024 22:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417127;
	bh=gOCqkkASyXjVmQiaIFvvE0JVuaRo5kBZiCc8oyyalW0=;
	h=Date:To:From:Subject:From;
	b=Kx/bYbyr5g58sEbUhQYthvCvKeyQTVr3kG1U2y9uq6F852x8wor3CDTycjYFCHxsu
	 9ksvTqtxVM2P8fVeoaeMDjG1O2eHuDG+anlakJsExNmK8CDhuziPv+dqkgXLDy8oUD
	 hC0g5jMjtuQkR1JEVAmfZfgSmBrhJgFd6eBFbZjA=
Date: Wed, 22 May 2024 15:32:06 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-support-compression-level-comp-config.patch added to mm-unstable branch
Message-Id: <20240522223207.8324DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: support compression level comp config
has been added to the -mm mm-unstable branch.  Its filename is
     zram-support-compression-level-comp-config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-support-compression-level-comp-config.patch

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
Subject: zram: support compression level comp config
Date: Wed, 15 May 2024 16:12:49 +0900

Add support for compression level level=N comp configuration to
comp_algorithm and recomp_algorithm knobs.

Note that zram cannot verify ranges, it's a task of corresponding backends
to make sure that level makes sense.

Link: https://lkml.kernel.org/r/20240515071645.1788128-13-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-support-compression-level-comp-config
+++ a/drivers/block/zram/zram_drv.c
@@ -998,6 +998,12 @@ static int __comp_algorithm_store(struct
 	return 0;
 }
 
+static int comp_config_store(struct zram *zram, u32 prio, s32 level)
+{
+	zram->configs[prio].level = level;
+	return 0;
+}
+
 static ssize_t comp_algorithm_show(struct device *dev,
 				   struct device_attribute *attr,
 				   char *buf)
@@ -1015,6 +1021,7 @@ static ssize_t comp_algorithm_store(stru
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val;
 	char *alg = NULL;
+	s32 level = ZCOMP_CONFIG_NO_LEVEL;
 	int ret;
 
 	args = skip_spaces(buf);
@@ -1034,12 +1041,21 @@ static ssize_t comp_algorithm_store(stru
 			alg = val;
 			continue;
 		}
+
+		if (!strcmp(param, "level")) {
+			ret = kstrtoint(val, 10, &level);
+			if (ret)
+				return ret;
+			continue;
+		}
 	}
 
 	if (!alg)
 		return -EINVAL;
 
-	ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, alg);
+	ret = comp_config_store(zram, ZRAM_PRIMARY_COMP, level);
+	if (!ret)
+		ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, alg);
 	return ret ? ret : len;
 }
 
@@ -1072,6 +1088,7 @@ static ssize_t recomp_algorithm_store(st
 	int prio = ZRAM_SECONDARY_COMP;
 	char *args, *param, *val;
 	char *alg = NULL;
+	s32 level = ZCOMP_CONFIG_NO_LEVEL;
 	int ret;
 
 	args = skip_spaces(buf);
@@ -1092,6 +1109,13 @@ static ssize_t recomp_algorithm_store(st
 				return ret;
 			continue;
 		}
+
+		if (!strcmp(param, "level")) {
+			ret = kstrtoint(val, 10, &level);
+			if (ret)
+				return ret;
+			continue;
+		}
 	}
 
 	if (!alg)
@@ -1100,7 +1124,9 @@ static ssize_t recomp_algorithm_store(st
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
-	ret = __comp_algorithm_store(zram, prio, alg);
+	ret = comp_config_store(zram, prio, level);
+	if (!ret)
+		ret = __comp_algorithm_store(zram, prio, alg);
 	return ret ? ret : len;
 }
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-move-from-crypto-api-to-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_config-structure.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-support-compression-level-comp-config.patch
zram-add-support-for-dict-comp-config.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
zram-add-dictionary-support-to-zstd-backend.patch
zram-add-config-init-release-backend-callbacks.patch
zram-share-dictionaries-between-per-cpu-contexts.patch
zram-add-dictionary-support-to-lz4.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
zram-add-dictionary-support-to-lz4hc.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

