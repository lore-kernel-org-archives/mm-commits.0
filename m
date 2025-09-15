Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9232E2DC348
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 23:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979906; cv=none; b=KTi+i4i+NKJ569jp2oJsatkjAXsvYElrIuQ7m1FmXms2FzM0JdIi2zCrY/2UB5x7eEczh9og5aSVrWlMRgjrqZNKiYbD6XkD5Q/zRrZWZnyX3zivVDgJbGITa4EYGhLMc1IxUh5mG25agCVE2P1cBODEOmnU9912MR0xC7EvZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979906; c=relaxed/simple;
	bh=MRIow+HN1oD1310t0rESYZD8em9OKe8AtovAEgem8HE=;
	h=Date:To:From:Subject:Message-Id; b=Y5wnnum11jqxHUtjcKb8dfbUU9QUHg8j37DU1a1Bv5dOoJb5Kbj/OE81Yfrkq0++WJEjDqIWOJgMi/MNlLM8iBafk6ZU/rPrYXCn6rDfOwzA6XD8kkiRckULjEucvYJwnL4GJ/Jq/ReHV5aY49JPN+4TreGrk54SFKnEfKjbaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+yLDak4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+yLDak4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE00C4CEF1;
	Mon, 15 Sep 2025 23:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757979906;
	bh=MRIow+HN1oD1310t0rESYZD8em9OKe8AtovAEgem8HE=;
	h=Date:To:From:Subject:From;
	b=M+yLDak4mPWh9SpJR82G8R0XHp9OXdNeeAx++/g3vlv7F7JlQkX+8++q5+22eFhmh
	 CZBmkeqvS+SO6kaptJJMFCzZyxHAlQRXMDCDtwfJYqcdLwrLlOS7KvJIAeofzcoAGu
	 Plb/od6ukgWZ0vsQZ2bwN0UvUxILwwmSyddxhf7c=
Date: Mon, 15 Sep 2025 16:45:05 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch added to mm-new branch
Message-Id: <20250915234506.3BE00C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: added fork inheritance test for ksm_merging_pages counter
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

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
Subject: selftests/mm: added fork inheritance test for ksm_merging_pages counter
Date: Mon, 15 Sep 2025 20:33:05 +0530

Add a new selftest to verify whether the `ksm_merging_pages` counter in
`mm_struct` is not inherited by a child process after fork.  This helps
ensure correctness of KSM accounting across process creation.

Link: https://lkml.kernel.org/r/f07c901d4b6b1d1c15a8c1bbd324367d6135d0a3.1757946863.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   42 +++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,45 @@ unmap:
 	munmap(map, size);
 }
 
+static void test_fork_ksm_merging_page_count(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	pid_t child_pid;
+	int status;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
+	if (map == MAP_FAILED)
+		return;
+
+	child_pid = fork();
+	if (!child_pid) {
+		init_global_file_handles();
+		exit(ksm_get_self_merging_pages());
+	} else if (child_pid < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		return;
+	}
+
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		return;
+	}
+
+	status = WEXITSTATUS(status);
+	if (status) {
+		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
+		return;
+	}
+
+	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
+
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -620,7 +659,7 @@ static void init_global_file_handles(voi
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 8;
+	unsigned int tests = 9;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -652,6 +691,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
+	test_fork_ksm_merging_page_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch
selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch
selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch

