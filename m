Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71161E894
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668014; cv=none; b=jstC5M3g184/9+X0Yt7y0WzP17jeWg3kq7UmlSkN3hrnRo0b2tj7OA1zlS6g4fwyXQ+ItGtRysR0sBO+SaWidcLSZK7TWD5cV4ZlTTVrJpCoJ04h1TVY15i/AFFEfhW4uqDEPBu3657gn6qPCk+VpOs0ND8YE6oO6zqIApmlzoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668014; c=relaxed/simple;
	bh=nx4ufn7XuMCrGVQFrpdNcx3Xk+b/gcG7Losb6SqBv+8=;
	h=Date:To:From:Subject:Message-Id; b=V3O4rW+0gSTjNP+LYTJNUjBxt1ByCrBJPW1hNp3jHBNzvJodEADs5qKaCGmjhjYA2th4QYHAYsY+jKIrUagVVXZSv2epTPKOPglC/9b7AxLEd5NjzrjxGYcHLGjLXCLpH85Uz5psenCUsxyribbRD6AmbgjgD8o3ldcOZ64WZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMD2BvIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMD2BvIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D436C113CC;
	Thu,  2 May 2024 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714668014;
	bh=nx4ufn7XuMCrGVQFrpdNcx3Xk+b/gcG7Losb6SqBv+8=;
	h=Date:To:From:Subject:From;
	b=nMD2BvIFa9eUskdwbCqpP7lacCW0FUllcwxZ7byQCBTpxxeUnTy9+cAO1cow9yqvh
	 MKX1VnGnDOti3jzdeEZ2VfcugNA250xENVu5YxSVsGJJwDm2A7wEqa8bsufdxgtnLw
	 1JhqpO2UBz5pyHKVZOmzNmwf2M2CiHwp8EQ8STgU=
Date: Thu, 02 May 2024 09:40:12 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch added to mm-unstable branch
Message-Id: <20240502164014.1D436C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: gup_longterm: test unsharing logic when R/O pinning
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: selftests: mm: gup_longterm: test unsharing logic when R/O pinning
Date: Tue, 30 Apr 2024 15:15:08 +0200

In our FOLL_LONGTERM tests, we prefault the page tables for the GUP-fast
test cases to be able to find a PTE and exercise the "longterm pinning
allowed" logic on the GUP-fast path where possible.

For now, we always prefault the page tables writable, resulting in PTEs
that are writable.

Let's cover more cases to also test if our unsharing logic works as
expected (and is able to make progress when there is nothing to unshare)
by mprotect'ing the range R/O when R/O-pinning, so we don't get PTEs that
are writable.

This change would have found an issue introduced by commit a12083d721d7
("mm/gup: handle hugepd for follow_page()"), whereby R/O pinning was not
able to make progress in all cases, because unsharing logic was not
provided with the VMA to decide at some point that long-term R/O pinning a
!anon page is fine.

Link: https://lkml.kernel.org/r/20240430131508.86924-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -118,15 +118,22 @@ static void do_test(int fd, size_t size,
 		return;
 	}
 
-	/*
-	 * Fault in the page writable such that GUP-fast can eventually pin
-	 * it immediately.
-	 */
+	/* Fault in the page such that GUP-fast can pin it directly. */
 	memset(mem, 0, size);
 
 	switch (type) {
 	case TEST_TYPE_RO:
 	case TEST_TYPE_RO_FAST:
+		/*
+		 * Cover more cases regarding unsharing decisions when
+		 * long-term R/O pinning by mapping the page R/O.
+		 */
+		ret = mprotect(mem, size, PROT_READ);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			goto munmap;
+		}
+		/* FALLTHROUGH */
 	case TEST_TYPE_RW:
 	case TEST_TYPE_RW_FAST: {
 		struct pin_longterm_test args;
@@ -228,6 +235,7 @@ static void do_test(int fd, size_t size,
 		assert(false);
 	}
 
+munmap:
 	munmap(mem, size);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch
mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch
selftests-mm-gup_longterm-test-unsharing-logic-when-r-o-pinning.patch

