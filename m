Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233218DB1A
	for <mm-commits@vger.kernel.org>; Fri, 24 Jul 2026 00:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853457; cv=none; b=m91AosuRRragfRguN1cjrVkslETpK6s1OZMMwHwy8YW21dtje46e5lgiWD/WI8QCGjtCM47ijS1yxafTxRCuYZ/qFwgO8HWSGOhYyXoo01dtmZ8xY2hqCmv6ON1kHJJ846bXOddNORA9+CGJ4Cg+aNCC62cvc7Ep6K9lBTBXOCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853457; c=relaxed/simple;
	bh=acNuyel4sG6hNtZbBmZUpMA+2nFtKZlJlXaxIa39ieU=;
	h=Date:To:From:Subject:Message-Id; b=YKr86a03i1MiWSjpugoCibLwaAnMR9cY0h6YbWa1ujKMdl8faf92ew2qsdQBuVMW3fo496TFS7uL1yKCo4UavwRuyhXaUA4wuSxTwA7gLTOtZvSrZI6YNCAR9wBSJpmUl+2aCd2hXxdnMBxsNXKwrF3YUVP9st75CPUXyZ35ZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0caKbLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0caKbLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC621F000E9;
	Fri, 24 Jul 2026 00:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784853455;
	bh=kWxC9CTFyY8JAEl+hhPTh4UGyKWMIACp5IijqSkZIxQ=;
	h=Date:To:From:Subject;
	b=i0caKbLkOtngxx/9OypIhooHhisD2HpeuF81Ng2YZvGuhTOvahKF4+vdVxaTOdII1
	 LK8h00A15ObfbaTu7xShwqwF5BRLnGfBksoLP4PHvDSoFLhWfCPeLqGUBo175PTS72
	 PzISB45Vksu+1rqkFimWX84T5tPg1H/gz45xfV5Q=
Date: Thu, 23 Jul 2026 17:37:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extract-non-swap-page-handling-to-do_non_swap_page.patch added to mm-new branch
Message-Id: <20260724003735.4CC621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: extract non-swap page handling to do_non_swap_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-extract-non-swap-page-handling-to-do_non_swap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extract-non-swap-page-handling-to-do_non_swap_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm: extract non-swap page handling to do_non_swap_page()
Date: Thu, 23 Jul 2026 11:07:52 +0800

Factor non-swap entry logic out of bloated do_swap_page() to simplify the
main swap fault flow and improve readability.

The new do_non_swap_page() handles migration, device private/exclusive,
hwpoison, marker and bad PTE entries.

Link: https://lore.kernel.org/20260723030752.16979-3-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  120 ++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 51 deletions(-)

--- a/mm/memory.c~mm-extract-non-swap-page-handling-to-do_non_swap_page
+++ a/mm/memory.c
@@ -4866,6 +4866,74 @@ static void check_swap_exclusive(struct
 	} while (--nr_pages);
 }
 
+static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	softleaf_t entry;
+	vm_fault_t ret = 0;
+
+	entry = softleaf_from_pte(vmf->orig_pte);
+	if (softleaf_is_migration(entry)) {
+		migration_entry_wait(vma->vm_mm, vmf->pmd,
+				     vmf->address);
+	} else if (softleaf_is_device_exclusive(entry)) {
+		vmf->page = softleaf_to_page(entry);
+		ret = remove_device_exclusive_entry(vmf);
+	} else if (softleaf_is_device_private(entry)) {
+
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			/*
+			 * migrate_to_ram is not yet ready to operate
+			 * under VMA lock.
+			 */
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
+
+		vmf->page = softleaf_to_page(entry);
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+						vmf->address, &vmf->ptl);
+		if (unlikely(!vmf->pte ||
+			     !pte_same(ptep_get(vmf->pte),
+					vmf->orig_pte)))
+			goto unlock;
+
+		/*
+		 * Get a folio reference while we know the folio can't be
+		 * freed.
+		 */
+		folio = page_folio(vmf->page);
+		if (folio_trylock(folio)) {
+			struct dev_pagemap *pgmap;
+
+			folio_get(folio);
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			pgmap = page_pgmap(vmf->page);
+			ret = pgmap->ops->migrate_to_ram(vmf);
+			folio_unlock(folio);
+			folio_put(folio);
+		} else {
+			pte_unmap(vmf->pte);
+			softleaf_entry_wait_on_locked(entry, vmf->ptl);
+		}
+	} else if (softleaf_is_hwpoison(entry)) {
+		ret = VM_FAULT_HWPOISON;
+	} else if (softleaf_is_marker(entry)) {
+		ret = handle_pte_marker(vmf);
+	} else {
+		print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
+		ret = VM_FAULT_SIGBUS;
+	}
+
+	return ret;
+
+unlock:
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return ret;
+}
+
 /*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
@@ -4896,57 +4964,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	entry = softleaf_from_pte(vmf->orig_pte);
 	if (unlikely(!softleaf_is_swap(entry))) {
-		if (softleaf_is_migration(entry)) {
-			migration_entry_wait(vma->vm_mm, vmf->pmd,
-					     vmf->address);
-		} else if (softleaf_is_device_exclusive(entry)) {
-			vmf->page = softleaf_to_page(entry);
-			ret = remove_device_exclusive_entry(vmf);
-		} else if (softleaf_is_device_private(entry)) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				/*
-				 * migrate_to_ram is not yet ready to operate
-				 * under VMA lock.
-				 */
-				vma_end_read(vma);
-				ret = VM_FAULT_RETRY;
-				goto out;
-			}
-
-			vmf->page = softleaf_to_page(entry);
-			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-					vmf->address, &vmf->ptl);
-			if (unlikely(!vmf->pte ||
-				     !pte_same(ptep_get(vmf->pte),
-							vmf->orig_pte)))
-				goto unlock;
-
-			/*
-			 * Get a folio reference while we know the folio can't be
-			 * freed.
-			 */
-			folio = page_folio(vmf->page);
-			if (folio_trylock(folio)) {
-				struct dev_pagemap *pgmap;
-
-				folio_get(folio);
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
-				pgmap = page_pgmap(vmf->page);
-				ret = pgmap->ops->migrate_to_ram(vmf);
-				folio_unlock(folio);
-				folio_put(folio);
-			} else {
-				pte_unmap(vmf->pte);
-				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-			}
-		} else if (softleaf_is_hwpoison(entry)) {
-			ret = VM_FAULT_HWPOISON;
-		} else if (softleaf_is_marker(entry)) {
-			ret = handle_pte_marker(vmf);
-		} else {
-			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
-			ret = VM_FAULT_SIGBUS;
-		}
+		ret = do_non_swap_page(vmf);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch
selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch
selftests-mm-fix-clone-cleartid-race-in-pkey-sighandler-tests.patch
selftests-mm-fix-memleak-in-migration-benchmark.patch
selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-extract-non-swap-page-handling-to-do_non_swap_page.patch

