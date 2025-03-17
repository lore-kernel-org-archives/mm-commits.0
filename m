Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C3F1531F0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188433; cv=none; b=tkenwj1iRRcWvkPTF0sme83pOzcRP9vVcJ+fAtpY7fwAKO7PXGEpdkLt982QVcM6CA6Yo5EIyCDMwghjYr46flT+tUu8th1dJrfxfMi4V9VFAXKhu7cHm++/2AHw4aK5qtUXCOp9ye7C0dcC9gqykRb8bcBi8lENYNP/24Wi4Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188433; c=relaxed/simple;
	bh=iXxN3hOsSOxzS83DbWiyb3UXIGLnTkyYkSpCHcUDzcs=;
	h=Date:To:From:Subject:Message-Id; b=KDgmhrNlgW/JHgXC1AwJe0FQ87nlE+p1/asaRJWEh/0c9LZ1HokHyxYQp17PQTMR9IMhR/dTwiQk2jWsgqU5ezo7QQdD8AToIIo+ikCzF/ycaiE6J2c714U3Rb5f1UTkkDSjcrKPntG4o/kZ/o6LJeqTGBrze05blNjcouBFYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNme9pvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNme9pvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE54C4CEEC;
	Mon, 17 Mar 2025 05:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188433;
	bh=iXxN3hOsSOxzS83DbWiyb3UXIGLnTkyYkSpCHcUDzcs=;
	h=Date:To:From:Subject:From;
	b=SNme9pvuV/ajJDcuyKyyT8+vJ9Yn6DpjnUJOVf4xgloqigr+elAwfpYN43An+StF2
	 xEf/DMXtm0vFqwgFib7ybpWtREkPn63deJUxfGq4VRTxawZ4R+yYmm0MRQqIC8Mv2h
	 CDjDi21JvP4L6ADLcdGebK4aChwOAuczQdNa/DBI=
Date: Sun, 16 Mar 2025 22:13:52 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-leak-page-on-writeback_store-error-path.patch removed from -mm tree
Message-Id: <20250317051353.6EE54C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not leak page on writeback_store error path
has been removed from the -mm tree.  Its filename was
     zram-do-not-leak-page-on-writeback_store-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not leak page on writeback_store error path
Date: Mon, 3 Mar 2025 11:03:27 +0900

Ensure the page used for local object data is freed on error out path.

Link: https://lkml.kernel.org/r/20250303022425.285971-19-senozhatsky@chromium.org
Fixes: 330edc2bc059 (zram: rework writeback target selection strategy)
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-leak-page-on-writeback_store-error-path
+++ a/drivers/block/zram/zram_drv.c
@@ -787,7 +787,7 @@ static ssize_t writeback_store(struct de
 	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
-	struct page *page;
+	struct page *page = NULL;
 	ssize_t ret = len;
 	int mode, err;
 	unsigned long blk_idx = 0;
@@ -929,8 +929,10 @@ next:
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-	__free_page(page);
+
 release_init_lock:
+	if (page)
+		__free_page(page);
 	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


