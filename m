Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15D1170D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560157; cv=none; b=nP46QxEYBesQLs+jNH5l5lQXFxWXTE6g9cC7vCLjNMVxgpAfo7DzhMuNFvo1yeER2g2OWtM3Gwt9XCmR/foyZdk6jeb7B2XuddOjhq2ofxA/Fu55I1pOBHiEvvjWTCFw5R7ap/SqcJG7pKT/Qa9sG/mck4CSvP8DdbpIj6lzXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560157; c=relaxed/simple;
	bh=kCtQgdNh0Ad+z9mlVSx/dvgIuoHfLaEqLlYAnSTqN+o=;
	h=Date:To:From:Subject:Message-Id; b=ECAtgXvRaLWWkdhZB/3T2+FLIWZInaykcT/9bsOJ/rGNvwXTgKdiLZUgFXmtog21WtpeFivHDnzTnERMeEdlH/9FM98IvmNgknRU0aIF+5tdfEvfmYaPUVigGcBQc1onX/A5lav8o8Up6nufW0CNLQ+NSVt9Xk52AbiRL090kbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ectAu9zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ectAu9zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A909C433F1;
	Thu, 22 Feb 2024 00:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560157;
	bh=kCtQgdNh0Ad+z9mlVSx/dvgIuoHfLaEqLlYAnSTqN+o=;
	h=Date:To:From:Subject:From;
	b=ectAu9zD8wH0951uT21eFx6JdkcRUK7P/0/uy9/UTQZu1Vmhw7aIu09FLzErqpOCh
	 bmsirNT5sW7VvX2gmQRQO/+2MPfCc5a3K0XVBkPCdlzv2HwjVVzAoh42Ihbspx5Hmj
	 Tp1txnL+zBqD1M+cLU8/5ipjIuOA3BlDWph/zV4U=
Date: Wed, 21 Feb 2024 16:02:36 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch removed from -mm tree
Message-Id: <20240222000237.6A909C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mrelease_test: conform test to TAP format output
has been removed from the -mm tree.  Its filename was
     selftests-mm-mrelease_test-conform-test-to-tap-format-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mrelease_test: conform test to TAP format output
Date: Fri, 2 Feb 2024 16:31:13 +0500

Conform the layout, informational and status messages to TAP.  No
functional change is intended other than the layout of output messages.

Link: https://lkml.kernel.org/r/20240202113119.2047740-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mrelease_test.c |   80 +++++++------------
 1 file changed, 33 insertions(+), 47 deletions(-)

