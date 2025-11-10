Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF4332ABFD
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 18:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762800671; cv=none; b=M6+165btWCT/jCfd9ul5ls4AcjiX4nKTIJurSosTpE6wIvzUgATuuohszHRTnGuMYQn3ZZwonKGtK0/jGYuuvIYJiu7JJLZv1jLgl0Hq/qDT6F1tOy8XSz8BublXdnsyQwp6nOQBm//XC7S5Eh1H8IZnP/t1ID56KV9a8Rz5H5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762800671; c=relaxed/simple;
	bh=/WgI5oXTwoDgfYwxytDnEkwx6YFK3G5iz30zB9VvULk=;
	h=Date:To:From:Subject:Message-Id; b=GQS2azq+rWZj4uhT6ROJmGfUu/yMBx0o+GTYnEkVQPNs8yUJTrqBb2Rwm4hgQDqQRNDgVGrrZpRXW4GT2gkMZUhXuUbpEUhTS/3k91FHJ1I2qe6dzTEUdNZ9kL1CbyB4us7x6WhjdgEN2culCHCkLqlzpz1JiXzlqNO9O9x0GBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsMd6hLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsMd6hLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBBFC19425;
	Mon, 10 Nov 2025 18:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762800671;
	bh=/WgI5oXTwoDgfYwxytDnEkwx6YFK3G5iz30zB9VvULk=;
	h=Date:To:From:Subject:From;
	b=jsMd6hLN7DuVCdwiQLqQ3+Js/S6/iagzh754hZEEn40Sj9QBZPyRGHiTTjg7oU42N
	 CbpZt5jq5NA2U5FUbNRrTiHjKIqxbyW4+rSP2SJ6DGQ0XxBxYCiKFOMHoEHacdjxr8
	 ArtAS9WDonmsGBBrNTc9bpg7LWnV8VvhFZWiC3iQ=
Date: Mon, 10 Nov 2025 10:51:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch added to mm-new branch
Message-Id: <20251110185111.0DBBFC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: allow guard page install/remove under VMA lock
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: allow guard page install/remove under VMA lock
Date: Mon, 10 Nov 2025 17:22:58 +0000

We only need to keep the page table stable so we can perform this
operation under the VMA lock.  PTE installation is stabilised via the PTE
lock.

One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
lock.  We can account for this by adapting the VMA locking logic to
explicitly check for this case and prevent a VMA lock from being acquired
should it be the case.

This check is safe, as while we might be raced on anon_vma installation,
this would simply make the check conservative, there's no way for us to
see an anon_vma and then for it to be cleared, as doing so requires the
mmap/VMA write lock.

We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.

In order to do this we need to have a way of installing page tables
explicitly for an identified VMA, so we export walk_page_range_vma() in an
unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
read lock be taken.

We additionally update the comments in madvise_guard_install() to more
accurately reflect the cases in which the logic may be reattempted,
specifically THP huge pages being present.

Link: https://lkml.kernel.org/r/cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +
 mm/madvise.c  |  110 ++++++++++++++++++++++++++++++++++--------------
 mm/pagewalk.c |   17 +++++--
 3 files changed, 94 insertions(+), 36 deletions(-)

--- a/mm/internal.h~mm-madvise-allow-guard-page-install-remove-under-vma-lock
+++ a/mm/internal.h
@@ -1655,6 +1655,9 @@ static inline void accept_page(struct pa
 int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd, void *private);
--- a/mm/madvise.c~mm-madvise-allow-guard-page-install-remove-under-vma-lock
+++ a/mm/madvise.c
@@ -1120,18 +1120,17 @@ static int guard_install_set_pte(unsigne
 	return 0;
 }
 
