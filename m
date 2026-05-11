Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027664D8DB8
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535270; cv=none; b=SQtUfWUFzNlnmkK7R1eMENa1Pmp1RYUMML0ZK7mzr+BGDQWwTPKpOxA+ykK3UpgMzG/yfa6KzttNfclqUTMPi04u6wEaTA8RVEMZNJMoH5cjJWET0uTXFVMpZ/CCI/26EFY6goWRcLg6ZBLY3+7uOulujCVGNlbGkZz2XNwIZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535270; c=relaxed/simple;
	bh=P+swVNkJTtX/DVuIMW69Bpbc0TaLYtYP2mAfJlxkVio=;
	h=Date:To:From:Subject:Message-Id; b=roKTCgA/aMMdJBmYhIfhlFTUOfq0/LU8fmS8k+5+q90+C6vSjIUphQOfO8x6N4Ra4fZv41semFGnfwVF+5fH8o2NXT9Rz9aBQb1KX/hm4YkvM3AtZ7iCNLT96pXoeSw8Z0swFrx3wS+Nk6DpuqpUo1pKrYJSCuEmO24TIQILg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aN+PcaY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aN+PcaY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5905C2BCB0;
	Mon, 11 May 2026 21:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535269;
	bh=P+swVNkJTtX/DVuIMW69Bpbc0TaLYtYP2mAfJlxkVio=;
	h=Date:To:From:Subject:From;
	b=aN+PcaY0x6H0OCbOQtpQuTFH/OwfbyV6YQYTaJU/XPP2LT1e99c10k/3mcGPfnSuI
	 m0eGLXr5PmyPuVF7WL5rPoDl4LdthXFZU5AgpZin3a1DAcwjqDJx9WQ72scgrj9B2J
	 PzRZLFZnOhFxFIkNJBR2rYcYblX7hHF1hprnO5Oo=
Date: Mon, 11 May 2026 14:34:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-stress-use-kselftest-framework.patch added to mm-new branch
Message-Id: <20260511213429.C5905C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: uffd-stress: use kselftest framework
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-stress-use-kselftest-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-stress-use-kselftest-framework.patch

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
Subject: selftests/mm: uffd-stress: use kselftest framework
Date: Mon, 11 May 2026 19:28:03 +0300

Convert uffd-stress test to use kselftest framework for reporting and
tracking successful and failing runs.

Link: https://lore.kernel.org/20260511162840.375890-20-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
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

 tools/testing/selftests/mm/uffd-stress.c |   40 +++++++++------------
 1 file changed, 19 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd-stress-use-kselftest-framework
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -286,18 +286,12 @@ static int userfaultfd_stress(uffd_globa
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
 	while (bounces--) {
-		printf("bounces: %d, mode:", bounces);
-		if (bounces & BOUNCE_RANDOM)
-			printf(" rnd");
-		if (bounces & BOUNCE_RACINGFAULTS)
-			printf(" racing");
-		if (bounces & BOUNCE_VERIFY)
-			printf(" ver");
-		if (bounces & BOUNCE_POLL)
-			printf(" poll");
-		else
-			printf(" read");
-		printf(", ");
+		ksft_print_msg("bounces: %d, mode:%s%s%s%s, ",
+			       bounces,
+			       bounces & BOUNCE_RANDOM ? " rnd" : "",
+			       bounces & BOUNCE_RACINGFAULTS ? " racing" : "",
+			       bounces & BOUNCE_VERIFY ? " ver" : "",
+			       bounces & BOUNCE_POLL ? " poll" : " read");
 		fflush(stdout);
 
 		if (bounces & BOUNCE_POLL)
@@ -461,6 +455,9 @@ int main(int argc, char **argv)
 	if (argc < 4)
 		usage();
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	if (signal(SIGALRM, sigalrm) == SIG_ERR)
 		err("failed to arm SIGALRM");
 	alarm(ALARM_INTERVAL_SECS);
@@ -484,10 +481,8 @@ int main(int argc, char **argv)
 	 * for racy extra reservation of hugepages.
 	 */
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1) {
-		printf("skip: Skipping userfaultfd... not enough hugepages\n");
-		return KSFT_SKIP;
-	}
+	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
+		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
@@ -503,9 +498,12 @@ int main(int argc, char **argv)
 	}
 	gopts->nr_pages = gopts->nr_pages_per_cpu * gopts->nr_parallel;
 
-	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
-	       gopts->nr_pages, gopts->nr_pages_per_cpu);
-	return userfaultfd_stress(gopts);
+	ksft_print_msg("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
+		       gopts->nr_pages, gopts->nr_pages_per_cpu);
+
+	ksft_test_result(!userfaultfd_stress(gopts),
+			 "uffd-stress %s\n", argv[1]);
+	ksft_finished();
 }
 
 #else /* __NR_userfaultfd */
@@ -514,8 +512,8 @@ int main(int argc, char **argv)
 
 int main(void)
 {
-	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
-	return KSFT_SKIP;
+	ksft_print_header();
+	ksft_exit_skip("missing __NR_userfaultfd definition\n");
 }
 
 #endif /* __NR_userfaultfd */
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

