Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4A519EEC2;
	Thu,  6 Mar 2025 05:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239468; cv=none; b=MScJTzJfhnXFHHnxT+m06zZh9uXJ6MqqVz3BAZTH1P5XWigtIL9sU0xiMcMIiVm+28tB2EqSudOKZxg45Vk6HUmQd+FCrAeeXR3P2twmA/dX0wArFl6r1I/EpvnMh6ma55fTyHhKkEQF/9dZm4FM5PRMNTRPdkSJDhIdZZDua58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239468; c=relaxed/simple;
	bh=lETi9zOslFfRGV6btWf9j3f5jz0vLmnSWUIS19JAxFs=;
	h=Date:To:From:Subject:Message-Id; b=BaWos74cvhY8p3+YnR9WnsfmGkDi8UaCPc4iEHF2ImB6b6E/2JSSJ/xLEvSftXfoUqYDdzJzcBT40cI96QbAGs9afEJRRROrJlRs9JMS/KI4mTOq+IrTYU/TthEUvFL42bIwceMmnLltg6EXzvi2sfB8cfCf48lShHLdG40HivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q/YE3MHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q/YE3MHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D2C4CEE4;
	Thu,  6 Mar 2025 05:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239467;
	bh=lETi9zOslFfRGV6btWf9j3f5jz0vLmnSWUIS19JAxFs=;
	h=Date:To:From:Subject:From;
	b=q/YE3MHb52PysxGWV94WUhIpy2NjfuM0znY8W62eepjhTXR7vrv2TYHw+i3RRDwAr
	 Or5+FvXanjfRtb2UWyHJtIYkCLX1wU+IYhEE/LSK6KHrk9VcfwBQT6Z0sTjD8A+oSz
	 MXRGgdQTkKe2ETkSk75yXt4eq/uFPQX8XO4DQBdg=
Date: Wed, 05 Mar 2025 21:37:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,v-songbaohua@oppo.com,stable@vger.kernel.org,peterx@redhat.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,aarcange@redhat.com,21cnbao@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount.patch removed from -mm tree
Message-Id: <20250306053747.776D2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: do not block on locking a large folio with raised refcount
has been removed from the -mm tree.  Its filename was
     userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: userfaultfd: do not block on locking a large folio with raised refcount
Date: Wed, 26 Feb 2025 10:55:08 -0800

Lokesh recently raised an issue about UFFDIO_MOVE getting into a deadlock
state when it goes into split_folio() with raised folio refcount. 
split_folio() expects the reference count to be exactly mapcount +
num_pages_in_folio + 1 (see can_split_folio()) and fails with EAGAIN
otherwise.

If multiple processes are trying to move the same large folio, they raise
the refcount (all tasks succeed in that) then one of them succeeds in
locking the folio, while others will block in folio_lock() while keeping
the refcount raised.  The winner of this race will proceed with calling
split_folio() and will fail returning EAGAIN to the caller and unlocking
the folio.  The next competing process will get the folio locked and will
go through the same flow.  In the meantime the original winner will be
retried and will block in folio_lock(), getting into the queue of waiting
processes only to repeat the same path.  All this results in a livelock.

An easy fix would be to avoid waiting for the folio lock while holding
folio refcount, similar to madvise_free_huge_pmd() where folio lock is
acquired before raising the folio refcount.  Since we lock and take a
refcount of the folio while holding the PTE lock, changing the order of
these operations should not break anything.

Modify move_pages_pte() to try locking the folio first and if that fails
and the folio is large then return EAGAIN without touching the folio
refcount.  If the folio is single-page then split_folio() is not called,
so we don't have this issue.  Lokesh has a reproducer [1] and I verified
that this change fixes the issue.

[1] https://github.com/lokeshgidra/uffd_move_ioctl_deadlock

[akpm@linux-foundation.org: reflow comment to 80 cols, s/end/end up/]
Link: https://lkml.kernel.org/r/20250226185510.2732648-2-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount
+++ a/mm/userfaultfd.c
@@ -1250,6 +1250,7 @@ retry:
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			bool locked;
 
 			/*
 			 * Pin the page while holding the lock to be sure the
@@ -1269,12 +1270,26 @@ retry:
 				goto out;
 			}
 
+			locked = folio_trylock(folio);
+			/*
+			 * We avoid waiting for folio lock with a raised
+			 * refcount for large folios because extra refcounts
+			 * will result in split_folio() failing later and
+			 * retrying.  If multiple tasks are trying to move a
+			 * large folio we can end up livelocking.
+			 */
+			if (!locked && folio_test_large(folio)) {
+				spin_unlock(src_ptl);
+				err = -EAGAIN;
+				goto out;
+			}
+
 			folio_get(folio);
 			src_folio = folio;
 			src_folio_pte = orig_src_pte;
 			spin_unlock(src_ptl);
 
-			if (!folio_trylock(src_folio)) {
+			if (!locked) {
 				pte_unmap(&orig_src_pte);
 				pte_unmap(&orig_dst_pte);
 				src_pte = dst_pte = NULL;
_

Patches currently in -mm which might be from surenb@google.com are

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

