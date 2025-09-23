Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7948D30ACF5
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758660812; cv=none; b=qppN7dF1IqSOaVrtw2aUeXl475tLRiChldHCAXP3Ml1maSv/pLxRhk/oFTqv9EBwche+K8hFjeEgwX6Ezx1tQ13BxYgGgP96a8RQaykkO36HgmiaXat0DLcq6muO89M9XUAj1r7QN3mqs2HnLpUFUAuNB9H0TPqJ8NTtF7wSFAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758660812; c=relaxed/simple;
	bh=wtuQvkw+dycF79+j0n6wiXkKBHRev/Dl/mLHXrTwXag=;
	h=Date:To:From:Subject:Message-Id; b=S9rylUg1w2YS2n7ukhWGe6HzXQ2skIhViw3el9iXPsXCeA/rP1H3KQL7EtwbF9i4LLU7Yf7SUL+5mQT8auxUG4tKl+yfhWUscGlxo2Gm/3xA49AIehdWKQo0Mc+7KJ+zShVqIaIr/hwqi2mCsrip9R9h4MRtdEGJey/X7YaMW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qhyPXg1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qhyPXg1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BBDC4CEF5;
	Tue, 23 Sep 2025 20:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758660812;
	bh=wtuQvkw+dycF79+j0n6wiXkKBHRev/Dl/mLHXrTwXag=;
	h=Date:To:From:Subject:From;
	b=qhyPXg1WzeWQ2z5wfYs3Tyg92hlXnBkEPfQb/yljU3GfhEu4USWy285wXDGg/vZuK
	 k6C51nBqDLbkPywtAsOe+x6rIuK5IAiD60V528x/jX51YS+BnDSzV3Mdk6NAyYr+lU
	 FTy4isOj/48oYr/BThyzp8/wQlqAm6bQpqo/Vjxg=
Date: Tue, 23 Sep 2025 13:53:31 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch added to mm-unstable branch
Message-Id: <20250923205331.E1BBDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add fork inheritance test for ksm_merging_pages counter
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests/mm: add fork inheritance test for ksm_merging_pages counter
Date: Wed, 24 Sep 2025 00:17:00 +0530

Add a new selftest to verify whether the `ksm_merging_pages` counter in
`mm_struct` is not inherited by a child process after fork.  This helps
ensure correctness of KSM accounting across process creation.

Link: https://lkml.kernel.org/r/e7bb17d374133bd31a3e423aa9e46e1122e74971.1758648700.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   43 +++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,46 @@ unmap:
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
+		goto unmap;
+	}
+
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		goto unmap;
+	}
+
+	status = WEXITSTATUS(status);
+	if (status) {
+		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
+		goto unmap;
+	}
+
+	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
+
+unmap:
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -620,7 +660,7 @@ static void init_global_file_handles(voi
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 8;
+	unsigned int tests = 9;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -652,6 +692,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
+	test_fork_ksm_merging_page_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-fix-double-free-in-register_one_node.patch
mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch
selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

