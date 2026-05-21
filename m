Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D988933F5A7
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400523; cv=none; b=VI7J9BsO1ghpmUr4695Tuj53Q5b9UbJnEJSfevcqzT8DuKqzWY9EpXrr/8ZoBq3I2XpFHQB6/9OVd0yat7cLFcFS6nLQh4cx/p2rlACBCAxSGMQFdHCa9GQmqXxbaPDRsRmvG3hPFxYNjEOuNqBqelYEDe7A2KWOkf5nDTr5YFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400523; c=relaxed/simple;
	bh=cT3v3mPPWUc1NlGxvCa+B40a8LOhhZYVe5VR1N9yLGo=;
	h=Date:To:From:Subject:Message-Id; b=FdG8nXJo+JUXCqapbX9s6qD7qmwolg3aEqijYLnPKEJf01BPaqHXPP3XKY/6iWuBM2M3o1qdWHSA301aTgINnnHLqCaYvY4vXw+q67D/N+X6z4haEen6mVUQsg54QVVNrK9sZMLI4YLvW12NgRyRPQcPVI/mOZPpiAd+slCB2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZqzkdVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZqzkdVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0531F000E9;
	Thu, 21 May 2026 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400521;
	bh=Kze3+y/Nvbp4+JnXBWcy6pGcchDOPVyoNw8nll1xhNU=;
	h=Date:To:From:Subject;
	b=BZqzkdVLUJuikALXhKh1PW0poVcMLQWiwRFwBB6P3YYL4+hTSqCgYxLaskfj1VH1D
	 kK/6rBCAf3094k5i+Lqo0KIlyHa++H0SWrEG119/WqO+U6PSr9Cv4L5sPTAoanOh68
	 V4pDIegdfn4OdOttL4ea/QYZ0ww7cPrygZ+FLMJg=
Date: Thu, 21 May 2026 14:55:21 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch added to mm-new branch
Message-Id: <20260521215521.AE0531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
Date: Thu, 21 May 2026 12:17:47 +0530

Dynamically allocated buffers of PMD size for file-backed THP operations
(file_buf1 and file_buf2) were not freed on the success path and some
failure paths.  Since the function is called repeatedly in a loop for each
split order, this can cause significant memory leaks.

On architectures with large PMD sizes, repeated leaks could exhaust system
memory and trigger the OOM killer during test execution.

Ensure all allocated buffers are freed to maintain stable repeated test
runs.

Link: https://lore.kernel.org/060c673b376bbeeed2b1fb1d48a825e846654191.1779296493.git.sayalip@linux.ibm.com
Fixes: 035a112e5fd5 ("selftests/mm: make file-backed THP split work by writing PMD size data")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   22 ++++++++----
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -475,12 +475,15 @@ static void split_file_backed_thp(int or
 	unsigned long size = 2 * pmd_pagesize;
 	char opts[64];
 	ssize_t num_written, num_read;
-	char *file_buf1, *file_buf2;
+	char *file_buf1 = NULL, *file_buf2 = NULL;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	if (!tmpfs_loc)
+		ksft_exit_fail_msg("mkdtemp failed\n");
+
 	file_buf1 = (char *)malloc(pmd_pagesize);
 	file_buf2 = (char *)malloc(pmd_pagesize);
 
@@ -496,8 +499,10 @@ static void split_file_backed_thp(int or
 	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
-	if (status)
-		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
+	if (status) {
+		ksft_print_msg("Unable to create a tmpfs for testing\n");
+		goto out;
+	}
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
@@ -549,10 +554,13 @@ static void split_file_backed_thp(int or
 
 	status = umount(tmpfs_loc);
 	if (status) {
-		rmdir(tmpfs_loc);
-		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
+		ksft_print_msg("Unable to umount %s\n", tmpfs_loc);
+		goto out;
 	}
 
+	free(file_buf1);
+	free(file_buf2);
+
 	status = rmdir(tmpfs_loc);
 	if (status)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
@@ -565,8 +573,10 @@ close_file:
 	close(fd);
 cleanup:
 	umount(tmpfs_loc);
-	rmdir(tmpfs_loc);
 out:
+	free(file_buf1);
+	free(file_buf2);
+	rmdir(tmpfs_loc);
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

