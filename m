Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF100613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849192; cv=none; b=sWAFg84VuC4S5BuL5AKqCeMXf+5q4018pGbzbswiRClx7LFZDLHh+rF60ANgZjdRt1FBXBRc9zV+GhqEroC0CRE6/0YdktWOhA6wl/9jsOGXcJlvLUYt+iJPorj0oK2hoxPVyMBM/HrJmvkUiKWiNki9NuV9slpn/Hk1QAbVxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849192; c=relaxed/simple;
	bh=55wSowU/RbHKSiq5D/ADitVwHS2xo+8cW/p4lQzbug8=;
	h=Date:To:From:Subject:Message-Id; b=LhSfKWpqKz2GM0dcVsI8iJa8kMgnCWVWD1JuBetqsutNsMxJRypN3wO+ZJlj5SyZYH51SViaF0E3BQtultcDOvhkMSLdoYKQ71oOR+j/R9k3/MLM0yUweK3XgnFdbbGyV/UY/ZT2qyIVugYpHi6hqgmTDJdvGR+IkDrhwDki5hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJDe4h+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJDe4h+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715C2C32781;
	Wed, 24 Jul 2024 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849191;
	bh=55wSowU/RbHKSiq5D/ADitVwHS2xo+8cW/p4lQzbug8=;
	h=Date:To:From:Subject:From;
	b=hJDe4h+hvXXFS2Mng6v4SVbFZ6HWo49CdXApWYLl/ywceWL+H4Nh+NK0zPwm5VKxQ
	 LYSoEqb5Jr14JbD8BUFNFGwrZm7BgmijN3dw8ndHNWk+W7Z+JaAfuJDBcr7RVos21A
	 TtW/rNus01fN4+zp7TpCSR8eeGhcPeXrvo1e0jTE=
Date: Wed, 24 Jul 2024 12:26:30 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-pass-estimated-src-size-hint-to-zstd.patch added to mm-unstable branch
Message-Id: <20240724192631.715C2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: pass estimated src size hint to zstd
has been added to the -mm mm-unstable branch.  Its filename is
     zram-pass-estimated-src-size-hint-to-zstd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-pass-estimated-src-size-hint-to-zstd.patch

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
Subject: zram: pass estimated src size hint to zstd
Date: Fri, 12 Jul 2024 14:18:20 +0900

zram works with PAGE_SIZE buffers, so we always know exact
size of the source buffer and hence can pass estimated_src_size
to zstd_get_params().

This hint on x86_64, for example, reduces the size of the work
memory buffer from 1303520 bytes down to 90080 bytes. Given that
compression streams are per-CPU that's quite some memory saving.

Link: https://lkml.kernel.org/r/20240712051850.484318-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-pass-estimated-src-size-hint-to-zstd
+++ a/drivers/block/zram/backend_zstd.c
@@ -35,7 +35,7 @@ static void *zstd_create(void)
 		return NULL;
 
 	ctx->level = zstd_default_clevel();
-	params = zstd_get_params(ctx->level, 0);
+	params = zstd_get_params(ctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&params.cParams);
 	ctx->cctx_mem = vzalloc(sz);
 	if (!ctx->cctx_mem)
@@ -65,7 +65,7 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters params = zstd_get_params(zctx->level, 0);
+	const zstd_parameters params = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
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

