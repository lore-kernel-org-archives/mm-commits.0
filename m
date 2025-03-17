Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FECDA59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188180; cv=none; b=B4LBou/4KNaZXG1hNyLfobdTKibQSsFmsF1Eg0wZp58O4owxLvFfC+0BMvHyG/g5Om4E21Cl+VVP6A7h/vWnk/rXRRaMe0Rfd97O4UzyRED2DNfV7xGsmbMzU8kI3qfl8qkojznqJtHO9NG00vWckdAjNFD0v7yGLIJ2sWUE8IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188180; c=relaxed/simple;
	bh=iuWQTAg2GMMDU3QKI4Fs1OVKrUaXOQnO5+cAAAb+x6s=;
	h=Date:To:From:Subject:Message-Id; b=oF1ocUDOONgA73R+L/2IfyyspsQWg0vVvmsULdG35GuYOznbeWRQod/+8EiL4sLTQ35zmKUBBlx+gIjQihfKmBPleMwsHUy6LgCd5vyMslTi9siyJNfV0u+isEu4fDmVQxXlQwpy6qzAZJQWvCbkXHkjmk5cMzEbU/cqdQ7x688=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BWDG0rYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BWDG0rYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDD4C4CEEC;
	Mon, 17 Mar 2025 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188179;
	bh=iuWQTAg2GMMDU3QKI4Fs1OVKrUaXOQnO5+cAAAb+x6s=;
	h=Date:To:From:Subject:From;
	b=BWDG0rYqz0yVpW7pyWcSxRzY1+JH2CL2ItKCWhBUpmbBiGhE0lDQAQ6Ntz60FBYM6
	 K0SzZ/dRoDmdLNGkWFjZQvuhcwd3rSPEMyxuUz5irupWnrKhnoXThO9t/vja0lTfZz
	 UubK7K9LUr+IOOiJ2PSkl+Zs2ZzxV3ZN87YeXz48=
Date: Sun, 16 Mar 2025 22:09:38 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch removed from -mm tree
Message-Id: <20250317050939.7CDD4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: make file-backed THP split work by writing PMD size data
has been removed from the -mm tree.  Its filename was
     selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: make file-backed THP split work by writing PMD size data
Date: Wed, 22 Jan 2025 11:19:26 -0500

Commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
changes huge=always to allocate THP/mTHP based on write size and
split_huge_page_test does not write PMD size data, so file-back THP is not
created during the test.  Fix it by writing PMD size data.

Link: https://lkml.kernel.org/r/20250122161928.1240637-1-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 tools/testing/selftests/mm/split_huge_page_test.c |   52 ++++++++++--
 1 file changed, 44 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -265,14 +265,28 @@ void split_file_backed_thp(void)
 {
 	int status;
 	int fd;
-	ssize_t num_written;
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	ssize_t num_written, num_read;
+	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
+	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	file_buf1 = (char *)malloc(pmd_pagesize);
+	file_buf2 = (char *)malloc(pmd_pagesize);
+
+	if (!file_buf1 || !file_buf2) {
+		ksft_print_msg("cannot allocate file buffers\n");
+		goto out;
+	}
+
+	for (i = 0; i < pmd_pagesize; i++)
+		file_buf1[i] = (char)i;
+	memset(file_buf2, 0, pmd_pagesize);
+
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
 
 	if (status)
@@ -281,26 +295,45 @@ void split_file_backed_thp(void)
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
 		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
+		goto cleanup;
 	}
 
-	fd = open(testfile, O_CREAT|O_WRONLY, 0664);
+	fd = open(testfile, O_CREAT|O_RDWR, 0664);
 	if (fd == -1) {
 		ksft_perror("Cannot open testing file");
 		goto cleanup;
 	}
 
-	/* write something to the file, so a file-backed THP can be allocated */
-	num_written = write(fd, tmpfs_loc, strlen(tmpfs_loc) + 1);
-	close(fd);
+	/* write pmd size data to the file, so a file-backed THP can be allocated */
+	num_written = write(fd, file_buf1, pmd_pagesize);
 
-	if (num_written < 1) {
-		ksft_perror("Fail to write data to testing file");
-		goto cleanup;
+	if (num_written == -1 || num_written != pmd_pagesize) {
+		ksft_perror("Failed to write data to testing file");
+		goto close_file;
 	}
 
 	/* split the file-backed THP */
 	write_debugfs(PATH_FMT, testfile, pgoff_start, pgoff_end, 0);
 
+	/* check file content after split */
+	status = lseek(fd, 0, SEEK_SET);
+	if (status == -1) {
+		ksft_perror("Cannot lseek file");
+		goto close_file;
+	}
+
+	num_read = read(fd, file_buf2, num_written);
+	if (num_read == -1 || num_read != num_written) {
+		ksft_perror("Cannot read file content back");
+		goto close_file;
+	}
+
+	if (strncmp(file_buf1, file_buf2, pmd_pagesize) != 0) {
+		ksft_print_msg("File content changed\n");
+		goto close_file;
+	}
+
+	close(fd);
 	status = unlink(testfile);
 	if (status) {
 		ksft_perror("Cannot remove testing file");
@@ -321,9 +354,12 @@ void split_file_backed_thp(void)
 	ksft_test_result_pass("File-backed THP split test done\n");
 	return;
 
+close_file:
+	close(fd);
 cleanup:
 	umount(tmpfs_loc);
 	rmdir(tmpfs_loc);
+out:
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
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

