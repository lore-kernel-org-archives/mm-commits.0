Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EB951C4A
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029369; cv=none; b=RrK+T03OpWwwl20Cmff0Biom2pyime/YptvJl0X6H8nvQobEcZHRKsycV8vLCdPD5w0nsy20EoxVmroEPn6cDJEHCRHEDG208aTgYQkueMWFmvU/xAUh4F5OmJIX13ObWI6FMxEw0FQerhg1HxWLulgtO0Erhj6HvFI5OnWvoRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029369; c=relaxed/simple;
	bh=wog+Ygchlu7klkLXc/YzLvvvBWDZuTLd3A1eMtvg2B0=;
	h=Date:To:From:Subject:Message-Id; b=sG4f/rc5DBDMFJtELsNrz38STu27fFe4jEGllT+EBfp/Mn3Y/ftIYaJ5Bhy9C/IUOis6Imu7rzdHOX8q+UoUeG0kmTfEgSWlbr2EbACam8moGSy/vD+AuiTL8LC2vwmP/R5cuEXferVntagwir93ZqZ6mHEW9JqEKSjun9BGQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rDhCYTXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rDhCYTXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5448EC4CEE0;
	Tue, 28 Jan 2025 01:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738029369;
	bh=wog+Ygchlu7klkLXc/YzLvvvBWDZuTLd3A1eMtvg2B0=;
	h=Date:To:From:Subject:From;
	b=rDhCYTXiKzYz9nhMneZOCnfR12GcHoLSQj93CokyLpvKYpziH8MLcNVbMmpJgdGZR
	 hbIKcRPdwmnt8TM+70sp22wL7bFfaeqqmENT4YtZVJfKmRwwS6sAnOob4DNbgEaD0p
	 G0Ybn2LhccDHg83G0EYg0SH3vqeDWjcgyVxFNPh0=
Date: Mon, 27 Jan 2025 17:56:08 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch added to mm-unstable branch
Message-Id: <20250128015609.5448EC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: test splitting file-backed THP to any lower order.
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

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
Subject: selftests/mm: test splitting file-backed THP to any lower order.
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
Cc: Hugh Dickens <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org> [English fixes]
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

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

