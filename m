Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593BB21B9C0
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873147; cv=none; b=OdxLtFgZsWLm/FwSWP1nuWbmd7q7JfOXyBgk9+WhOQVvKpTIv9JuYIf2Pyc1xzgSJCmECB6vGV3wmLOmmTnxi/wW0I7ReLsoIeHbHYf/i3cSrGJrArecKMIDB3Lfjwh4rjvB+hyqRGj3aEW6J8CdtODVgptqCXvKDd1gG2zHsMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873147; c=relaxed/simple;
	bh=ISYo5hhqczS6GPPLyphFkayRQK7qh9jfMFThqumr59c=;
	h=Date:To:From:Subject:Message-Id; b=f1/8o2PLl/srHfUelIdh6n4HapgC2tnV02/a4cJpcXfGtxvTDWJOcB0HSQIujjuh34KLemXdkDBnoy8MXXIzfORKEc8vjC3njFNUjrqVolwfPjMGL2U9S8BUiavtBbojJClBlWiRi3IhKcMIwkl6Xbls/XVOLcuTyChtlh2PJhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SR+knnU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SR+knnU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA114C4CEEB;
	Fri, 18 Jul 2025 21:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752873146;
	bh=ISYo5hhqczS6GPPLyphFkayRQK7qh9jfMFThqumr59c=;
	h=Date:To:From:Subject:From;
	b=SR+knnU/00aE3GJv6kM4/aJQPT+h4Z8qbQPZSy7DWg5eYDSlBXB73GUvTpoQPFDUa
	 G/i1cmkLb6hU7mXHk75Chy/qO2f8ZmdiT7XAvHb/PbiXyo3L1DqdZ8dPxdqRiHuNPK
	 AVttShp9VerDNvvjSWglh/TsCfy4ziPaF62mIpDQ=
Date: Fri, 18 Jul 2025 14:12:26 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-deduplicate-code-in-__folio_split.patch added to mm-new branch
Message-Id: <20250718211226.DA114C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: deduplicate code in __folio_split()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-deduplicate-code-in-__folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-deduplicate-code-in-__folio_split.patch

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
Subject: mm/huge_memory: deduplicate code in __folio_split()
Date: Fri, 18 Jul 2025 14:37:17 -0400

xas unlock, remap_page(), local_irq_enable() are moved out of if branches
to deduplicate the code.  While at it, add remap_flags to clean up
remap_page() call site.  nr_dropped is renamed to nr_shmem_dropped, as it
becomes a variable at __folio_split() scope.

Link: https://lkml.kernel.org/r/20250718183720.4054515-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   73 +++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-deduplicate-code-in-__folio_split
+++ a/mm/huge_memory.c
@@ -3595,6 +3595,8 @@ static int __folio_split(struct folio *f
 	struct anon_vma *anon_vma = NULL;
 	int order = folio_order(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
+	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end;
 	bool is_hzp;
@@ -3718,15 +3720,16 @@ static int __folio_split(struct folio *f
 		 */
 		xas_lock(&xas);
 		xas_reset(&xas);
-		if (xas_load(&xas) != folio)
+		if (xas_load(&xas) != folio) {
+			ret = -EAGAIN;
 			goto fail;
+		}
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct address_space *swap_cache = NULL;
-		int nr_dropped = 0;
 		struct lruvec *lruvec;
 
 		if (folio_order(folio) > 1 &&
@@ -3798,7 +3801,7 @@ static int __folio_split(struct folio *f
 			/* Some pages can be beyond EOF: drop them from cache */
 			if (new_folio->index >= end) {
 				if (shmem_mapping(mapping))
-					nr_dropped += folio_nr_pages(new_folio);
+					nr_shmem_dropped += folio_nr_pages(new_folio);
 				else if (folio_test_clear_dirty(new_folio))
 					folio_account_cleaned(
 						new_folio,
@@ -3828,47 +3831,41 @@ static int __folio_split(struct folio *f
 
 		if (swap_cache)
 			xa_unlock(&swap_cache->i_pages);
-		if (mapping)
-			xas_unlock(&xas);
+	} else {
+		spin_unlock(&ds_queue->split_queue_lock);
+		ret = -EAGAIN;
+	}
+fail:
+	if (mapping)
+		xas_unlock(&xas);
 
-		local_irq_enable();
+	local_irq_enable();
 
-		if (nr_dropped)
-			shmem_uncharge(mapping->host, nr_dropped);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-		remap_page(folio, 1 << order,
-			   !ret && folio_test_anon(folio) ?
-				   RMP_USE_SHARED_ZEROPAGE :
-				   0);
+	if (!ret && is_anon)
+		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+	remap_page(folio, 1 << order, remap_flags);
 
+	/*
+	 * Unlock all after-split folios except the one containing
+	 * @lock_at page. If @folio is not split, it will be kept locked.
+	 */
+	for (new_folio = folio; new_folio != end_folio; new_folio = next) {
+		next = folio_next(new_folio);
+		if (new_folio == page_folio(lock_at))
+			continue;
+
+		folio_unlock(new_folio);
 		/*
-		 * Unlock all after-split folios except the one containing
-		 * @lock_at page. If @folio is not split, it will be kept locked.
+		 * Subpages may be freed if there wasn't any mapping
+		 * like if add_to_swap() is running on a lru page that
+		 * had its mapping zapped. And freeing these pages
+		 * requires taking the lru_lock so we do the put_page
+		 * of the tail pages after the split is complete.
 		 */
-		for (new_folio = folio; new_folio != end_folio;
-		     new_folio = next) {
-			next = folio_next(new_folio);
-			if (new_folio == page_folio(lock_at))
-				continue;
-
-			folio_unlock(new_folio);
-			/*
-			 * Subpages may be freed if there wasn't any mapping
-			 * like if add_to_swap() is running on a lru page that
-			 * had its mapping zapped. And freeing these pages
-			 * requires taking the lru_lock so we do the put_page
-			 * of the tail pages after the split is complete.
-			 */
-			free_folio_and_swap_cache(new_folio);
-		}
-	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
-fail:
-		if (mapping)
-			xas_unlock(&xas);
-		local_irq_enable();
-		remap_page(folio, folio_nr_pages(folio), 0);
-		ret = -EAGAIN;
+		free_folio_and_swap_cache(new_folio);
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch
mm-huge_memory-deduplicate-code-in-__folio_split.patch
mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch
mm-huge_memory-get-frozen-folio-refcount-with-folio_expected_ref_count.patch
mm-huge_memory-refactor-after-split-page-cache-code.patch

