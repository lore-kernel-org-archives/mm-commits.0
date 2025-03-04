Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6311156C76
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048725; cv=none; b=oxxRL75McdG8BJu+AaG4r0PBkwYzBcJb5+OjyQ2QNW3DMcWMVrhMdz2xD9liyTdmwzqvE/+IdhDWJ1jwU22vHikjkH2cmY2IodVZtC3giUMjEdU/e58QmQdVYiGX7r2Gn9REbP/7xbswABFR2tXDGjNKGvPnwnX1/SB91fRv/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048725; c=relaxed/simple;
	bh=EfFusaebeVcRm0Q2jxKdl2aUNknu6CrsHJNDsIkgXHU=;
	h=Date:To:From:Subject:Message-Id; b=smVo8UUvyL/rmmFMzR50qtLOeWM7jV6W9uO3VzDu+sIFrryFho9LHqaWWxr/x3Q7kqC0mnu0FsrG90IrTOyu2wx0JlVX9FLMp1k7GP9EjoJFrobdZlBKIxBsl2fkntxcud1gpaZkuW3XQrZtdLaES4p1zfBGcJTdE3IbUtHLmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rCGyY0K5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rCGyY0K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F2AC4CEE4;
	Tue,  4 Mar 2025 00:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048725;
	bh=EfFusaebeVcRm0Q2jxKdl2aUNknu6CrsHJNDsIkgXHU=;
	h=Date:To:From:Subject:From;
	b=rCGyY0K5RN+Dd8l1GHrMjLmlQFr7wfUAbKzCBM747idIYKiLS3hI+M9RkHryHE8my
	 7QxxcTWSorL9iSs65Ya69/yZJrLJwd6GLOS0bIhVwl/k4sf2TpTo6KbfBSrYfgQoCv
	 pF/ngtQliiWSaroPLfFEHFxdVPm+DI6DEUDfNxRA=
Date: Mon, 03 Mar 2025 16:38:44 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-writestall-zram_stats-member.patch added to mm-unstable branch
Message-Id: <20250304003845.30F2AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove writestall zram_stats member
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-writestall-zram_stats-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-writestall-zram_stats-member.patch

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
Subject: zram: remove writestall zram_stats member
Date: Mon, 3 Mar 2025 11:03:16 +0900

There is no zsmalloc handle allocation slow path now and writestall is not
possible any longer.  Remove it from zram_stats.

Link: https://lkml.kernel.org/r/20250303022425.285971-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-writestall-zram_stats-member
+++ a/drivers/block/zram/zram_drv.c
@@ -1437,9 +1437,8 @@ static ssize_t debug_stat_show(struct de
 
 	down_read(&zram->init_lock);
 	ret = scnprintf(buf, PAGE_SIZE,
-			"version: %d\n%8llu %8llu\n",
+			"version: %d\n0 %8llu\n",
 			version,
-			(u64)atomic64_read(&zram->stats.writestall),
 			(u64)atomic64_read(&zram->stats.miss_free));
 	up_read(&zram->init_lock);
 
--- a/drivers/block/zram/zram_drv.h~zram-remove-writestall-zram_stats-member
+++ a/drivers/block/zram/zram_drv.h
@@ -82,7 +82,6 @@ struct zram_stats {
 	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t writestall;		/* no. of write slow paths */
 	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */
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

