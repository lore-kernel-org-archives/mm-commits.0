Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338942DCBF7
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979908; cv=none; b=szsDWa3y8K0b7PcZB/NomrNYkpVMZfYaxKXT4fFA1+T5rqiIdwr/6RqOZulL1kiFYUCPOh/NQFLfqyIfug08rCcYc4QaEz2Gv/qFbXQ6t2EDJM+9oF2/RLwFBDA0dpxZf3vms9s8nrP+POvbGHOOLHStET7Ieg1FJ9wxHYR8FmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979908; c=relaxed/simple;
	bh=DLUGH563v+SxLDiFbVk3SrB1RDl0STH8+N2qWzuOxtc=;
	h=Date:To:From:Subject:Message-Id; b=l3WAyfRbkmU+uJ3h30TF74iL0LICNAR9ZeKFnIVGUcvUS0qtbRCZqDWraAYkkZvOuxBTafjo25O50/CNAP+F2vAFYDO94DfFMc8xydGwLoFYxmbeIkatQWphBUd5nX5aSnGcgLQbjQ+AyglRybpiATlXNFWxBv0lW2HGnHIZA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLqCylGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLqCylGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2CDC4CEF5;
	Mon, 15 Sep 2025 23:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757979907;
	bh=DLUGH563v+SxLDiFbVk3SrB1RDl0STH8+N2qWzuOxtc=;
	h=Date:To:From:Subject:From;
	b=DLqCylGlG+gDqq7p8/xbDnjUF3QAt28KoIsMn7RkhbgiLiGzHCtgNJJ7yecJuVxr1
	 L5XHlMiNdB86/sGb3sh1icBFHc2urRj3efVDhKP2QOn/NcOI9aED4I61i5glpbAj3L
	 HcFj/3PiW+Xswq1FlSjEHze9bH2Hlr+r6aHNYtCs=
Date: Mon, 15 Sep 2025 16:45:07 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch added to mm-new branch
Message-Id: <20250915234507.AB2CDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: added fork test to verify global ksm_zero_pages counter behavior
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch

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
Subject: selftests/mm: added fork test to verify global ksm_zero_pages counter behavior
Date: Mon, 15 Sep 2025 20:33:06 +0530

Added a selftest to verify the behavior of the global KSM zero-page
counter during fork.  When a process forks, the per-process zero-page
counter is inherited by the child, and the global counter should be
updated with this inherited value.  This test ensures that the global
counter is correctly updated after fork.

Link: https://lkml.kernel.org/r/5910cb6bfc7c43b169b679a0108667a56d7ebdb8.1757946863.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   74 +++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,77 @@ unmap:
 	munmap(map, size);
 }
 
+long ksm_get_global_ksm_zero_pages(void)
+{
+	int global_ksm_zero_pages_fd;
+	char buf[10];
+	ssize_t ret;
+
+	global_ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/ksm_zero_pages",
+								O_RDONLY);
+	if (global_ksm_zero_pages_fd < 0)
+		return -errno;
+
+	ret = pread(global_ksm_zero_pages_fd, buf, sizeof(buf) - 1, 0);
+	close(global_ksm_zero_pages_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+static void test_fork_global_ksm_zero_pages_count(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	pid_t child_pid;
+	int status;
+	long g_zpages_before = 0, g_zpages_after = 0;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	/* Unmerge all pages before test */
+	if (ksm_stop() < 0) {
+		ksft_test_result_fail("KSM unmerging failed\n");
+		return;
+	}
+	/* Get the global zero page count before test */
+	g_zpages_before = ksm_get_global_ksm_zero_pages();
+	/* Let KSM deduplicate zero pages. */
+	map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
+	if (map == MAP_FAILED)
+		return;
+
+	child_pid = fork();
+	if (!child_pid) {
+		exit(ksm_stop());
+	} else if (child_pid < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		return;
+	}
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		return;
+	}
+	status = WEXITSTATUS(status);
+	if (status < 0) {
+		ksft_test_result_fail("KSM unmerging failed in child\n");
+		return;
+	}
+
+	/* Verify global zero-page count remains unchanged */
+	g_zpages_after = ksm_get_global_ksm_zero_pages();
+	if (g_zpages_before != g_zpages_after) {
+		ksft_test_result_fail("Incorrect global ksm zero page count after fork\n");
+		return;
+	}
+
+	ksft_test_result_pass("Global ksm zero page count is correct after fork\n");
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void test_fork_ksm_merging_page_count(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -659,7 +730,7 @@ static void init_global_file_handles(voi
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -692,6 +763,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_fork_global_ksm_zero_pages_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch
selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch
selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch

