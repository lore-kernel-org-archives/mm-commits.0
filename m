Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295A318E04D
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925269; cv=none; b=ETyXFaAvlZl/qND1UnIG7SSmmugNoTGLAKuZuJfA1/qjdfSN8EUYzwMlK2o5A0S5ElizDZhc0dDi3Xe9Uk0bNfF3LfH6VdQNA3FvLCf4E6lfs51te8eqQyc2TmO6QunvV8vUBgJPMkyNUN7W7VCuJxu4FlAIMYnclW+pR92eUdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925269; c=relaxed/simple;
	bh=ZUOAh3/setvSxP7vmvIp/qAffzO4CTYusGFTaiP5bjY=;
	h=Date:To:From:Subject:Message-Id; b=fbleM8bVmFeG6cTGGEYywz3cT0j6iVLVcrunjjDY6STM61QTH2FVzBnJym8tNF3tekG6T4OG9fYuFjZI7Thu5YNlWONuPdriyKAOSg8+K6mIDfUAfWyYobfeQ6WffNfDHCcC6McpCbbzpJmbG7JIctpnW2J75yJk27pWxDtQ4I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Kjwhwm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Kjwhwm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F344FC4CEC5;
	Mon,  9 Sep 2024 23:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925269;
	bh=ZUOAh3/setvSxP7vmvIp/qAffzO4CTYusGFTaiP5bjY=;
	h=Date:To:From:Subject:From;
	b=2Kjwhwm5c8A7eMh5mqU3T40eObKXlJme6NEtDx8kPGx7w0YR44osCBx+cG+HNJkfP
	 haR2i7GNKbb7joe37jHZ2KCgoWiwJgULmZ6BGIs8+r041pqmfxvASJY5HiOrw71u5v
	 N2dgOdozkLqnO/F12AkvLZKk5SX0qblUIDPLNmds=
Date: Mon, 09 Sep 2024 16:41:08 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-pass-estimated-src-size-hint-to-zstd.patch removed from -mm tree
Message-Id: <20240909234108.F344FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: pass estimated src size hint to zstd
has been removed from the -mm tree.  Its filename was
     zram-pass-estimated-src-size-hint-to-zstd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: pass estimated src size hint to zstd
Date: Mon, 2 Sep 2024 19:55:57 +0900

zram works with PAGE_SIZE buffers, so we always know exact size of the
source buffer and hence can pass estimated_src_size to zstd_get_params().

This hint on x86_64, for example, reduces the size of the work memory
buffer from 1303520 bytes down to 90080 bytes.  Given that compression
streams are per-CPU that's quite some memory saving.

Link: https://lkml.kernel.org/r/20240902105656.1383858-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
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

zsmalloc-use-unique-zsmalloc-caches-names.patch

