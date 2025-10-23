Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789BD29C33F
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761247184; cv=none; b=D0IFZyfirvkC8JNwTHF6rWKzpJlLvyoo34OiR6LLvkclRwLNZ5fZC5Ut2yjeuL8TZ++yya/DlTuJierahJxt7Xg21HOMWU6wDmOuqE9Fn8jqZDPiI9lpp/diyZxlxY7W6WLF5hyqMu3bVyqXGXlYCp8GXH8ncyXuQOhCl73Kz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761247184; c=relaxed/simple;
	bh=i7GoFPXXh1RjBkcu43DKSie87Ma+luQDjXwkBk7QSRY=;
	h=Date:To:From:Subject:Message-Id; b=oD5WgflsHB6Aoj6j1HsQCOJXKT7RtgvudltoPqzcuO/3p2TLxh3HwIkAuZEuOT3Hv1WItDuku1dqfDRRx0UnbW0MPSH8NaiWuL02eK6Dr28CBA6AUmTCNep6stLKOk90VxW1q0l8D75T3l4Kg+WO3J89jnXr5v2fDq5Au5TV+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPczWnEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPczWnEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F69C4CEE7;
	Thu, 23 Oct 2025 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761247184;
	bh=i7GoFPXXh1RjBkcu43DKSie87Ma+luQDjXwkBk7QSRY=;
	h=Date:To:From:Subject:From;
	b=lPczWnEWGChHOi0ohsn3zRfh/zFrA1Hglb1zR88ySu39uYaVmtP9+DROjk/C4FcVZ
	 nuFhl4YZXXB23H4YQK5DeZX/gGDY/6METwj3hYKaDBwtRaHhCwgB7oY0BjCO4nETjl
	 F09bn2NLLQ/Y6wXeYiOBnw+vfSsq5HxmhxDxE5cE=
Date: Thu, 23 Oct 2025 12:19:43 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch added to mm-new branch
Message-Id: <20251023191944.06F69C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove redundant argument for isolating a cluster
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

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

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

