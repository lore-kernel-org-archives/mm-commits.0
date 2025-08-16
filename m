Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6071EEA5D
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755322018; cv=none; b=kvzGATtMIBnK15E98+ImES1expsITblO4HAlwF2X0XRfGtgr1+GWk0/GVCmVYihBjcFPrWi7L8lpLperkDLy3cBm3RZYJUvYlqdqFwWra/JMCoFrcXNIbLMRGCVUseioVo2nYL3SyYTbhhK2f+2OH2TmuZzb8P2WlU1wJ1mwmxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755322018; c=relaxed/simple;
	bh=xZn/ALuH5C3EiBqSx4g713ptvbSwROQ1luu+nUi4P5Y=;
	h=Date:To:From:Subject:Message-Id; b=MoK0VEkvFWh3kXB8JpIH8BZ4+f64zsXPt4+v+PsUUJ1oBJcaAT5tgvf8nPxiUdthW7xhjZoRncrvSAEqQvNO3HACJviW14JZJzUjt9VXSofN2Y0E1cAKOXwcyRA/ez+O1cibHBcJd/3TTj8zFLKPiJTwXMHrvfr9dzDTvdJ51Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWaeGD+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWaeGD+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9828C4CEEF;
	Sat, 16 Aug 2025 05:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322017;
	bh=xZn/ALuH5C3EiBqSx4g713ptvbSwROQ1luu+nUi4P5Y=;
	h=Date:To:From:Subject:From;
	b=nWaeGD+HPMg8EkThFvQ7u15ApKMV+n635wf6Y6t/7lsv+AFw7zoD3MS8Wiz2SNldE
	 P4fRalhcqHE5VJW7ES/K8sjkhTN7pAZIJuW//bnj62agqI/Za3ANmXddyi7gp48+kt
	 jTwoLMU1CqbrUjIeE2VysHFHIwVkqZ1B1BcRKjIg=
Date: Fri, 15 Aug 2025 22:26:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-fix-ksm_funtional_test-failures.patch added to mm-new branch
Message-Id: <20250816052657.B9828C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: fix ksm_funtional_test failures
has been added to the -mm mm-new branch.  Its filename is
     selftest-mm-fix-ksm_funtional_test-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-fix-ksm_funtional_test-failures.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftest/mm: fix ksm_funtional_test failures
Date: Sat, 16 Aug 2025 09:31:09 +0530

This patch fixes 2 issues.

1) After fork() in test_prctl_fork, the child process uses the file
   descriptors from the parent process to read ksm_stat and
   ksm_merging_pages.  This results in incorrect values being read (parent
   process ksm_stat and ksm_merging_pages will be read in child), causing
   the test to fail.

   This patch calls init_global_file_handles() in the child process to
   ensure that the current process's file descriptors are used to read
   ksm_stat and ksm_merging_pages.

2) All tests currently call ksm_merge to trigger page merging.  To
   ensure the system remains in a consistent state for subsequent tests,
   it is better to call ksm_unmerge during the test cleanup phase

   In the test_prctl_fork test, after a fork(), reading
   ksm_merging_pages in the child process returns a non-zero value because
   a previous test performed a merge, and the child's memory state is
   inherited from the parent.

   Although the child process calls ksm_unmerge, the ksm_merging_pages
   counter in the parent is reset to zero, while the child's counter
   remains unchanged.  This discrepancy causes the test to fail.

   To avoid this issue, each test should call ksm_unmerge during
   cleanup to ensure the counter is reset and the system is in a clean
   state for subsequent tests.

execv argument is an array of pointers to null-terminated strings.  In
this patch we also added NULL in the execv argument.

Link: https://lkml.kernel.org/r/20250816040113.760010-4-aboorvad@linux.ibm.com
Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-fix-ksm_funtional_test-failures
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
+static void init_global_file_handles(void);
+
 static bool range_maps_duplicates(char *addr, unsigned long size)
 {
 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
@@ -274,6 +276,7 @@ static void test_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -338,6 +341,7 @@ static void test_unmerge_zero_pages(void
 	ksft_test_result(!range_maps_duplicates(map, size),
 			"KSM zero pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -366,6 +370,7 @@ static void test_unmerge_discarded(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -452,6 +457,7 @@ static void test_unmerge_uffd_wp(void)
 close_uffd:
 	close(uffd);
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 #endif
@@ -515,6 +521,7 @@ static int test_child_ksm(void)
 	else if (map == MAP_MERGE_SKIP)
 		return -3;
 
+	ksm_unmerge();
 	munmap(map, size);
 	return 0;
 }
@@ -548,6 +555,7 @@ static void test_prctl_fork(void)
 
 	child_pid = fork();
 	if (!child_pid) {
+		init_global_file_handles();
 		exit(test_child_ksm());
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
@@ -595,7 +603,7 @@ static void test_prctl_fork_exec(void)
 		return;
 	} else if (child_pid == 0) {
 		char *prg_name = "./ksm_functional_tests";
-		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME };
+		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
 
 		execv(prg_name, argv_for_program);
 		return;
@@ -644,6 +652,7 @@ static void test_prctl_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
@@ -677,6 +686,7 @@ static void test_prot_none(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_unmerge();
 	munmap(map, size);
 }
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

