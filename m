Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877C18628F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006301; cv=none; b=K5Fmh5g/HjtxxiNAcOJcvirgjhPPYPgw7zlf7lecdQCUReGuVpGz5RV7goagXemEhh+tqLmLCSukeWhUswe7CZCBVwaMOWXU9Hma2vwDlmVZxheuqlLy8342UjlMoVWSRTlHGSGgVqc8Dj7k7wspCV8aM0te0cGKXufKdRJyI1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006301; c=relaxed/simple;
	bh=WU4gdHHbZsSV/N3nsnMOOeSqkbFVL13btLiInHgdoXE=;
	h=Date:To:From:Subject:Message-Id; b=dB2LK9W3aXT1W4mYlGvhf69Hh7eBSrxfQH9dMASB1C6PKkOzl/22NLiPeAdqLj9lxRj6lILjEPLsTHBeTgTvAMm8BJq4qr0gnAMxHfzfuOgu+rjaNEudicNcj62x/dDoVCWL3AuBVj+KaQ747l3JePmVRe0ICNFjKG0fjKgM0LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=An25f9HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="An25f9HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63BC4CED6;
	Thu, 16 Jan 2025 05:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006300;
	bh=WU4gdHHbZsSV/N3nsnMOOeSqkbFVL13btLiInHgdoXE=;
	h=Date:To:From:Subject:From;
	b=An25f9HQJcELXnqxzIYFfZpOuwiMl6mq1bBTSaMtsgJ22qmRnVeiENMlC3k7whWE/
	 rHi/UR3gInRkLcr+jwGueCBv3Dxeg/tdYH3+ZDWlHFep+Z/54GDIZe+RzwR3p+v5Bq
	 z1SR/S5j9yUfL/u0yAU37DZCxhle9QY2WUbepFVM=
Date: Wed, 15 Jan 2025 21:45:00 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch removed from -mm tree
Message-Id: <20250116054500.CF63BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add tests for splitting pmd THPs to all lower orders
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add tests for splitting pmd THPs to all lower orders
Date: Fri, 10 Jan 2025 18:50:28 -0500

Kernel already supports splitting a folio to any lower order. Test it.

[ziy@nvidia.com: no need to test splitting to order-1]
 Link: https://lkml.kernel.org/r/DDA202EA-4664-4F50-A7FD-B00CBB7A624B@nvidia.com
Link: https://lkml.kernel.org/r/20250110235028.96824-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   14 +++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -144,7 +144,7 @@ void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
-void split_pmd_thp(void)
+void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
@@ -164,7 +164,7 @@ void split_pmd_thp(void)
 
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		(uint64_t)one_page + len, 0);
+		(uint64_t)one_page + len, order);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)i)
@@ -174,7 +174,7 @@ void split_pmd_thp(void)
 	if (!check_huge_anon(one_page, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
-	ksft_test_result_pass("Split huge pages successful\n");
+	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
 	free(one_page);
 }
 
@@ -481,7 +481,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(4+9);
+	ksft_set_plan(1+8+2+9);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -492,7 +492,11 @@ int main(int argc, char **argv)
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
-	split_pmd_thp();
+
+	for (i = 0; i < 9; i++)
+		if (i != 1)
+			split_pmd_thp_to_order(i);
+
 	split_pte_mapped_thp();
 	split_file_backed_thp();
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


