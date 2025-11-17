Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA523BD1F
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343267; cv=none; b=lYk+zxgiuZjJ+ZqCrU51k4VsznY80+YDULyX0I9h8saq4oI0aUFC08T2dlOnVxSYf+JCpmQrVy48+by03id2lavJbn0kAfyBS0zD94Df1Y6IUUv08miDZpoPJdUqKzV3flM6oeFk6+2uYcL5a0GlMDoCQPMctZw7U6clbS7hjpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343267; c=relaxed/simple;
	bh=+3cGFUAjVszftHNCcTvrUUq4tO1Sq1xWqcxrEhJHyTE=;
	h=Date:To:From:Subject:Message-Id; b=r3sqs+JCUhVO3VQ85vSH0d8A8enD5JSpT5DHXl7qcKuF6ixmnlNsNSu59372OpXF4TKHNNPQD9KIsI+AxQo349jlU0XGuraqqyk2LYDGHebebGXurfRg6JQHu/FmIYJH6Mih9xQ1ldgToKka6jmNDY71++tGhi0rFiBYH6VOGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sfr2aH0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sfr2aH0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0A1C4CEF1;
	Mon, 17 Nov 2025 01:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343266;
	bh=+3cGFUAjVszftHNCcTvrUUq4tO1Sq1xWqcxrEhJHyTE=;
	h=Date:To:From:Subject:From;
	b=Sfr2aH0NxiyHnuZE9K47A6/od0F10gjLmby/MgfVH2anhuBpoNXe6kQlYBFo+Pp4p
	 vXSj3pALxOQrZUajAmkNVHb/Bh2G2GypeK/NcNv/uom1bk4AxBVOVsZiWj/G+RNWwQ
	 G15NCz5BSs144ZFIerMiCw/aP+HMzsq+kZerjhrk=
Date: Sun, 16 Nov 2025 17:34:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,liam.howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-small-vma-lock-cleanups.patch removed from -mm tree
Message-Id: <20251117013426.DD0A1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: small VMA lock cleanups
has been removed from the -mm tree.  Its filename was
     mm-vma-small-vma-lock-cleanups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: small VMA lock cleanups
Date: Fri, 24 Oct 2025 10:09:02 +0100

We declare vma_start_read() as a static function in mm/mmap_lock.c, so
there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.

__is_vma_write_locked() is declared in a header and should therefore be
static inline.

Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to
make precedence clear.

Link: https://lkml.kernel.org/r/20251024090902.1118174-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-small-vma-lock-cleanups
+++ a/include/linux/mmap_lock.h
@@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(in
 	 * a detached vma happens only in vma_mark_detached() and is a rare
 	 * case, therefore most of the time there will be no unnecessary wakeup.
 	 */
-	return refcnt & VMA_LOCK_OFFSET && refcnt <= VMA_LOCK_OFFSET + 1;
+	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
 }
 
 static inline void vma_refcount_put(struct vm_area_struct *vma)
@@ -183,7 +183,7 @@ static inline void vma_end_read(struct v
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_r
 	return true;
 }
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-						    struct vm_area_struct *vma)
-		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch

