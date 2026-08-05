Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5528314C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896750; cv=none; b=DwwPPbULyNAbgxxWdZQJ7xLTzmyAvNKELXk8PQ9vzmuXrPAVIb591k6GctkLIKfiDwdiju8chsD+GUbtHKfgvFSfxskRU1+lls2JPGdQwMd1sUTlQAACbDuuQlYmUmqPs/7anuQHeHMCLIH0P25ZdbEtR2R+DKIoEoOifJ6Pxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896750; c=relaxed/simple;
	bh=hZDKlQTJsent5r/HA2WInNvxzrBViAsJau6KZVr6ST0=;
	h=Date:To:From:Subject:Message-Id; b=rtsnaBJtFqWF7PRYJ2xGnyHWd9M/6FmSv/3djPdPQSr4KsJASoy1K0f3CGI6/knzyXxV3BoGhANcd7jjf7taKrPFjnf5OIwoR4SmYG1EvH2fFe6tydoMn6W991lFlO6flzx1P15NEUeUvqoxhPXwVUSQf3RKXvCcVBegqgFxNpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z3UyR978; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z3UyR978"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4131F000E9;
	Wed,  5 Aug 2026 02:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896748;
	bh=a02yO8x4/245A1xR6qGiz8qF1uoUPvFMavTGe5w3EBs=;
	h=Date:To:From:Subject;
	b=z3UyR978PCBt0Mb/NVX0jkgETDhd7BA5RskwJ7ym8l0kXGL+V+DkKxj/pG3F6ky8W
	 WY1i6EMomfH8P4Y1sxndgDK6MVJG98Pyl5bchzUqZdKRr3BHF8LSwhU6764R77U4J8
	 dFr0XqiXtaUcddDLWku5iCqFj7Egy5qlw4YjmYh0=
Date: Tue, 04 Aug 2026 19:25:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch removed from -mm tree
Message-Id: <20260805022548.4B4131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: use vma_start_pgoff() in merge tests
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
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
mm-add-some-missing-includes-to-mm-local-headers.patch

