Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D893EC2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721700838; cv=none; b=ZgNZbi7dtTpPbi/SsduNuaQFVawcU8sbhXh6fpKtYPEIC3k/HS2LCX36aRy7f6Z/MLirCMsWIWx7geSwEtpc+xiGZK8sASr6dd3nZISYM7IUxd6VRd6PTHlee/Aai3A4LriJ4mjTieT2dOGea5SqR/+JI4oZEOK7j56hWeIDcvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721700838; c=relaxed/simple;
	bh=rzMEbxkcOim8XUw/yp1FGNpYSUr/c5J2uPBL0kqoKAY=;
	h=Date:To:From:Subject:Message-Id; b=ZscgYNFbGLtZajBeL6W55qUkdqa7o5gqzpkuFLCrx2CP+4I7ipC1v7jCE0m3QCpFw+2zCwcrHYHa5GkblWeRSkGb2LXrepmVocvaC7YlSIn5aBYHF4MWW/ug2L9++geqhEieS18rRfBDwiZePJq7boGMHWW1bWXEkY1eRNZCZ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBrYigZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBrYigZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16931C116B1;
	Tue, 23 Jul 2024 02:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721700838;
	bh=rzMEbxkcOim8XUw/yp1FGNpYSUr/c5J2uPBL0kqoKAY=;
	h=Date:To:From:Subject:From;
	b=fBrYigZ/vjpaqZ2SCf/kAsbQ76oITsF0IFsukxDzLMmM7dlS4rd+okOtRlrUEaRkD
	 7P8IfRh9Mh0Hp3l649Gri7tGdlhGvlwXRoGt2v0rsq1nJmIB+wil63fpwD6v4Qmzrp
	 rzKHQ6YuJ9bD0n5GdaQYnqHcZSNfpYeMi3RrVHwU=
Date: Mon, 22 Jul 2024 19:13:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch added to mm-unstable branch
Message-Id: <20240723021358.16931C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: simplify the suitable huge orders validation for tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch

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
Subject: mm: shmem: simplify the suitable huge orders validation for tmpfs
Date: Mon, 22 Jul 2024 13:43:17 +0800

Patch series "Some cleanups for shmem", v3.

This series does some cleanups to reuse code, rename functions and
simplify logic to make code more clear.  No functional changes are
expected.


This patch (of 3):

Move the suitable huge orders validation into shmem_suitable_orders() for
tmpfs, which can reuse some code to simplify the logic.

In addition, we don't have special handling for the error code -E2BIG when
checking for conflicts with PMD sized THP in the pagecache for tmpfs,
instead, it will just fallback to order-0 allocations like this patch
does, so this simplification will not add functional changes.

Link: https://lkml.kernel.org/r/cover.1721626645.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/965985dd6d322929d78a0beee0dafa1c2a1b81e2.1721626645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

--- a/mm/shmem.c~mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs
+++ a/mm/shmem.c
@@ -1685,19 +1685,29 @@ static unsigned long shmem_suitable_orde
 					   struct address_space *mapping, pgoff_t index,
 					   unsigned long orders)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	unsigned long pages;
 	int order;
 
-	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
-	if (!orders)
-		return 0;
+	if (vma) {
+		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
+		if (!orders)
+			return 0;
+	}
 
 	/* Find the highest order that can add into the page cache */
 	order = highest_order(orders);
 	while (orders) {
 		pages = 1UL << order;
 		index = round_down(index, pages);
+		/*
+		 * Check for conflict before waiting on a huge allocation.
+		 * Conflict might be that a huge page has just been allocated
+		 * and added to page cache by a racing thread, or that there
+		 * is already at least one small page in the huge extent.
+		 * Be careful to retry when appropriate, but not forever!
+		 * Elsewhere -EEXIST would be the right code, but not here.
+		 */
 		if (!xa_find(&mapping->i_pages, &index,
 			     index + pages - 1, XA_PRESENT))
 			break;
@@ -1735,7 +1745,6 @@ static struct folio *shmem_alloc_and_add
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
 	long pages;
@@ -1745,26 +1754,8 @@ static struct folio *shmem_alloc_and_add
 		orders = 0;
 
 	if (orders > 0) {
-		if (vma && vma_is_anon_shmem(vma)) {
-			suitable_orders = shmem_suitable_orders(inode, vmf,
+		suitable_orders = shmem_suitable_orders(inode, vmf,
 							mapping, index, orders);
-		} else if (orders & BIT(HPAGE_PMD_ORDER)) {
-			pages = HPAGE_PMD_NR;
-			suitable_orders = BIT(HPAGE_PMD_ORDER);
-			index = round_down(index, HPAGE_PMD_NR);
-
-			/*
-			 * Check for conflict before waiting on a huge allocation.
-			 * Conflict might be that a huge page has just been allocated
-			 * and added to page cache by a racing thread, or that there
-			 * is already at least one small page in the huge extent.
-			 * Be careful to retry when appropriate, but not forever!
-			 * Elsewhere -EEXIST would be the right code, but not here.
-			 */
-			if (xa_find(&mapping->i_pages, &index,
-				    index + HPAGE_PMD_NR - 1, XA_PRESENT))
-				return ERR_PTR(-E2BIG);
-		}
 
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

