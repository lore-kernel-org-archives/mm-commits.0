Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90191613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849170; cv=none; b=ZIB2koJjPBewplggA5Dh63xQu/zuuYuojioxVVcQuhNL4Gug7IOJimulOe80DM3U7HFl48sADByvmOtVJhikfN3Wr6TXsUlk0RbWqqllForTP/CN7L1pk/5J+V+R1d9VzCwqghSNsGAS4ikToUujT+bpz/+RaHmivNhlpjLLtjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849170; c=relaxed/simple;
	bh=1z8qun/Ckb8kRn6HhZna/Q7HTERlD5lb0WL9E10BTdw=;
	h=Date:To:From:Subject:Message-Id; b=eBwRy4xf8ZHyrN+HkDrtnh+WO5KPZW6vu7M8inoNHiZbdLjvkP8MZ8AXB4T2jviAfdiLXMhQBsb0L5q03y/FOQOeUUg9eHmzbmr/HTyJK0EFivmfqyS6cxiOfh9wPbAmH+r2HL7uKZzCHUOmg9DVkiXp3N29AgbISb7xhV9xpVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kfok5zPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kfok5zPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435E4C32781;
	Wed, 24 Jul 2024 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849170;
	bh=1z8qun/Ckb8kRn6HhZna/Q7HTERlD5lb0WL9E10BTdw=;
	h=Date:To:From:Subject:From;
	b=kfok5zPWwf5t5UXPhfYPRI8auH8klMtUOtaFPxor6aN7Yw9L2+kfi/0GnOV8bWwqq
	 SZZSFsh1z7ZN8a7wbI75kTi+3EbP1lypSiUKLnaJhoFtHoQRwNxw9uTbH8YtbsjMof
	 uXXH80++LVHOwdV/KhsU92s+Y8hGfDKjdVCZHqjA=
Date: Wed, 24 Jul 2024 12:26:09 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch added to mm-unstable branch
Message-Id: <20240724192610.435E4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: zstd: fix null-deref in ZSTD_createCDict_advanced2()
has been added to the -mm mm-unstable branch.  Its filename is
     lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch

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
Subject: lib: zstd: fix null-deref in ZSTD_createCDict_advanced2()
Date: Fri, 12 Jul 2024 14:18:14 +0900

ZSTD_createCDict_advanced2() must ensure that
ZSTD_createCDict_advanced_internal() has successfully
allocated cdict.  customMalloc() may be called under
low memory condition and may be unable to allocate
workspace for cdict.

Link: https://lkml.kernel.org/r/20240712051850.484318-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zstd/compress/zstd_compress.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/zstd/compress/zstd_compress.c~lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2
+++ a/lib/zstd/compress/zstd_compress.c
@@ -4810,6 +4810,8 @@ ZSTD_CDict* ZSTD_createCDict_advanced2(
                         dictLoadMethod, cctxParams.cParams,
                         cctxParams.useRowMatchFinder, cctxParams.enableDedicatedDictSearch,
                         customMem);
+    if (!cdict)
+        return NULL;
 
     if (ZSTD_isError( ZSTD_initCDict_internal(cdict,
                                     dict, dictSize,
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

