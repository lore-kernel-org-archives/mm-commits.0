Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EA71C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836942; cv=none; b=sxZGXBnevfWDMUbULs9iFtWlBtZRGvuxnaXx+L112COhtv42Tircmts+QmXQg6nHjpV2+uT9+7E5/Kp5Ko7/GkAuOsnWVI0BnbKxOkXiFQdISOjszX5T2HyPVd1blvIQ5BxTR17CS5JwvhW5IoFpYBOqw+8nMzz7Z0hTfFYOCq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836942; c=relaxed/simple;
	bh=mbq1p4+vIhhVMoZw/dXyxd0C4znyOH8kAV7Aesg9GGU=;
	h=Date:To:From:Subject:Message-Id; b=Y28etN5yvVTDRp7UY2SKZF1IGmbDSiSRMdc6SrKD4QcXKbTlT6bZrFTqVuD6FOPYNVT7AP1MNLG9pEox+XAyN5JQ97PhKJMOXBR/NVwVSGAgjzdNfAzLwyze2Hnw+drxHj0+H0uqV9Rhl9ht6LXhABA1KqS6m8uz2nevDY+RE00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZZPOfMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZZPOfMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245C9C4CEDD;
	Tue, 14 Jan 2025 06:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836942;
	bh=mbq1p4+vIhhVMoZw/dXyxd0C4znyOH8kAV7Aesg9GGU=;
	h=Date:To:From:Subject:From;
	b=1ZZPOfMSl1CwZe86WSx0+s89x/WZdZHJShz+WEIasbp43GTXoiOI1Yyoq6Cze0Sql
	 to6Kj3wFf1TDGbmZ47gPRJ3qfTrPf4SNT0rzSa8tMcxZw2d3Ae0xUi90dy7ItkXtd6
	 ifhZdX1NtsbRWHtWvJfgbY3KiKWmCTDahj+7JIyk=
Date: Mon, 13 Jan 2025 22:42:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch removed from -mm tree
Message-Id: <20250114064222.245C9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: change shmem_huge_global_enabled() to return huge order bitmap
has been removed from the -mm tree.  Its filename was
     mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: change shmem_huge_global_enabled() to return huge order bitmap
Date: Thu, 28 Nov 2024 15:40:40 +0800

Change the shmem_huge_global_enabled() to return the suitable huge order
bitmap, and return 0 if huge pages are not allowed.  This is a preparation
for supporting various huge orders allocation of tmpfs in the following
patches.

No functional changes.

Link: https://lkml.kernel.org/r/9dce1cfad3e9c1587cf1a0ea782ddbebd0e92984.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/mm/shmem.c~mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap
+++ a/mm/shmem.c
@@ -554,37 +554,37 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-				      loff_t write_end, bool shmem_huge_force,
-				      unsigned long vm_flags)
+static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					      loff_t write_end, bool shmem_huge_force,
+					      unsigned long vm_flags)
 {
 	loff_t i_size;
 
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
-		return false;
+		return 0;
 	if (!S_ISREG(inode->i_mode))
-		return false;
+		return 0;
 	if (shmem_huge == SHMEM_HUGE_DENY)
-		return false;
+		return 0;
 	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
+		return BIT(HPAGE_PMD_ORDER);
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-		return true;
+		return BIT(HPAGE_PMD_ORDER);
 	case SHMEM_HUGE_WITHIN_SIZE:
 		index = round_up(index + 1, HPAGE_PMD_NR);
 		i_size = max(write_end, i_size_read(inode));
 		i_size = round_up(i_size, PAGE_SIZE);
 		if (i_size >> PAGE_SHIFT >= index)
-			return true;
+			return BIT(HPAGE_PMD_ORDER);
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
-			return true;
+			return BIT(HPAGE_PMD_ORDER);
 		fallthrough;
 	default:
-		return false;
+		return 0;
 	}
 }
 
@@ -779,11 +779,11 @@ static unsigned long shmem_unused_huge_s
 	return 0;
 }
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-				      loff_t write_end, bool shmem_huge_force,
-				      unsigned long vm_flags)
+static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					      loff_t write_end, bool shmem_huge_force,
+					      unsigned long vm_flags)
 {
-	return false;
+	return 0;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -1690,21 +1690,21 @@ unsigned long shmem_allowable_huge_order
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
 	pgoff_t aligned_index;
-	bool global_huge;
+	unsigned int global_orders;
 	loff_t i_size;
 	int order;
 
 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
 
-	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-						shmem_huge_force, vm_flags);
+	global_orders = shmem_huge_global_enabled(inode, index, write_end,
+						  shmem_huge_force, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
 		 * is enabled, otherwise fallback to order 0.
 		 */
-		return global_huge ? BIT(HPAGE_PMD_ORDER) : 0;
+		return global_orders;
 	}
 
 	/*
@@ -1737,7 +1737,7 @@ unsigned long shmem_allowable_huge_order
 	if (vm_flags & VM_HUGEPAGE)
 		mask |= READ_ONCE(huge_shmem_orders_madvise);
 
-	if (global_huge)
+	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


