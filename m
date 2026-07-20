Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8B52FD1A5
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576944; cv=none; b=FYlLqz5oReR6L1fnYbkkd9ZC1hUTjankyiFTaUwWYnrcZmw0AgdtV17hCdzABji2oZwdD1GjgFTcpSGZ9fgDccms96g5vaKfCpLoGs8ZxaYiOjQ39i7z01FsmU/KJjK6n5f4NR6W4wH5onUiQKMTg6KgQpXUp+2dYq2m+PET4r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576944; c=relaxed/simple;
	bh=Ww8bIF8IcxPUKC0+jFc8nzkzi3O1ASTCURJh2TKcVHk=;
	h=Date:To:From:Subject:Message-Id; b=IvilVR4CWoZe/V67O5ReANA9W858Fkwns+0zvqjUhQ3/OU1BviA+FBxNg7f5jJZHB2BtdIxP9TUl5MV4JGVAcHBURD1qc3mCvoPvOcHS4lCF08g5S6E7dEqN/bDCxHCIqHlOU/2+aDahJVrbbuAvk3nR3TuGX1vYi3pJworw5nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfZs4cpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfZs4cpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222AC1F000E9;
	Mon, 20 Jul 2026 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784576942;
	bh=bHN9y+tzr4iSbKr2bIZ395kBpEgsp2ecOSrfyDaPorE=;
	h=Date:To:From:Subject;
	b=gfZs4cpXwyxfNH7IGmuUT4+6ryM1P7YaM3VTrdvlbwb3slGfJ8pjzlP7gSGTrPFcg
	 RJgeoojTimLBpTm5UHLPs97iNJXiQHiRJ9CrNJfcaG9E5iHwUcLhG4KRr01E1T59he
	 LLUXUl4DYHr/H1+CaOS1ZzMA0NVTn1syMu+JluxY=
Date: Mon, 20 Jul 2026 12:49:01 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch added to mm-new branch
Message-Id: <20260720194902.222AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: expand VMA merge tests to assert virt pgoff
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: expand VMA merge tests to assert virt pgoff
Date: Mon, 20 Jul 2026 15:38:36 +0100

Now we have introduced the VMA virtual page offset attribute and update it
when VMAs are manipulated, update VMA merge tests to assert that the
virtual page offset is as expected.

Also update instances where we could use vma_start_pgoff() to do so.

Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-10-2d549757a76f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/merge.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/tools/testing/vma/tests/merge.c~tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff
+++ a/tools/testing/vma/tests/merge.c
@@ -121,6 +121,7 @@ static bool test_simple_merge(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -153,6 +154,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -165,6 +167,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -174,6 +177,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -183,6 +187,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -212,6 +217,7 @@ static bool test_simple_expand(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -234,6 +240,7 @@ static bool test_simple_shrink(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -346,6 +353,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -367,6 +375,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -387,6 +396,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -407,6 +417,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -426,6 +437,7 @@ static bool __test_merge_new(bool is_sti
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -446,6 +458,7 @@ static bool __test_merge_new(bool is_sti
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
 		ASSERT_EQ(vma_start_pgoff(vma), 0);
+		ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -808,6 +821,7 @@ static bool test_vma_merge_new_with_clos
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -863,11 +877,13 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x3000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_next), 3);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -929,11 +945,13 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x6000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -964,7 +982,8 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -996,7 +1015,8 @@ static bool __test_merge_existing(bool p
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x9000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -1419,6 +1439,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1480,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
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
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

