Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D2C1B5AA
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724810302; cv=none; b=erxuq/qS+JmYWgFaL5Iu5EaGjTno+C7ttk8pUAI47rbEOryIMAF9mHgbKVRZwC7wjfr2YV+vtBePqV9cBYohcyyoJfg4ZHhVLDhnqlGXN1ISB7DyY0JWeecLJAxaxHLYPTdEvBXRuNYbQS3vvC30YvFOKWdJp8qaJcpY3/SSczY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724810302; c=relaxed/simple;
	bh=80IJAaXcHC/jxaliUNfb/SCoEUsWIN755V+HL5trkDs=;
	h=Date:To:From:Subject:Message-Id; b=pKfQXHJl7VRWODUYLZOfgzThsjMA4qM5fCkKeLDNgpdxwBP9dP5ooodsVsmBPSqsmsg20sSAnJ5OQp+FUPfwa+dnfFjR0KjyB2T4NthvSaL0GUvaLuijzvrtsX2oX7nLejEwHTN3nbJ2zhqr6MxS1v0zW7XLljYc/NqFU1tW8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bXoaKe01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXoaKe01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8481DC4FE8D;
	Wed, 28 Aug 2024 01:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724810301;
	bh=80IJAaXcHC/jxaliUNfb/SCoEUsWIN755V+HL5trkDs=;
	h=Date:To:From:Subject:From;
	b=bXoaKe01RAwRPl9X0SG66IKT55Vxx/A2/hSG5DtKT2hZnLKxeRy2pVoSCrMMvFBV9
	 wOYgVS4lNyEVpUG3jBEBmp8ZsdZumH1A2Mnlct/ClFETKB/szrKdBlixIF1vBz/zF0
	 SUUEG7fIps9AJczQXoRk7gB82Xn5C9ndBQEywGac=
Date: Tue, 27 Aug 2024 18:58:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch added to mm-unstable branch
Message-Id: <20240828015821.8481DC4FE8D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch

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
Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2
Date: Tue, 27 Aug 2024 14:46:40 +0800

Now we only split large folio to order 0, so drop the 'new_order'
parameter.

Link: https://lkml.kernel.org/r/39c71ccf-669b-4d9f-923c-f6b9c4ceb8df@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2
+++ a/mm/shmem.c
@@ -1987,10 +1987,10 @@ static void shmem_set_folio_swapin_error
 }
 
 static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
-				   swp_entry_t swap, int new_order, gfp_t gfp)
+				   swp_entry_t swap, gfp_t gfp)
 {
 	struct address_space *mapping = inode->i_mapping;
-	XA_STATE_ORDER(xas, &mapping->i_pages, index, new_order);
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
 	void *alloced_shadow = NULL;
 	int alloced_order = 0, i;
 
@@ -2018,7 +2018,7 @@ static int shmem_split_large_entry(struc
 		}
 
 		/* Try to split large swap entry in pagecache */
-		if (order > 0 && order > new_order) {
+		if (order > 0) {
 			if (!alloced_order) {
 				split_order = order;
 				goto unlock;
@@ -2029,7 +2029,7 @@ static int shmem_split_large_entry(struc
 			 * Re-set the swap entry after splitting, and the swap
 			 * offset of the original large entry must be continuous.
 			 */
-			for (i = 0; i < 1 << order; i += (1 << new_order)) {
+			for (i = 0; i < 1 << order; i++) {
 				pgoff_t aligned_index = round_down(index, 1 << order);
 				swp_entry_t tmp;
 
@@ -2114,7 +2114,7 @@ static int shmem_swapin_folio(struct ino
 		 * should split the large swap entry stored in the pagecache
 		 * if necessary.
 		 */
-		split_order = shmem_split_large_entry(inode, index, swap, 0, gfp);
+		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
 			error = split_order;
 			goto failed;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

