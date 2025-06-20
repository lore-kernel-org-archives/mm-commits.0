Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BDC4C79
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380680; cv=none; b=OSLKbhS1aj2uDiR6dlNwOXhClfrJRI9RC2Z688JwFICqQdJfd23S456Jk7ttbg7DjgAitSkAhOXvu63Qr3+06N8R55Fmd2xgw4wDIT1V+H6jv3eRcfltbNkhe1goGvOaiYWD0dFWfbHh5uTePynZlRoyfPXKLrPcSU2JB/2gXQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380680; c=relaxed/simple;
	bh=INq01GHsGTTzNwhcUEzhVNusOAQ0wRxyPwmws/dNsE8=;
	h=Date:To:From:Subject:Message-Id; b=iuMwdZ6tffW3jlr6OMPzsbiwd9B2gMBWnNZN4Yju1+nGO4voBI9XI7UCr+pcCFBsKMJ4suDVxV6cVuecp0NHNyBEpLNRqUPuUPZYMeuOn7UopepXvi6r1/gFkdankpqK6i/DbgAi1F4YjeOd2dL2R1sGHKHqGcAdFu6YSqdw2k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2rA3kxdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2rA3kxdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1728CC4CEEA;
	Fri, 20 Jun 2025 00:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380680;
	bh=INq01GHsGTTzNwhcUEzhVNusOAQ0wRxyPwmws/dNsE8=;
	h=Date:To:From:Subject:From;
	b=2rA3kxdTliOVj6mX4t+35tYa1juKLlDkcxy56bpiIdMk4Q4je6k1SlE3ylNwOcTz6
	 NoJllZD0qDzB4v3EmSchecKXo9N3aGOPz9pdcO/aRBWp6BX/61zRbF6SNjx4lopNVg
	 6PvQDbAUFdwAYRmN4Xa8oTNRXmubovIidYFoHipo=
Date: Thu, 19 Jun 2025 17:51:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-thread-vma-range-state-through-madvise_behavior.patch added to mm-new branch
Message-Id: <20250620005120.1728CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: thread VMA range state through madvise_behavior
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-thread-vma-range-state-through-madvise_behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-thread-vma-range-state-through-madvise_behavior.patch

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
Subject: mm/madvise: thread VMA range state through madvise_behavior
Date: Thu, 19 Jun 2025 21:26:28 +0100

Rather than updating start and a confusing local parameter 'tmp' in
madvise_walk_vmas(), instead store the current range being operated upon
in the struct madvise_behavior helper object in a range pair and use this
consistently in all operations.

This makes it clearer what is going on and opens the door to further
cleanup now we store state regarding what is currently being operated upon
here.

Link: https://lkml.kernel.org/r/a520417243ce7f8122de05a0420f964a922e392a.1750363557.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |  101 ++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 46 deletions(-)

--- a/mm/madvise.c~mm-madvise-thread-vma-range-state-through-madvise_behavior
+++ a/mm/madvise.c
@@ -58,17 +58,26 @@ enum madvise_lock_mode {
 	MADVISE_VMA_READ_LOCK,
 };
 
+struct madvise_behavior_range {
+	unsigned long start, end;
+};
+
 struct madvise_behavior {
 	struct mm_struct *mm;
 	int behavior;
 	struct mmu_gather *tlb;
 	enum madvise_lock_mode lock_mode;
 	struct anon_vma_name *anon_name;
+
+	/*
+	 * The range over which the behaviour is currently being applied. If
+	 * traversing multiple VMAs, this is updated for each.
+	 */
+	struct madvise_behavior_range range;
 };
 
 #ifdef CONFIG_ANON_VMA_NAME
-static int madvise_walk_vmas(unsigned long start, unsigned long end,
-		struct madvise_behavior *madv_behavior);
+static int madvise_walk_vmas(struct madvise_behavior *madv_behavior);
 
 struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
