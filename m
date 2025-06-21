Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6ED20F07C
	for <mm-commits@vger.kernel.org>; Sat, 21 Jun 2025 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750532720; cv=none; b=RMDLR1vGewsWIkGvVn+lMZU7AtDIPbO7F1rtwc5+pRqCRbPjR+7SseSF+hX9xeA+wYq3SwRiIQ/jfPPkxmsSaRWopYV2fL8WfBJR/35VFQiOt1ShTGpkD1ZlF96b0Of8gUvLQaIqhtTXizP3CMtLqn6NpQt/0HPuZiKkxqWRtW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750532720; c=relaxed/simple;
	bh=rGLpHTwon0iSysRFJVAZfOCKZpF/1iMff6S6DsnW3bw=;
	h=Date:To:From:Subject:Message-Id; b=tnxhB9Sn2AAEZgdcKCqP5/qDeywVGLwcypIcGI8BDLrhb4s4b8PRXawlWK1AdMD3hkW8CU7vpgNSFW1gqAZOy7xk/h56LnjnhAD28zVFrGZN3yIVPrS51f7oZL7Vzmu3aFbuLx/TrcBSEYVn3GRkBXmJOBzbu0osxibxxD20VCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=scH9T7ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="scH9T7ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39130C4CEEE;
	Sat, 21 Jun 2025 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750532719;
	bh=rGLpHTwon0iSysRFJVAZfOCKZpF/1iMff6S6DsnW3bw=;
	h=Date:To:From:Subject:From;
	b=scH9T7eiQ58PAg5tGscXdx34ApucDQ2eypijcMVxZoAGdaoPQyiCnBGCdZwe3pZO7
	 GVaH1CnUe4JEV6ZBaRF8iO9YsXoxQdCMsbN6CHwUAXYmZcjkXZX4IsVW6NB4MaT1Qq
	 ljHilXLePDPyMcIPI25pmR5RHI4ACYSfAgPQ6SiQ=
Date: Sat, 21 Jun 2025 12:05:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-thread-mm_struct-through-madvise_behavior.patch added to mm-new branch
Message-Id: <20250621190519.39130C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: thread mm_struct through madvise_behavior
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-thread-mm_struct-through-madvise_behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-thread-mm_struct-through-madvise_behavior.patch

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
Subject: mm/madvise: thread mm_struct through madvise_behavior
Date: Fri, 20 Jun 2025 16:33:02 +0100

There's no need to thread a pointer to the mm_struct nor have different
functions signatures for each behaviour, instead store state in the struct
madvise_behavior object consistently and use it for all madvise() actions.

Link: https://lkml.kernel.org/r/a47d850b0111735e026d438c3300c0e3b7f439f4.1750433500.git.lorenzo.stoakes@oracle.com
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

 mm/madvise.c |  110 +++++++++++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 53 deletions(-)

--- a/mm/madvise.c~mm-madvise-thread-mm_struct-through-madvise_behavior
+++ a/mm/madvise.c
@@ -58,6 +58,7 @@ enum madvise_lock_mode {
 };
 
 struct madvise_behavior {
+	struct mm_struct *mm;
 	int behavior;
 	struct mmu_gather *tlb;
 	enum madvise_lock_mode lock_mode;
@@ -65,8 +66,8 @@ struct madvise_behavior {
 };
 
 #ifdef CONFIG_ANON_VMA_NAME
-static int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
-		unsigned long end, struct madvise_behavior *madv_behavior);
+static int madvise_walk_vmas(unsigned long start, unsigned long end,
+		struct madvise_behavior *madv_behavior);
 
 struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
