Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7EF1DA61D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188562; cv=none; b=XZRKSJsRjRIWt9iC2zmg5TRCRzz2Y524i7zpFCz8KdM0C/er7quvs5XoU4f2u64Hj2eAWg4cDXHdRP/AUyxKf8Mgq+/mWpCcHoAg7NfdOguK7+AUZ3SkCjoy+2dfLt0y9PxQyaKlelahbg7VSijgIXVvmsoegoUVoeUQpox38yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188562; c=relaxed/simple;
	bh=WjfrTwjoV8kK4LUhSjNObErSvH4CZ4yWH+FK0/G4oZI=;
	h=Date:To:From:Subject:Message-Id; b=A1uGqjfgBi9Au7N1XJMcfuXtf+J3dH/12knfnunrR/EwZ7bd7vczQuomlPMFUvpHR9DpXYld5rkB+B+0xtQ3EDVVQbA5z4kSxUmHI9/drZgRwUUg/bMCYuWtVSTR32gP3CPJ/2kTvxgOW/T0BbQzg7lWkXM3bhXyqW0D5whsihc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3D0XM19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3D0XM19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13446C4CEEC;
	Mon, 17 Mar 2025 05:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188562;
	bh=WjfrTwjoV8kK4LUhSjNObErSvH4CZ4yWH+FK0/G4oZI=;
	h=Date:To:From:Subject:From;
	b=L3D0XM19Bpp+gxznkDVtZ0B7CWcjV+Zz/tKebt2PVp15AYWZKp+u3v5EddjHWODd4
	 QMaXEuej/Ase5FqvZfzoWHs/36N+0K7QwXksqe9p+hRpnuDPG/vFWtu7igDR7J4nWV
	 CbO8mI/7I+1VzxqlzCBX9XAyGAdypWmjAPp/BWYQ=
Date: Sun, 16 Mar 2025 22:16:01 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch removed from -mm tree
Message-Id: <20250317051602.13446C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: factor out the within_size logic into a new helper
has been removed from the -mm tree.  Its filename was
     mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: factor out the within_size logic into a new helper
Date: Fri, 7 Feb 2025 17:44:21 +0800

Factor out the within_size logic into a new helper to remove duplicate
code.

Link: https://lkml.kernel.org/r/527dea9d7e32fe6b94c7fe00df2c126203017911.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   53 +++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

--- a/mm/shmem.c~mm-shmem-factor-out-the-within_size-logic-into-a-new-helper
+++ a/mm/shmem.c
@@ -590,6 +590,28 @@ shmem_mapping_size_orders(struct address
 	return order > 0 ? BIT(order + 1) - 1 : 0;
 }
 
+static unsigned int shmem_get_orders_within_size(struct inode *inode,
+		unsigned long within_size_orders, pgoff_t index,
+		loff_t write_end)
+{
+	pgoff_t aligned_index;
+	unsigned long order;
+	loff_t i_size;
+
+	order = highest_order(within_size_orders);
+	while (within_size_orders) {
+		aligned_index = round_up(index + 1, 1 << order);
+		i_size = max(write_end, i_size_read(inode));
+		i_size = round_up(i_size, PAGE_SIZE);
+		if (i_size >> PAGE_SHIFT >= aligned_index)
+			return within_size_orders;
+
+		order = next_order(&within_size_orders, order);
+	}
+
+	return 0;
+}
+
 static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 					      loff_t write_end, bool shmem_huge_force,
 					      struct vm_area_struct *vma,
@@ -598,9 +620,6 @@ static unsigned int shmem_huge_global_en
 	unsigned int maybe_pmd_order = HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER ?
 		0 : BIT(HPAGE_PMD_ORDER);
 	unsigned long within_size_orders;
-	unsigned int order;
-	pgoff_t aligned_index;
-	loff_t i_size;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -634,16 +653,11 @@ static unsigned int shmem_huge_global_en
 			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
 								       index, write_end);
 
-		order = highest_order(within_size_orders);
-		while (within_size_orders) {
-			aligned_index = round_up(index + 1, 1 << order);
-			i_size = max(write_end, i_size_read(inode));
-			i_size = round_up(i_size, PAGE_SIZE);
-			if (i_size >> PAGE_SHIFT >= aligned_index)
-				return within_size_orders;
+		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
+								  index, write_end);
+		if (within_size_orders > 0)
+			return within_size_orders;
 
-			order = next_order(&within_size_orders, order);
-		}
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
@@ -1747,10 +1761,7 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
-	pgoff_t aligned_index;
 	unsigned int global_orders;
-	loff_t i_size;
-	int order;
 
 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
@@ -1776,17 +1787,7 @@ unsigned long shmem_allowable_huge_order
 		return READ_ONCE(huge_shmem_orders_inherit);
 
 	/* Allow mTHP that will be fully within i_size. */
-	order = highest_order(within_size_orders);
-	while (within_size_orders) {
-		aligned_index = round_up(index + 1, 1 << order);
-		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >> PAGE_SHIFT >= aligned_index) {
-			mask |= within_size_orders;
-			break;
-		}
-
-		order = next_order(&within_size_orders, order);
-	}
+	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
 
 	if (vm_flags & VM_HUGEPAGE)
 		mask |= READ_ONCE(huge_shmem_orders_madvise);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


