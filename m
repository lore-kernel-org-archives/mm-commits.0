Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7270D1E520C
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755322020; cv=none; b=PVXRew7Y+ACbnavvwmYGZv5jwJbq24cxki60V2gBrARVm5vjT8VN75bWwDVvckEOCKkqRwV9zcdxLOnFxAfetMVCOd/FKW5tZdkSrzsKI3QFriXtWGMSvBOcHAbtI9i5ncgu+toKaTajj8NkfIUP0BEVwD/jBUejPSSfSP8kSIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755322020; c=relaxed/simple;
	bh=kFEmGKBwlcfz3/lMd2MVjd2YKiJYUZXUewPEXhg+dXw=;
	h=Date:To:From:Subject:Message-Id; b=Lt1EkRd9DrNtBJq6gFQlF59IDaNdYN13356XXZxmCR7BnfAxym3B0ut4AyEEf7p1/JEZWkIiezBH9M8FdACax1Irg2h1xgB//eD9Si4fSO9Wb9jdpJTSM+QbN6tbn11aEwkyxGPnYWrCVd906aiHa8lHDqCkDRuEWzR9eX03PEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YrweBO5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YrweBO5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17D0C4CEEF;
	Sat, 16 Aug 2025 05:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322020;
	bh=kFEmGKBwlcfz3/lMd2MVjd2YKiJYUZXUewPEXhg+dXw=;
	h=Date:To:From:Subject:From;
	b=YrweBO5D0fxPoMSyJ0C8qXTiEFqoNGzW7WDs9Uhyjv0BQUBatkcYpJ+1gdWBpqfWv
	 JpkXRtp3muWiM48QkYr7HeoLFgXmGl1flnV3qa29Z8712b5Pzi6/BXpp/DOWq27JQR
	 KxRmzmXGw7NhZ5Vbf3PxDF13Y/0Zr+YwyfBeVrxg=
Date: Fri, 15 Aug 2025 22:26:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch added to mm-new branch
Message-Id: <20250816052659.E17D0C4CEEF@smtp.kernel.org>
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
Date: Sat, 16 Aug 2025 09:31:10 +0530

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

Link: https://lkml.kernel.org/r/20250816040113.760010-5-aboorvad@linux.ibm.com
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c                  |    5 --
 tools/testing/selftests/mm/split_huge_page_test.c |   22 +++++++-----
 tools/testing/selftests/mm/uffd-wp-mremap.c       |    5 --
 tools/testing/selftests/mm/vm_util.h              |    5 ++
 4 files changed, 19 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size
+++ a/tools/testing/selftests/mm/cow.c
@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
--- a/tools/testing/selftests/mm/split_huge_page_test.c~mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -523,6 +523,9 @@ int main(int argc, char **argv)
 	const char *fs_loc;
 	bool created_tmp;
 	int offset;
+	unsigned int max_order;
+	unsigned int nr_pages;
+	unsigned int tests;
 
 	ksft_print_header();
 
@@ -534,35 +537,38 @@ int main(int argc, char **argv)
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
+	max_order =  sz2ord(pmd_pagesize);
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
 
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,11 +19,6 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
--- a/tools/testing/selftests/mm/vm_util.h~mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -127,6 +127,11 @@ static inline void log_test_result(int r
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+static inline int sz2ord(size_t size)
+{
+	return __builtin_ctzll(size / getpagesize());
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

