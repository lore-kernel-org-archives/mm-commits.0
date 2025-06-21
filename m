Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5C20F07C
	for <mm-commits@vger.kernel.org>; Sat, 21 Jun 2025 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750532721; cv=none; b=nx8xPpzyx+7jQ1Eh4g7KrRLbW9/VliMn5vkaj709HRv1GMvsCc/LODA+YijsZAc6PEfHiUBtvsAgml/XNAaR5j934aVK4GKrDMSI7Xw+kiFl3EV3U2+aQVcpdNqaT6qP8x6BTsec33Dq2tieOSuwdjtNH4WVllUdqWVuqhZuCP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750532721; c=relaxed/simple;
	bh=7Ta5bWj5SMoA487bPKJooRlF/3dtGijBk28BvS2tcKg=;
	h=Date:To:From:Subject:Message-Id; b=lDPxzYqj3ioPey9HuM14Mwx7gZgkkdTfR5DKfWSe4/p+Mv/kXyaYPSaX5wTuwfeGPalHlteRtNMnNaKZcoUrIS6VVkwYryqQgePkaMLfImY56jF9m3UYphSLnipKPDXnzsmkwfZILr1JNXeWeeDWkg+fiqgf30BGcAnbmHys63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULO3JM+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULO3JM+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CCCC4CEE7;
	Sat, 21 Jun 2025 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750532721;
	bh=7Ta5bWj5SMoA487bPKJooRlF/3dtGijBk28BvS2tcKg=;
	h=Date:To:From:Subject:From;
	b=ULO3JM+zIWaeL7ebZGkR/V4YXoZwESxXz6M8uFah3Fy8uJYVAD6nL7GDI1Nn7pqIX
	 rx0rZ31RUR8srI6f+kWXcKATJKmJi7W+GwtjynUgDDIifdiqXNPy2WlY4NCAb+USdb
	 BYVb/dx2QmN0EUP5Rf48/0oDksmddfFQXFxlfya4=
Date: Sat, 21 Jun 2025 12:05:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-thread-vma-range-state-through-madvise_behavior.patch added to mm-new branch
Message-Id: <20250621190521.68CCCC4CEE7@smtp.kernel.org>
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
Date: Fri, 20 Jun 2025 16:33:03 +0100

Rather than updating start and a confusing local parameter 'tmp' in
madvise_walk_vmas(), instead store the current range being operated upon
in the struct madvise_behavior helper object in a range pair and use this
consistently in all operations.

This makes it clearer what is going on and opens the door to further
cleanup now we store state regarding what is currently being operated upon
here.

Link: https://lkml.kernel.org/r/518480ceb48553d3c280bc2b0b5e77bbad840147.1750433500.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |  103 +++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 46 deletions(-)

--- a/mm/madvise.c~mm-madvise-thread-vma-range-state-through-madvise_behavior
+++ a/mm/madvise.c
@@ -57,17 +57,27 @@ enum madvise_lock_mode {
 	MADVISE_VMA_READ_LOCK,
 };
 
+struct madvise_behavior_range {
+	unsigned long start;
+	unsigned long end;
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
@@ -147,7 +157,9 @@ int madvise_set_anon_name(struct mm_stru
 	if (end == start)
 		return 0;
 
-	return madvise_walk_vmas(start, end, &madv_behavior);
+	madv_behavior.range.start = start;
+	madv_behavior.range.end = end;
+	return madvise_walk_vmas(&madv_behavior);
 }
 #else /* CONFIG_ANON_VMA_NAME */
 static int replace_anon_vma_name(struct vm_area_struct *vma,
@@ -993,12 +1005,13 @@ static long madvise_dontneed_free(struct
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
@@ -1289,12 +1302,13 @@ static long madvise_guard_remove(struct
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
 	bool set_new_anon_name = behavior == __MADV_SET_ANON_VMA_NAME;
 	int error;
 
@@ -1411,10 +1425,11 @@ out:
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
@@ -1468,8 +1483,7 @@ static bool is_memory_failure(struct mad
 
 #else
 
-static int madvise_inject_error(unsigned long start, unsigned long end,
-		struct madvise_behavior *madv_behavior)
+static int madvise_inject_error(struct madvise_behavior *madv_behavior)
 {
 	return 0;
 }
@@ -1551,21 +1565,20 @@ static bool process_madvise_remote_valid
  * If a VMA read lock could not be acquired, we return NULL and expect caller to
  * fallback to mmap lock behaviour.
  */
-static struct vm_area_struct *try_vma_read_lock(
-		struct madvise_behavior *madv_behavior,
-		unsigned long start, unsigned long end)
+static
+struct vm_area_struct *try_vma_read_lock(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
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
@@ -1588,13 +1601,14 @@ take_mmap_read_lock:
  * reading or writing.
  */
 static
-int madvise_walk_vmas(unsigned long start, unsigned long end,
-		      struct madvise_behavior *madv_behavior)
+int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	/* range is updated to span each VMA, so store end of entire range. */
+	unsigned long last_end = range->end;
 	struct vm_area_struct *vma;
 	struct vm_area_struct *prev;
-	unsigned long tmp;
 	int unmapped_error = 0;
 	int error;
 
@@ -1603,11 +1617,10 @@ int madvise_walk_vmas(unsigned long star
 	 * tentatively, avoiding walking VMAs.
 	 */
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
-		vma = try_vma_read_lock(madv_behavior, start, end);
+		vma = try_vma_read_lock(madv_behavior);
 		if (vma) {
 			prev = vma;
-			error = madvise_vma_behavior(vma, &prev, start, end,
-						     madv_behavior);
+			error = madvise_vma_behavior(vma, &prev, madv_behavior);
 			vma_end_read(vma);
 			return error;
 		}
@@ -1618,8 +1631,8 @@ int madvise_walk_vmas(unsigned long star
 	 * ranges, just ignore them, but return -ENOMEM at the end.
 	 * - different from the way of handling in mlock etc.
 	 */
-	vma = find_vma_prev(mm, start, &prev);
-	if (vma && start > vma->vm_start)
+	vma = find_vma_prev(mm, range->start, &prev);
+	if (vma && range->start > vma->vm_start)
 		prev = vma;
 
 	for (;;) {
@@ -1627,33 +1640,30 @@ int madvise_walk_vmas(unsigned long star
 		if (!vma)
 			return -ENOMEM;
 
-		/* Here start < (end|vma->vm_end). */
-		if (start < vma->vm_start) {
+		/* Here start < (last_end|vma->vm_end). */
+		if (range->start < vma->vm_start) {
 			unmapped_error = -ENOMEM;
-			start = vma->vm_start;
-			if (start >= end)
+			range->start = vma->vm_start;
+			if (range->start >= last_end)
 				break;
 		}
 
-		/* Here vma->vm_start <= start < (end|vma->vm_end) */
-		tmp = vma->vm_end;
-		if (end < tmp)
-			tmp = end;
+		/* Here vma->vm_start <= range->start < (last_end|vma->vm_end) */
+		range->end = min(vma->vm_end, last_end);
 
-		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
-		error = madvise_vma_behavior(vma, &prev, start, tmp,
-					     madv_behavior);
+		/* Here vma->vm_start <= range->start < range->end <= (last_end|vma->vm_end). */
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
+		if (range->start >= last_end)
 			break;
 		if (prev)
 			vma = find_vma(mm, prev->vm_end);
 		else	/* madvise_remove dropped mmap_lock */
-			vma = find_vma(mm, start);
+			vma = find_vma(mm, range->start);
 	}
 
 	return unmapped_error;
@@ -1834,22 +1844,23 @@ static int madvise_do_behavior(unsigned
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

