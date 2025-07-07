Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954B4254858
	for <mm-commits@vger.kernel.org>; Mon,  7 Jul 2025 19:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751917782; cv=none; b=eUdip4nSpYzkTwAewdbbVQCPFPbAaCicxLvZEKrcyQ/DaUAoLcT4rN96iPveLgB3ULT0YKmSberfVzig1Z8oTvk3zwYnwBkgou3E3qK/SSwUWB4tMeqAa9HCMXIszrcg9uMof9TtBl92STZ8bizMoXkYo6q0xNsdkDs+zPDqOdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751917782; c=relaxed/simple;
	bh=aC42e9oP/DktO87z0FTKB+58N0y+4eLMirzmnLDoPps=;
	h=Date:To:From:Subject:Message-Id; b=MQuRGc9Vnm89sVCg7BbwNetZ4wPf+ziEIxJVFi6c954v1f6APlZNwzk36tGdI/BvMGrAoT/hFTwiF7rwY+NXOLz+6EG4oLfxnyKUw2KcV1qjZonroL1ddxRz8iDHPcqk03pqXpWeeDmoHZ2pR/3OmeNPsHx7r55tL/9EH8Szc1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zT4vUu/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zT4vUu/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2EFC4CEE3;
	Mon,  7 Jul 2025 19:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751917782;
	bh=aC42e9oP/DktO87z0FTKB+58N0y+4eLMirzmnLDoPps=;
	h=Date:To:From:Subject:From;
	b=zT4vUu/IJji9nYYLhd4KJV3LYVVLsazEcY/GxxWLp2MvIF36+/W35BKYUwMFcYYSN
	 5K3rmIs6Yk2XyEpCFn4djUjSAq8GCfuDUoB0RsjRFuHFb9cx640u3LuQLbjB1XGnAc
	 /Rgbja5ydmyRjKnHu1/nrWboqEbqtCfDDFY7n15M=
Date: Mon, 07 Jul 2025 12:49:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,luizcap@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch added to mm-new branch
Message-Id: <20250707194942.1A2EFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
Date: Mon, 7 Jul 2025 14:50:43 -0400

Patch series "mm: introduce snapshot_page()", v2.

This series introduces snapshot_page(), a helper function that can be used
to create a snapshot of a struct page and its associated struct folio.

This function is intended to help callers with a consistent view of a a
folio while reducing the chance of encountering partially updated or
inconsistent state, such as during folio splitting which could lead to
crashes and BUG_ON()s being triggered.


This patch (of 4):

Let's avoid working with the PMD when not required.  If
vm_normal_page_pmd() would be called on something that is not a present
pmd, it would already be a bug (pfn possibly garbage).

While at it, let's support passing in any pfn covered by the huge zero
folio by masking off PFN bits -- which should be rather cheap.

Link: https://lkml.kernel.org/r/cover.1751914235.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/0e343f6f088fc79f625161b5d74567d696f2228e.1751914235.git.luizcap@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   12 +++++++++++-
 mm/memory.c             |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd
+++ a/include/linux/huge_mm.h
@@ -487,9 +487,14 @@ static inline bool is_huge_zero_folio(co
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return READ_ONCE(huge_zero_pfn) == (pfn & ~(HPAGE_PMD_NR - 1));
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
+	return pmd_present(pmd) && is_huge_zero_pfn(pmd_pfn(pmd));
 }
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
@@ -636,6 +641,11 @@ static inline bool is_huge_zero_folio(co
 {
 	return false;
 }
+
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return false;
+}
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
--- a/mm/memory.c~mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd
+++ a/mm/memory.c
@@ -674,7 +674,7 @@ struct page *vm_normal_page_pmd(struct v
 		}
 	}
 
-	if (is_huge_zero_pmd(pmd))
+	if (is_huge_zero_pfn(pfn))
 		return NULL;
 	if (unlikely(pfn > highest_memmap_pfn))
 		return NULL;
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch
mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch
mm-page_alloc-let-page-freeing-clear-any-set-page-type.patch
mm-balloon_compaction-make-pageoffline-sticky-until-the-page-is-freed.patch
mm-zsmalloc-make-pagezsmalloc-sticky-until-the-page-is-freed.patch
mm-migrate-rename-isolate_movable_page-to-isolate_movable_ops_page.patch
mm-migrate-rename-putback_movable_folio-to-putback_movable_ops_page.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-migrate-remove-folio_test_movable-and-folio_movable_ops.patch
mm-migrate-move-movable_ops-page-handling-out-of-move_to_new_folio.patch
mm-zsmalloc-stop-using-__clearpagemovable.patch
mm-balloon_compaction-stop-using-__clearpagemovable.patch
mm-migrate-remove-__clearpagemovable.patch
mm-migration-remove-pagemovable.patch
mm-rename-__pagemovable-to-page_has_movable_ops.patch
mm-page_isolation-drop-__folio_test_movable-check-for-large-folios.patch
mm-remove-__folio_test_movable.patch
mm-stop-storing-migration_ops-in-page-mapping.patch
mm-convert-movable-flag-in-page-mapping-to-a-page-flag.patch
mm-rename-pg_isolated-to-pg_movable_ops_isolated.patch
mm-page-flags-rename-page_mapping_movable-to-page_mapping_anon_ksm.patch
mm-page-alloc-remove-pagemappingflags.patch
mm-page-flags-remove-folio_mapping_flags.patch
mm-simplify-folio_expected_ref_count.patch
mm-rename-page_mapping_-to-folio_mapping_.patch
docs-mm-convert-from-non-lru-page-migration-to-movable_ops-page-migration.patch
mm-balloon_compaction-movable_ops-doc-updates.patch
mm-balloon_compaction-provide-single-balloon_page_insert-and-balloon_mapping_gfp_mask.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

