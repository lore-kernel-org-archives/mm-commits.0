Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80C12877D2
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542463; cv=none; b=o5dpOOzWwqV8P/U9UcgN4ihksuvv3J2DmeOq8nM4r6yLn2cJq/Rf8R542ROufsaaYERu0GtKFWYtWU2jX1njX3ecDLazClTeL6EGoBevKt78nQQNu0Fgam38jVY+drNKuO3F8J1my13XtCa+YLbNC09gReAXd8Zd5JcIDaJiZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542463; c=relaxed/simple;
	bh=2N8u5hojebU1LZtvXybopP+O+IMqEmf29NqyBbQwfDY=;
	h=Date:To:From:Subject:Message-Id; b=OkjY95kfG29dkczW6IwFxNfBRWivfqcFH7faxOGv8tJ485qs1V8KWlNBsY3M00WXufWCB4SSLBMX7qvIg2dFQ/lR1nQIUvQC1oXqyTOmu6CSGWHhecjdO2g/7yTLGxJnm1phXsAcqL66hUqfuj0bP1y/qV7GixTtF0h8SqC2OcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gxGMIruc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gxGMIruc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D09C4CEF8;
	Fri,  7 Nov 2025 19:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762542463;
	bh=2N8u5hojebU1LZtvXybopP+O+IMqEmf29NqyBbQwfDY=;
	h=Date:To:From:Subject:From;
	b=gxGMIrucEk5KkI/LXk7UBso0xX7x+lmoF02a+9/lT6htNLjfqgCYFZni8A2Z/7rmC
	 oBSpP5JaB/LDJo79aLsX5ATkoMAG0v1RHxUsDKrwUZo/8eBJCBp1I9qmvxtNZN1QTw
	 b95NpUXdAGhZQTVXM1ETStzH7U3/zhIFYd4wXQDs=
Date: Fri, 07 Nov 2025 11:07:43 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-add-vma-sticky-userland-tests.patch added to mm-new branch
Message-Id: <20251107190743.96D09C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add VMA sticky userland tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-add-vma-sticky-userland-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-add-vma-sticky-userland-tests.patch

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
Subject: tools/testing/vma: add VMA sticky userland tests
Date: Fri, 7 Nov 2025 16:11:51 +0000

Modify existing merge new/existing userland VMA tests to assert that
sticky VMA flags behave as expected.

We do so by generating every possible permutation of VMAs being
manipulated being sticky/not sticky and asserting that VMA flags with this
property retain are retained upon merge.

Link: https://lkml.kernel.org/r/cea1bd69624a67811de4252941ac615801d7bf19.1762531708.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma.c |   89 +++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 10 deletions(-)

--- a/tools/testing/vma/vma.c~tools-testing-vma-add-vma-sticky-userland-tests
+++ a/tools/testing/vma/vma.c
@@ -48,6 +48,8 @@ static struct anon_vma dummy_anon_vma;
 #define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
 #define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
 
+#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
+
 static struct task_struct __current;
 
 struct task_struct *get_current(void)
@@ -441,7 +443,7 @@ static bool test_simple_shrink(void)
 	return true;
 }
 
-static bool test_merge_new(void)
+static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky, bool c_is_sticky)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
 	struct mm_struct mm = {};
@@ -469,23 +471,32 @@ static bool test_merge_new(void)
 	struct vm_area_struct *vma, *vma_a, *vma_b, *vma_c, *vma_d;
 	bool merged;
 
+	if (is_sticky)
+		vm_flags |= VM_STICKY;
+
 	/*
 	 * 0123456789abc
 	 * AA B       CC
 	 */
 	vma_a = alloc_and_link_vma(&mm, 0, 0x2000, 0, vm_flags);
 	ASSERT_NE(vma_a, NULL);
+	if (a_is_sticky)
+		vm_flags_set(vma_a, VM_STICKY);
 	/* We give each VMA a single avc so we can test anon_vma duplication. */
 	INIT_LIST_HEAD(&vma_a->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_a.same_vma, &vma_a->anon_vma_chain);
 
 	vma_b = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vm_flags);
 	ASSERT_NE(vma_b, NULL);
+	if (b_is_sticky)
+		vm_flags_set(vma_b, VM_STICKY);
 	INIT_LIST_HEAD(&vma_b->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_b.same_vma, &vma_b->anon_vma_chain);
 
 	vma_c = alloc_and_link_vma(&mm, 0xb000, 0xc000, 0xb, vm_flags);
 	ASSERT_NE(vma_c, NULL);
+	if (c_is_sticky)
+		vm_flags_set(vma_c, VM_STICKY);
 	INIT_LIST_HEAD(&vma_c->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_c.same_vma, &vma_c->anon_vma_chain);
 
