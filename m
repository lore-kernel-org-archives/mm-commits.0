Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E918E345
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925275; cv=none; b=ChEjvon2iPTNwytzGbFAa6VQccLtYmwb9TMCRUOIYHW6my/YelHkcVu/+bsgoJq7RRmclTtHUwhg5zP+QYwYBEsk86c7ELCQdH/ddOW/TSmwKLpgx3ILIeO1MlmcBSG033C7bv54RvFNYeKz33VHTs/SGyf2fuwCIl4pLzLldAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925275; c=relaxed/simple;
	bh=Nmiu+uvNnzUlORaZVn53v4J30FBsIb3Q1L1avmzorT0=;
	h=Date:To:From:Subject:Message-Id; b=XGWzuADiK1ioUiC4xiDkWg+7gePycR6wCK7PTpzuc4mO5l3/jxFg7sO7oF5eQy8DvFDtvnk7fhiEisXxU/xbJKu9m4FA3kLlSCohC9j9pued8oVtnqJykrhiEz42wtniJu1r+pVazjlllC/V5xP/YVJqZ8hZdMsnwJ1p1DMp+vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OyMffVDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OyMffVDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B90C4CEC5;
	Mon,  9 Sep 2024 23:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925275;
	bh=Nmiu+uvNnzUlORaZVn53v4J30FBsIb3Q1L1avmzorT0=;
	h=Date:To:From:Subject:From;
	b=OyMffVDYu802ivDjSJgm214dLXMzz0yDLOYMtI+Om8eXDcJCFzohBveRrOVO2PULx
	 rfBGcji/wKh7EIwOlckCgSHNaB8+M5Ge5Bw6qCW2ySrvfsUhLg9Y+h7GpcKbQLSGXv
	 5LtnavGec5ReDK9/IPvd/rxzRjyS6/H/p54FtrU8=
Date: Mon, 09 Sep 2024 16:41:14 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-recalculate-zstd-compression-params-once.patch removed from -mm tree
Message-Id: <20240909234115.63B90C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: recalculate zstd compression params once
has been removed from the -mm tree.  Its filename was
     zram-recalculate-zstd-compression-params-once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: recalculate zstd compression params once
Date: Mon, 2 Sep 2024 19:56:02 +0900

zstd compression params depends on level, but are constant for a given
instance of zstd compression backend.  Calculate once (during ctx
creation).

Link: https://lkml.kernel.org/r/20240902105656.1383858-15-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-recalculate-zstd-compression-params-once
+++ a/drivers/block/zram/backend_zstd.c
@@ -10,6 +10,7 @@
 struct zstd_ctx {
 	zstd_cctx *cctx;
 	zstd_dctx *dctx;
+	zstd_parameters cprm;
 	void *cctx_mem;
 	void *dctx_mem;
 	s32 level;
@@ -40,6 +41,7 @@ static void *zstd_create(struct zcomp_pa
 		ctx->level = zstd_default_clevel();
 
 	prm = zstd_get_params(ctx->level, PAGE_SIZE);
+	ctx->cprm = zstd_get_params(ctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&prm.cParams);
 	ctx->cctx_mem = vzalloc(sz);
 	if (!ctx->cctx_mem)
@@ -69,11 +71,10 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters prm = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
-				 src, src_len, &prm);
+				 src, src_len, &zctx->cprm);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	*dst_len = ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

