Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A70A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188182; cv=none; b=gctVKYsYp0/LxzNtAT6VAPn+04+n2lLZ4HzBNJ2JIfqC/j8rMHTVlMA0M3NPKKu+YVZiH9zsyj8x597Jhs97T+Pt88FErDLVpNOAO9vYHpzntjQ3LQLrPk2AIqWprkw+U5CauiSp1XKQCo0IvbJKOi+B6dFK1jAPlMEsUfWUMG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188182; c=relaxed/simple;
	bh=sm8Wde7ffA5iqGjJ5b4mJuuZRuAgP1Fur6bwe8LOvFk=;
	h=Date:To:From:Subject:Message-Id; b=GD4uw13gnWzyL4XsZyLLcy44P4xAKicz7uz/1Y06RKG27D+b9v3aE/xbOUCeQeVRtUQl1BuZKQ+UIRYhHGh5luWwgR4L/A3JRjLqbZIO3L6MOXDTZ2z3lYKfpTB9jUIHsaoWduqv8Gx9Qjmzne7n5c3OygARXeKUusw16McJ+84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K78Wlgi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K78Wlgi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C4C4CEEC;
	Mon, 17 Mar 2025 05:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188182;
	bh=sm8Wde7ffA5iqGjJ5b4mJuuZRuAgP1Fur6bwe8LOvFk=;
	h=Date:To:From:Subject:From;
	b=K78Wlgi4MvQ8MWbil2Xl6dd8gHIpO2+35V8hvhAMBRjCpoxtdIaY8ykZ3bU1E9Y3H
	 SukQlV2E22yH1nIpANM9Qz101KmYdIar4BGhKqZ82yMCNrLHW0HkF+2/OnV1XnhI5x
	 Q4pzAmBPcDeuMdPtdT4eYQ5LXdNyKKZYGf/o+F6Q=
Date: Sun, 16 Mar 2025 22:09:41 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch removed from -mm tree
Message-Id: <20250317050941.E19C4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: test splitting file-backed THP to any lower order
has been removed from the -mm tree.  Its filename was
     selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: test splitting file-backed THP to any lower order
Date: Wed, 22 Jan 2025 11:19:28 -0500

Now split_huge_page*() supports shmem THP split to any lower order.  Test
it.

The test now reads file content out after split to check if the split
corrupts the file data.

Link: https://lkml.kernel.org/r/20250122161928.1240637-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-test-splitting-file-backed-thp-to-any-lower-order
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -261,7 +261,7 @@ void split_pte_mapped_thp(void)
 	close(kpageflags_fd);
 }
 
-void split_file_backed_thp(void)
+void split_file_backed_thp(int order)
 {
 	int status;
 	int fd;
@@ -313,7 +313,7 @@ void split_file_backed_thp(void)
 	}
 
 	/* split the file-backed THP */
-	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end, 0);
+	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end, order);
 
 	/* check file content after split */
 	status = lseek(fd, 0, SEEK_SET);
@@ -351,7 +351,7 @@ void split_file_backed_thp(void)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
 
 	ksft_print_msg("Please check dmesg for more information\n");
-	ksft_test_result_pass("File-backed THP split test done\n");
+	ksft_test_result_pass("File-backed THP split to order %d test done\n", order);
 	return;
 
 close_file:
@@ -517,7 +517,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+8+2+9);
+	ksft_set_plan(1+8+1+9+9);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -534,7 +534,8 @@ int main(int argc, char **argv)
 			split_pmd_thp_to_order(i);
 
 	split_pte_mapped_thp();
-	split_file_backed_thp();
+	for (i = 0; i < 9; i++)
+		split_file_backed_thp(i);
 
 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
 			&fs_loc);
_

Patches currently in -mm which might be from ziy@nvidia.com are

xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

