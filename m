Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82023172BD5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048745; cv=none; b=rxwHg9XI/VZbud6g+13BFQSk+Cl5dUj7r+n0K7DOAAxitQr8dqvgcJ+zuOw4vO/7Rn3jR3YefLaBC8hGhtI8WDly/ROxjD2oEZ6DH2PLiqQF9X1+f9jP6Z5hKPKbcBg+PYLeQTY+sz3K3dEhwy+3rgx34LMUgT0XTPWBhOd68xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048745; c=relaxed/simple;
	bh=31viiwl1bpPeXnXvgZDqiH0MXZ7COZyc8WOrgvVxupg=;
	h=Date:To:From:Subject:Message-Id; b=Y5klyCNP6paRfk50sPnP4JbzOZRbMYH7iTHtUvuadHCTOG239V+ekcgNu+el/Zj8imuXCwCof65PYnsHDudTWYaMiYrPiGO1Y679WJ/u2NbUS1f7+SIcEhff+Ln7F9FB7jJKEzFGDiTPLEk75Fb7aEUhBBqnGUkNftM84+HEH18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzPwgLH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzPwgLH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52726C4CEE4;
	Tue,  4 Mar 2025 00:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048745;
	bh=31viiwl1bpPeXnXvgZDqiH0MXZ7COZyc8WOrgvVxupg=;
	h=Date:To:From:Subject:From;
	b=fzPwgLH4HAwXP1Q8o6dNeUSpVsGPyWRrjhOiPiyRCkOMUh+n/4gVY8cdGkoAb+tD0
	 zPKa9sEKMPREIicn0fcnAhkrQEK0EUqQhl4w6m55wqNeLDx+4f6hluV9APW7YHjMBt
	 ysYcvMLVp487OVb0oX2cTc7HOIbAagNFqsnFX4eo=
Date: Mon, 03 Mar 2025 16:39:04 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-permit-reclaim-in-zstd-custom-allocator.patch added to mm-unstable branch
Message-Id: <20250304003905.52726C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: permit reclaim in zstd custom allocator
has been added to the -mm mm-unstable branch.  Its filename is
     zram-permit-reclaim-in-zstd-custom-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-permit-reclaim-in-zstd-custom-allocator.patch

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
Subject: zram: permit reclaim in zstd custom allocator
Date: Mon, 3 Mar 2025 11:03:25 +0900

When configured with pre-trained compression/decompression dictionary
support, zstd requires custom memory allocator, which it calls internally
from compression()/decompression() routines.  That means allocation from
atomic context (either under entry spin-lock, or per-CPU local-lock or
both).  Now, with non-atomic zram read()/write(), those limitations are
relaxed and we can allow direct and indirect reclaim.

Link: https://lkml.kernel.org/r/20250303022425.285971-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-permit-reclaim-in-zstd-custom-allocator
+++ a/drivers/block/zram/backend_zstd.c
@@ -24,19 +24,10 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
- *
- * This means that allocator.customAlloc() can be called from zcomp_compress()
- * under local-lock (per-CPU compression stream), in which case we must use
- * GFP_ATOMIC.
- *
- * Another complication here is that we can be configured as a swap device.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	if (!preemptible())
-		return kvzalloc(size, GFP_ATOMIC);
-
-	return kvzalloc(size, __GFP_KSWAPD_RECLAIM | __GFP_NOWARN);
+	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
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

