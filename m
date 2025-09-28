Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9003234BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085542; cv=none; b=kjSEM8Ixesp0PT4/sBoVwf4tyAh/WOm8cmfmzlUMkNrWUCmOT8Tz4ho2dNyQg/rD9hyav3xirsXvYwHBrUJ2KHInvbtFe3dv+Ntms1be8Xp5v+WLQvo6jOwmCnpULYKPzoj9gVsbDelZEzA2l4K8nVf/teBZEQSN/dca85yrvFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085542; c=relaxed/simple;
	bh=rVlzPXouc2q03kk8abrz36HksZe+D+iZPFYUei0EAlk=;
	h=Date:To:From:Subject:Message-Id; b=LfXY/a7WLixbs4Z2sXZKnzAllDu3NjVLJQI8x6mwmjSuhGmv+EuEYC+cbgaQTosWhW0M3V1CIvG5R0tQxA1H1WNYADRm6ikKyD/DW/Y6LQPiWsUg7/BSWuyIrtdJG8NROf8lhLb09NnvXXauA+5OGkQkSVCiOV9zXg6LAyNJjcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dt6dKUDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dt6dKUDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFD1C4CEF0;
	Sun, 28 Sep 2025 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085542;
	bh=rVlzPXouc2q03kk8abrz36HksZe+D+iZPFYUei0EAlk=;
	h=Date:To:From:Subject:From;
	b=dt6dKUDNp6GcxlQYHNfe4zzWyU4vMSp78Y5X/cb6hu56mcYmJSKHsXvU6W2XiZfTa
	 nsRl0hJGUV/wQmWnfmWFr6e3KkMt0F96s/wgbEVVszmqZlKMBVUWlJ0DmGNARYgt8B
	 Fs22s0NhvQLk1J7ctwTjkQqjmn8QD6kCSoB4JoCk=
Date: Sun, 28 Sep 2025 11:52:21 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch removed from -mm tree
Message-Id: <20250928185222.5CFD1C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add fork inheritance test for ksm_merging_pages counter
has been removed from the -mm tree.  Its filename was
     selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


