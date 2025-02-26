Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB53156C72
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536101; cv=none; b=Cveun6FBnO5vFnTaTUXs9Vg/68f07Ij0z7Xzf7ZqcWfGHfYLoZ4EEUrRkhHvVOLe49BWHsPNtd9WVftTBHKzq8eymDVCg45LNHWX8Pa1NykpngQtYbXL552m7mC6WPHc46hWePJ2bGYrekv43DpPqChIC7hEzAVHd/nhJ/T3puo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536101; c=relaxed/simple;
	bh=7d3YSxg8Cjw+8SnmeuRnrLqO4xpyn3frqAmLvrI++yI=;
	h=Date:To:From:Subject:Message-Id; b=i2MhbL/HsHJq+VAY+wCuJOLPcXiNyadYjrUOISHjQ5HzeThAfb0nVoH6IU92yvwofSdUSGVO1UEzFZiEyGQOsIpy18fBk78agwYmPqIgzvsG+0rvgtkFbZFzUDQneywsnz10BmZemaYA5oRDfzjLydu8OY5Q/JFlwnY0hCbZHBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ckX2BD8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ckX2BD8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB7C4CEE6;
	Wed, 26 Feb 2025 02:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740536100;
	bh=7d3YSxg8Cjw+8SnmeuRnrLqO4xpyn3frqAmLvrI++yI=;
	h=Date:To:From:Subject:From;
	b=ckX2BD8gxKK3eZiF2/bqhq7yJjQ8SVLahgclQwsG9yThwRuDXVE3E83T4+MUGkMuE
	 tYm/aKOxsm77PxQvv626borCZIWaiGntcFJwbdiA2pBs2q+xjgWBHU4zVLf3iTSfv5
	 RFxDEM8qjUAUtSrkRLANzj8qbIc13Mor0oft4wtE=
Date: Tue, 25 Feb 2025 18:15:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch added to mm-unstable branch
Message-Id: <20250226021500.C2AB7C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix shmem_split_large_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch

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
Subject: mm/shmem: fix shmem_split_large_entry()
Date: Tue, 25 Feb 2025 12:03:34 -0500

The swap entry offset was updated incorrectly. fix it.

Link: https://lkml.kernel.org/r/AF487A7A-F685-485D-8D74-756C843D6F0A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix
+++ a/mm/shmem.c
@@ -2162,7 +2162,7 @@ static int shmem_split_large_entry(struc
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0;
+	int split_order = 0, entry_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2180,35 +2180,46 @@ static int shmem_split_large_entry(struc
 		}
 
 		order = xas_get_order(&xas);
+		entry_order = order;
 
 		/* Try to split large swap entry in pagecache */
 		if (order > 0) {
 			int cur_order = order;
+			pgoff_t swap_index = round_down(index, 1 << order);
 
 			split_order = xas_try_split_min_order(cur_order);
 
 			while (cur_order > 0) {
+				pgoff_t aligned_index =
+					round_down(index, 1 << cur_order);
+				pgoff_t swap_offset = aligned_index - swap_index;
+
 				xas_set_order(&xas, index, split_order);
 				xas_try_split(&xas, old, cur_order, GFP_NOWAIT);
 				if (xas_error(&xas))
 					goto unlock;
+
+				/*
+				 * Re-set the swap entry after splitting, and
+				 * the swap offset of the original large entry
+				 * must be continuous.
+				 */
+				for (i = 0; i < 1 << cur_order;
+				     i += (1 << split_order)) {
+					swp_entry_t tmp;
+
+					tmp = swp_entry(swp_type(swap),
+							swp_offset(swap) +
+							swap_offset +
+								i);
+					__xa_store(&mapping->i_pages,
+						   aligned_index + i,
+						   swp_to_radix_entry(tmp), 0);
+				}
 				cur_order = split_order;
 				split_order =
 					xas_try_split_min_order(split_order);
 			}
-
-			/*
-			 * Re-set the swap entry after splitting, and the swap
-			 * offset of the original large entry must be continuous.
-			 */
-			for (i = 0; i < 1 << order; i++) {
-				pgoff_t aligned_index = round_down(index, 1 << order);
-				swp_entry_t tmp;
-
-				tmp = swp_entry(swp_type(swap), swp_offset(swap) + i);
-				__xa_store(&mapping->i_pages, aligned_index + i,
-					   swp_to_radix_entry(tmp), 0);
-			}
 		}
 
 unlock:
@@ -2221,7 +2232,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return split_order;
+	return entry_order;
 }
 
 /*
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch

