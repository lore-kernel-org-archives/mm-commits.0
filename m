Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B636366074
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388552; cv=none; b=FW+iUYYPPghXEkGXseorUu859RKl0NtjXbRbumagUIgvq7RgyQzn3HRhYK0Sy6dEQDdHZGBJiGG/laa4K6Vghqx9oAImPZBNrZWJ7hzfAungLXOR5UtpvO9i7sc28RFHU6G7ccrszSaAIJfEPE/fm+hhosQd+iw1MKdJkJEqWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388552; c=relaxed/simple;
	bh=5WUG0x/XFEb3UOAfrzY7JVlhkLRn+xVFG1qAVnebsrk=;
	h=Date:To:From:Subject:Message-Id; b=KUK1t8XsMKGdudWXdycopZWR3oMNX4lwQ728F6Nqw4WmHxXjce8I6wSJB+C9Iu4O3WEil4YGv3NkT4IJ1ZTM0zBq5UWalX8ArNHC17O6Mne6SdnY9Bau4UGDuTs5KgLSvNb/AZ1vc8bnGN71Lo3jXBiUnZ8h/8p1ZU2doLqNN7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rbtyGobT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rbtyGobT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4324EC19424;
	Tue, 24 Mar 2026 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388552;
	bh=5WUG0x/XFEb3UOAfrzY7JVlhkLRn+xVFG1qAVnebsrk=;
	h=Date:To:From:Subject:From;
	b=rbtyGobTls/8A+aHznuXG9ScGoaxA31Ln503qCsfsiJZsKULxQJJgWjZJ9am6+lqg
	 JxXWkzi9tZbC9Obt06868SOSfYQMqVUmmtTVdfcNZnMHwEhn3TIjOmn85kkZl34d1H
	 O/Lea0WknBYCoO9abJNZbxAbv26445VY2Wn+kMyw=
Date: Tue, 24 Mar 2026 14:42:31 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-no-need-to-truncate-the-scan-border.patch removed from -mm tree
Message-Id: <20260324214232.4324EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: no need to truncate the scan border
has been removed from the -mm tree.  Its filename was
     mm-swap-no-need-to-truncate-the-scan-border.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: no need to truncate the scan border
Date: Wed, 18 Feb 2026 04:06:35 +0800

swap_map had a static flexible size, so the last cluster won't be fully
covered, hence the allocator needs to check the scan border to avoid OOB. 
But the swap table has a fixed-sized swap table for each cluster, and the
slots beyond the device size are marked as bad slots.  The allocator can
simply scan all slots as usual, and any bad slots will be skipped.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-10-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    2 +-
 mm/swapfile.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swap-no-need-to-truncate-the-scan-border
+++ a/mm/swapfile.c
@@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_clus
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
+	unsigned long end = start + SWAPFILE_CLUSTER;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 
--- a/mm/swap.h~mm-swap-no-need-to-truncate-the-scan-border
+++ a/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *
 		struct swap_info_struct *si, pgoff_t offset)
 {
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	VM_WARN_ON_ONCE(offset >= si->max);
+	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are


