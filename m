Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC83A217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188418; cv=none; b=QCrW9zaJ+Sg0HpxjictS04jpZN0q/JzuZf9p5To8TYK26ePtXtuY1gy6gz2lbf1owU/rBNaLtf9qRPe+vA/KKTjdGMr/7eZjWow1/xJvnvAYYRHtaw1Ch0JlcKxAjMGR0nIJje3SFkieUgBi3eO9OdrACFeF09drVW93lWZqVUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188418; c=relaxed/simple;
	bh=iFpPJAYunEt2dhQMp01tMT8hG+R0JL2SUJUVtzocA2o=;
	h=Date:To:From:Subject:Message-Id; b=mWdS3s546G2LwZsfstaE8q8FNymPd3oFGj4H1FJwp6eIyyipjYrTUSveu3goBB/Y9dnZ5OKo4Z7doJjJjSDnLifH17vPW16lG470dRRql8H3GVodv6J7LPaqPc14TmPEvBWlqejR1SQakgVziLO9Vq+FsPoRSirwMBv+K4tKRFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJF6f+fW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJF6f+fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FA9C4CEEC;
	Mon, 17 Mar 2025 05:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188418;
	bh=iFpPJAYunEt2dhQMp01tMT8hG+R0JL2SUJUVtzocA2o=;
	h=Date:To:From:Subject:From;
	b=RJF6f+fWGxmZeUwWumq3hosR1pmEAFZxqZxe8S9VNbYNlhd3X5MhkOgEuJ6Y6ZTY7
	 a7h3u9AY3o9YCpkXxpbhvIKAEkm599Y7KdqKJD/fEqTbXtXLb0X0Kbp6nO6A8XwdKh
	 xZgubCz8btR/X8Xrqr1NoU5n+Xk1hyi+mmcEgsKU=
Date: Sun, 16 Mar 2025 22:13:38 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-writestall-zram_stats-member.patch removed from -mm tree
Message-Id: <20250317051338.90FA9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove writestall zram_stats member
has been removed from the -mm tree.  Its filename was
     zram-remove-writestall-zram_stats-member.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


