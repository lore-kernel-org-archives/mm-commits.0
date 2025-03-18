Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16821CF5C0
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274629; cv=none; b=XWikC7V5OF+se7e2rvpGF66SSwuBaaRdNGFTHjqixSeBq8sgHqCLC3SI4Ievgo/uL94dyFEFrlToJqLbNOIALoOzs8sD306D1ucjcxt3u8OxmpCqGrYTUQ5Zk8KM6Di4OmfWKFOLGVQlN3QmrT1Qykv+pkcRHKTfLbjnsypb7Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274629; c=relaxed/simple;
	bh=BoOX/muoX4qLmh6nCykez9GqLqS2k8g4QcVLihbaGQo=;
	h=Date:To:From:Subject:Message-Id; b=IXgN3/KkJT9b4tt1nA0Qag/zVls9HLAI4or/LuyQR9b9tGBNxh2+ZcdMv7tfLlM5JoH3FoGvFr3ZgsUEDgh+ou14PaGx1Pv2o3N8K+E6gOj2TNS6e0ipZZE/ADR9Fgzs6IotCy6ftuRXByefG5bYSwgmH/PCvaMlen9jzEnd3jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nAX5uXTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nAX5uXTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88EBC4CEDD;
	Tue, 18 Mar 2025 05:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274629;
	bh=BoOX/muoX4qLmh6nCykez9GqLqS2k8g4QcVLihbaGQo=;
	h=Date:To:From:Subject:From;
	b=nAX5uXTludLZQ9WBrobP9YjlJ/L1RtGzYe6Hda1EVcOHbCey7OrbLh0aQSUg6vzCA
	 sAYAi8sqP23+ghHyKf2WiTRWQBnnzZWSjOTzXlawdb2hwaNRxt4Z9lId8M/MoZwWSX
	 BbD5BXBs0r+FSnPaIlb1qRIARPLVKpdW1mbtXOJA=
Date: Mon, 17 Mar 2025 22:10:29 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch removed from -mm tree
Message-Id: <20250318051029.A88EBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add tests for folio_split(), buddy allocator like split
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add tests for folio_split(), buddy allocator like split
Date: Fri, 7 Mar 2025 12:40:01 -0500

It splits page cache folios to orders from 0 to 8 at different in-folio
offset.

Link: https://lkml.kernel.org/r/20250307174001.242794-9-ziy@nvidia.com
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
Cc: Kairui Song <kasong@tencent.com>
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


