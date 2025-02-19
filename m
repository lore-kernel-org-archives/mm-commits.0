Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB51BDCF
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 01:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927447; cv=none; b=cax6MZEVwqb9e74iRKw4+zZeG9Lls3n75oGHKEiDAyljNj67JC68r9YWoTrEOeSotdOCy1/jwYLJ1YwV/8SjB2j6UrXrEId4qffoYG0JnurwJ6CvUfGfRIfT/xnrTG9wm2P9gwD69BJxMgOr2OcgIHKWiW269v+qsL6oIh7w3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927447; c=relaxed/simple;
	bh=E1FN1nVEGjYf7KXNvZN2mZJPwMKSoXaJzHG3O1mZre8=;
	h=Date:To:From:Subject:Message-Id; b=e0HId3qZs/KTfpvKpBkEH45lsFkeubFS49wPd23VhiMamqthBvIc3TiHScyGVkjKkRtyVYtTTJ03eJPJKOSSqyFEKgKozp3uXyoh7zwkOSKaMK5LHCXwL1RO7qVRaSRX4mhYefuHeYoDy8jWk6EGm9EPP5J3QHp9v0A+7W36nmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gtyrMfBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gtyrMfBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2972BC4CEE2;
	Wed, 19 Feb 2025 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739927447;
	bh=E1FN1nVEGjYf7KXNvZN2mZJPwMKSoXaJzHG3O1mZre8=;
	h=Date:To:From:Subject:From;
	b=gtyrMfBYu3oOPWMqAIGyGR/QErVQMFXluMYu0Fj4MGVD25uIbGoq/Ijr9nyJ96xQI
	 84yVtqLMuyUrdV4paVbULQvl+z1NC3SyAgvEekuiSfPGQjpoOC4Lkv1LeXFR0/Vb/0
	 /j2nGk2OZMTSyWE7U+84R2cy4eb3KQLzr8wq9OTY=
Date: Tue, 18 Feb 2025 17:10:46 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch added to mm-unstable branch
Message-Id: <20250219011047.2972BC4CEE2@smtp.kernel.org>
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
Date: Tue, 18 Feb 2025 18:54:44 -0500

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

Link: https://lkml.kernel.org/r/20250218235444.1543173-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
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

 mm/shmem.c |   43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-xas_try_split-in-shmem_split_large_entry
+++ a/mm/shmem.c
@@ -2162,14 +2162,14 @@ static int shmem_split_large_entry(struc
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	void *alloced_shadow = NULL;
-	int alloced_order = 0, i;
+	int split_order = 0;
+	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
 	gfp &= GFP_RECLAIM_MASK;
 
 	for (;;) {
-		int order = -1, split_order = 0;
+		int order = -1;
 		void *old = NULL;
 
 		xas_lock_irq(&xas);
@@ -2181,20 +2181,21 @@ static int shmem_split_large_entry(struc
 
 		order = xas_get_order(&xas);
 
-		/* Swap entry may have changed before we re-acquire the lock */
-		if (alloced_order &&
-		    (old != alloced_shadow || order != alloced_order)) {
-			xas_destroy(&xas);
-			alloced_order = 0;
-		}
-
 		/* Try to split large swap entry in pagecache */
 		if (order > 0) {
-			if (!alloced_order) {
-				split_order = order;
-				goto unlock;
+			int cur_order = order;
+
+			split_order = xas_try_split_min_order(cur_order);
+
+			while (cur_order > 0) {
+				xas_set_order(&xas, index, split_order);
+				xas_try_split(&xas, old, cur_order, GFP_NOWAIT);
+				if (xas_error(&xas))
+					goto unlock;
+				cur_order = split_order;
+				split_order =
+					xas_try_split_min_order(split_order);
 			}
-			xas_split(&xas, old, order);
 
 			/*
 			 * Re-set the swap entry after splitting, and the swap
@@ -2213,26 +2214,14 @@ static int shmem_split_large_entry(struc
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
+	return split_order;
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

