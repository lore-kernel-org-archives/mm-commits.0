Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7F618892D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006299; cv=none; b=phHaArkA+3cgeGabeb4Bys+9aPhhOERZDlvbBh3vJamOOgfyRcR8zLtnY9qBGQ2tvSW+hPwVc5Ddr9s3yPxd4iVpsltwhuCylWXCcDFt1MuC4jOIDsBp0zm0PSFtc3h/JZ4PkwW0wotujcHcTQwSFkWunrgAGu0RnLj5Ghpc1EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006299; c=relaxed/simple;
	bh=XFNxgTLm67zI8m/fNhPPdZfh4AuNKkaAq+rhP6VX834=;
	h=Date:To:From:Subject:Message-Id; b=T17YBiRyMbGPPSPRra/r75vVR/8fkwvDTHyrsafHg1PalJq9WjlfGMp0JdJBR9TUPIIYvtRFx09DiA6vipgtR0zAeGCYSCpwyTAeDekjRztAFkT83bSeJtRO/XjvjiTuBlPb+NmARRDqK4nGCJ0y22+Hg1uM4Y+MW9kCOfWWgyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PLiDAr8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PLiDAr8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FF2C4CED6;
	Thu, 16 Jan 2025 05:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006299;
	bh=XFNxgTLm67zI8m/fNhPPdZfh4AuNKkaAq+rhP6VX834=;
	h=Date:To:From:Subject:From;
	b=PLiDAr8Wc6ed0LdY8CDpvfxI9hlY/+JMV41H9Xes5PDgxcIvjoXH9u9xI/my3ZJeS
	 rOUlLfuDw4um5RhyKo/GvAlKVp8lDUGYOIBQJ+p70ugBLumIQCX8M4/0d41Apg1img
	 AC5Z3qAqPKy22bA7KtGmB9pfy/fDvyvUo/VSao9o=
Date: Wed, 15 Jan 2025 21:44:58 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-selftests-framework-to-print-test-result.patch removed from -mm tree
Message-Id: <20250116054459.11FF2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use selftests framework to print test result
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-selftests-framework-to-print-test-result.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
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


