Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08490195811
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011505; cv=none; b=HmaMA0VyDOHuNn97d6oT/eRUJFoscZejf9vsPmR9S3Fdx91Jcs/za5f3aTQrEi+IO0gw765qPJsM4xWvHTI5Tswxw3wcPUpm/cd9US2TQpJ2KVjPTGL9b1D8NarzGzQl0uYKI7L1gN476otoGV55Ey66H4Pdh4tHe7ze5hvnMJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011505; c=relaxed/simple;
	bh=qHdV5J9o/xPBFqSmBRnoGNhrvZvV9pDKq+DxIjl0Rro=;
	h=Date:To:From:Subject:Message-Id; b=r1ccC5VTOPDv3Z4ZRzak3OYGP9feRKPvqFLTe+jh4b1LJk6nv0BoJB4T1q1kW4440UmLKW9wIXUflbHsv7IpoVAiSJv301HvpSoRa/xyAhUZ7QKWPu5PtLzRY4LwBySP909jPgFtaMDW/owS1ix5tVzzlopMRc+bJB9bC5G7Nz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fk64D9LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fk64D9LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E2C4CED2;
	Mon, 27 Jan 2025 20:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011504;
	bh=qHdV5J9o/xPBFqSmBRnoGNhrvZvV9pDKq+DxIjl0Rro=;
	h=Date:To:From:Subject:From;
	b=fk64D9LUTPOrgM5dvWyjITo8nkJdKWmDNANHTya3z0+kMiS40/vEkhhKK8jiR2NNw
	 E9tt/HJdv+RiKTqKjytGZz0sCwJcrwr2kcf03bWT8LLEayS4uus9Xs8exIwXs1eUGB
	 gfZ4qTQRj5RX/sC/ZjfABOC5Jtr98OYmaRO4VZy0=
Date: Mon, 27 Jan 2025 12:58:24 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-permit-reclaim-in-recompression-handle-allocation.patch added to mm-unstable branch
Message-Id: <20250127205824.CC8E2C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: permit reclaim in recompression handle allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-permit-reclaim-in-recompression-handle-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-permit-reclaim-in-recompression-handle-allocation.patch

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
Subject: zram: permit reclaim in recompression handle allocation
Date: Mon, 27 Jan 2025 16:29:18 +0900

Recompression path can now permit direct reclaim during new zs_handle
allocation, because it's not atomic anymore.

Link: https://lkml.kernel.org/r/20250127072932.1289973-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-permit-reclaim-in-recompression-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1988,17 +1988,11 @@ static int recompress_slot(struct zram *
 		return 0;
 
 	/*
-	 * No direct reclaim (slow path) for handle allocation and no
-	 * re-compression attempt (unlike in zram_write_bvec()) since
-	 * we already have stored that object in zsmalloc. If we cannot
-	 * alloc memory for recompressed object then we bail out and
-	 * simply keep the old (existing) object in zsmalloc.
+	 * If we cannot alloc memory for recompressed object then we bail out
+	 * and simply keep the old (existing) object in zsmalloc.
 	 */
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
-			       __GFP_KSWAPD_RECLAIM |
-			       __GFP_NOWARN |
-			       __GFP_HIGHMEM |
-			       __GFP_MOVABLE);
+			       GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zram->comps[prio], zstrm);
 		return PTR_ERR((void *)handle_new);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-switch-to-non-atomic-entry-locking.patch
zram-do-not-use-per-cpu-compression-streams.patch
zram-remove-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-permit-reclaim-in-recompression-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-unlock-slot-during-recompression.patch