@@ -520,6 +531,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky || a_is_sticky || b_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to PREVIOUS VMA.
@@ -537,6 +550,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky || a_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to NEXT VMA.
@@ -556,6 +571,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
+	if (is_sticky) /* D uses is_sticky. */
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge BOTH sides.
@@ -574,6 +591,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (is_sticky || a_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge to NEXT VMA.
@@ -592,6 +611,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (is_sticky || c_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Merge BOTH sides.
@@ -609,6 +630,8 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
+	if (is_sticky || a_is_sticky || c_is_sticky)
+		ASSERT_TRUE(IS_SET(vma->vm_flags, VM_STICKY));
 
 	/*
 	 * Final state.
@@ -637,6 +660,20 @@ static bool test_merge_new(void)
 	return true;
 }
 
+static bool test_merge_new(void)
+{
+	int i, j, k, l;
+
+	/* Generate every possible permutation of sticky flags. */
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			for (k = 0; k < 2; k++)
+				for (l = 0; l < 2; l++)
+					ASSERT_TRUE(__test_merge_new(i, j, k, l));
+
+	return true;
+}
+
 static bool test_vma_merge_special_flags(void)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
@@ -973,9 +1010,11 @@ static bool test_vma_merge_new_with_clos
 	return true;
 }
 
-static bool test_merge_existing(void)
+static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bool next_is_sticky)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
+	vm_flags_t prev_flags = vm_flags;
+	vm_flags_t next_flags = vm_flags;
 	struct mm_struct mm = {};
 	VMA_ITERATOR(vmi, &mm, 0);
 	struct vm_area_struct *vma, *vma_prev, *vma_next;
@@ -988,6 +1027,13 @@ static bool test_merge_existing(void)
 	};
 	struct anon_vma_chain avc = {};
 
+	if (prev_is_sticky)
+		prev_flags |= VM_STICKY;
+	if (middle_is_sticky)
+		vm_flags |= VM_STICKY;
+	if (next_is_sticky)
+		next_flags |= VM_STICKY;
+
 	/*
 	 * Merge right case - partial span.
 	 *
@@ -1000,7 +1046,7 @@ static bool test_merge_existing(void)
 	 */
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x6000, 2, vm_flags);
 	vma->vm_ops = &vm_ops; /* This should have no impact. */
-	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, next_flags);
 	vma_next->vm_ops = &vm_ops; /* This should have no impact. */
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x6000, 3, vm_flags, &dummy_anon_vma);
 	vmg.middle = vma;
@@ -1018,6 +1064,8 @@ static bool test_merge_existing(void)
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
+	if (middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_next->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1033,7 +1081,7 @@ static bool test_merge_existing(void)
 	 *   NNNNNNN
 	 */
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x6000, 2, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x9000, 6, next_flags);
 	vma_next->vm_ops = &vm_ops; /* This should have no impact. */
 	vmg_set_range_anon_vma(&vmg, 0x2000, 0x6000, 2, vm_flags, &dummy_anon_vma);
 	vmg.middle = vma;
@@ -1046,6 +1094,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 1);
+	if (middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_next->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1060,7 +1110,7 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPV
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
 	vma->vm_ops = &vm_ops; /* This should have no impact. */
@@ -1080,6 +1130,8 @@ static bool test_merge_existing(void)
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
+	if (prev_is_sticky || middle_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1094,7 +1146,7 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPP
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x7000, 3, vm_flags, &dummy_anon_vma);
@@ -1109,6 +1161,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
+	if (prev_is_sticky || middle_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1123,10 +1177,10 @@ static bool test_merge_existing(void)
 	 * 0123456789
 	 * PPPPPPPPPP
 	 */
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma_prev->vm_ops = &vm_ops; /* This should have no impact. */
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x7000, 3, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x7000, 0x9000, 7, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x7000, 0x9000, 7, next_flags);
 	vmg_set_range_anon_vma(&vmg, 0x3000, 0x7000, 3, vm_flags, &dummy_anon_vma);
 	vmg.prev = vma_prev;
 	vmg.middle = vma;
@@ -1139,6 +1193,8 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
+	if (prev_is_sticky || middle_is_sticky || next_is_sticky)
+		ASSERT_TRUE(IS_SET(vma_prev->vm_flags, VM_STICKY));
 
 	/* Clear down and reset. We should have deleted prev and next. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1158,9 +1214,9 @@ static bool test_merge_existing(void)
 	 * PPPVVVVVNNN
 	 */
 
-	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, vm_flags);
+	vma_prev = alloc_and_link_vma(&mm, 0, 0x3000, 0, prev_flags);
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x8000, 3, vm_flags);
-	vma_next = alloc_and_link_vma(&mm, 0x8000, 0xa000, 8, vm_flags);
+	vma_next = alloc_and_link_vma(&mm, 0x8000, 0xa000, 8, next_flags);
 
 	vmg_set_range(&vmg, 0x4000, 0x5000, 4, vm_flags);
 	vmg.prev = vma;
@@ -1202,6 +1258,19 @@ static bool test_merge_existing(void)
 
 	return true;
 }
+
+static bool test_merge_existing(void)
+{
+	int i, j, k;
+
+	/* Generate every possible permutation of sticky flags. */
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			for (k = 0; k < 2; k++)
+				ASSERT_TRUE(__test_merge_existing(i, j, k));
+
+	return true;
+}
 
 static bool test_anon_vma_non_mergeable(void)
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
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-uses-of-is_swap_pte-when-leafent_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-leafent_from_pte.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