@@ -149,8 +158,9 @@ int madvise_set_anon_name(struct mm_stru
 
 	madv_behavior.behavior =
 		anon_name ? __MADV_SET_ANON_VMA_NAME : __MADV_CLEAR_ANON_VMA_NAME;
-
-	return madvise_walk_vmas(start, end, &madv_behavior);
+	madv_behavior.range.start = start;
+	madv_behavior.range.end = end;
+	return madvise_walk_vmas(&madv_behavior);
 }
 
 static bool is_anon_vma_name(int behavior)
@@ -1012,12 +1022,13 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 }
 
-static long madvise_populate(unsigned long start, unsigned long end,
-		struct madvise_behavior *madv_behavior)
+static long madvise_populate(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
 	const bool write = madv_behavior->behavior == MADV_POPULATE_WRITE;
 	int locked = 1;
+	unsigned long start = madv_behavior->range.start;
+	unsigned long end = madv_behavior->range.end;
 	long pages;
 
 	while (start < end) {
@@ -1308,12 +1319,13 @@ static long madvise_guard_remove(struct
  */
 static int madvise_vma_behavior(struct vm_area_struct *vma,
 				struct vm_area_struct **prev,
-				unsigned long start, unsigned long end,
 				struct madvise_behavior *madv_behavior)
 {
 	int behavior = madv_behavior->behavior;
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	vm_flags_t new_flags = vma->vm_flags;
+	unsigned long start = madv_behavior->range.start;
+	unsigned long end = madv_behavior->range.end;
 	int error;
 
 	if (unlikely(!can_modify_vma_madv(vma, behavior)))
@@ -1425,10 +1437,11 @@ out:
 /*
  * Error injection support for memory error handling.
  */
-static int madvise_inject_error(unsigned long start, unsigned long end,
-		struct madvise_behavior *madv_behavior)
+static int madvise_inject_error(struct madvise_behavior *madv_behavior)
 {
 	unsigned long size;
+	unsigned long start = madv_behavior->range.start;
+	unsigned long end = madv_behavior->range.end;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1482,8 +1495,7 @@ static bool is_memory_failure(struct mad
 
 #else
 
-static int madvise_inject_error(unsigned long start, unsigned long end,
-		struct madvise_behavior *madv_behavior)
+static int madvise_inject_error(struct madvise_behavior *madv_behavior)
 {
 	return 0;
 }
@@ -1565,20 +1577,20 @@ static bool process_madvise_remote_valid
  * If a VMA read lock could not be acquired, we return NULL and expect caller to
  * fallback to mmap lock behaviour.
  */
-static struct vm_area_struct *try_vma_read_lock(struct mm_struct *mm,
-		struct madvise_behavior *madv_behavior,
-		unsigned long start, unsigned long end)
+static
+struct vm_area_struct *try_vma_read_lock(struct madvise_behavior *madv_behavior)
 {
+	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma;
 
-	vma = lock_vma_under_rcu(mm, start);
+	vma = lock_vma_under_rcu(mm, madv_behavior->range.start);
 	if (!vma)
 		goto take_mmap_read_lock;
 	/*
 	 * Must span only a single VMA; uffd and remote processes are
 	 * unsupported.
 	 */
-	if (end > vma->vm_end || current->mm != mm ||
+	if (madv_behavior->range.end > vma->vm_end || current->mm != mm ||
 	    userfaultfd_armed(vma)) {
 		vma_end_read(vma);
 		goto take_mmap_read_lock;
@@ -1600,13 +1612,13 @@ take_mmap_read_lock:
  * Must be called with the mmap_lock held for reading or writing.
  */
 static
-int madvise_walk_vmas(unsigned long start, unsigned long end,
-		      struct madvise_behavior *madv_behavior)
+int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	unsigned long end = range->end;
 	struct vm_area_struct *vma;
 	struct vm_area_struct *prev;
-	unsigned long tmp;
 	int unmapped_error = 0;
 	int error;
 
@@ -1615,11 +1627,10 @@ int madvise_walk_vmas(unsigned long star
 	 * tentatively, avoiding walking VMAs.
 	 */
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
-		vma = try_vma_read_lock(mm, madv_behavior, start, end);
+		vma = try_vma_read_lock(madv_behavior);
 		if (vma) {
 			prev = vma;
-			error = madvise_vma_behavior(vma, &prev, start, end,
-						     madv_behavior);
+			error = madvise_vma_behavior(vma, &prev, madv_behavior);
 			vma_end_read(vma);
 			return error;
 		}
@@ -1630,8 +1641,8 @@ int madvise_walk_vmas(unsigned long star
 	 * ranges, just ignore them, but return -ENOMEM at the end.
 	 * - different from the way of handling in mlock etc.
 	 */
-	vma = find_vma_prev(mm, start, &prev);
-	if (vma && start > vma->vm_start)
+	vma = find_vma_prev(mm, range->start, &prev);
+	if (vma && range->start > vma->vm_start)
 		prev = vma;
 
 	for (;;) {
@@ -1640,32 +1651,29 @@ int madvise_walk_vmas(unsigned long star
 			return -ENOMEM;
 
 		/* Here start < (end|vma->vm_end). */
-		if (start < vma->vm_start) {
+		if (range->start < vma->vm_start) {
 			unmapped_error = -ENOMEM;
-			start = vma->vm_start;
-			if (start >= end)
+			range->start = vma->vm_start;
+			if (range->start >= end)
 				break;
 		}
 
-		/* Here vma->vm_start <= start < (end|vma->vm_end) */
-		tmp = vma->vm_end;
-		if (end < tmp)
-			tmp = end;
+		/* Here vma->vm_start <= range->start < (end|vma->vm_end) */
+		range->end = min(vma->vm_end, end);
 
-		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
-		error = madvise_vma_behavior(vma, &prev, start, tmp,
-					     madv_behavior);
+		/* Here vma->vm_start <= range->start < range->end <= (end|vma->vm_end). */
+		error = madvise_vma_behavior(vma, &prev, madv_behavior);
 		if (error)
 			return error;
-		start = tmp;
-		if (prev && start < prev->vm_end)
-			start = prev->vm_end;
-		if (start >= end)
+		range->start = range->end;
+		if (prev && range->start < prev->vm_end)
+			range->start = prev->vm_end;
+		if (range->start >= range->end)
 			break;
 		if (prev)
 			vma = find_vma(mm, prev->vm_end);
 		else	/* madvise_remove dropped mmap_lock */
-			vma = find_vma(mm, start);
+			vma = find_vma(mm, range->start);
 	}
 
 	return unmapped_error;
@@ -1846,22 +1854,23 @@ static int madvise_do_behavior(unsigned
 		struct madvise_behavior *madv_behavior)
 {
 	struct blk_plug plug;
-	unsigned long end;
 	int error;
+	struct madvise_behavior_range *range = &madv_behavior->range;
 
 	if (is_memory_failure(madv_behavior)) {
-		end = start + len_in;
-		return madvise_inject_error(start, end, madv_behavior);
+		range->start = start;
+		range->end = start + len_in;
+		return madvise_inject_error(madv_behavior);
 	}
 
-	start = get_untagged_addr(madv_behavior->mm, start);
-	end = start + PAGE_ALIGN(len_in);
+	range->start = get_untagged_addr(madv_behavior->mm, start);
+	range->end = range->start + PAGE_ALIGN(len_in);
 
 	blk_start_plug(&plug);
 	if (is_madvise_populate(madv_behavior))
-		error = madvise_populate(start, end, madv_behavior);
+		error = madvise_populate(madv_behavior);
 	else
-		error = madvise_walk_vmas(start, end, madv_behavior);
+		error = madvise_walk_vmas(madv_behavior);
 	blk_finish_plug(&plug);
 	return error;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