--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-mrelease_test-conform-test-to-tap-format-output
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -26,19 +26,15 @@ static int alloc_noexit(unsigned long nr
 
 	buf = (char *)mmap(NULL, nr_pages * psize(), PROT_READ | PROT_WRITE,
 			   MAP_PRIVATE | MAP_ANON, 0, 0);
-	if (buf == MAP_FAILED) {
-		perror("mmap failed, halting the test");
-		return KSFT_FAIL;
-	}
+	if (buf == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed, halting the test: %s\n", strerror(errno));
 
 	for (i = 0; i < nr_pages; i++)
 		*((unsigned long *)(buf + (i * psize()))) = i;
 
 	/* Signal the parent that the child is ready */
-	if (write(pipefd, "", 1) < 0) {
-		perror("write");
-		return KSFT_FAIL;
-	}
+	if (write(pipefd, "", 1) < 0)
+		ksft_exit_fail_msg("write: %s\n", strerror(errno));
 
 	/* Wait to be killed (when reparenting happens) */
 	while (getppid() == ppid && timeout > 0) {
@@ -54,23 +50,17 @@ static int alloc_noexit(unsigned long nr
 /* The process_mrelease calls in this test are expected to fail */
 static void run_negative_tests(int pidfd)
 {
-	int res;
 	/* Test invalid flags. Expect to fail with EINVAL error code. */
 	if (!syscall(__NR_process_mrelease, pidfd, (unsigned int)-1) ||
 			errno != EINVAL) {
-		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
-		perror("process_mrelease with wrong flags");
-		exit(res);
+		ksft_exit_fail_msg("process_mrelease with wrong flags: %s\n", strerror(errno));
 	}
 	/*
 	 * Test reaping while process is alive with no pending SIGKILL.
 	 * Expect to fail with EINVAL error code.
 	 */
-	if (!syscall(__NR_process_mrelease, pidfd, 0) || errno != EINVAL) {
-		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
-		perror("process_mrelease on a live process");
-		exit(res);
-	}
+	if (!syscall(__NR_process_mrelease, pidfd, 0) || errno != EINVAL)
+		ksft_exit_fail_msg("process_mrelease on a live process: %s\n", strerror(errno));
 }
 
 static int child_main(int pipefd[], size_t size)
@@ -93,11 +83,18 @@ int main(void)
 	char byte;
 	int res;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	/* Test a wrong pidfd */
 	if (!syscall(__NR_process_mrelease, -1, 0) || errno != EBADF) {
-		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
-		perror("process_mrelease with wrong pidfd");
-		exit(res);
+		if (errno == ENOSYS) {
+			ksft_test_result_skip("process_mrelease not implemented\n");
+			ksft_finished();
+		} else {
+			ksft_exit_fail_msg("process_mrelease with wrong pidfd: %s",
+					   strerror(errno));
+		}
 	}
 
 	/* Start the test with 1MB child memory allocation */
@@ -107,16 +104,14 @@ retry:
 	 * Pipe for the child to signal when it's done allocating
 	 * memory
 	 */
-	if (pipe(pipefd)) {
-		perror("pipe");
-		exit(KSFT_FAIL);
-	}
+	if (pipe(pipefd))
+		ksft_exit_fail_msg("pipe: %s\n", strerror(errno));
+
 	pid = fork();
 	if (pid < 0) {
-		perror("fork");
 		close(pipefd[0]);
 		close(pipefd[1]);
-		exit(KSFT_FAIL);
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
 	}
 
 	if (pid == 0) {
@@ -134,28 +129,23 @@ retry:
 	res = read(pipefd[0], &byte, 1);
 	close(pipefd[0]);
 	if (res < 0) {
-		perror("read");
 		if (!kill(pid, SIGKILL))
 			waitpid(pid, NULL, 0);
-		exit(KSFT_FAIL);
+		ksft_exit_fail_msg("read: %s\n", strerror(errno));
 	}
 
 	pidfd = syscall(__NR_pidfd_open, pid, 0);
 	if (pidfd < 0) {
-		perror("pidfd_open");
 		if (!kill(pid, SIGKILL))
 			waitpid(pid, NULL, 0);
-		exit(KSFT_FAIL);
+		ksft_exit_fail_msg("pidfd_open: %s\n", strerror(errno));
 	}
 
 	/* Run negative tests which require a live child */
 	run_negative_tests(pidfd);
 
-	if (kill(pid, SIGKILL)) {
-		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
-		perror("kill");
-		exit(res);
-	}
+	if (kill(pid, SIGKILL))
+		ksft_exit_fail_msg("kill: %s\n", strerror(errno));
 
 	success = (syscall(__NR_process_mrelease, pidfd, 0) == 0);
 	if (!success) {
@@ -169,18 +159,15 @@ retry:
 		if (errno == ESRCH) {
 			retry = (size <= MAX_SIZE_MB);
 		} else {
-			res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
-			perror("process_mrelease");
 			waitpid(pid, NULL, 0);
-			exit(res);
+			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));
 		}
 	}
 
 	/* Cleanup to prevent zombies */
-	if (waitpid(pid, NULL, 0) < 0) {
-		perror("waitpid");
-		exit(KSFT_FAIL);
-	}
+	if (waitpid(pid, NULL, 0) < 0)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+
 	close(pidfd);
 
 	if (!success) {
@@ -188,11 +175,10 @@ retry:
 			size *= 2;
 			goto retry;
 		}
-		printf("All process_mrelease attempts failed!\n");
-		exit(KSFT_FAIL);
+		ksft_exit_fail_msg("All process_mrelease attempts failed!\n");
 	}
 
-	printf("Success reaping a child with %zuMB of memory allocations\n",
-	       size);
-	return KSFT_PASS;
+	ksft_test_result_pass("Success reaping a child with %zuMB of memory allocations\n",
+			      size);
+	ksft_finished();
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap-fix.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

