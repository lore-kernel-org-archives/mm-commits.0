Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7EA1465A8
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417121; cv=none; b=n6umc4nmn1fpf570C7k0rz/GGBnxmPqRQecZBYd/nn4P4v2BkD9z5eH8MnUp7iRTPBIgYUwWZ4Ir0vf8tfdshETb64DEvIUyL/xbkLjRAWD1+VWO/gSnPetN4k/ibEJLqeWHhhWGvL4Ih8FVmxGC32DbVpP1a3q19UDcwg0byH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417121; c=relaxed/simple;
	bh=vSVAS/OLAIYfbjvqOFwjk6k5VvEbhJN+LETrSeJsk+c=;
	h=Date:To:From:Subject:Message-Id; b=ZlPlcTYvqkiRUW7DA2fdFALpQAPEzPthHE56MLsN8+XodZNmMgS7Mni3JanNoRqj2MgTBbQP8TZXKET/xe0Jd7JxvS6ac6jMR8VMSfiw4QQuuvyeW8KlnOu0qkclnRWFgg4xQCnjEqudQSp8IFxjzfcBz574zBaVPVpiQp2U/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pCyuMh0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pCyuMh0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8E1C2BBFC;
	Wed, 22 May 2024 22:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417121;
	bh=vSVAS/OLAIYfbjvqOFwjk6k5VvEbhJN+LETrSeJsk+c=;
	h=Date:To:From:Subject:From;
	b=pCyuMh0mJQYI0aTVcKNqk688J6Qgl4tOUlMlj9wwBGflelxMeriAbi0nQX4/IwHeE
	 SswQOl/PbMXXP1Lv9fIKXJ0VedK7hvq9UXdk8c+TZRaLmWtX8Xw8Ybn+VyV6EqtW2f
	 XIT+YlTTA7ysPYqb1vRlmh/mfDwldIHfixvNBdPI=
Date: Wed, 22 May 2024 15:32:00 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-check-that-backends-array-has-at-least-one-backend.patch added to mm-unstable branch
Message-Id: <20240522223201.4A8E1C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: check that backends array has at least one backend
has been added to the -mm mm-unstable branch.  Its filename is
     zram-check-that-backends-array-has-at-least-one-backend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-check-that-backends-array-has-at-least-one-backend.patch

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
Subject: zram: check that backends array has at least one backend
Date: Wed, 15 May 2024 16:12:46 +0900

Make sure that backends array has anything apart from the sentinel NULL
value.

We also select LZO_BACKEND if none backends were selected.

Link: https://lkml.kernel.org/r/20240515071645.1788128-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig |   19 +++++++++++++------
 drivers/block/zram/zcomp.c |    8 ++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-check-that-backends-array-has-at-least-one-backend
+++ a/drivers/block/zram/Kconfig
@@ -14,12 +14,6 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
-config ZRAM_BACKEND_LZO
-	bool "lzo and lzo-rle compression support"
-	depends on ZRAM
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
-
 config ZRAM_BACKEND_LZ4
 	bool "lz4 compression support"
 	depends on ZRAM
@@ -50,6 +44,19 @@ config ZRAM_BACKEND_842
 	select 842_COMPRESS
 	select 842_DECOMPRESS
 
+config ZRAM_BACKEND_FORCE_LZO
+	depends on ZRAM
+	def_bool !ZRAM_BACKEND_LZ4 && !ZRAM_BACKEND_LZ4HC && \
+		!ZRAM_BACKEND_ZSTD && !ZRAM_BACKEND_DEFLATE && \
+		!ZRAM_BACKEND_842
+
+config ZRAM_BACKEND_LZO
+	bool "lzo and lzo-rle compression support" if !ZRAM_BACKEND_FORCE_LZO
+	depends on ZRAM
+	default ZRAM_BACKEND_FORCE_LZO
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
--- a/drivers/block/zram/zcomp.c~zram-check-that-backends-array-has-at-least-one-backend
+++ a/drivers/block/zram/zcomp.c
@@ -209,6 +209,14 @@ struct zcomp *zcomp_create(const char *a
 	struct zcomp *comp;
 	int error;
 
+	/*
+	 * The backends array has a sentinel NULL value, so the minimum
+	 * size is 1. In order to be valid the array, apart from the
+	 * sentinel NULL element, should have at least one compression
+	 * backend selected.
+	 */
+	BUILD_BUG_ON(ARRAY_SIZE(backends) <= 1);
+
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
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

