Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1CD305057
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723545; cv=none; b=kHtGXLEuyKB9CwwKHsi3Pyh8CcMJOIQ3myQ0zo85GDGYdwI0PbUEZi/V342eLZxCvsT+q7cPj6H1KqTh9ppDW8RSMmJaBYu2HIpMaIFbMogjE9kNLUPa1bTlQQ0Kjry1z2bwG3H+GxZCX55oFVyRtbjMH+slaecG6pCgeZIvZi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723545; c=relaxed/simple;
	bh=IOMra9p3gM+HllmC8zBlfrznaiqvJieK1qXlpepLZfA=;
	h=Date:To:From:Subject:Message-Id; b=IuKfn//DptA9gdXGjPFXY+uDW7/E14zzaIQw1PqXhy0ZyqKF5HFtpXeeUQOLshxi58Dw0HaxosHTfOblrfVLNCAQ+QCLZzIKLUMGiVMWlIKlL+ZPPs7r+T4LIqFhU3NAiuJtxARO1PPM3jGh3NLc7WAc8CSzalkCpDtaAFMGDfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtvL/C6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtvL/C6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E2D1F000E9;
	Fri, 10 Jul 2026 22:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723543;
	bh=l0NaolM99J9BsuMzJc6aTKEa0l8oEZkIPTSOQEFMPpU=;
	h=Date:To:From:Subject;
	b=CtvL/C6KHVViuOTuVLEvYzoZDPFl6K/17RmnwfoxZ+4nr16VfuNTvPXHbmudYpVHV
	 YUKTnFsW/89K1DWO+blsdW4VCOlYnaEgYw7m8Vn8ItqvDjibWiKpjf5uHPc2FOCyKZ
	 3odIBmj/ix8NNI5WQE5FGdCfWUGoQS9IzbsSHg9A=
Date: Fri, 10 Jul 2026 15:45:42 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch added to mm-new branch
Message-Id: <20260710224543.48E2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: use vma_start_pgoff() in merge tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: tools/testing/vma: use vma_start_pgoff() in merge tests
Date: Fri, 10 Jul 2026 21:16:44 +0100

Now we have the vma_start_pgoff() helper, update the merge tests to make
use of it for consistency.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/merge.c |   38 +++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/tools/testing/vma/tests/merge.c~tools-testing-vma-use-vma_start_pgoff-in-merge-tests
+++ a/tools/testing/vma/tests/merge.c
@@ -118,7 +118,7 @@ static bool test_simple_merge(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -150,7 +150,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -162,7 +162,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -171,7 +171,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -180,7 +180,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -209,7 +209,7 @@ static bool test_simple_expand(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -231,7 +231,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -324,7 +324,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -343,7 +343,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -364,7 +364,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -384,7 +384,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -404,7 +404,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0xa);
+	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -423,7 +423,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -443,7 +443,7 @@ static bool __test_merge_new(bool is_sti
 		ASSERT_NE(vma, NULL);
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
-		ASSERT_EQ(vma->vm_pgoff, 0);
+		ASSERT_EQ(vma_start_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -805,7 +805,7 @@ static bool test_vma_merge_new_with_clos
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -865,7 +865,7 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -931,7 +931,7 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -1416,7 +1416,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma_merge_extend(&vmi, vma, 0x2000), vma);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1456,7 +1456,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

