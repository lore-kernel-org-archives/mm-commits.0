Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF43C3443
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178860; cv=none; b=CU2VKM4PYvR5p++hjQxBx95pUo4jdAe2CXqTNfEEgUEVZVG+t/AWCv6C5bj9Ntz/WtYdr1hTqnMSJn4gg4JYmRV4mdStOdq1mJrq1nh2b7YPY7pAk61s8xLYAcPLtA60E7kwVr2uwbVO+QE1vjN0jiRWhhc8gDoSXH0+X2/Nyow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178860; c=relaxed/simple;
	bh=heo+PmocQE5ZWnNtiYWpAbmkW4IEikQWxxEkfVTIgMQ=;
	h=Date:To:From:Subject:Message-Id; b=HmFkdHVjEOVRRnITAvhaLZ4mj6M5/qS85XCQtc4i6qtbsHFsBDyTm0TqZ/v8P6i9w+z2+3Q5fhXRQgEodVBeOi8bDZHHOMuRJL+silYS6xNvSxSXRnGtRenCLsZ5VmxcREP+8991/C+DNzMy+rSATuAYDQ2/f578OgHCQcFuKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sg0RjKpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sg0RjKpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70B51F00A3F;
	Mon, 27 Jul 2026 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785178853;
	bh=ZFApzc9iVCg+X14pffJn2A6vU1spghNfSxTQtDpHD1E=;
	h=Date:To:From:Subject;
	b=Sg0RjKpISe7XzOAoL3wdp9HBpMpkXvABmWmGzDb5eIwqZDDK4gSYjLA8jQhZEZ82R
	 FhY61gTR5eAWIE70dZ2hLh8T+R7fzd+wdKVNAScWjS61Xj/6y7JKe5gChJAAWB+Dqs
	 z81l5IrQ8VUtOF3IfnZXKMDXmPiq5LnqXuRFRx4Y=
Date: Mon, 27 Jul 2026 12:00:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-extract-non-swap-page-handling-to-do_non_swap_page.patch removed from -mm tree
Message-Id: <20260727190053.C70B51F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extract non-swap page handling to do_non_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-extract-non-swap-page-handling-to-do_non_swap_page.patch

This patch was dropped because an updated version will be issued

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

