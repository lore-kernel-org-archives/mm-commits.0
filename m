Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E2D12CDA5
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739851641; cv=none; b=TvOCUslsNGHrgCSUT5HiAAtsOXEasXbgR4UGZq0++qDc2cO6hJJwChOrHZZmbpJKFjsT7IH+OJq4FJAxzXgfdKKz/Aely4Ymz/9cowT3R04g3Ap5Fkusn0w1H/yhkdsYEVMViJdbYWGri4lETdV4fTMn8Pq5S08ZYsW9NE0F5fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739851641; c=relaxed/simple;
	bh=jKuds4sYbA7/TiNlDcB+Y2RZajMasp+h4UrXJN9k+gM=;
	h=Date:To:From:Subject:Message-Id; b=XEkOSXH1lBSQnYb9qzqg0ahntc2kF6LODGqIHNwL6lJa2BHJ/Hh9BqCdgDuB9nElwVNiMBBP0vTB+cCt5MuHFE2SXoaSu4jttUG+L0SK4rsfGrU2GKll/uVLoYAZZWz5MyqlZDxeykRmSaVLQ9xcPcBCymKCagQgV3zg6DdzRg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t9oknF7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t9oknF7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA180C4CEE6;
	Tue, 18 Feb 2025 04:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739851639;
	bh=jKuds4sYbA7/TiNlDcB+Y2RZajMasp+h4UrXJN9k+gM=;
	h=Date:To:From:Subject:From;
	b=t9oknF7GCuIX9z9X1DfP8pcRXDHqxaQcgJBAgulH118zLWM3F2qjyTjyx/XEt0vDV
	 hs1O/TLyL4k2ZCUgpkG0sC370qpwJyI0pcz7i3sVIgZrr7Z7b2UGk3+JQMQ2I4uNCQ
	 CT5KQty+mw0P7CGcyWCSUY96Cw3PwFNeNa67L+mM=
Date: Mon, 17 Feb 2025 20:07:19 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split-fix.patch added to mm-unstable branch
Message-Id: <20250218040719.AA180C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: check folio_test_anon() before mapping_large_folio_support()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split-fix.patch

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
Subject: mm/huge_memory: check folio_test_anon() before mapping_large_folio_support()
Date: Sun, 16 Feb 2025 09:01:29 -0500

Otherwise mapping_large_folio_support() complains.

Link: https://lkml.kernel.org/r/4483B46A-FEAF-46D9-AFF4-F0DF34864633@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split-fix
+++ a/mm/huge_memory.c
@@ -3723,20 +3723,19 @@ after_split:
 static bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
-	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1) {
-		VM_WARN_ONCE(warns, "Cannot split to order-1 folio");
-		return false;
-	}
-
-	/*
-	 * No split if the file system does not support large folio.
-	 * Note that we might still have THPs in such mappings due to
-	 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
-	 * does not actually support large folios properly.
-	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+	if (folio_test_anon(folio)) {
+		/* order-1 is not supported for anonymous THP. */
+		VM_WARN_ONCE(warns && new_order == 1,
+				"Cannot split to order-1 folio");
+		return new_order != 1;
+	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    !mapping_large_folio_support(folio->mapping)) {
+		/*
+		 * No split if the file system does not support large folio.
+		 * Note that we might still have THPs in such mappings due to
+		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
+		 * does not actually support large folios properly.
+		 */
 		VM_WARN_ONCE(warns,
 			"Cannot split file folio to non-0 order");
 		return false;
@@ -3756,24 +3755,25 @@ static bool non_uniform_split_supported(
 static bool uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
-	if (folio_test_anon(folio) && new_order == 1) {
-		VM_WARN_ONCE(warns, "Cannot split to order-1 folio");
-		return false;
-	}
-
-	if (new_order) {
+	if (folio_test_anon(folio)) {
+		VM_WARN_ONCE(warns && new_order == 1,
+				"Cannot split to order-1 folio");
+		return new_order != 1;
+	} else  if (new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
 			return false;
 		}
-		if (folio_test_swapcache(folio)) {
-			VM_WARN_ONCE(warns,
-				"Cannot split swapcache folio to non-0 order");
-			return false;
-		}
 	}
+
+	if (new_order && folio_test_swapcache(folio)) {
+		VM_WARN_ONCE(warns,
+			"Cannot split swapcache folio to non-0 order");
+		return false;
+	}
+
 	return true;
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split-fix.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

