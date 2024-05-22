Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB1142910
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417126; cv=none; b=dextPUOvAwtmBJ8/ShjqU/hU+sXXLd+j+Pknx/X2s64HUfaGG46nObORBN9Cn4D5viDph28uSIbqPF3NpKwPttOxInJi/RAlOUJsYBQB5+zavV59axyLecDZ0NoBIkTjUtVkIKsb1TpE85FlUcwpA9ZbG5mHYwT0/O2+T8LZhEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417126; c=relaxed/simple;
	bh=pFx0o42hBLkLEPtnTSNIXH5OYCq/FNiEiZG9btAYBVQ=;
	h=Date:To:From:Subject:Message-Id; b=XniD6AxkGJoRfAAAh9mGb6WuNdvKm/ja5tt+KUhdTQHqtM71aT02Vbaz6M3tUm/WRXSuNr0yDLT9a+2JcKm31YEvI/ir9S8ZTpvh+i/p5aM9reTyJK2+c+bWfwDekbbpht2Hk5mBiK3kuY7lDpPBrHp6C7sNJlFvpOoDtmGEiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jdRZ8eub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jdRZ8eub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265B9C2BBFC;
	Wed, 22 May 2024 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417126;
	bh=pFx0o42hBLkLEPtnTSNIXH5OYCq/FNiEiZG9btAYBVQ=;
	h=Date:To:From:Subject:From;
	b=jdRZ8eub5EN3rblR9mn0oUid99Xf/8Z3jtzfl8afiFTwC8FX4MFQOfrwD1axpDR8Y
	 rjwOp39g387tfbmHz3xtvho9KcnkGvXEDTNHOoiKWDsrfaWZCvRmYGYyFEqvCSYAF8
	 iBmlOuUuiszHv9/p749NlptwqcYd6az1LVVea7QU=
Date: Wed, 22 May 2024 15:32:05 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-extend-comp_algorithm-attr-write-handling.patch added to mm-unstable branch
Message-Id: <20240522223206.265B9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: extend comp_algorithm attr write handling
has been added to the -mm mm-unstable branch.  Its filename is
     zram-extend-comp_algorithm-attr-write-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-extend-comp_algorithm-attr-write-handling.patch

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
Subject: zram: extend comp_algorithm attr write handling
Date: Wed, 15 May 2024 16:12:48 +0900

Previously comp_algorithm device attr would accept only algorithm name
param, however in order to enabled comp configuration we need to extend
comp_algorithm_store() with param=value support.

Link: https://lkml.kernel.org/r/20240515071645.1788128-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-extend-comp_algorithm-attr-write-handling
+++ a/drivers/block/zram/zram_drv.c
@@ -1013,9 +1013,33 @@ static ssize_t comp_algorithm_store(stru
 				    size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
+	char *args, *param, *val;
+	char *alg = NULL;
 	int ret;
 
-	ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, buf);
+	args = skip_spaces(buf);
+	while (*args) {
+		args = next_arg(args, &param, &val);
+
+		/*
+		 * We need to support 'param' without value, which is an
+		 * old format for this attr (algorithm name only).
+		 */
+		if (!val || !*val) {
+			alg = param;
+			continue;
+		}
+
+		if (!strcmp(param, "algo")) {
+			alg = val;
+			continue;
+		}
+	}
+
+	if (!alg)
+		return -EINVAL;
+
+	ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, alg);
 	return ret ? ret : len;
 }
 
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

