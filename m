Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA2217722
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188417; cv=none; b=TYpEWoLn10v3BeSWP1bFadRbhYQmaT/nbSp27C4hXKFT4psJuKe+O1Q3OJJIQZ9cmigLEOgHTBkVp9MQmA/+b4UIK5X5TxGyf23AW7EkKS6NNrBAeGHpTsZjmQ3CwSQZr8AHQteDVGc2Lb5+ery7Ys4GyE1WG1ucw0kBROo5G6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188417; c=relaxed/simple;
	bh=zSCrclDP5X6p6heE+RaBRRl6SQYXYy0zGgxE3Ir5vok=;
	h=Date:To:From:Subject:Message-Id; b=DcHQ6/K8waupLBIzLUfVUw/Z7+V0JlU3+JRf4VoRW/VgKf0CgpxNXxStGhjwpoz5uU5qXOax6kAJWNG+Ji/0iMos2jh6P2MkwzW4/YHPuL1mdKo7L0KyzuQDGnC8INH6aq0xmXRVm0xZ+QBuQ4FL/DaSIAGvJvF3gmjqfw4KjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtBqhSzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtBqhSzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78286C4CEEC;
	Mon, 17 Mar 2025 05:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188417;
	bh=zSCrclDP5X6p6heE+RaBRRl6SQYXYy0zGgxE3Ir5vok=;
	h=Date:To:From:Subject:From;
	b=dtBqhSzhsbQWguPl/yeqMa7CTGjMGsUegUw+i1Ias4jAqOPy20YUUbjQMLDb371di
	 KqYYbj/6kUxb3peRB38Uy0jCtYqWEFiOWDkm6TIlTdNJugsj1DG88NzT5ICGI9Jn61
	 I5zjslksPEdPASf4MHt9CewKGwV2VLSmS1TPpn8E=
Date: Sun, 16 Mar 2025 22:13:36 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch removed from -mm tree
Message-Id: <20250317051337.78286C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add GFP_NOWARN to incompressible zsmalloc handle allocation
has been removed from the -mm tree.  Its filename was
     zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