-static const struct mm_walk_ops guard_install_walk_ops = {
-	.pud_entry		= guard_install_pud_entry,
-	.pmd_entry		= guard_install_pmd_entry,
-	.pte_entry		= guard_install_pte_entry,
-	.install_pte		= guard_install_set_pte,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops walk_ops = {
+		.pud_entry	= guard_install_pud_entry,
+		.pmd_entry	= guard_install_pmd_entry,
+		.pte_entry	= guard_install_pte_entry,
+		.install_pte	= guard_install_set_pte,
+		.walk_lock	= get_walk_lock(madv_behavior->lock_mode),
+	};
 	long err;
 	int i;
 
@@ -1148,8 +1147,14 @@ static long madvise_guard_install(struct
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
 	 * have an anon_vma associated with it.
+	 *
+	 * We will hold an mmap read lock if this is necessary, this is checked
+	 * as part of the VMA lock logic.
 	 */
 	if (vma_is_anonymous(vma)) {
+		VM_WARN_ON_ONCE(!vma->anon_vma &&
+				madv_behavior->lock_mode != MADVISE_MMAP_READ_LOCK);
+
 		err = anon_vma_prepare(vma);
 		if (err)
 			return err;
@@ -1157,12 +1162,14 @@ static long madvise_guard_install(struct
 
 	/*
 	 * Optimistically try to install the guard marker pages first. If any
-	 * non-guard pages are encountered, give up and zap the range before
-	 * trying again.
+	 * non-guard pages or THP huge pages are encountered, give up and zap
+	 * the range before trying again.
 	 *
 	 * We try a few times before giving up and releasing back to userland to
-	 * loop around, releasing locks in the process to avoid contention. This
-	 * would only happen if there was a great many racing page faults.
+	 * loop around, releasing locks in the process to avoid contention.
+	 *
+	 * This would only happen due to races with e.g. page faults or
+	 * khugepaged.
 	 *
 	 * In most cases we should simply install the guard markers immediately
 	 * with no zap or looping.
@@ -1171,8 +1178,13 @@ static long madvise_guard_install(struct
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
-				range->end, &guard_install_walk_ops, &nr_pages);
+		if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK)
+			err = walk_page_range_vma_unsafe(madv_behavior->vma,
+					range->start, range->end, &walk_ops,
+					&nr_pages);
+		else
+			err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+					range->end, &walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
 
@@ -1193,8 +1205,7 @@ static long madvise_guard_install(struct
 	}
 
 	/*
-	 * We were unable to install the guard pages due to being raced by page
-	 * faults. This should not happen ordinarily. We return to userspace and
+	 * We were unable to install the guard pages, return to userspace and
 	 * immediately retry, relieving lock contention.
 	 */
 	return restart_syscall();
@@ -1238,17 +1249,16 @@ static int guard_remove_pte_entry(pte_t
 	return 0;
 }
 
-static const struct mm_walk_ops guard_remove_walk_ops = {
-	.pud_entry		= guard_remove_pud_entry,
-	.pmd_entry		= guard_remove_pmd_entry,
-	.pte_entry		= guard_remove_pte_entry,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops wallk_ops = {
+		.pud_entry = guard_remove_pud_entry,
+		.pmd_entry = guard_remove_pmd_entry,
+		.pte_entry = guard_remove_pte_entry,
+		.walk_lock = get_walk_lock(madv_behavior->lock_mode),
+	};
 
 	/*
 	 * We're ok with removing guards in mlock()'d ranges, as this is a
@@ -1258,7 +1268,7 @@ static long madvise_guard_remove(struct
 		return -EINVAL;
 
 	return walk_page_range_vma(vma, range->start, range->end,
-			       &guard_remove_walk_ops, NULL);
+				   &wallk_ops, NULL);
 }
 
 #ifdef CONFIG_64BIT
@@ -1571,6 +1581,47 @@ static bool process_madvise_remote_valid
 	}
 }
 
+/* Does this operation invoke anon_vma_prepare()? */
+static bool prepares_anon_vma(int behavior)
+{
+	switch (behavior) {
+	case MADV_GUARD_INSTALL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * We have acquired a VMA read lock, is the VMA valid to be madvise'd under VMA
+ * read lock only now we have a VMA to examine?
+ */
+static bool is_vma_lock_sufficient(struct vm_area_struct *vma,
+		struct madvise_behavior *madv_behavior)
+{
+	/* Must span only a single VMA.*/
+	if (madv_behavior->range.end > vma->vm_end)
+		return false;
+	/* Remote processes unsupported. */
+	if (current->mm != vma->vm_mm)
+		return false;
+	/* Userfaultfd unsupported. */
+	if (userfaultfd_armed(vma))
+		return false;
+	/*
+	 * anon_vma_prepare() explicitly requires an mmap lock for
+	 * serialisation, so we cannot use a VMA lock in this case.
+	 *
+	 * Note we might race with anon_vma being set, however this makes this
+	 * check overly paranoid which is safe.
+	 */
+	if (vma_is_anonymous(vma) &&
+	    prepares_anon_vma(madv_behavior->behavior) && !vma->anon_vma)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to acquire a VMA read lock if possible.
  *
@@ -1592,15 +1643,12 @@ static bool try_vma_read_lock(struct mad
 	vma = lock_vma_under_rcu(mm, madv_behavior->range.start);
 	if (!vma)
 		goto take_mmap_read_lock;
-	/*
-	 * Must span only a single VMA; uffd and remote processes are
-	 * unsupported.
-	 */
-	if (madv_behavior->range.end > vma->vm_end || current->mm != mm ||
-	    userfaultfd_armed(vma)) {
+
+	if (!is_vma_lock_sufficient(vma, madv_behavior)) {
 		vma_end_read(vma);
 		goto take_mmap_read_lock;
 	}
+
 	madv_behavior->vma = vma;
 	return true;
 
@@ -1713,9 +1761,9 @@ static enum madvise_lock_mode get_lock_m
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
+		return MADVISE_MMAP_READ_LOCK;
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
-		return MADVISE_MMAP_READ_LOCK;
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
--- a/mm/pagewalk.c~mm-madvise-allow-guard-page-install-remove-under-vma-lock
+++ a/mm/pagewalk.c
@@ -694,9 +694,8 @@ int walk_page_range_debug(struct mm_stru
 	return walk_pgd_range(start, end, &walk);
 }
 
-int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, const struct mm_walk_ops *ops,
-			void *private)
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops, void *private)
 {
 	struct mm_walk walk = {
 		.ops		= ops,
@@ -709,14 +708,22 @@ int walk_page_range_vma(struct vm_area_s
 		return -EINVAL;
 	if (start < vma->vm_start || end > vma->vm_end)
 		return -EINVAL;
-	if (!check_ops_safe(ops))
-		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
 	process_vma_walk_lock(vma, ops->walk_lock);
 	return __walk_page_range(start, end, &walk);
 }
 
+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	if (!check_ops_safe(ops))
+		return -EINVAL;
+
+	return walk_page_range_vma_unsafe(vma, start, end, ops, private);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
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
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch

