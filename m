Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFE19343E
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011507; cv=none; b=fykuv8N3QDOzO/i4vU3k4HwlhydFcG5gCWI1LmAjNOTcOcFrDhWX0QjKnEeYlKg6n+qsi+vmUo8JETh/MoeLQXKeFY1XMDyKe6fyodMQH4NddSXUttSMVwloLe0yMsUyfOtRzhiWVOL4brm9buIizeTSc/A0aDJrWd2egK/Vvf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011507; c=relaxed/simple;
	bh=YuQHKMrcMDz4E5wtpY/33JhgoXwg5D7D+2zYqQ+DXpY=;
	h=Date:To:From:Subject:Message-Id; b=AYzprKxEiUTm1M5xc6EjI+JIDU2d2pGbL5o+3ZjgNgPY4tjNCw42hMzWw+GZskkHDq7GE3XNHM6QHERCYg+eW8mcN9KFT/PppqqOjwotoz09fiA1XyQOGwGD4MRZXiXxJM8J7CFkz9tzt0AZ8iwbvXLDUMWOgxfmGj/pD4ODTEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LFe07uyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LFe07uyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D71C4CED2;
	Mon, 27 Jan 2025 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011506;
	bh=YuQHKMrcMDz4E5wtpY/33JhgoXwg5D7D+2zYqQ+DXpY=;
	h=Date:To:From:Subject:From;
	b=LFe07uyMkeEQ/FjpZ829AD8xg0wa38q7gP3gfvSEtNgcfNmMu84034E/3VU3rS5m1
	 PEeZCvVjS1/6h6YKaNc5nEE14oTqBtxZJ7iTeQiCKBDlDnEmbpzn6tihsxyunZA/vY
	 +8m54XW+NkgQLhFhoMnfNCNOSZU27PQ28R5JIW+k=
Date: Mon, 27 Jan 2025 12:58:26 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-writestall-zram_stats-member.patch added to mm-unstable branch
Message-Id: <20250127205826.A8D71C4CED2@smtp.kernel.org>
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
Date: Mon, 27 Jan 2025 16:29:19 +0900

There is no zsmalloc handle allocation slow path now and writestall is not
possible any longer.  Remove it from zram_stats.

Link: https://lkml.kernel.org/r/20250127072932.1289973-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
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
@@ -78,7 +78,6 @@ struct zram_stats {
 	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t writestall;		/* no. of write slow paths */
 	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */
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

