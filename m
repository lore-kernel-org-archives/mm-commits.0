Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2B413793D
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 18:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652170; cv=none; b=hZUup2S7TZyij4BRuUphJc1nuKMnzXAeJ4H1GW7JwKfAMsQ+BreUuMlOIABRcDoaJsL+hNweqiCs8XFzltlb3TiCCo/nuPBJDZQ6H2q597y8l6oCKYoVn0JwCNU249pz22QHHicM1QKCXlK1dt5MvtlKZBntkWH6/YHTtLjTWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652170; c=relaxed/simple;
	bh=DGxshUVrsh+TkLODSZdFzFlK8zGEQUPUotZVrOT5Row=;
	h=Date:To:From:Subject:Message-Id; b=JnEIMV5exmKiYwKMSNOBx03LH838R8u/upfberMC0ioQ3FcZbgX7dn3bZ0rz44DRR5u8ij7jJ0yImZ46uj23tD/UH0D2vHOstSI2Y7JpJ/8GonpsUULaNMbSz9Q2ClS/MyYKGifXdgR5xjmMqtki2zS2UJ7rGdVz09wPUfNcNJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C5MtukzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C5MtukzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C801EC433F1;
	Thu, 28 Mar 2024 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711652169;
	bh=DGxshUVrsh+TkLODSZdFzFlK8zGEQUPUotZVrOT5Row=;
	h=Date:To:From:Subject:From;
	b=C5MtukzM6nlsb44EXWeNZYJe2BUyjnPe9+A9rFu9SJhD3qcb5Abq5S9GlIF8qIwcp
	 V84J9dgQ124XC+dfpkwM4WocHx0ksI/j+YLdLPROr83Kk7EKT9uWSIu3ED96AhrCmi
	 OYk+f1/E+VJia1FnAe0MZ7ZQmYsftVOsTEY+e/EE=
Date: Thu, 28 Mar 2024 11:56:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch added to mm-unstable branch
Message-Id: <20240328185609.C801EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec
Date: Thu, 28 Mar 2024 19:10:10 +0800

This extends test_prctl_fork() and test_prctl_fork_exec() to make sure
that deduplication really happens, instead of only testing the
MMF_VM_MERGE_ANY flag is set.

Link: https://lkml.kernel.org/r/20240328111010.1502191-4-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   49 +++++++++---
 1 file changed, 38 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -475,6 +475,36 @@ static void test_prctl(void)
 	ksft_test_result_pass("Setting/clearing PR_SET_MEMORY_MERGE works\n");
 }
 
+static int test_child_ksm(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+
+	/* Test if KSM is enabled for the process. */
+	if (prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0) != 1)
+		return -1;
+
+	/* Test if merge could really happen. */
+	map = __mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_NONE);
+	if (map == MAP_MERGE_FAIL)
+		return -2;
+	else if (map == MAP_MERGE_SKIP)
+		return -3;
+
+	munmap(map, size);
+	return 0;
+}
+
+static void test_child_ksm_err(int status)
+{
+	if (status == -1)
+		ksft_test_result_fail("unexpected PR_GET_MEMORY_MERGE result in child\n");
+	else if (status == -2)
+		ksft_test_result_fail("Merge in child failed\n");
+	else if (status == -3)
+		ksft_test_result_skip("Merge in child skiped\n");
+}
+
 /* Verify that prctl ksm flag is inherited. */
 static void test_prctl_fork(void)
 {
@@ -494,7 +524,7 @@ static void test_prctl_fork(void)
 
 	child_pid = fork();
 	if (!child_pid) {
-		exit(prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0));
+		exit(test_child_ksm());
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
 		return;
@@ -503,8 +533,11 @@ static void test_prctl_fork(void)
 	if (waitpid(child_pid, &status, 0) < 0) {
 		ksft_test_result_fail("waitpid() failed\n");
 		return;
-	} else if (WEXITSTATUS(status) != 1) {
-		ksft_test_result_fail("unexpected PR_GET_MEMORY_MERGE result in child\n");
+	}
+
+	status = WEXITSTATUS(status);
+	if (status) {
+		test_child_ksm_err(status);
 		return;
 	}
 
@@ -516,12 +549,6 @@ static void test_prctl_fork(void)
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }
 
-static int ksm_fork_exec_child(void)
-{
-	/* Test if KSM is enabled for the process. */
-	return prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0) == 1;
-}
-
 static void test_prctl_fork_exec(void)
 {
 	int ret, status;
@@ -554,7 +581,7 @@ static void test_prctl_fork_exec(void)
 		if (WIFEXITED(status)) {
 			status = WEXITSTATUS(status);
 			if (status) {
-				ksft_test_result_fail("KSM not enabled\n");
+				test_child_ksm_err(status);
 				return;
 			}
 		} else {
@@ -635,7 +662,7 @@ int main(int argc, char **argv)
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
-		exit(ksm_fork_exec_child() == 1 ? 0 : 1);
+		exit(test_child_ksm());
 	}
 
 #ifdef __NR_userfaultfd
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-ksm-fix-ksm-exec-support-for-prctl.patch
selftest-mm-ksm_functional_tests-refactor-mmap_and_merge_range.patch
selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch

