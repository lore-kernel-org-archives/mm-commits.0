Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3AE15855C
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048733; cv=none; b=Byv0fFwJ6gpsbyewDjJ335aaoQFHAwzyHF85AvtCw+YAFZ2fGZgU1f4fR5bVFOmuNGQ/svCtHeb1yFDFloMkTY9NsbCmOFF353OrDS59siMdbVaRWkudIBvrHmY4iIveH298tgN7nc404T7ihYMBAMjpp3E3WyQyArOP87Ml6kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048733; c=relaxed/simple;
	bh=ZE/dmN7B+7w7VOCTo4ZnNT2W9gNvIloKAIHm1MgiFx0=;
	h=Date:To:From:Subject:Message-Id; b=cZ87UkHZzSa9CjysGZnyw6xHIJRP2Zp/EsBDx24s2V00eSQC6q/rh9YEln9Y185YEl/sxMbVe1WwNIYQHjT3Ssy15b0j51MFMY8TB9GlfNQ6a4eqPIS0rPZL/aHEFjIqId8j65rWRbRgMvGBpjlwVdcXVCsZKPGU/7fLfrcKxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k1CpXi/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k1CpXi/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EE2C4CEE4;
	Tue,  4 Mar 2025 00:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048733;
	bh=ZE/dmN7B+7w7VOCTo4ZnNT2W9gNvIloKAIHm1MgiFx0=;
	h=Date:To:From:Subject:From;
	b=k1CpXi/jLrMoWLcoSNxoQ8fywKmuO0NsTzAnrTd/RzOpxczcX9nn2x+ENTP07ohpZ
	 /GJsEP6ZjHvdzXSHWdWemVvnibaRT6U4ZgyMK+bXOvZXUMoUOOuvECRyzHvZumWK/3
	 4Tdi2LsKFoDd5BPO1nFVZZWUx/LT70TyhRvK943I=
Date: Mon, 03 Mar 2025 16:38:53 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-post-processing-target-allocation.patch added to mm-unstable branch
Message-Id: <20250304003853.99EE2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: move post-processing target allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-move-post-processing-target-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-post-processing-target-allocation.patch

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

