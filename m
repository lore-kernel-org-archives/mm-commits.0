Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E6827293C
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739314991; cv=none; b=tSfRQY6GdwPveMmW/exbqlMtlPfZ8aFY0v9w7eTJ7almUH7vcHgf4OMP/tqs1uqr2a21JPomXzXWIsttKLzp5r3sWWiMfd6EGO5qzO8VLKdzE23EozlHdYRtE1Mf7vSyQrk2iHKBOw7N4AlMh3IJ/EDiPxiS32VH9Yo/B8BL7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739314991; c=relaxed/simple;
	bh=+pIaK2axmyCqbcnDgKpxjnRe+h0PqxAM1lxi42sujbs=;
	h=Date:To:From:Subject:Message-Id; b=Gl7/NJiJqezmOcNTsRD3k/IXoL/RpTW5/ZKfsNl48nt2hfdxTRe1nVsXLs879IUe3KFYqsgRhg/bXeYLGH/uyU65v7HlRQJbk38Sh90LDzXsWregLKvDAQx6S2EloJY+7C3WcNgwT/UGCYg1aLr5aBJ/Cj9LFLJk++rOyBclFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nk2IIDUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nk2IIDUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F72C4CEDD;
	Tue, 11 Feb 2025 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739314991;
	bh=+pIaK2axmyCqbcnDgKpxjnRe+h0PqxAM1lxi42sujbs=;
	h=Date:To:From:Subject:From;
	b=Nk2IIDUKgzH6oirYjrPV1j+gJTgYTr45a6uclP7HYbynC3Lad0BsnBKOGOwaGIbf2
	 ywvgKwQxY9L8aCr9LJhYUmp8chIM+7oHuY1AxLrxCOmlFnGFOOd1jI7D3/INOnAqGK
	 OY348sE9YYcU567dH3Tb0yczpJgVek2G/JupJisA=
Date: Tue, 11 Feb 2025 15:03:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch added to mm-unstable branch
Message-Id: <20250211230311.13F72C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add tests for folio_split(), buddy allocator like split.
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

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
Subject: selftests/mm: add tests for folio_split(), buddy allocator like split.
Date: Tue, 11 Feb 2025 10:50:33 -0500

It splits page cache folios to orders from 0 to 8 at different in-folio
offset.

Link: https://lkml.kernel.org/r/20250211155034.268962-9-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   34 +++++++++---
 1 file changed, 27 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -14,6 +14,7 @@
 #include <fcntl.h>
 #include <sys/mman.h>
 #include <sys/mount.h>
+#include <sys/param.h>
 #include <malloc.h>
 #include <stdbool.h>
 #include <time.h>
@@ -456,7 +457,8 @@ err_out_unlink:
 	return -1;
 }
 
-void split_thp_in_pagecache_to_order(size_t fd_size, int order, const char *fs_loc)
+void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
+		int order, int offset)
 {
 	int fd;
 	char *addr;
@@ -474,7 +476,12 @@ void split_thp_in_pagecache_to_order(siz
 		return;
 	err = 0;
 
-	write_debugfs(PID_FMT, getpid(), (uint64_t)addr, (uint64_t)addr + fd_size, order);
+	if (offset == -1)
+		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
+			      (uint64_t)addr + fd_size, order);
+	else
+		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
+			      (uint64_t)addr + fd_size, order, offset);
 
 	for (i = 0; i < fd_size; i++)
 		if (*(addr + i) != (char)i) {
@@ -493,9 +500,15 @@ out:
 	munmap(addr, fd_size);
 	close(fd);
 	unlink(testfile);
-	if (err)
-		ksft_exit_fail_msg("Split PMD-mapped pagecache folio to order %d failed\n", order);
-	ksft_test_result_pass("Split PMD-mapped pagecache folio to order %d passed\n", order);
+	if (offset == -1) {
+		if (err)
+			ksft_exit_fail_msg("Split PMD-mapped pagecache folio to order %d failed\n", order);
+		ksft_test_result_pass("Split PMD-mapped pagecache folio to order %d passed\n", order);
+	} else {
+		if (err)
+			ksft_exit_fail_msg("Split PMD-mapped pagecache folio to order %d at in-folio offset %d failed\n", order, offset);
+		ksft_test_result_pass("Split PMD-mapped pagecache folio to order %d at in-folio offset %d passed\n", order, offset);
+	}
 }
 
 int main(int argc, char **argv)
@@ -506,6 +519,7 @@ int main(int argc, char **argv)
 	char fs_loc_template[] = "/tmp/thp_fs_XXXXXX";
 	const char *fs_loc;
 	bool created_tmp;
+	int offset;
 
 	ksft_print_header();
 
@@ -517,7 +531,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+8+1+9+9);
+	ksft_set_plan(1+8+1+9+9+8*4+2);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -540,7 +554,13 @@ int main(int argc, char **argv)
 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
 			&fs_loc);
 	for (i = 8; i >= 0; i--)
-		split_thp_in_pagecache_to_order(fd_size, i, fs_loc);
+		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
+
+	for (i = 0; i < 9; i++)
+		for (offset = 0;
+		     offset < pmd_pagesize / pagesize;
+		     offset += MAX(pmd_pagesize / pagesize / 4, 1 << i))
+			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
 	cleanup_thp_fs(fs_loc, created_tmp);
 
 	ksft_finished();
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

