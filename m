Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF84217727
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188432; cv=none; b=Jc73z4nrgs9UfTOg4AHN5H0Mw9mE32d3N+fKCQr/nWpagGYJ3/Fa84wDBIieiIdTFgF2OZ4FzuS2DAX0YXbHbnPNlXuttM7VF2vGYFfS5cpVrB63RfAZlA2V21nWJ35d/WfulHjQBIrxtqLywr5e2L33WGQhUX+2EOuIWrxksy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188432; c=relaxed/simple;
	bh=QG00vZM/CBIUJlZGo8mPrOU7WgqINUQprkAY8cNPmCM=;
	h=Date:To:From:Subject:Message-Id; b=RCURHECaNI9ezEyTT9YH5kJffVlBvxfEahQ9IBrVnJ2b2QhvacRfoV6ydGyOYQATpadcsG2rnxE3EYNucTHxVUGuZy0d/BN7IlO2srASVsOMpcU+Alr4L9BvFq/ST6rRMIf36gYKmCCwTvwnyC0bFM9ZinNjR3ulJ1P3AIUWjts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c6goW4Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6goW4Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12437C4CEEF;
	Mon, 17 Mar 2025 05:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188432;
	bh=QG00vZM/CBIUJlZGo8mPrOU7WgqINUQprkAY8cNPmCM=;
	h=Date:To:From:Subject:From;
	b=c6goW4PhIvSSMSlIegPtFJ1TG2/m1Sjqz8eFRVQFu6nr4n0NeTNEKL2N6PJwB59IJ
	 OeBKCi7W8Q4yiynwP0zKpbQ4w0ukMkf0D0UcCxaoxphaJDXmkAevPh6u+b0eBT6yKI
	 vMCSy4bIMLXVSgd7GZdGdjJOq1mZWcb9p1H8s4+g=
Date: Sun, 16 Mar 2025 22:13:51 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-leak-page-on-recompress_store-error-path.patch removed from -mm tree
Message-Id: <20250317051352.12437C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not leak page on recompress_store error path
has been removed from the -mm tree.  Its filename was
     zram-do-not-leak-page-on-recompress_store-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not leak page on recompress_store error path
Date: Mon, 3 Mar 2025 11:03:26 +0900

Ensure the page used for local object data is freed on error out path.

Link: https://lkml.kernel.org/r/20250303022425.285971-18-senozhatsky@chromium.org
Fixes: 3f909a60cec1 ("zram: rework recompress target selection strategy")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-leak-page-on-recompress_store-error-path
+++ a/drivers/block/zram/zram_drv.c
@@ -2013,7 +2013,7 @@ static ssize_t recompress_store(struct d
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
 	u32 prio, prio_max;
-	struct page *page;
+	struct page *page = NULL;
 	ssize_t ret;
 
 	prio = ZRAM_SECONDARY_COMP;
@@ -2157,9 +2157,9 @@ next:
 		cond_resched();
 	}
 
-	__free_page(page);
-
 release_init_lock:
+	if (page)
+		__free_page(page);
 	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


