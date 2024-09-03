Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389601865FB
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 21:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398931; cv=none; b=BtycAzU8HNLUcCAKeh7fGiGVZNQ9lnCW6og443Q2EItmU5BVm4l2ZPtEPH7lWIxPR9GM0YjDBhrrcxRiios1Bm25PBI1SrDeaAdXlhKo7E8BnoCSsEHjPqTTPuBkxx2WNNjqh46oT2th7XZzhzV/wNFRaHRvifeJBa1gslN9JYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398931; c=relaxed/simple;
	bh=YQPIrNpBMODBIVoKA/BaxlF425o3Mj1BvTpDKiPqXrg=;
	h=Date:To:From:Subject:Message-Id; b=OiEEJwRLppTnUbqUA8hcdkFCI6xJvjOVt3o0tKrTijtsPtcq+99lj15pwnTTB9+t0z6LtLTRMLJz/Aj4VX5sbWEPTRzzGtlakAvjg/lV8zsNxYEXxjMvgNtGmTR3cARi1HTIPdFPs3tOpDi4PrnzhERCQ+wy05+C/sKGyXbkgLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x05Xt8xO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x05Xt8xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB99C4CEC5;
	Tue,  3 Sep 2024 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725398930;
	bh=YQPIrNpBMODBIVoKA/BaxlF425o3Mj1BvTpDKiPqXrg=;
	h=Date:To:From:Subject:From;
	b=x05Xt8xOu71aVQVgz/hHniZLBBcvscb2s3pJJ6veiW/BYRMRUDwC51QvL/wHrnqik
	 qOnmimIDoqwSArJPvMdk0EwGF0SMOhTYMf4bsy5kwJGZKaZUSdQL4RWqVVTMEzdeW8
	 oEI+EXZdy1nB0+s3/QooOXEALj7pjODKvNXrHSTc=
Date: Tue, 03 Sep 2024 14:28:50 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,hannes@cmpxchg.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-fixup-zsmalloc-configuration.patch added to mm-unstable branch
Message-Id: <20240903212850.9BB99C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Kconfig: fixup zsmalloc configuration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-fixup-zsmalloc-configuration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-fixup-zsmalloc-configuration.patch

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
Subject: mm: Kconfig: fixup zsmalloc configuration
Date: Tue, 3 Sep 2024 13:00:22 +0900

zsmalloc is not exclusive to zswap.  Commit b3fbd58fcbb1 ("mm: Kconfig:
simplify zswap configuration") made CONFIG_ZSMALLOC only visible when
CONFIG_ZSWAP is selected, which makes it impossible to menuconfig
zsmalloc-specific features (stats, chain-size, etc.) on systems that use
ZRAM but don't have ZSWAP enabled.

Make zsmalloc depend on both ZRAM and ZSWAP.

Link: https://lkml.kernel.org/r/20240903040143.1580705-1-senozhatsky@chromium.org
Fixes: b3fbd58fcbb1 ("mm: Kconfig: simplify zswap configuration") 
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-fixup-zsmalloc-configuration
+++ a/mm/Kconfig
@@ -188,7 +188,7 @@ config Z3FOLD
 
 config ZSMALLOC
 	tristate
-	prompt "N:1 compression allocator (zsmalloc)" if ZSWAP
+	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
 	depends on MMU
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
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
documentation-zram-add-documentation-for-algorithm-parameters-fix.patch
zram-support-priority-parameter-in-recompression.patch
mm-kconfig-fixup-zsmalloc-configuration.patch

