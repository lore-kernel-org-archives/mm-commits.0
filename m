Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E363CB
	for <mm-commits@vger.kernel.org>; Sat, 15 Mar 2025 00:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741999849; cv=none; b=ASXg6G8bXCEE/rRSrIJljj5NAN8zM12qDsv6/qTJXQKN3cCSlAX7csONnWBC6TQVUKsmImYa1Wt66px/koezjk0ZH3hpdH1sdjiNGyC/1SDVCExWJdXMCw/uZ9oCqevDFtZ/TkKDv/rge3FhMpZvWPRwaFEFuFvD1gJtznU6Aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741999849; c=relaxed/simple;
	bh=h+ckvkuRmTqszB0k9bn0UW7Evu5n8c3FLQu0g4WDPew=;
	h=Date:To:From:Subject:Message-Id; b=mzmRpTH8qkAqut5W3mUSobw7+5tnLMb5EPKE/u6As3+ZPs0N5Y8AfwAXDWAygjbCCCEhQQW8bXHnupY98ldaSVopf1lfDfYaLlTUpvJEmZbDewhI2JoyZBtlO73zfvmj/PiJ0eAelCv3kqsHwy9OPdCd5alyLpODLqMRGJJ8Wy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14MjzJzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14MjzJzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5A6C4CEE3;
	Sat, 15 Mar 2025 00:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741999849;
	bh=h+ckvkuRmTqszB0k9bn0UW7Evu5n8c3FLQu0g4WDPew=;
	h=Date:To:From:Subject:From;
	b=14MjzJzdCZmdMwzeyQN1Pu9QmS1cQ7eQAVCRt3FqFSWEe0+C8ybOZHdpZ6zX+VlyA
	 FjTe+7sFodcCy5UB5gr3nFRaXVmdFfTJ7Z1O49xy6DwUQvKMjDOLFDPwR/+CyvKGTM
	 7XB420WBL7cwU5W0x3g0uCiQnkjvRIgjCe5Zb/KM=
Date: Fri, 14 Mar 2025 17:50:48 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch added to mm-unstable branch
Message-Id: <20250315005049.0F5A6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: use xas_try_split() in shmem_split_large_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/shmem: use xas_try_split() in shmem_split_large_entry()
Date: Fri, 14 Mar 2025 18:21:13 -0400

During shmem_split_large_entry(), large swap entries are covering n slots
and an order-0 folio needs to be inserted.

Instead of splitting all n slots, only the 1 slot covered by the folio
need to be split and the remaining n-1 shadow entries can be retained with
orders ranging from 0 to n-1.  This method only requires
(n/XA_CHUNK_SHIFT) new xa_nodes instead of (n % XA_CHUNK_SHIFT) *
(n/XA_CHUNK_SHIFT) new xa_nodes, compared to the original
xas_split_alloc() + xas_split() one.

For example, to split an order-9 large swap entry (assuming XA_CHUNK_SHIFT
is 6), 1 xa_node is needed instead of 8.

xas_try_split_min_order() is used to reduce the number of calls to
xas_try_split() during split.

Link: https://lkml.kernel.org/r/20250314222113.711703-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   59 ++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-xas_try_split-in-shmem_split_large_entry
+++ a/mm/shmem.c
@@ -2153,15 +2153,16 @@ static int shmem_split_large_entry(struc
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	void *alloced_shadow = NULL;
-	int alloced_order = 0, i;
+	int split_order = 0, entry_order;
+	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
 	gfp &= GFP_RECLAIM_MASK;
 
 	for (;;) {
-		int order = -1, split_order = 0;
 		void *old = NULL;
+		int cur_order;
+		pgoff_t swap_index;
 
 		xas_lock_irq(&xas);
 		old = xas_load(&xas);
@@ -2170,60 +2171,56 @@ static int shmem_split_large_entry(struc
 			goto unlock;
 		}
 
-		order = xas_get_order(&xas);
+		entry_order = xas_get_order(&xas);
 
-		/* Swap entry may have changed before we re-acquire the lock */
-		if (alloced_order &&
-		    (old != alloced_shadow || order != alloced_order)) {
-			xas_destroy(&xas);
-			alloced_order = 0;
-		}
+		if (!entry_order)
+			goto unlock;
 
 		/* Try to split large swap entry in pagecache */
-		if (order > 0) {
-			if (!alloced_order) {
-				split_order = order;
+		cur_order = entry_order;
+		swap_index = round_down(index, 1 << entry_order);
+
+		split_order = xas_try_split_min_order(cur_order);
+
+		while (cur_order > 0) {
+			pgoff_t aligned_index =
+				round_down(index, 1 << cur_order);
+			pgoff_t swap_offset = aligned_index - swap_index;
+
+			xas_set_order(&xas, index, split_order);
+			xas_try_split(&xas, old, cur_order);
+			if (xas_error(&xas))
 				goto unlock;
-			}
-			xas_split(&xas, old, order);
 
 			/*
 			 * Re-set the swap entry after splitting, and the swap
 			 * offset of the original large entry must be continuous.
 			 */
-			for (i = 0; i < 1 << order; i++) {
-				pgoff_t aligned_index = round_down(index, 1 << order);
+			for (i = 0; i < 1 << cur_order;
+			     i += (1 << split_order)) {
 				swp_entry_t tmp;
 
-				tmp = swp_entry(swp_type(swap), swp_offset(swap) + i);
+				tmp = swp_entry(swp_type(swap),
+						swp_offset(swap) + swap_offset +
+							i);
 				__xa_store(&mapping->i_pages, aligned_index + i,
 					   swp_to_radix_entry(tmp), 0);
 			}
+			cur_order = split_order;
+			split_order = xas_try_split_min_order(split_order);
 		}
 
 unlock:
 		xas_unlock_irq(&xas);
 
-		/* split needed, alloc here and retry. */
-		if (split_order) {
-			xas_split_alloc(&xas, old, split_order, gfp);
-			if (xas_error(&xas))
-				goto error;
-			alloced_shadow = old;
-			alloced_order = split_order;
-			xas_reset(&xas);
-			continue;
-		}
-
 		if (!xas_nomem(&xas, gfp))
 			break;
 	}
 
-error:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return alloced_order;
+	return entry_order;
 }
 
 /*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-fix-shmem-xarray-update-during-migration.patch
mm-huge_memory-drop-beyond-eof-folios-with-the-right-number-of-refs.patch
selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

