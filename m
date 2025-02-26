Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891742745E;
	Wed, 26 Feb 2025 21:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740605535; cv=none; b=b5OQxmvdBRPA6JguZksDOJDlOm7dEDE4qeS9eZ9AfXAnK3sMggLua1rfkzj7nREHMctTVquJOaoz3NSINVr9KtEM+RFqh38sQWJEdLm5/RoePffm3l+kCfRm6MCdLTMenbi/FAmjSk0m66KICl5m1wC3HCOrtViLut/rN5L8/B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740605535; c=relaxed/simple;
	bh=uXSePFVCUMGaYm5BxxVJKlXEJQpALJXdsJNqK5bnCZw=;
	h=Date:To:From:Subject:Message-Id; b=nVnfpiPH31JbE2T3R5Ow16rco/57njh7L1EXDG3EpByeUMArVYjLwgrVBnm0VsCPf35kHNW9WKTT5Vju+Scu1kHzjWmrJO63SooW4XHaTWPWSaeKb+sp3zH4RbKuwDfZT14kMjxE6vVueLSame2KX+RhSBRXPSOGOH3OT+DRVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pjbe2Iqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pjbe2Iqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF780C4CEE9;
	Wed, 26 Feb 2025 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740605535;
	bh=uXSePFVCUMGaYm5BxxVJKlXEJQpALJXdsJNqK5bnCZw=;
	h=Date:To:From:Subject:From;
	b=Pjbe2IqcfG16Uv5TMqb+PJzeMGnzXuo6oWZkB0swPQ0WQ6j3UoQYVaVzler01HPe5
	 HZxDsQimtpO28XyMZosjzTtnydZyNmVVvWvzr4R/zaaY6QZsoXYe1ZpTgxe+J/VFeZ
	 DwZekMilnurbQ/dkxHbuOjC+pvIG4SsFrJ5GTzXE=
Date: Wed, 26 Feb 2025 13:32:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,v-songbaohua@oppo.com,stable@vger.kernel.org,peterx@redhat.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,aarcange@redhat.com,21cnbao@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-pte-unmapping-stack-allocated-pte-copies.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226213214.EF780C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix PTE unmapping stack-allocated PTE copies
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-fix-pte-unmapping-stack-allocated-pte-copies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-pte-unmapping-stack-allocated-pte-copies.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: fix PTE unmapping stack-allocated PTE copies
Date: Wed, 26 Feb 2025 10:55:09 -0800

Current implementation of move_pages_pte() copies source and destination
PTEs in order to detect concurrent changes to PTEs involved in the move. 
However these copies are also used to unmap the PTEs, which will fail if
CONFIG_HIGHPTE is enabled because the copies are allocated on the stack. 
Fix this by using the actual PTEs which were kmap()ed.

Link: https://lkml.kernel.org/r/20250226185510.2732648-3-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-pte-unmapping-stack-allocated-pte-copies
+++ a/mm/userfaultfd.c
@@ -1290,8 +1290,8 @@ retry:
 			spin_unlock(src_ptl);
 
 			if (!locked) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				/* now we can block and wait */
 				folio_lock(src_folio);
@@ -1307,8 +1307,8 @@ retry:
 		/* at this point we have src_folio locked */
 		if (folio_test_large(src_folio)) {
 			/* split_folio() can block */
-			pte_unmap(&orig_src_pte);
-			pte_unmap(&orig_dst_pte);
+			pte_unmap(src_pte);
+			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			err = split_folio(src_folio);
 			if (err)
@@ -1333,8 +1333,8 @@ retry:
 				goto out;
 			}
 			if (!anon_vma_trylock_write(src_anon_vma)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				/* now we can block and wait */
 				anon_vma_lock_write(src_anon_vma);
@@ -1352,8 +1352,8 @@ retry:
 		entry = pte_to_swp_entry(orig_src_pte);
 		if (non_swap_entry(entry)) {
 			if (is_migration_entry(entry)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				migration_entry_wait(mm, src_pmd, src_addr);
 				err = -EAGAIN;
@@ -1396,8 +1396,8 @@ retry:
 			src_folio = folio;
 			src_folio_pte = orig_src_pte;
 			if (!folio_trylock(src_folio)) {
-				pte_unmap(&orig_src_pte);
-				pte_unmap(&orig_dst_pte);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
 				src_pte = dst_pte = NULL;
 				/* now we can block and wait */
 				folio_lock(src_folio);
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount.patch
userfaultfd-fix-pte-unmapping-stack-allocated-pte-copies.patch
mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count-fix.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
docs-mm-document-latest-changes-to-vm_lock.patch