@@ -125,6 +126,7 @@ int madvise_set_anon_name(struct mm_stru
 	unsigned long end;
 	unsigned long len;
 	struct madvise_behavior madv_behavior = {
+		.mm = mm,
 		.behavior = __MADV_SET_ANON_VMA_NAME,
 		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
 		.anon_name = anon_name,
@@ -145,7 +147,7 @@ int madvise_set_anon_name(struct mm_stru
 	if (end == start)
 		return 0;
 
-	return madvise_walk_vmas(mm, start, end, &madv_behavior);
+	return madvise_walk_vmas(start, end, &madv_behavior);
 }
 #else /* CONFIG_ANON_VMA_NAME */
 static int replace_anon_vma_name(struct vm_area_struct *vma,
@@ -991,10 +993,11 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 }
 
-static long madvise_populate(struct mm_struct *mm, unsigned long start,
-		unsigned long end, int behavior)
+static long madvise_populate(unsigned long start, unsigned long end,
+		struct madvise_behavior *madv_behavior)
 {
-	const bool write = behavior == MADV_POPULATE_WRITE;
+	struct mm_struct *mm = madv_behavior->mm;
+	const bool write = madv_behavior->behavior == MADV_POPULATE_WRITE;
 	int locked = 1;
 	long pages;
 
@@ -1408,15 +1411,14 @@ out:
 /*
  * Error injection support for memory error handling.
  */
-static int madvise_inject_error(int behavior,
-		unsigned long start, unsigned long end)
+static int madvise_inject_error(unsigned long start, unsigned long end,
+		struct madvise_behavior *madv_behavior)
 {
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-
 	for (; start < end; start += size) {
 		unsigned long pfn;
 		struct page *page;
@@ -1434,7 +1436,7 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
-		if (behavior == MADV_SOFT_OFFLINE) {
+		if (madv_behavior->behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
 			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
@@ -1453,9 +1455,9 @@ static int madvise_inject_error(int beha
 	return 0;
 }
 
-static bool is_memory_failure(int behavior)
+static bool is_memory_failure(struct madvise_behavior *madv_behavior)
 {
-	switch (behavior) {
+	switch (madv_behavior->behavior) {
 	case MADV_HWPOISON:
 	case MADV_SOFT_OFFLINE:
 		return true;
@@ -1466,13 +1468,13 @@ static bool is_memory_failure(int behavi
 
 #else
 
-static int madvise_inject_error(int behavior,
-		unsigned long start, unsigned long end)
+static int madvise_inject_error(unsigned long start, unsigned long end,
+		struct madvise_behavior *madv_behavior)
 {
 	return 0;
 }
 
-static bool is_memory_failure(int behavior)
+static bool is_memory_failure(struct madvise_behavior *madv_behavior)
 {
 	return false;
 }
@@ -1549,10 +1551,11 @@ static bool process_madvise_remote_valid
  * If a VMA read lock could not be acquired, we return NULL and expect caller to
  * fallback to mmap lock behaviour.
  */
-static struct vm_area_struct *try_vma_read_lock(struct mm_struct *mm,
+static struct vm_area_struct *try_vma_read_lock(
 		struct madvise_behavior *madv_behavior,
 		unsigned long start, unsigned long end)
 {
+	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma;
 
 	vma = lock_vma_under_rcu(mm, start);
@@ -1585,9 +1588,10 @@ take_mmap_read_lock:
  * reading or writing.
  */
 static
-int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
-		      unsigned long end, struct madvise_behavior *madv_behavior)
+int madvise_walk_vmas(unsigned long start, unsigned long end,
+		      struct madvise_behavior *madv_behavior)
 {
+	struct mm_struct *mm = madv_behavior->mm;
 	struct vm_area_struct *vma;
 	struct vm_area_struct *prev;
 	unsigned long tmp;
@@ -1599,7 +1603,7 @@ int madvise_walk_vmas(struct mm_struct *
 	 * tentatively, avoiding walking VMAs.
 	 */
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
-		vma = try_vma_read_lock(mm, madv_behavior, start, end);
+		vma = try_vma_read_lock(madv_behavior, start, end);
 		if (vma) {
 			prev = vma;
 			error = madvise_vma_behavior(vma, &prev, start, end,
@@ -1662,12 +1666,10 @@ int madvise_walk_vmas(struct mm_struct *
  */
 static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
 {
-	int behavior = madv_behavior->behavior;
-
-	if (is_memory_failure(behavior))
+	if (is_memory_failure(madv_behavior))
 		return MADVISE_NO_LOCK;
 
-	switch (behavior) {
+	switch (madv_behavior->behavior) {
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_COLD:
@@ -1687,9 +1689,9 @@ static enum madvise_lock_mode get_lock_m
 	}
 }
 
-static int madvise_lock(struct mm_struct *mm,
-		struct madvise_behavior *madv_behavior)
+static int madvise_lock(struct madvise_behavior *madv_behavior)
 {
+	struct mm_struct *mm = madv_behavior->mm;
 	enum madvise_lock_mode lock_mode = get_lock_mode(madv_behavior);
 
 	switch (lock_mode) {
@@ -1711,9 +1713,10 @@ static int madvise_lock(struct mm_struct
 	return 0;
 }
 
-static void madvise_unlock(struct mm_struct *mm,
-		struct madvise_behavior *madv_behavior)
+static void madvise_unlock(struct madvise_behavior *madv_behavior)
 {
+	struct mm_struct *mm = madv_behavior->mm;
+
 	switch (madv_behavior->lock_mode) {
 	case  MADVISE_NO_LOCK:
 		return;
@@ -1743,11 +1746,10 @@ static bool madvise_batch_tlb_flush(int
 	}
 }
 
-static void madvise_init_tlb(struct madvise_behavior *madv_behavior,
-		struct mm_struct *mm)
+static void madvise_init_tlb(struct madvise_behavior *madv_behavior)
 {
 	if (madvise_batch_tlb_flush(madv_behavior->behavior))
-		tlb_gather_mmu(madv_behavior->tlb, mm);
+		tlb_gather_mmu(madv_behavior->tlb, madv_behavior->mm);
 }
 
 static void madvise_finish_tlb(struct madvise_behavior *madv_behavior)
@@ -1802,9 +1804,9 @@ static bool madvise_should_skip(unsigned
 	return false;
 }
 
-static bool is_madvise_populate(int behavior)
+static bool is_madvise_populate(struct madvise_behavior *madv_behavior)
 {
-	switch (behavior) {
+	switch (madv_behavior->behavior) {
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 		return true;
@@ -1828,25 +1830,26 @@ static inline unsigned long get_untagged
 				   untagged_addr_remote(mm, start);
 }
 
-static int madvise_do_behavior(struct mm_struct *mm,
-		unsigned long start, size_t len_in,
+static int madvise_do_behavior(unsigned long start, size_t len_in,
 		struct madvise_behavior *madv_behavior)
 {
-	int behavior = madv_behavior->behavior;
 	struct blk_plug plug;
 	unsigned long end;
 	int error;
 
-	if (is_memory_failure(behavior))
-		return madvise_inject_error(behavior, start, start + len_in);
-	start = get_untagged_addr(mm, start);
+	if (is_memory_failure(madv_behavior)) {
+		end = start + len_in;
+		return madvise_inject_error(start, end, madv_behavior);
+	}
+
+	start = get_untagged_addr(madv_behavior->mm, start);
 	end = start + PAGE_ALIGN(len_in);
 
 	blk_start_plug(&plug);
-	if (is_madvise_populate(behavior))
-		error = madvise_populate(mm, start, end, behavior);
+	if (is_madvise_populate(madv_behavior))
+		error = madvise_populate(start, end, madv_behavior);
 	else
-		error = madvise_walk_vmas(mm, start, end, madv_behavior);
+		error = madvise_walk_vmas(start, end, madv_behavior);
 	blk_finish_plug(&plug);
 	return error;
 }
@@ -1928,19 +1931,20 @@ int do_madvise(struct mm_struct *mm, uns
 	int error;
 	struct mmu_gather tlb;
 	struct madvise_behavior madv_behavior = {
+		.mm = mm,
 		.behavior = behavior,
 		.tlb = &tlb,
 	};
 
 	if (madvise_should_skip(start, len_in, behavior, &error))
 		return error;
-	error = madvise_lock(mm, &madv_behavior);
+	error = madvise_lock(&madv_behavior);
 	if (error)
 		return error;
-	madvise_init_tlb(&madv_behavior, mm);
-	error = madvise_do_behavior(mm, start, len_in, &madv_behavior);
+	madvise_init_tlb(&madv_behavior);
+	error = madvise_do_behavior(start, len_in, &madv_behavior);
 	madvise_finish_tlb(&madv_behavior);
-	madvise_unlock(mm, &madv_behavior);
+	madvise_unlock(&madv_behavior);
 
 	return error;
 }
@@ -1958,16 +1962,17 @@ static ssize_t vector_madvise(struct mm_
 	size_t total_len;
 	struct mmu_gather tlb;
 	struct madvise_behavior madv_behavior = {
+		.mm = mm,
 		.behavior = behavior,
 		.tlb = &tlb,
 	};
 
 	total_len = iov_iter_count(iter);
 
-	ret = madvise_lock(mm, &madv_behavior);
+	ret = madvise_lock(&madv_behavior);
 	if (ret)
 		return ret;
-	madvise_init_tlb(&madv_behavior, mm);
+	madvise_init_tlb(&madv_behavior);
 
 	while (iov_iter_count(iter)) {
 		unsigned long start = (unsigned long)iter_iov_addr(iter);
@@ -1977,8 +1982,7 @@ static ssize_t vector_madvise(struct mm_
 		if (madvise_should_skip(start, len_in, behavior, &error))
 			ret = error;
 		else
-			ret = madvise_do_behavior(mm, start, len_in,
-					&madv_behavior);
+			ret = madvise_do_behavior(start, len_in, &madv_behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
@@ -1997,11 +2001,11 @@ static ssize_t vector_madvise(struct mm_
 
 			/* Drop and reacquire lock to unwind race. */
 			madvise_finish_tlb(&madv_behavior);
-			madvise_unlock(mm, &madv_behavior);
-			ret = madvise_lock(mm, &madv_behavior);
+			madvise_unlock(&madv_behavior);
+			ret = madvise_lock(&madv_behavior);
 			if (ret)
 				goto out;
-			madvise_init_tlb(&madv_behavior, mm);
+			madvise_init_tlb(&madv_behavior);
 			continue;
 		}
 		if (ret < 0)
@@ -2009,7 +2013,7 @@ static ssize_t vector_madvise(struct mm_
 		iov_iter_advance(iter, iter_iov_len(iter));
 	}
 	madvise_finish_tlb(&madv_behavior);
-	madvise_unlock(mm, &madv_behavior);
+	madvise_unlock(&madv_behavior);
 
 out:
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
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

