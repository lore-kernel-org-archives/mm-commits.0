Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0C163A97;
	Mon, 17 Jun 2024 21:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718659935; cv=none; b=TflQ2xUvVJE8lgSApU+sSL38IqVrmjsjtUp4YFF5061NX9392T30qZ23q6jZ79jhNYV/FepHylOCP1UcWNBW1yqAs1kyvagagnxNaMxEXZk+8d/Q8BG1KWiYNfTeKClsSWHufanNMmiaE0ShiDOTnsaUGtR5jNFKf/jDBrG6+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718659935; c=relaxed/simple;
	bh=dLf7C3JFGXHWi01i/JiQQpLdrsEVFXdUhQbtKVlOkoE=;
	h=Date:To:From:Subject:Message-Id; b=ggB6f/16RRoMmyQ+Mg0EliXumlIzZwGJmluZiX0PFQQr3SsPGAg1DDRvnIjCQDdO1zc8vWvLcrIm0PmJ5lfObxd9fQTtBrJ62lLb6xrg/tTtnlYGe33OCmSzuManQ6qh8MVZ2Ul+RvfJENfxUZst/duazZYldiCd6YijVqS/+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rB5vukKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rB5vukKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E84C2BD10;
	Mon, 17 Jun 2024 21:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718659935;
	bh=dLf7C3JFGXHWi01i/JiQQpLdrsEVFXdUhQbtKVlOkoE=;
	h=Date:To:From:Subject:From;
	b=rB5vukKU8OmTWt8RwGv1zxy/cni8WNLRx2hyplmj1gLvvoHK8pN0evppKgbU01lIq
	 Mr/MQLRpPyOyENtGL000v25jsXbjw2xNkycNmj10VMCHNsEjQLLoIQzxayATQAsXKv
	 Tc2VbxhwlEF/TRceY8McXLLyfbawOoxkLWDaC1Nk=
Date: Mon, 17 Jun 2024 14:32:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,david@redhat.com,shechenglong001@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-test_prctl_fork_exec-return-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20240617213215.20E84C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm:fix test_prctl_fork_exec return failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-test_prctl_fork_exec-return-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-test_prctl_fork_exec-return-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-fix-test_prctl_fork_exec-return-failure.patch

