Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9333E4D2EF6
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535274; cv=none; b=GyF1QMn/UJzWCE9oRWdGaxJr/NfLxTHiKj3iJzIxpCZwrzieorBqaLPNLK1tzQ5LGzMOmZWY3mvQXipd01X1Gicnc6x/3o5eWz0hriZzqygPday6pld8j2mHbSA9cBQ8PPD53RxmvtPQnfiz+VibkegcofLOTOrE3ri1k15yqaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535274; c=relaxed/simple;
	bh=pCUYcoAeAMpaesjl1GrTGuJxKeMWebu4G7oW1R6eqrQ=;
	h=Date:To:From:Subject:Message-Id; b=s+1C6ZROGTHhrqB5p37X/yzJ/0faevh5Q+qqQszAdSD+WTqSjEeNwosRAwj5Ogv1N7qJLMTOwclPIFuwX0wstUMNNBavZR5LiihFuTW2+eulhr5cSLBqsx40dO2zLoorwYKz/7qIRm4T/2/QzTsTDpKco6IoHfgzIJI1knR7YvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gslp2l5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gslp2l5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D667C2BCB0;
	Mon, 11 May 2026 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535274;
	bh=pCUYcoAeAMpaesjl1GrTGuJxKeMWebu4G7oW1R6eqrQ=;
	h=Date:To:From:Subject:From;
	b=gslp2l5xB+XVeEiTEaluAFfUCUSPa538I630swIxBbJcRJNBpH5kNY4xCm/6qJJAv
	 J0/UZVcs+ttop2cpDtBc/YOFpE3ZEhfZsU7WpU48/6+kZTmamgSxYLIMauYMLqiy5c
	 xEyalgAWigqDNj5TOIubz1yogdszArNrJRVL/+G4=
Date: Mon, 11 May 2026 14:34:33 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-va_high_addr_switch-use-kselftest-framework.patch added to mm-new branch
Message-Id: <20260511213434.6D667C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: va_high_addr_switch: use kselftest framework
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-va_high_addr_switch-use-kselftest-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-va_high_addr_switch-use-kselftest-framework.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: va_high_addr_switch: use kselftest framework
Date: Mon, 11 May 2026 19:28:05 +0300

Convert va_high_addr_switch test to use kselftest framework for reporting
and tracking successful and failing runs.

Link: https://lore.kernel.org/20260511162840.375890-22-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |   41 ++++++-------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-va_high_addr_switch-use-kselftest-framework
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -257,40 +257,35 @@ void testcases_init(void)
 	switch_hint = addr_switch_hint;
 }
 
-static int run_test(struct testcase *test, int count)
+static void run_test(struct testcase *test, int count)
 {
 	void *p;
-	int i, ret = KSFT_PASS;
+	int i;
 
 	for (i = 0; i < count; i++) {
 		struct testcase *t = test + i;
 
 		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
-
-		printf("%s: %p - ", t->msg, p);
-
 		if (p == MAP_FAILED) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_perror("MAP_FAILED");
+			ksft_test_result_fail("%s\n", t->msg);
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(switch_hint)) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_print_msg("%p not below switch hint\n", p);
+			ksft_test_result_fail("%s\n", t->msg);
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
 			 * bugs in page fault handling
 			 */
 			memset(p, 0, t->size);
-			printf("OK\n");
+			ksft_test_result_pass("%s\n", t->msg);
 		}
 		if (!t->keep_mapped)
 			munmap(p, t->size);
 	}
-
-	return ret;
 }
 
 #ifdef __aarch64__
@@ -322,19 +317,23 @@ static int supported_arch(void)
 
 int main(int argc, char **argv)
 {
-	int ret, hugetlb_ret = KSFT_PASS;
+	bool run_hugetlb = false;
+
+	ksft_print_header();
 
 	if (!supported_arch())
-		return KSFT_SKIP;
+		ksft_exit_skip("Architecture not supported\n");
+
+	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+		run_hugetlb = true;
 
 	testcases_init();
 
-	ret = run_test(testcases, sz_testcases);
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
+	ksft_set_plan(sz_testcases + (run_hugetlb ? sz_hugetlb_testcases : 0));
+
+	run_test(testcases, sz_testcases);
+	if (run_hugetlb)
+		run_test(hugetlb_testcases, sz_hugetlb_testcases);
 
-	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
-		return KSFT_PASS;
-	else
-		return KSFT_FAIL;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

