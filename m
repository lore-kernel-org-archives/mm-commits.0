Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4765D2913
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983902; cv=none; b=DbOsR/u24mdxoZlqZ6/qClUnOsyfJWPooqqQGVmEKSWwg/dBetBM6L7wpByiSKmqAzs+Cp6h5MPHgHAy78NoH05ndn4VHBjKyZmJn02VBfQ77Prk9+kl0t9D9NX2r27qAA3n3cettGHwaGS3nRAd3XBbykuOW35jalv9NJ9cxSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983902; c=relaxed/simple;
	bh=mhm/rKy3/Nspd2vB5AtcNHFPkPQ+vmX0Ke3s5oS0O+4=;
	h=Date:To:From:Subject:Message-Id; b=tNKkh7g7DR55slTkD/qEGT9U/XJ+1HYyGjtCGnnroCGIRYPeMO8yaVdmmfAOaDiQyg8s8bYkqRaWfUVW5rOHHmbDAh5YvD+6ozDzb5CJXMyRMAKN+k66Z0lfFDManNZrulvyaJgdR6Zm82tUAz1fx7pi/XOJyUAbm+lAaMUbnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDoG793o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDoG793o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48D2C4CED1;
	Sat,  8 Feb 2025 03:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983901;
	bh=mhm/rKy3/Nspd2vB5AtcNHFPkPQ+vmX0Ke3s5oS0O+4=;
	h=Date:To:From:Subject:From;
	b=IDoG793ojbY+cmgBt2Ke074YkA854x1Zmue0bxuBtFj4cF9+sH2b1GaNCxsqxnGYB
	 yGt4p9gUenqBWiCUmRZmt5xoiwY8Bbg5Fbwau1ptSeJrJ9utdFHv1iYf5qw80oxZJa
	 /e+9HNBr78tj5N2ZY8Rx2xqGjhd0QGALCiyGaGGo=
Date: Fri, 07 Feb 2025 19:05:01 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch added to mm-unstable branch
Message-Id: <20250208030501.A48D2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: factor out the within_size logic into a new helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: factor out the within_size logic into a new helper
Date: Fri, 7 Feb 2025 17:44:21 +0800

Factor out the within_size logic into a new helper to remove duplicate
code.

Link: https://lkml.kernel.org/r/527dea9d7e32fe6b94c7fe00df2c126203017911.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
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
@@ -1756,10 +1770,7 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
-	pgoff_t aligned_index;
 	unsigned int global_orders;
-	loff_t i_size;
-	int order;
 
 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
@@ -1785,17 +1796,7 @@ unsigned long shmem_allowable_huge_order
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

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

