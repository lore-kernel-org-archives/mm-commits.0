Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43C3613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849168; cv=none; b=LOKGqSW8VRyyPCq737EKZ+EYMaR3oOYHhel3eyF+V70xQAGwTmaEexB/c/2s+9h30SEeRYD9ajbyoBMp92Lm6fEMtzWxO4KaS8LC/zbNPMC50Wx8PzbkXISU2wjeq1WmjNi77R/qMXthvQsIMQBAF8X1c9Dz5cPuaRH4pzhckGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849168; c=relaxed/simple;
	bh=7Fi5XmGKB7YZLMGLSnIsypUpYAWaSY7C3bXfhdSuIi8=;
	h=Date:To:From:Subject:Message-Id; b=D0G62unmSYkIbye53pDeC7X2PvidKMP6L44Z+KDKnZjkaa/KNxlG0STegWvC71W47h/iDVMkT3lVIIcBLpHOKdQVXqgKsYojfElXCksprFkeFg8ccpinEVFFL51i2lPmoEzzMyQsQtYkkWJMDQRJGqy1sbCSvkGQvgSBM9TM7ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ApiN4SK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ApiN4SK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C575C32781;
	Wed, 24 Jul 2024 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849168;
	bh=7Fi5XmGKB7YZLMGLSnIsypUpYAWaSY7C3bXfhdSuIi8=;
	h=Date:To:From:Subject:From;
	b=ApiN4SK9mm1WDHDSlKmsmZ9xQ6JU+svVRynmVz1B5s9w2JlGzDCTsTMkM9+ZstJ5C
	 n6yw/WVYHqTKdDw+UpHh+vZKrUKXLCo1+E+XFszdS8/79Wntu2JAJwelmlacWfgpfQ
	 v5plmFJ7Rl6P9rdFT+Iz639egnn1WNtfBIQxEQ+M=
Date: Wed, 24 Jul 2024 12:26:07 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lz4hc-export-lz4_resetstreamhc-symbol.patch added to mm-unstable branch
Message-Id: <20240724192608.5C575C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: lz4hc: export LZ4_resetStreamHC symbol
has been added to the -mm mm-unstable branch.  Its filename is
     lib-lz4hc-export-lz4_resetstreamhc-symbol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lz4hc-export-lz4_resetstreamhc-symbol.patch

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
Subject: lib: lz4hc: export LZ4_resetStreamHC symbol
Date: Fri, 12 Jul 2024 14:18:13 +0900

This symbol is needed to enable lz4hc dictionary support.

Link: https://lkml.kernel.org/r/20240712051850.484318-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4hc_compress.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/lz4/lz4hc_compress.c~lib-lz4hc-export-lz4_resetstreamhc-symbol
+++ a/lib/lz4/lz4hc_compress.c
@@ -621,6 +621,7 @@ void LZ4_resetStreamHC(LZ4_streamHC_t *L
 	LZ4_streamHCPtr->internal_donotuse.base = NULL;
 	LZ4_streamHCPtr->internal_donotuse.compressionLevel = (unsigned int)compressionLevel;
 }
+EXPORT_SYMBOL(LZ4_resetStreamHC);
 
 int LZ4_loadDictHC(LZ4_streamHC_t *LZ4_streamHCPtr,
 	const char *dictionary,
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

