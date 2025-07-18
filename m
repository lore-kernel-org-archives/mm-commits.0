Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7F321CFE0
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873148; cv=none; b=EMpRBBA2wuNuo42Ho/LprSnWmH1dHOyylqC4bstNjIg6y8aIq0lDb4Pb/2NtS4qcxRxeDlaoYFwrPUI4cVMq8Jv+rnmdaaGTOrptdliBjNv/9xtsvCFe6G6RiBZ/gbtRKt3a84IhkdMY6Yo1he6PQx/fV0JsFnEzapZOrLEx3zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873148; c=relaxed/simple;
	bh=4d0p+cCoJuIH7aVNd2w2nZpiG03ryKSGXG+EuMW9DSw=;
	h=Date:To:From:Subject:Message-Id; b=qNBcE0n7/QB4epTXYYnXV05VLi18DzUuf5XW82+WNt0zNiYzM6hCJYsq+05T9COgzur+Z+NRBX4kQv2G3blUtSHpKKtEFenuNi3j80gSoxmCu5UkFVmyZw1jxfsyjgXxBpORtOMwBYAjDxbjL36RDDzqFl2MtkKKBfYL/mFAYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAjBq91E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAjBq91E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFADC4CEEB;
	Fri, 18 Jul 2025 21:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752873148;
	bh=4d0p+cCoJuIH7aVNd2w2nZpiG03ryKSGXG+EuMW9DSw=;
	h=Date:To:From:Subject:From;
	b=HAjBq91E9EGPq7g/yJbOlpWxhm427ZcPL6hafhNtCMGabpVLWuNA1B9IRpgSvY+Km
	 CKxamIZYLU4naNMYzoTzAqE4kLJk1dMF3HWXiX6RI9EGICVmNME2VM9kXrDMKZ3aK5
	 sxoymFAEQWPKIdfqaOGaH43r0MXL0ilFXnE2E6Cw=
Date: Fri, 18 Jul 2025 14:12:27 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch added to mm-new branch
Message-Id: <20250718211228.1CFADC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split()
Date: Fri, 18 Jul 2025 14:37:18 -0400

These VM_BUG* can be handled gracefully without crashing kernel.

Link: https://lkml.kernel.org/r/20250718183720.4054515-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split
+++ a/mm/huge_memory.c
@@ -3601,8 +3601,8 @@ static int __folio_split(struct folio *f
 	pgoff_t end;
 	bool is_hzp;
 
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
@@ -3766,7 +3766,11 @@ static int __folio_split(struct folio *f
 		}
 
 		if (folio_test_swapcache(folio)) {
-			VM_BUG_ON(mapping);
+			if (mapping) {
+				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
+				ret = -EINVAL;
+				goto fail;
+			}
 
 			swap_cache = swap_address_space(folio->swap);
 			xa_lock(&swap_cache->i_pages);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch

