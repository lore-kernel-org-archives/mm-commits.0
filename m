Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01B217709
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188424; cv=none; b=Npmlth23CHaT+03zECUgeHOV3JZzQSdegegSN96rHxuAkMyBJFHpNT5D8nIYbwGP3hqA1EgUn/Hq2yIq062cLXGb6ykQUXIsl3owfLrKW+MrCHdblELKcEg0Hg1QexzYMpzSJ4vKGGOOilTUPolqO/JgKPLfvGm9XMRjaL31KQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188424; c=relaxed/simple;
	bh=Ej/Yox2xUm9QFxSPH+RqA5Cdt+6hFp3a+zYRXr165Mc=;
	h=Date:To:From:Subject:Message-Id; b=Dk5qsuG+rrd8xjKzV9KigP4qA27iG1CYqOz43oWL8AU8dcoenFfqOQ2YegGv51Lqd1/703PrBkcUyacchI6K7FTo5zsO9hUZ3ICE/3mjDTYZRE5hbZ2qRF9eumVwB2wnBk9rQxQJ2pz6iaPYgGB2akLWw+5Pny+1mL7jN4X1FqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJzg3SMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJzg3SMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21523C4CEEC;
	Mon, 17 Mar 2025 05:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188424;
	bh=Ej/Yox2xUm9QFxSPH+RqA5Cdt+6hFp3a+zYRXr165Mc=;
	h=Date:To:From:Subject:From;
	b=xJzg3SMnFVe1DErgN4jmLCgR7Iim2TsY2xx7/yvzBBxJy8RP0o8rKB5qmcALPJbUQ
	 nkfZNR49KV3/9LA56lss9iIVN7eYM55J/omptIbaVM0mXX7FmJ6ecQQj6O3fg/YLPS
	 w1HNA3qQc5k+4HZh1rgSuJZ30HIMijg1cfdSfIbM=
Date: Sun, 16 Mar 2025 22:13:43 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-move-post-processing-target-allocation.patch removed from -mm tree
Message-Id: <20250317051344.21523C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: move post-processing target allocation
has been removed from the -mm tree.  Its filename was
     zram-move-post-processing-target-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: move post-processing target allocation
Date: Mon, 3 Mar 2025 11:03:20 +0900

Allocate post-processing target in place_pp_slot().  This simplifies
scan_slots_for_writeback() and scan_slots_for_recompress() loops because
we don't need to track pps pointer state anymore.  Previously we have to
explicitly NULL the point if it has been added to a post-processing bucket
or re-use previously allocated pointer otherwise and make sure we don't
leak the memory in the end.

We are also fine doing GFP_NOIO allocation, as post-processing can be
called under memory pressure so we better pick as many slots as we can as
soon as we can and start post-processing them, possibly saving the memory.
Allocation failure there is not fatal, we will post-process whatever we
put into the buckets on previous iterations.

Link: https://lkml.kernel.org/r/20250303022425.285971-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   50 ++++++++++++++------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-move-post-processing-target-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -295,15 +295,24 @@ static void release_pp_ctl(struct zram *
 	kfree(ctl);
 }
 
-static void place_pp_slot(struct zram *zram, struct zram_pp_ctl *ctl,
-			  struct zram_pp_slot *pps)
+static bool place_pp_slot(struct zram *zram, struct zram_pp_ctl *ctl,
+			  u32 index)
 {
-	u32 idx;
+	struct zram_pp_slot *pps;
+	u32 bid;
+
+	pps = kmalloc(sizeof(*pps), GFP_NOIO | __GFP_NOWARN);
+	if (!pps)
+		return false;
 
-	idx = zram_get_obj_size(zram, pps->index) / PP_BUCKET_SIZE_RANGE;
-	list_add(&pps->entry, &ctl->pp_buckets[idx]);
+	INIT_LIST_HEAD(&pps->entry);
+	pps->index = index;
+
+	bid = zram_get_obj_size(zram, pps->index) / PP_BUCKET_SIZE_RANGE;
+	list_add(&pps->entry, &ctl->pp_buckets[bid]);
 
 	zram_set_flag(zram, pps->index, ZRAM_PP_SLOT);
+	return true;
 }
 
 static struct zram_pp_slot *select_pp_slot(struct zram_pp_ctl *ctl)
@@ -737,15 +746,8 @@ static int scan_slots_for_writeback(stru
 				    unsigned long index,
 				    struct zram_pp_ctl *ctl)
 {
-	struct zram_pp_slot *pps = NULL;
-
 	for (; nr_pages != 0; index++, nr_pages--) {
-		if (!pps)
-			pps = kmalloc(sizeof(*pps), GFP_KERNEL);
-		if (!pps)
-			return -ENOMEM;
-
-		INIT_LIST_HEAD(&pps->entry);
+		bool ok = true;
 
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index))
@@ -765,14 +767,13 @@ static int scan_slots_for_writeback(stru
 		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		pps->index = index;
-		place_pp_slot(zram, ctl, pps);
-		pps = NULL;
+		ok = place_pp_slot(zram, ctl, index);
 next:
 		zram_slot_unlock(zram, index);
+		if (!ok)
+			break;
 	}
 
-	kfree(pps);
 	return 0;
 }
 
@@ -1827,16 +1828,10 @@ static int scan_slots_for_recompress(str
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct zram_pp_slot *pps = NULL;
 	unsigned long index;
 
 	for (index = 0; index < nr_pages; index++) {
-		if (!pps)
-			pps = kmalloc(sizeof(*pps), GFP_KERNEL);
-		if (!pps)
-			return -ENOMEM;
-
-		INIT_LIST_HEAD(&pps->entry);
+		bool ok = true;
 
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index))
@@ -1859,14 +1854,13 @@ static int scan_slots_for_recompress(str
 		if (zram_get_priority(zram, index) + 1 >= prio_max)
 			goto next;
 
-		pps->index = index;
-		place_pp_slot(zram, ctl, pps);
-		pps = NULL;
+		ok = place_pp_slot(zram, ctl, index);
 next:
 		zram_slot_unlock(zram, index);
+		if (!ok)
+			break;
 	}
 
-	kfree(pps);
 	return 0;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


