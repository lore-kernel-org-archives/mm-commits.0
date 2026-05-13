Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5788B3A9DB5
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696993; cv=none; b=NdK//FG2/7b8boct0G3LIeNzfrCqe44Y17lC78AWcZXa2yQc7UzN9D3L91rTf5eCCf7oYBc+g3rYYFmz3Qo1CXyyyPJzExp8o3I2okgtHwh7PZ8uwxpuQ/rWrAzI2/ZJjbFFqWyeVt9NM40DjRd++CDygBT55gC2tXfAJ9RAjHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696993; c=relaxed/simple;
	bh=nJsZrPQw67hg3JZBWiFF2SGC+Rz2HArIyhiH/pu34NM=;
	h=Date:To:From:Subject:Message-Id; b=QsC/0UNlSi85xtmIuftQy+LseGVFmBHXh17xuxTQMdaHNHNDPWiUh7G17xGaHQwFH9zZWHzo2DsehBEBdCdC8BU5rik9d76ipeAG9kh97FAS100DhrHuN/GBN0Afd+cVumjY2hE2x2X79tSfbH+vYUgzxRX6vEFqqRSw6dT1iyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xIzgiMEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xIzgiMEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5572C19425;
	Wed, 13 May 2026 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778696992;
	bh=nJsZrPQw67hg3JZBWiFF2SGC+Rz2HArIyhiH/pu34NM=;
	h=Date:To:From:Subject:From;
	b=xIzgiMEzMIQrf1KPGEo2HvDAq74mvzJaW6kMbVf/982gBbhnPNlqMBar53XPOYA98
	 CiA+SsDNx6N2yJhOeQd0CLe7TNH1CdEyxDnSSH3rah5vI9pNAH8TudDEorvVTIuidE
	 G9LiCT52Y5SEP591VOL4B6T6AivCbivpMaeW1J3o=
Date: Wed, 13 May 2026 11:29:52 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,leitao@debian.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch added to mm-new branch
Message-Id: <20260513182952.C5572C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: avoid leaving unused extend table after alloc race
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid leaving unused extend table after alloc race
Date: Wed, 13 May 2026 17:21:11 +0800

Allocating an extend table requires dropping the ci lock first.  While the
lock is dropped, a concurrent put can decrease the slot's swap count to a
value that is no longer maxed out, so the extend table is no longer
required.  The current allocation path still attach the new extend table
to the cluster anyway, leaving it unused.

It's not really leaked, the next maxed out count on the same cluster
reuses the table, and frees it properly.  Swapoff will also clean it up.

The worst case is one unused page pinned per cluster until the next
maxed-out allocation or swapoff.  To eliminate the waste, re-check under
the ci lock that the extend table is still needed before publishing it,
and free the local allocation otherwise.  The added overhead is ignorable.

Link: https://lore.kernel.org/20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
Tested-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swap-avoid-leaving-unused-extend-table-after-alloc-race
+++ a/mm/swapfile.c
@@ -1443,8 +1443,10 @@ start_over:
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
-				   struct swap_cluster_info *ci, gfp_t gfp)
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_off, gfp_t gfp)
 {
+	int count;
 	void *table;
 
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
@@ -1452,11 +1454,27 @@ static int swap_extend_table_alloc(struc
 		return -ENOMEM;
 
 	spin_lock(&ci->lock);
-	if (!ci->extend_table)
-		ci->extend_table = table;
-	else
-		kfree(table);
+	/*
+	 * Extend table allocation requires releasing ci lock first so it's
+	 * possible that the slot has been freed, no longer overflowed, or
+	 * a concurrent extend table allocation has already succeeded, so
+	 * the allocation is no longer needed.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		goto out_free;
+	count = swp_tb_get_count(__swap_table_get(ci, ci_off));
+	if (count < (SWP_TB_COUNT_MAX - 1))
+		goto out_free;
+	if (ci->extend_table)
+		goto out_free;
+
+	ci->extend_table = table;
+	spin_unlock(&ci->lock);
+	return 0;
+
+out_free:
 	spin_unlock(&ci->lock);
+	kfree(table);
 	return 0;
 }
 
@@ -1472,7 +1490,7 @@ int swap_retry_table_alloc(swp_entry_t e
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1665,7 +1683,7 @@ restart:
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch
mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch

