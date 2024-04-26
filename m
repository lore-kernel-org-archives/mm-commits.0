Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5837EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104100; cv=none; b=f3Doxa8trafRrE8/bDwlmbOISVCCF35K964AvNEcCmIhP4uFX8fNWIqTuiecyYRDdtI8MBdk7UvZtURxXloBibHYo1CXn4AFPwZIcOsSCbiB35BuObqtXyUN69aF4KozlEYHkDN9/vGFGoXSZ0ysWuq6SLn6ACWqlR+om+0fCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104100; c=relaxed/simple;
	bh=QBUV66ugquRtHQx33acgRBnF3MD2MLCoMKOdphpkI4o=;
	h=Date:To:From:Subject:Message-Id; b=mMibBmYWmbJa/XXnlmFIhjBsGl2GImCZw/MiLb81EXdSaIb2AMPzCuL/Zp9j+eRcEMK9WEFnb8GQ2gB27wd7JdazSWbV9Cud5ZxCSDnhg6zAV2Igp60iD4cYzYrXmNivYMeqhWXoM9EJGffoMzPWIj/3bF+NUr3fMqSKYx0kI08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vS7F/wM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vS7F/wM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D0DC113CD;
	Fri, 26 Apr 2024 04:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104100;
	bh=QBUV66ugquRtHQx33acgRBnF3MD2MLCoMKOdphpkI4o=;
	h=Date:To:From:Subject:From;
	b=vS7F/wM7Pt4fLX++5gSOq+eQHAqAlNZaF0D0OOFsQVg/qD7eLAYjLBlYTJe9w25rK
	 I6mOEg9NDXLrZW48MzMIQ15RZSUQOGkK0+GrLnTsifGXHa2aPKCyQf/NARls0J73Qp
	 5qvCia7fGQXnVrMLOcUO0sfC7OtIS8POWVE5u9Ks=
Date: Thu, 25 Apr 2024 21:01:39 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,colin.i.king@gmail.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch removed from -mm tree
Message-Id: <20240426040140.72D0DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec
has been removed from the -mm tree.  Its filename was
     selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec
Date: Thu, 28 Mar 2024 19:10:10 +0800

This extends test_prctl_fork() and test_prctl_fork_exec() to make sure
that deduplication really happens, instead of only testing the
MMF_VM_MERGE_ANY flag is set.

[colin.i.king@gmail.com: fix spelling mistake in ksft_test_result_skip message]
  Link: https://lkml.kernel.org/r/20240402081537.1365939-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/20240328111010.1502191-4-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
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
+		ksft_test_result_skip("Merge in child skipped\n");
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


