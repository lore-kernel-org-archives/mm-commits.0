Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA51673448;
	Tue, 25 Jun 2024 03:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287562; cv=none; b=uFQOkc0An7qct9r9ePCxM9++IFYQaxEguSpqleUp5jc6w7vIdxoSRoLQAFz/N17EBXiIPiIqRcUF/DrQ2mpoFWLFqeGIoNPh+5WpJGooR/9mkquRSMIhIMQ4JT0ldCe/yIqQOaWrHguM+U1okWOxyn/4ZKsqV6Y9J96hjAZYyLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287562; c=relaxed/simple;
	bh=NlaITtq1XinK2e0d3kZur4xidyZ5OIfxoIw0P7aj/+A=;
	h=Date:To:From:Subject:Message-Id; b=mUo5Pp6FfeU7oTwZttTYf6eVajC4pIBPcyg9ypNnjTTpF08Niki2e3xqaMzo/laBRvDpKPYDw2wLk8KDuhG9nlIuxb0fYs4zVX3us4nJOoSz/BjgV7G1pZbermjb3m8QMoW8OyGF2MIIisO8Nqu9Q8F9rtwqkJqjP/6naH+RvSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jh4J4EcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jh4J4EcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5800EC32782;
	Tue, 25 Jun 2024 03:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287562;
	bh=NlaITtq1XinK2e0d3kZur4xidyZ5OIfxoIw0P7aj/+A=;
	h=Date:To:From:Subject:From;
	b=Jh4J4EcYllLwCdlFfdai2ERqYdH3Xc4cShBqiXTR+4PkzphyD/iJ+g/lXe5diR+/S
	 OfQAoRu03pvWHM+scHLFF2irMyzSdzEJ3WTDyWqRKkyPJnNU1TmDIsG5gK/rZ01I98
	 5aYxapZVl50S7RW/xjJXK0zEG3BBrnAwap7gwbkw=
Date: Mon, 24 Jun 2024 20:52:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,david@redhat.com,shechenglong001@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-test_prctl_fork_exec-return-failure.patch removed from -mm tree
Message-Id: <20240625035242.5800EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm:fix test_prctl_fork_exec return failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-test_prctl_fork_exec-return-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: aigourensheng <shechenglong001@gmail.com>
Subject: selftests/mm:fix test_prctl_fork_exec return failure
Date: Mon, 17 Jun 2024 01:29:34 -0400

After calling fork() in test_prctl_fork_exec(), the global variable
ksm_full_scans_fd is initialized to 0 in the child process upon entering
the main function of ./ksm_functional_tests.

In the function call chain test_child_ksm() -> __mmap_and_merge_range ->
ksm_merge-> ksm_get_full_scans, start_scans = ksm_get_full_scans() will
return an error.  Therefore, the value of ksm_full_scans_fd needs to be
initialized before calling test_child_ksm in the child process.

Link: https://lkml.kernel.org/r/20240617052934.5834-1-shechenglong001@gmail.com
Signed-off-by: aigourensheng <shechenglong001@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   38 ++++++------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-fix-test_prctl_fork_exec-return-failure
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -656,12 +656,33 @@ unmap:
 	munmap(map, size);
 }
 
+static void init_global_file_handles(void)
+{
+	mem_fd = open("/proc/self/mem", O_RDWR);
+	if (mem_fd < 0)
+		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
+	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
+	if (ksm_full_scans_fd < 0)
+		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+						O_RDONLY);
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+}
+
 int main(int argc, char **argv)
 {
 	unsigned int tests = 8;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
+		init_global_file_handles();
 		exit(test_child_ksm());
 	}
 
@@ -674,22 +695,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	mem_fd = open("/proc/self/mem", O_RDWR);
-	if (mem_fd < 0)
-		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
-	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
-	if (ksm_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
-	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
-	if (ksm_full_scans_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
-	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-	if (pagemap_fd < 0)
-		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
-	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
-					      O_RDONLY);
-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	init_global_file_handles();
 
 	test_unmerge();
 	test_unmerge_zero_pages();
_

Patches currently in -mm which might be from shechenglong001@gmail.com are


