Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4198219E7D0
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821851; cv=none; b=q8SVeIR/ar+SdDBS55nVwI3NyGf2te4KmgExsfDwv8V90YGghuqliQSaHTZjXQ2XbN4X8927CqyQCYOFe2tEAKiMvb3lCL1PGQ/O3BVQhUhb7I9hHEyZ/kYkSjVDk5Sjt7yRXN4xRqZ7IL8Nf/NhU8myuHfYyRUShxNe8TjyK/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821851; c=relaxed/simple;
	bh=qogDTEkSZW5HVo6F2EJCNGTpxtyVc+6ZFu3YCXOWWzk=;
	h=Date:To:From:Subject:Message-Id; b=CZCGEgATk2BuXEM+MVWNGLdRz1fP9ekKft0LqXcU9EyH5M87FDxRwbIp6A6JBXGl+ez4TmjSjKZsp8dRBSw86eLfL1CZySKvdwdJoK4/SP9UtkbVl5STGZexGwmBbON5LNIL5/F5BAdSGOxeIJXeuxickBT1N0EOCsG4Fo85rG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/plTuTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/plTuTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE77C4CEEF;
	Tue, 29 Jul 2025 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821851;
	bh=qogDTEkSZW5HVo6F2EJCNGTpxtyVc+6ZFu3YCXOWWzk=;
	h=Date:To:From:Subject:From;
	b=H/plTuTrinnEA2ViDvrkddpBUB3fkjDWg04ngY3PdsQ1YVFL5y4YWsKKEDzxL2oyp
	 8o9nZR0gcE1UfTme27et3ZcmsqsWe6WZb6JFwGpADN8oxBQWtfl7zsW7w5x00EAhE3
	 s6HwqMIh0LpG95kJAA9hQzHvrUj7IUHx4xzqb/fg=
Date: Tue, 29 Jul 2025 13:44:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch added to mm-new branch
Message-Id: <20250729204411.0EE77C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix child process exit codes in ksm_functional_tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch

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
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: selftests/mm: fix child process exit codes in ksm_functional_tests
Date: Tue, 29 Jul 2025 11:04:01 +0530

In ksm_functional_tests, test_child_ksm() returned negative values to
indicate errors.  However, when passed to exit(), these were interpreted
as large unsigned values (e.g, -2 became 254), leading to incorrect
handling in the parent process.  As a result, some tests appeared to be
skipped or silently failed.

This patch changes test_child_ksm() to return positive error codes (1, 2,
3) and updates test_child_ksm_err() to interpret them correctly. 
Additionally, test_prctl_fork_exec() now uses exit(4) after a failed
execv() to clearly signal exec failures.  This ensures the parent
accurately detects and reports child process failures.

--------------
Before patch:
--------------
- [RUN] test_unmerge
ok 1 Pages were unmerged
...
- [RUN] test_prctl_fork
- No pages got merged
- [RUN] test_prctl_fork_exec
ok 7 PR_SET_MEMORY_MERGE value is inherited
...
Bail out! 1 out of 8 tests failed
- Planned tests != run tests (9 != 8)
- Totals: pass:7 fail:1 xfail:0 xpass:0 skip:0 error:0

--------------
After patch:
--------------
- [RUN] test_unmerge
ok 1 Pages were unmerged
...
- [RUN] test_prctl_fork
- No pages got merged
not ok 7 Merge in child failed
- [RUN] test_prctl_fork_exec
ok 8 PR_SET_MEMORY_MERGE value is inherited
...
Bail out! 2 out of 9 tests failed
- Totals: pass:7 fail:2 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20250729053403.1071807-6-aboorvad@linux.ibm.com
Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   16 ++++++------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -512,14 +512,14 @@ static int test_child_ksm(void)
 
 	/* Test if KSM is enabled for the process. */
 	if (prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0) != 1)
-		return -1;
+		return 1;
 
 	/* Test if merge could really happen. */
 	map = __mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_NONE);
 	if (map == MAP_MERGE_FAIL)
-		return -2;
+		return 2;
 	else if (map == MAP_MERGE_SKIP)
-		return -3;
+		return 3;
 
 	ksm_unmerge();
 	munmap(map, size);
@@ -528,12 +528,14 @@ static int test_child_ksm(void)
 
 static void test_child_ksm_err(int status)
 {
-	if (status == -1)
+	if (status == 1)
 		ksft_test_result_fail("unexpected PR_GET_MEMORY_MERGE result in child\n");
-	else if (status == -2)
+	else if (status == 2)
 		ksft_test_result_fail("Merge in child failed\n");
-	else if (status == -3)
+	else if (status == 3)
 		ksft_test_result_skip("Merge in child skipped\n");
+	else if (status == 4)
+		ksft_test_result_fail("Binary not found\n");
 }
 
 /* Verify that prctl ksm flag is inherited. */
@@ -606,7 +608,7 @@ static void test_prctl_fork_exec(void)
 		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
 
 		execv(prg_name, argv_for_program);
-		return;
+		exit(4);
 	}
 
 	if (waitpid(child_pid, &status, 0) > 0) {
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are

selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch
selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch
selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch

