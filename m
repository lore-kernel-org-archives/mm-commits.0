Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50489248881
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821849; cv=none; b=F5IuLXWgmFuipiiBUyh2XsEipCQP8RJZtSjxvOrxEyGE7MpzuSA9slOQ6DbvsOm2nwOc6J3hQV8gFEpOYKrFaVxN7o4jGP8goOB1sGBwFWKMTr3ybZj+tqWoTkoDrsvV+OmISxmRcxh0SzeBhVNjKpA5wbyqJiHg2VYp3f3np3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821849; c=relaxed/simple;
	bh=rtkxtMOF1hLI54ezw5UlOeys2EAW3OC4MBR0lV70KKQ=;
	h=Date:To:From:Subject:Message-Id; b=kSBWrBLQuwzlNhstAkiXC3gijDCjTpFe7O1qBlPxLMm2iGYiwT11yQlHFuoFrtsPCrA0wkw6rIOC4Im/uTT53U99+OKxwfpVM3CUIftDd4q0mcXr0Jw+zrl30BadzAIkbFGZTzOiPJw9K3Q0U782Y25sIBNddXmyRlD07CfmSAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q6XoGV1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q6XoGV1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B9BC4CEEF;
	Tue, 29 Jul 2025 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821848;
	bh=rtkxtMOF1hLI54ezw5UlOeys2EAW3OC4MBR0lV70KKQ=;
	h=Date:To:From:Subject:From;
	b=Q6XoGV1emmfBIPf01+BvQH5D9+SoLqmeSLoFla43LXiTGcdN/R8kEuTNf7wdz+sfy
	 AzGWje5MM0b2iBga3QN2ecgCMPVCj60k0qgiJY+0DJRHfeCzXg3fLeO6ijPEhxi6O8
	 HU+H9Dp8eyM/GNHB1ACmVQy165kTV5idUXWmgIHg=
Date: Tue, 29 Jul 2025 13:44:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch added to mm-new branch
Message-Id: <20250729204408.D6B9BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/selftests: fix split_huge_page_test failure on systems with 64KB page size
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

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
Subject: mm/selftests: fix split_huge_page_test failure on systems with 64KB page size
Date: Tue, 29 Jul 2025 11:04:00 +0530

The split_huge_page_test fails on systems with a 64KB base page size. 
This is because the order of a 2MB huge page is different:

On 64KB systems, the order is 5.

On 4KB systems, it's 9.

The test currently assumes a maximum huge page order of 9, which is only
valid for 4KB base page systems.  On systems with 64KB pages, attempting
to split huge pages beyond their actual order (5) causes the test to fail.

In this patch, we calculate the huge page order based on the system's base
page size.  With this change, the tests now run successfully on both 64KB
and 4KB page size systems.

Link: https://lkml.kernel.org/r/20250729053403.1071807-5-aboorvad@linux.ibm.com
Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   23 +++++++-----
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -36,6 +36,7 @@ uint64_t pmd_pagesize;
 
 #define PFN_MASK     ((1UL<<55)-1)
 #define KPF_THP      (1UL<<22)
+#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
 int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
 {
@@ -522,6 +523,9 @@ int main(int argc, char **argv)
 	const char *fs_loc;
 	bool created_tmp;
 	int offset;
+	unsigned int max_order;
+	unsigned int nr_pages;
+	unsigned int tests;
 
 	ksft_print_header();
 
@@ -533,35 +537,38 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+8+1+9+9+8*4+2);
-
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
 	pmd_pagesize = read_pmd_pagesize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
+	nr_pages = pmd_pagesize / pagesize;
+	max_order = GET_ORDER(nr_pages);
+	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
+	ksft_set_plan(tests);
+
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
 
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		if (i != 1)
 			split_pmd_thp_to_order(i);
 
 	split_pte_mapped_thp();
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		split_file_backed_thp(i);
 
 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
 			&fs_loc);
-	for (i = 8; i >= 0; i--)
+	for (i = max_order - 1; i >= 0; i--)
 		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
 
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		for (offset = 0;
-		     offset < pmd_pagesize / pagesize;
-		     offset += MAX(pmd_pagesize / pagesize / 4, 1 << i))
+		     offset < nr_pages;
+		     offset += MAX(nr_pages / 4, 1 << i))
 			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
 	cleanup_thp_fs(fs_loc, created_tmp);
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

