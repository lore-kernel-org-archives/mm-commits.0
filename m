Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC68231A32
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343241; cv=none; b=H7zJA5NogfvniM/D+rwrJY+9I7KuylL2plrMGSA4keAjs+AhJVNN5XvhdXFvDdKNly7bcc/5tGh62PVx8rCbscvUN+sAQ0WbNS8/qojeEbVz33qrVfojUT8Bwr5f23gjBS0hLKtJlL7KX/VK47rTYBWOGpbhZEc5XaZp0QaUnSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343241; c=relaxed/simple;
	bh=UkAEalV+pspU5QgbPOsp26gAc8GsZSusURPeI23FM7o=;
	h=Date:To:From:Subject:Message-Id; b=jhXgUXs2GKQAcgqoUw9KYgjdPokXA04x9Du2J5NbhP7YyyLFLfNVTNYcIKFDNM9bg1JhjAx0GKIVuR6bsyLCx0eAWUlSdNo4BWgqvGrPb90nISrhsYPCI1u54RzseYEwiInZroJc4MAvTrfSzl7B+Dn82wdKFrg7dGd9JU35itg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qYUNnDWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qYUNnDWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B84C113D0;
	Mon, 17 Nov 2025 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343240;
	bh=UkAEalV+pspU5QgbPOsp26gAc8GsZSusURPeI23FM7o=;
	h=Date:To:From:Subject:From;
	b=qYUNnDWfM5i0VcgrQK0LrLxU6NGxrBX0JZo6w23vyqMgYsJpNq0X7nn/kGs6ldbza
	 h8hotfhApS9CCQGX6mgC5o20cXPEJ1x8dr+Fbq0S/Qial5jzrvKbkeh0uMJdFf6gSS
	 b6y/IqEGhfXFrNk4KjECoyXi19FqgDKS4Y9mWW0c=
Date: Sun, 16 Nov 2025 17:33:59 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch removed from -mm tree
Message-Id: <20251117013400.73B84C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove redundant argument for isolating a cluster
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove redundant argument for isolating a cluster
Date: Fri, 24 Oct 2025 02:00:43 +0800

The order argument was introduced by an intermediate commit and was then
never used, just remove it.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-5-a709469052e7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-redundant-argument-for-isolating-a-cluster
+++ a/mm/swapfile.c
@@ -594,7 +594,7 @@ static void __free_cluster(struct swap_i
  * this returns NULL for an non-empty list.
  */
 static struct swap_cluster_info *isolate_lock_cluster(
-		struct swap_info_struct *si, struct list_head *list, int order)
+		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
 
@@ -957,7 +957,7 @@ static unsigned int alloc_swap_scan_list
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
 		unsigned long offset;
 
 		if (!ci)
@@ -982,7 +982,7 @@ static void swap_reclaim_full_clusters(s
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
_

Patches currently in -mm which might be from kasong@tencent.com are


