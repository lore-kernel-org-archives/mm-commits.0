Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A5C3403E6
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400521; cv=none; b=KhV1ku1b96yRTJfGLKNxuyQtA14NwwC1n0qi5K6mjcujLVdcJ6LkV2Sk4X+5ucz9Fnzj0woRPs2UGs2iokpBYBBpy2QeFHNq7mv4kGncksSqrYgH0SKfeLEDqkxqwVD6AkZDyN7EjARpx8gT5nd9oFsfVmn/bipDMEIxkIBf7to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400521; c=relaxed/simple;
	bh=UI4rYYYUAioU7uXshemogrZBMt1wgI3xMZO53bMyXm8=;
	h=Date:To:From:Subject:Message-Id; b=GEjBzK4Lv/TmLN5XECu0J8vO0Ay4VR40pTKxyYGmQeO1A7vAHhuex4QN07zZ/6Bq49CZg4MO+tVTsaajH/fgXyhrsN2RNuW92zKUMlu7hQqlnmoz+ME/chRv2VePS483ZK2OD3gnYFhOnnEe6msWenZfjj1qNCc0w7cUODVmk10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRwB6LkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRwB6LkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5A21F000E9;
	Thu, 21 May 2026 21:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400519;
	bh=qXAoKBmuiPG9sbxKORsAuIJDriKj/+ukOt8mWs/WTq8=;
	h=Date:To:From:Subject;
	b=YRwB6LkXf3kH1aKyCzsT3Ep5DyFdUQqCnFINrAYzM7wgG9Rh1ofiqUIMqfZpiMF3L
	 5OoY7olrabRVPQkhtUrlUSOeGD1SzGNdCAaCL7INuDSqR5TSK5PJcrrS6j98HsRlq6
	 F+ZgaoP+tomOpput6cGQi54bQN1dOO6V7pRcz2Ik=
Date: Thu, 21 May 2026 14:55:19 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch added to mm-new branch
Message-Id: <20260521215519.8F5A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch

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
Subject: selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Thu, 21 May 2026 12:17:46 +0530

The split_file_backed_thp() test mounts a tmpfs with a fixed size of "4m".
This works on systems with smaller PMD page sizes, but fails on
configurations where the PMD huge page size is larger (e.g.  16MB).

On such systems, the fixed 4MB tmpfs is insufficient to allocate even a
single PMD-sized THP, causing the test to fail.

Fix this by sizing the tmpfs dynamically based on the runtime
pmd_pagesize, allocating space for two PMD-sized pages.

Before patch:
  running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Failed to write data to testing file: Success (0)
  Bail out! Error occurred
   Planned tests != run tests (55 != 9)
   Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]

After patch:
  running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 10 File-backed THP split to order 0 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 11 File-backed THP split to order 1 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 12 File-backed THP split to order 2 test done
...
  ok 55 Split PMD-mapped pagecache folio to order 7 at
    in-folio offset 128 passed
   Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]
ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o

Link: https://lore.kernel.org/33e1bc10753fe82d1217613d8cd496020778cf2b.1779296493.git.sayalip@linux.ibm.com
Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -472,6 +472,8 @@ static void split_file_backed_thp(int or
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -491,7 +493,8 @@ static void split_file_backed_thp(int or
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
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

