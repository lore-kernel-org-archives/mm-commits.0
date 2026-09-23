Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593914279E0
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 18:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790189103; cv=none; b=SrnDHVW/BYfKo4jeEuT4FErC8zhp0iAI/Q5Ha+wh1++V4C4UoIPh9VD9Zi5RSoYocWOoYlF2y3ggt+ax0JNHzbt9Kyp76v4XuJPSpAQ+nKkbyE1Kg5XVJZGpyaUUOG3fapkw/i4j0GJn4erhYvUzi0pfLfbSoLI+Ku3zEwoDj2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790189103; c=relaxed/simple;
	bh=yHtA0vLXN+IJb7jy8delhkkjzwgZr6FjetlSuIct9ro=;
	h=Date:To:From:Subject:Message-Id; b=aEU5tXVYaTPEE+E1c975bPEKctBuGidjYPldvNUr7O+AyoHAz11NH2Vbu0Umsenaw+sU5Ire+NbBQLuXKo1v/L4yTKyMeZ1e3oBq5vOJxxexQS1GdcVeg+fvd5pomjMwq4rzzy8LPeHEt+ZPvqZvEAuGvxM5EH5uAneXFGO8sT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOG3hvU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOG3hvU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875CA1F00893;
	Wed, 23 Sep 2026 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790189093;
	bh=8+x5eLk+2dP6r49jlubhDu9o4sjc/PovWT6m/j3aC2c=;
	h=Date:To:From:Subject;
	b=qOG3hvU0+GtGKi2vDj0zOFQ+DBbOFS+KCdzhd6QmF/tr7QF4jgp2bBrlmHS+vUuUr
	 PN4rI7/2smeoKb8cNG54ex6GSE66w7/A/5WFUPt4qmn/7RY61NUqRxl1HWr1tSlavq
	 clolw9x/sdsxG9FeIsBf5GVoj7a26jXUjBllxTMU=
Date: Wed, 23 Sep 2026 11:44:53 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch removed from -mm tree
Message-Id: <20260923184453.875CA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: return fail when child test result is fail in khugepaged
has been removed from the -mm tree.  Its filename was
     kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: return fail when child test result is fail in khugepaged
Date: Mon, 21 Sep 2026 11:35:01 +0100

Patch series "kselftest: mm: fix intermittent failure khugepaged test", v2.

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before
wait_for_scan() is called, causing a sanity check that expects uncollapsed
pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them
again before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon.  This prevents khugepaged from
collapsing it again before c->collapse() is called.

Also, fix false-positive results when a child process fails in tests such
as collapse_fork*() or collapse_max_ptes_shared():

  # -------------------------
  # running ./khugepaged -s 2
  # -------------------------
  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

This failure was observed on NVIDIA Spark with 16KB page.


This patch (of 2):

Although the child process in collapse_fork*() or
collapse_max_ptes_shared() reports `KSFT_FAIL`, the result is ignored
because the test only checks whether the parent's page was collapsed into
a huge page.

As a result, the test is considered successful whenever the parent's page
is a huge page, even if the child test fails, as shown below:

  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

To address this, propagate the child's failure and skip the subsequent
check in the parent.

Link: https://lore.kernel.org/20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com
Link: https://lore.kernel.org/20260921-fix_khugepagd_fail-v2-1-3c2877beef61@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kirill A. Shutemov <kas@kernel.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand (ARM) <david@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1053,6 +1053,8 @@ static void collapse_fork(struct collaps
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
@@ -1060,6 +1062,7 @@ static void collapse_fork(struct collaps
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1100,6 +1103,8 @@ static void collapse_fork_compound(struc
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1107,6 +1112,7 @@ static void collapse_fork_compound(struc
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1158,6 +1164,8 @@ static void collapse_max_ptes_shared(str
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1165,6 +1173,7 @@ static void collapse_max_ptes_shared(str
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch

