Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3012F0683
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 23:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755041386; cv=none; b=O6kNeR04v4pXIUzozG6V2JqslaQUqjwEV3jHHrUHntYdn+Q16gc2EX1F0qHpfdaE8TGy/MobeoNWyaVBWE7caMYBU0jIcezGFpxvcGJt33d+RFvft5vxN9w+SnqPFBfsux7YZlDuaDkds0aIUeVyIQrK8/FDl6gIGF+HxCOixZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755041386; c=relaxed/simple;
	bh=ckRA/CK+0CUbvprqT1FR1JNJLIRYDi4Alh9DzO9J1oI=;
	h=Date:To:From:Subject:Message-Id; b=a5QRgIpI0VE6vxlWrKOmacp0SaT4u5SaCIvP+VxbNgBe8eiAxbV4y6Gy/PbExP38NBmwz9QkwNeVESAM0EUaRdiy+NRnatBKelAtkqJEwd4A46T2BLLGs2pDIMilUAUdr00H261Q2ujS1r7ndH7GPXLqC74aW8iPVTQV1xa/4iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R2DVTt22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R2DVTt22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F838C4CEF0;
	Tue, 12 Aug 2025 23:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755041386;
	bh=ckRA/CK+0CUbvprqT1FR1JNJLIRYDi4Alh9DzO9J1oI=;
	h=Date:To:From:Subject:From;
	b=R2DVTt22rFaQ9TM6w0/r28mBdecEhui6EUuB2dhA8bWCJ67vONVOEdVNajPLJ6RC2
	 17BLAZmnoobhTOwrBMC7TT51OPuPXKzf2CYCImHRrLSYRndydAemRZzQhAJLTnSv7R
	 OKVMOUOEUxOMhii4Qra/XzgcHJje+AovrT7WKtE8=
Date: Tue, 12 Aug 2025 16:29:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,bhe@redhat.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-introduce-function-alloc_swap_scan_list.patch added to mm-new branch
Message-Id: <20250812232946.0F838C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: introduce function alloc_swap_scan_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-swapfilec-introduce-function-alloc_swap_scan_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-introduce-function-alloc_swap_scan_list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Chris Li <chrisl@kernel.org>
Subject: mm/swapfile.c: introduce function alloc_swap_scan_list()
Date: Tue, 12 Aug 2025 00:10:58 -0700

Patch series "mm/swapfile.c and swap.h cleanup", v3.

This patch series, which builds on Kairui's swap improve cluster scan series.
https://lore.kernel.org/linux-mm/20250806161748.76651-1-ryncsn@gmail.com/

It introduces a new function, alloc_swap_scan_list(), for swapfile.c.

It also cleans up swap.h by removing comments that reference fields that
have been deleted.

There are no functional changes in this two-patch series.


This patch (of 2):

alloc_swap_scan_list() will scan the whole list or the first cluster.

This reduces the repeat patterns of isolating a cluster then scanning that
cluster.  As a result, cluster_alloc_swap_entry() is shorter and
shallower.

No functional change.

Link: https://lkml.kernel.org/r/20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org
Link: https://lkml.kernel.org/r/20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   86 ++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-introduce-function-alloc_swap_scan_list
+++ a/mm/swapfile.c
@@ -820,6 +820,29 @@ out:
 	return found;
 }
 
+static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
+					 struct list_head *list,
+					 unsigned int order,
+					 unsigned char usage,
+					 bool scan_all)
+{
+	unsigned int found = SWAP_ENTRY_INVALID;
+
+	do {
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		unsigned long offset;
+
+		if (!ci)
+			break;
+		offset = cluster_offset(si, ci);
+		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		if (found)
+			break;
+	} while (scan_all);
+
+	return found;
+}
+
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
@@ -913,32 +936,24 @@ new_cluster:
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		ci = isolate_lock_cluster(si, &si->free_clusters);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
+					     false);
+		if (found)
+			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
+					     order, usage, true);
+		if (found)
+			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		ci = isolate_lock_cluster(si, &si->free_clusters);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
+					     false);
+		if (found)
+			goto done;
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
@@ -952,13 +967,10 @@ new_cluster:
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		ci = isolate_lock_cluster(si, &si->frag_clusters[order]);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
+					     usage, false);
+		if (found)
+			goto done;
 	}
 
 	/*
@@ -977,19 +989,15 @@ new_cluster:
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							0, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
+					     0, usage, true);
+		if (found)
+			goto done;
 
-		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[o]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							0, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
+					     0, usage, true);
+		if (found)
+			goto done;
 	}
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
_

Patches currently in -mm which might be from chrisl@kernel.org are

mm-swapfilec-introduce-function-alloc_swap_scan_list.patch
mm-swaph-remove-deleted-field-from-comments.patch

