Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF9265CB2
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588777; cv=none; b=pbptCdfVN6AZRXsj3aAdfJTGsZ/3itFzquGvm9iJ7ivinwW0TGQll5jl8pBoa3+oUg6m4Y+p6snLKz0RIYqf9hI0hqKxJHN1qWtaasw6UNp0vZ9EpDc07Is9/vwUfP/bC4o9aGLOkVxaHNXpwrMEXufg8YJgW4O+qeknL0HBm4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588777; c=relaxed/simple;
	bh=wKTXIFMMcviUPUePu26ajzXlDpWFeZUK1VHfXkL8zHE=;
	h=Date:To:From:Subject:Message-Id; b=qi2KQhDzq7aDVobwH5cWqGF3XAV7/FHxaIMNG4a1RveE0xqWD7WuoWFgdcSPfAQ8JY3p0u7hkYfgLq+aveuQkO85HvS9cSicbV8YqO4hsX6LrQCA2Tb3UQI69bnU9OOirlweyoo3xnYso7+RpTw8SUinloRQhPLlJ4p3H6ZbbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qPM48R99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qPM48R99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D37C4CEED;
	Tue, 10 Jun 2025 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588776;
	bh=wKTXIFMMcviUPUePu26ajzXlDpWFeZUK1VHfXkL8zHE=;
	h=Date:To:From:Subject:From;
	b=qPM48R99dhD/LkOl1EkYMaQWUs4oGW24775SNtKDf3e3Ql85/SNZZlFw1+rbP8rGu
	 0KY7orbK1NQy8OR316Xt9gsUFIBzt0yZQ3++HZz7j8woZm6jAJRkm/1hNhVSsGnTQv
	 sXR0Cc910aO1pwN8EsGDt8ZGhn+/a2rTMT1KKAhA=
Date: Tue, 10 Jun 2025 13:52:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch added to mm-new branch
Message-Id: <20250610205256.B4D37C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: have CoW self test use MREMAP_RELOCATE_ANON
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch

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
Subject: tools/testing/selftests: have CoW self test use MREMAP_RELOCATE_ANON
Date: Mon, 9 Jun 2025 14:26:43 +0100

It is useful to have the CoW self-test invoke MREMAP_RELOCATE_ANON on
partial THP mappings, as this triggers folio split code paths and asserts
that this behaves correctly.

Add an additional set of tests to explicitly do so.

Link: https://lkml.kernel.org/r/0cbe373c1d14270f5fcaf3ba8734d50d761796c0.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon
+++ a/tools/testing/selftests/mm/cow.c
@@ -853,13 +853,14 @@ enum thp_run {
 	THP_RUN_SINGLE_PTE,
 	THP_RUN_SINGLE_PTE_SWAPOUT,
 	THP_RUN_PARTIAL_MREMAP,
+	THP_RUN_PARTIAL_MREMAP_RELOCATE_ANON,
 	THP_RUN_PARTIAL_SHARED,
 };
 
 static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t thpsize)
 {
 	char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
-	size_t size, mmap_size, mremap_size;
+	size_t size, mmap_size, mremap_size, mremap_flags;
 	int ret;
 
 	/* For alignment purposes, we need twice the thp size. */
@@ -935,6 +936,7 @@ static void do_run_with_thp(test_fn fn,
 		size = pagesize;
 		break;
 	case THP_RUN_PARTIAL_MREMAP:
+	case THP_RUN_PARTIAL_MREMAP_RELOCATE_ANON:
 		/*
 		 * Remap half of the THP. We need some new memory location
 		 * for that.
@@ -947,8 +949,13 @@ static void do_run_with_thp(test_fn fn,
 			log_test_result(KSFT_FAIL);
 			goto munmap;
 		}
-		tmp = mremap(mem + mremap_size, mremap_size, mremap_size,
-			     MREMAP_MAYMOVE | MREMAP_FIXED, mremap_mem);
+
+		mremap_flags = MREMAP_MAYMOVE | MREMAP_FIXED;
+		if (thp_run == THP_RUN_PARTIAL_MREMAP_RELOCATE_ANON)
+			mremap_flags |= MREMAP_RELOCATE_ANON;
+
+		tmp = sys_mremap(mem + mremap_size, mremap_size, mremap_size,
+				 mremap_flags, mremap_mem);
 		if (tmp != mremap_mem) {
 			ksft_perror("mremap() failed");
 			log_test_result(KSFT_FAIL);
@@ -1060,6 +1067,13 @@ static void run_with_partial_mremap_thp(
 	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP, size);
 }
 
+static void run_with_partial_mremap_relocate_anon_thp(test_fn fn, const char *desc, size_t size)
+{
+	ksft_print_msg("[RUN] %s ... with partially mremap(MREMAP_RELOCATE_ANON)'ed THP (%zu kB)\n",
+		desc, size / 1024);
+	do_run_with_thp(fn, THP_RUN_PARTIAL_MREMAP_RELOCATE_ANON, size);
+}
+
 static void run_with_partial_shared_thp(test_fn fn, const char *desc, size_t size)
 {
 	log_test_start("%s ... with partially shared THP (%zu kB)",
@@ -1255,6 +1269,7 @@ static void run_anon_test_case(struct te
 		run_with_single_pte_of_thp(test_case->fn, test_case->desc, size);
 		run_with_single_pte_of_thp_swap(test_case->fn, test_case->desc, size);
 		run_with_partial_mremap_thp(test_case->fn, test_case->desc, size);
+		run_with_partial_mremap_relocate_anon_thp(test_case->fn, test_case->desc, size);
 		run_with_partial_shared_thp(test_case->fn, test_case->desc, size);
 
 		thp_pop_settings();
@@ -1278,7 +1293,7 @@ static int tests_per_anon_test_case(void
 {
 	int tests = 2 + nr_hugetlbsizes;
 
-	tests += 6 * nr_thpsizes;
+	tests += 7 * nr_thpsizes;
 	if (pmdsize)
 		tests += 2;
 	return tests;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
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

