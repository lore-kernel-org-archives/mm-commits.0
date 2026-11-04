Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816829;
	b=dbRaaITW2x1LLXoqjU/5VtjVMoDWwIRtxWGvuIFtyZE5vg9gOaX2hIYSI+F0pArUI0MF
	 kUpiIdZ8aSJNx/ohT9AQIOKSvOp/TmrXj46Z8ECSuiUKXBYc/j5CW6WGqJdi768Kt4aoR
	 EmmXnknXGQ2tEQbtlcdNAxske8L+UO+7e65SFeQbM8hNl10Rl7GYNCw0eUlJ+P3kOyWPY
	 MnQHXzk6LsWiWKqc1zAvOJhG82ZbI2+XIOLN63j9j9+rEcmic3JO7LFPmYaqcsCqClL4l
	 qq2QZaqI6cPglMB5y9iqmgPA7GwMrvsG7p3oj6UgFy+TnIp2H+XNkT3u5Hkk1CHSICA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816829;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=c+eCYJ0SGnT9WcBaWmKTik1Yf39l7SG/UW+gt/Is+TU=;
	b=ApaYHG78hv9Er1Qr+DJJKZ2/rM3H8HTr67wz8qeLtFh0mkSrKR4nl11KRVc6TiwDpgCr
	 4JM6wd3GZchjkYpLHHfEHYs2BvQUBXHE8qqPvAc8LhJXc21gyhxokIQZBGsiTieFCYfIV
	 xYEaL0eiqqHDYlzMCT5UJdc8X76PrviCYVFg/pKrKpEcrdOIT5TWWCnuxDvBoW/f0UlWu
	 vqCBLl1nik83RK1YsvSa3YkaQyXp9DctInpPP0GzPV/su5ii7C27w1gDOPo3m4/hr2hNZ
	 uTp6tr6NyBJTkIhCb/YvYkVgwNS8N26VeLkC2jayuS6vZTxR3bZLSIUsTDtuyAX/Eug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oPXaU+1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2330B606A32C
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oPXaU+1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4331F000C1;
	Wed,  4 Nov 2026 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793816828;
	bh=c+eCYJ0SGnT9WcBaWmKTik1Yf39l7SG/UW+gt/Is+TU=;
	h=Date:To:From:Subject;
	b=oPXaU+1g8GvSczIAhzfJM0CRakkaUUyld/Suja3aepY7z5Kn3k+oQPsZxRUiSApea
	 WrDFpf8Tagl826VJRGThmjmmohsglxXgCZKR/WgZCkxI4W4U6eoitHMT/Lylg1gmyh
	 V4ILolHDSU+briHYqiVDRiIn6G1Idpce7mGaLa0s=
Date: Wed, 04 Nov 2026 10:27:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yeoreum.yun@arm.com,
	shuah@kernel.org,kas@kernel.org,david@kernel.org,ampr.mhd@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-handle-child-status-safely-in-khugepaged.patch added to mm-new branch
Message-Id: <20261104182708.AF4331F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: handle child status safely in khugepaged
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-handle-child-status-safely-in-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-handle-child-status-safely-in-khugepaged.patch

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
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: selftests/mm: handle child status safely in khugepaged
Date: Mon, 02 Nov 2026 22:21:30 +0330

collapse_fork(), collapse_fork_compound() and collapse_max_ptes_shared()
take the child result from WEXITSTATUS() without checking WIFEXITED(). 
For a child killed by a signal WEXITSTATUS() is 0, which is KSFT_PASS: the
parent runs its own checks and the test reports ok even though the child
crashed.

Fail the test when the child did not exit normally, and print the signal
that killed it.  Also fail when fork() fails, instead of reading an
uninitialised status.

Use get_child_status() in all four fork tests, and use wait_for_child() to
handle fork() and waitpid() in the three blocking-wait tests.

Link: https://lore.kernel.org/20261102185130.30504-1-ampr.mhd@gmail.com
Fixes: bd212a7dbdb1 ("kselftest: mm: return fail when child test result is fail in khugepaged")
Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |   61 +++++++++++++++++-----
 1 file changed, 48 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-handle-child-status-safely-in-khugepaged
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1006,9 +1006,44 @@ static void collapse_compound_extreme(st
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
-static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
+static int get_child_status(int wstatus)
+{
+	char buf[64];
+
+	if (WIFEXITED(wstatus))
+		return WEXITSTATUS(wstatus);
+
+	if (WIFSIGNALED(wstatus)) {
+		snprintf(buf, sizeof(buf), "Child killed by signal %d",
+			 WTERMSIG(wstatus));
+		fail(buf);
+	} else {
+		fail("Child terminated abnormally");
+	}
+
+	return KSFT_FAIL;
+}
+
+static int wait_for_child(pid_t pid)
 {
 	int wstatus;
+
+	if (pid < 0) {
+		fail("fork() failed");
+		return KSFT_FAIL;
+	}
+
+	if (waitpid(pid, &wstatus, 0) == -1) {
+		fail("waitpid() failed");
+		return KSFT_FAIL;
+	}
+
+	return get_child_status(wstatus);
+}
+
+static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
+{
+	pid_t pid;
 	void *p;
 
 	p = ops->setup_area(1);
@@ -1021,7 +1056,8 @@ static void collapse_fork(struct collaps
 		fail("Fail");
 
 	ksft_print_msg("Share small page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
@@ -1037,8 +1073,7 @@ static void collapse_fork(struct collaps
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1055,12 +1090,13 @@ out:
 
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
 {
-	int wstatus;
+	pid_t pid;
 	void *p;
 
 	p = alloc_hpage(ops);
 	ksft_print_msg("Share huge page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
@@ -1087,8 +1123,7 @@ static void collapse_fork_compound(struc
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1106,12 +1141,13 @@ out:
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
 {
 	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
-	int wstatus;
+	pid_t pid;
 	void *p;
 
 	p = alloc_hpage(ops);
 	ksft_print_msg("Share huge page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
@@ -1148,8 +1184,7 @@ static void collapse_max_ptes_shared(str
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1250,7 +1285,7 @@ static void collapse_fork_cow_race(struc
 	for (; i < n; i++)
 		ip[i * stride] = i + 0xbeef0000;
 	/* A child that died reading the racing pages is a failure, not a zero */
-	child_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
+	child_status = get_child_status(wstatus);
 
 	ksft_print_msg("Check the parent sees only its own writes...");
 	for (i = 0; i < n; i++)
_

Patches currently in -mm which might be from ampr.mhd@gmail.com are

selftests-mm-handle-child-status-safely-in-khugepaged.patch

