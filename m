Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CDC42A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181360; cv=none; b=roxOYW0BeEqJnfA+mNRk8Pymg8Kc5WCf0Xp83ZB7CgFXPYWDB3zY0+sWGn2h0oEQ3gHimeIEf/HR/M2vYWOyRyeDPjJmFvCRMzJf5eE3xEFYUzwa2Xqz57arLh84eUEwFDXGb8Qi5sv0rI/P5T2DfpHP+5QLu9EliMRU484NpjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181360; c=relaxed/simple;
	bh=eZvDRqQJh31hiM7Xb9FUWZFFv7o70H0KjlS/b54riWo=;
	h=Date:To:From:Subject:Message-Id; b=VuZXjJOIdYcAALUDdS3bDkRWV8Nb7uN9NACp57VrujNMENC6buFC9U9b8EvtqA83Hhbt/R1ELNt8HTrcCBI3JW5j6afvjJmSAHc1sAzf8kGMrEbodpjZ2ZqMpUiUyQx+paDzuGDhDnZGZf35EKlFWOie0nkuraRC31ibgt4LDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKvgN68K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKvgN68K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898C9C4CED6;
	Fri, 21 Feb 2025 23:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181360;
	bh=eZvDRqQJh31hiM7Xb9FUWZFFv7o70H0KjlS/b54riWo=;
	h=Date:To:From:Subject:From;
	b=AKvgN68KxwqZ47tBziB42AKZrvrTwPZpOlgXnH/BlJjhS9PGDgMOywD6HbuJxynJd
	 2jKPq3YmNTvtPRcelqoBywExmELUVBPscoSkkXQXJbtMQgtE0flGCT1DSTNh3Vk4DI
	 ro0Xggo/F0dldJHn6kJ3Dmp/NxO9IXmM+7KSQg8c=
Date: Fri, 21 Feb 2025 15:42:40 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-writestall-zram_stats-member.patch added to mm-unstable branch
Message-Id: <20250221234240.898C9C4CED6@smtp.kernel.org>
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
Date: Sat, 22 Feb 2025 07:25:37 +0900

There is no zsmalloc handle allocation slow path now and writestall is not
possible any longer.  Remove it from zram_stats.

Link: https://lkml.kernel.org/r/20250221222958.2225035-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
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
@@ -1443,9 +1443,8 @@ static ssize_t debug_stat_show(struct de
 
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
@@ -84,7 +84,6 @@ struct zram_stats {
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
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

