Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C47215C66
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434489; cv=none; b=PJ64PkDzFun1Xid88O8rk4NMF4yGLZE6EBvKy3m3m1JKx8rVofmURYAv3WJan/qHb56dMTxDWarP5v5RphTWRDSxiusNc837Nj1dfDlEHCUJM+BIPyx9X/7kKf4t1dQ4fLVUOWv/8CtmgcDJmRkZ4w+Rp3NZOqZUP69w7h5nDkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434489; c=relaxed/simple;
	bh=OkJFNn1eD4xKMCI9KuJWci9fSOphiSKHigM6oFswAYA=;
	h=Date:To:From:Subject:Message-Id; b=uaDG7bmJYQArO70nCK+4mhxhDlBx/dgmXP/GAZhtzz6MTidBbGSV+3xnrVWt1QNNs9q1U6qWXIwJhPsKCMKIcHTF/LHphmWX4HwPiycqgU0FlRG1lq7cxEoAAQKWOZwC5EyFMaalCbGAvhDp7vnf6XxoiG3ehqytRfjkKI5jLDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+5iGFqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+5iGFqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CACC4CECD;
	Tue, 12 Nov 2024 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731434488;
	bh=OkJFNn1eD4xKMCI9KuJWci9fSOphiSKHigM6oFswAYA=;
	h=Date:To:From:Subject:From;
	b=u+5iGFqqgwoJphTIwTI1+5F81FTXTO7uRFFw3xoqtDhxHGM+d1IYw5vvkWWSlyiS5
	 RNo+3hTTEj4jC2y2Ccg423gH7EhvuQKYX/U5XeYpbFsFebO3lGHw4oXTq/fZEHA13O
	 NLerYTqhDXj5gHqokzasoGsERa7IG52H67Gv+q2U=
Date: Tue, 12 Nov 2024 10:01:27 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-allocation-and-scanning-race-with-swapoff.patch added to mm-hotfixes-unstable branch
Message-Id: <20241112180128.52CACC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix allocation and scanning race with swapoff
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-allocation-and-scanning-race-with-swapoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-allocation-and-scanning-race-with-swapoff.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix allocation and scanning race with swapoff
Date: Tue, 12 Nov 2024 16:34:14 +0800

There are two flags used to synchronize allocation and scanning with
swapoff: SWP_WRITEOK and SWP_SCANNING.

SWP_WRITEOK: Swapoff will first unset this flag, at this point any further
swap allocation or scanning on this device should just abort so no more
new entries will be referencing this device.  Swapoff will then unuse all
existing swap entries.

SWP_SCANNING: This flag is set when device is being scanned.  Swapoff will
wait for all scanner to stop before the final release of the swap device
structures to avoid UAF.  Note this flag is the highest used bit of
si->flags so it could be added up arithmetically, if there are multiple
scanner.

commit 5f843a9a3a1e ("mm: swap: separate SSD allocation from
scan_swap_map_slots()") ignored SWP_SCANNING and SWP_WRITEOK flags while
separating cluster allocation path from the old allocation path.  Add the
flags back to fix swapoff race.  The race is hard to trigger as si->lock
prevents most parallel operations, but si->lock could be dropped for
reclaim or discard.  This issue is found during code review.

This commit fixes this problem.  For SWP_SCANNING, Just like before, set
the flag before scan and remove it afterwards.

For SWP_WRITEOK, there are several places where si->lock could be dropped,
it will be error-prone and make the code hard to follow if we try to cover
these places one by one.  So just do one check before the real allocation,
which is also very similar like before.  With new cluster allocator it may
waste a bit of time iterating the clusters but won't take long, and
swapoff is not performance sensitive.

Link: https://lkml.kernel.org/r/20241112083414.78174-1-ryncsn@gmail.com
Fixes: 5f843a9a3a1e ("mm: swap: separate SSD allocation from scan_swap_map_slots()")
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87a5es3f1f.fsf@yhuang6-desk2.ccr.corp.intel.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-allocation-and-scanning-race-with-swapoff
+++ a/mm/swapfile.c
@@ -664,12 +664,15 @@ static bool cluster_scan_range(struct sw
 	return true;
 }
 
-static void cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
+static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
 				unsigned int start, unsigned char usage,
 				unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 
+	if (!(si->flags & SWP_WRITEOK))
+		return false;
+
 	if (cluster_is_free(ci)) {
 		if (nr_pages < SWAPFILE_CLUSTER) {
 			list_move_tail(&ci->list, &si->nonfull_clusters[order]);
@@ -690,6 +693,8 @@ static void cluster_alloc_range(struct s
 		list_move_tail(&ci->list, &si->full_clusters);
 		ci->flags = CLUSTER_FLAG_FULL;
 	}
+
+	return true;
 }
 
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si, unsigned long offset,
@@ -713,7 +718,10 @@ static unsigned int alloc_swap_scan_clus
 
 	while (offset <= end) {
 		if (cluster_scan_range(si, ci, offset, nr_pages)) {
-			cluster_alloc_range(si, ci, offset, usage, order);
+			if (!cluster_alloc_range(si, ci, offset, usage, order)) {
+				offset = SWAP_NEXT_INVALID;
+				goto done;
+			}
 			*foundp = offset;
 			if (ci->count == SWAPFILE_CLUSTER) {
 				offset = SWAP_NEXT_INVALID;
@@ -805,7 +813,11 @@ new_cluster:
 	if (!list_empty(&si->free_clusters)) {
 		ci = list_first_entry(&si->free_clusters, struct swap_cluster_info, list);
 		offset = alloc_swap_scan_cluster(si, cluster_offset(si, ci), &found, order, usage);
-		VM_BUG_ON(!found);
+		/*
+		 * Either we didn't touch the cluster due to swapoff,
+		 * or the allocation must success.
+		 */
+		VM_BUG_ON((si->flags & SWP_WRITEOK) && !found);
 		goto done;
 	}
 
@@ -1041,6 +1053,8 @@ static int cluster_alloc_swap(struct swa
 
 	VM_BUG_ON(!si->cluster_info);
 
+	si->flags += SWP_SCANNING;
+
 	while (n_ret < nr) {
 		unsigned long offset = cluster_alloc_swap_entry(si, order, usage);
 
@@ -1049,6 +1063,8 @@ static int cluster_alloc_swap(struct swa
 		slots[n_ret++] = swp_entry(si->type, offset);
 	}
 
+	si->flags -= SWP_SCANNING;
+
 	return n_ret;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-fix-allocation-and-scanning-race-with-swapoff.patch

