Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3173A7E0FF
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736564162; cv=none; b=CsBRdA60jJM97cYWe4BdH4s29Chk+/IuPboqTVkHIBzx5KNjmNTvF+K+eDO0nHpLtvQwDWcp/fXZuIKSQJAhBj84DSPyiRj3xT4Um9doVmHoOjNKK0V5Uy5GqE8aEUWQxGMYU4jt6bG1ZCsU35ABQVHw9yYLK7bcfBONXtMA56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736564162; c=relaxed/simple;
	bh=uBTSLZrLjrkmgFL4zBAuxiTRQzIbNnwgVPdJfAg1D2U=;
	h=Date:To:From:Subject:Message-Id; b=jLJd9ii8QXB/+8uwYBEMZXV8M1hjDI5opoRrV1kh35Vt4NmPXsF+bUFEdLiHlB/8fcFU/0tvlwdMRSDrPic7rO0D2z9JKlfGwUOQN7XZn7bl2Wue+zSClXsWy46+p2nYWasq+JIAIc5PnZLOwFFFCAmZ6D3vX3YkbPbAYsPoCL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJBSQTGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJBSQTGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87386C4CED6;
	Sat, 11 Jan 2025 02:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736564161;
	bh=uBTSLZrLjrkmgFL4zBAuxiTRQzIbNnwgVPdJfAg1D2U=;
	h=Date:To:From:Subject:From;
	b=AJBSQTGJ8uy/Vgdbovy4bPd+kqVJWzy0cNhp5msmIQ1m+cEQ4opkgkIxT9FXZ69d/
	 vQxhtXsUDuaTUBIvzr8lufZRP5CBscR9T6wKL7XNf+ESLOPPtfRE+s+Lx7gPa7F60A
	 VWmlo32XO++ICyt3ENoSReWxg4jJF+LEXF/4B7Bg=
Date: Fri, 10 Jan 2025 18:56:00 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-selftests-framework-to-print-test-result.patch added to mm-unstable branch
Message-Id: <20250111025601.87386C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use selftests framework to print test result
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-selftests-framework-to-print-test-result.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-selftests-framework-to-print-test-result.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: use selftests framework to print test result
Date: Fri, 10 Jan 2025 18:50:27 -0500

Otherwise the number of tests does not match the reality.

Link: https://lkml.kernel.org/r/20250110235028.96824-1-ziy@nvidia.com
Fixes: 391e86971161 ("mm: selftest to verify zero-filled pages are mapped to zeropage")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   34 ++++--------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-use-selftests-framework-to-print-test-result
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -108,38 +108,28 @@ static void verify_rss_anon_split_huge_p
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
-		printf("No THP is allocated\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
-	if (!rss_anon_before) {
-		printf("No RssAnon is allocated before split\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!rss_anon_before)
+		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
 
 	for (i = 0; i < len; i++)
-		if (one_page[i] != (char)0) {
-			printf("%ld byte corrupted\n", i);
-			exit(EXIT_FAILURE);
-		}
+		if (one_page[i] != (char)0)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
-	if (!check_huge_anon(one_page, 0, pmd_pagesize)) {
-		printf("Still AnonHugePages not split\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!check_huge_anon(one_page, 0, pmd_pagesize))
+		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
 	rss_anon_after = rss_anon();
-	if (rss_anon_after >= rss_anon_before) {
-		printf("Incorrect RssAnon value. Before: %ld After: %ld\n",
+	if (rss_anon_after >= rss_anon_before)
+		ksft_exit_fail_msg("Incorrect RssAnon value. Before: %ld After: %ld\n",
 		       rss_anon_before, rss_anon_after);
-		exit(EXIT_FAILURE);
-	}
 }
 
 void split_pmd_zero_pages(void)
@@ -150,7 +140,7 @@ void split_pmd_zero_pages(void)
 
 	one_page = allocate_zero_filled_hugepage(len);
 	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
-	printf("Split zero filled huge pages successful\n");
+	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
 }
 
@@ -491,7 +481,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(3+9);
+	ksft_set_plan(4+9);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-use-selftests-framework-to-print-test-result.patch
selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

