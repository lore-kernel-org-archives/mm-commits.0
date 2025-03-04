Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4A0154BF5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048723; cv=none; b=QgwxNKW560IxE3wOz5UEuXbrdfrhSi5uivnBcaOj3NrfcbyymKNCQ5g6ohpY/2CkDbJbfcwmuD2602mTIXKz/bkJlTuhV1BI29GiDQrFNuIk9+AC8oeEai7r6h81wrxj0JMleoPgIVG654I9mZh19fjytiNAQMhdzm1Cq5K2Vm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048723; c=relaxed/simple;
	bh=WnmiFdf71IzE4y/iahcplfsZF0qLIgSbyAYCyMEuxvs=;
	h=Date:To:From:Subject:Message-Id; b=JSjfKLvnCdmmxnNQJDRDfwDggLrVYno7l8DUO9e5Z6XM0JDFYGN9qzdYvxC4RIytLarrguG5KXvGH6n2O7GO5DnKYvM0xnP43G8gK0VoBhDry0RgaY6RS18FViLN9GZBicwk++YvuQwclj4fAieH02jUuIlCXv/To4BqhXZyvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0gEQTcnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0gEQTcnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC00C4CEE4;
	Tue,  4 Mar 2025 00:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048723;
	bh=WnmiFdf71IzE4y/iahcplfsZF0qLIgSbyAYCyMEuxvs=;
	h=Date:To:From:Subject:From;
	b=0gEQTcnqTw0BIRw25u1vdrmDowaO08DR4uXDv/IRBNYnJFQyJoK/x7wL3c1OcQqBN
	 l33DCi3TOA0BNF7EUZS1AmBm/pot/NEoJFiqYERZZDrX3ZtXYGirqBYdhGhTLqK0IG
	 cNlHgpq17FV06X/9WJi8PCSznuWGOQWqeePYAlug=
Date: Mon, 03 Mar 2025 16:38:42 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch added to mm-unstable branch
Message-Id: <20250304003843.2DC00C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add GFP_NOWARN to incompressible zsmalloc handle allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch

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
Subject: zram: add GFP_NOWARN to incompressible zsmalloc handle allocation
Date: Mon, 3 Mar 2025 11:03:15 +0900

We normally use __GFP_NOWARN for zsmalloc handle allocations, add it to
write_incompressible_page() allocation too.

Link: https://lkml.kernel.org/r/20250303022425.285971-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1691,7 +1691,8 @@ static int write_incompressible_page(str
 	 * like we do for compressible pages.
 	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
-			   GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
+			   GFP_NOIO | __GFP_NOWARN |
+			   __GFP_HIGHMEM | __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle))
 		return PTR_ERR((void *)handle);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zram-move-post-processing-target-allocation.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-sleepable-zspage-reader-lock.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

