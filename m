Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA23597B
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418024; cv=none; b=qNdxhcIV+fw+QMUeo5a0nbM/K2atfsD7b2cgIZUsXZQVME1U/yjkH2aWl9dxv7yIZu/WlvvFqJ0PqNM9bY+VrKiA/1csDyp/z4F2mR0s064Uj7+6Cc/aVBAvNc4MJJwdKcI4ntvBZzwa89IUutZOdV4HUmfLCpNeeOktHcGiTUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418024; c=relaxed/simple;
	bh=qFGj0o+gE7kojPb5UVU4qpZVhyMlaFTm2t+TLR9PwDc=;
	h=Date:To:From:Subject:Message-Id; b=UHXSehLu1P0drpCAsPHrqLTh6I3NUzQ8n2512QEMD8YAl8ULPY3I6nOH9ZvVCgTeL794+PSAagv0L6F2DbxbBDHyWrQVJmP/1uTjoG67/++F/WMrF8YTcU7va5obsY6z74Z4c5Yh7vmtt1a1OeuPiPpRvs8J6ZdW+ecyxcVkItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onZBoT8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onZBoT8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B22BC4CEE2;
	Sat, 12 Apr 2025 00:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418024;
	bh=qFGj0o+gE7kojPb5UVU4qpZVhyMlaFTm2t+TLR9PwDc=;
	h=Date:To:From:Subject:From;
	b=onZBoT8vfrE03i78F+GzBdDJPg3dwxTLkuKa9dx1FkYaqXScbrmI9bXfs/WUowk8Y
	 T/aqn0smBoWIB4112oqxLf/HZf2bVLLJfLSvH6D88ceY/1A2dLAhJgZT82r/Y7dhJa
	 KBOaiUOWCDu8bvdJEcGwsCVpVv8n8xyUGWBvQsno=
Date: Fri, 11 Apr 2025 17:33:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mincore-fix-tmpfs-mincore-test-failure.patch removed from -mm tree
Message-Id: <20250412003344.7B22BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mincore: fix tmpfs mincore test failure
has been removed from the -mm tree.  Its filename was
     selftests-mincore-fix-tmpfs-mincore-test-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mincore: fix tmpfs mincore test failure
Date: Mon, 7 Apr 2025 19:31:35 +0800

When running mincore test cases, I encountered the following failures:

"
mincore_selftest.c:359:check_tmpfs_mmap:Expected ra_pages (511) == 0 (0)
mincore_selftest.c:360:check_tmpfs_mmap:Read-ahead pages found in memory
check_tmpfs_mmap: Test terminated by assertion
          FAIL  global.check_tmpfs_mmap
not ok 5 global.check_tmpfs_mmap
FAILED: 4 / 5 tests passed
"

The reason for the test case failure is that my system automatically enabled
tmpfs large folio allocation by adding the 'transparent_hugepage_tmpfs=always'
cmdline. However, the test case still expects the tmpfs mounted on /dev/shm to
allocate small folios, which leads to assertion failures when verifying readahead
pages.

As discussed with David, there's no reason to continue checking the readahead
logic for tmpfs. Drop it to fix this issue.

Link: https://lkml.kernel.org/r/9a00856cc6a8b4e46f4ab8b1af11ce5fc1a31851.1744025467.git.baolin.wang@linux.alibaba.com
Fixes: d635ccdb435c ("mm: shmem: add a kernel command line to change the default huge policy for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mincore/mincore_selftest.c |   16 +----------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mincore/mincore_selftest.c~selftests-mincore-fix-tmpfs-mincore-test-failure
+++ a/tools/testing/selftests/mincore/mincore_selftest.c
@@ -286,8 +286,7 @@ out_free:
 
 /*
  * Test mincore() behavior on a page backed by a tmpfs file.  This test
- * performs the same steps as the previous one. However, we don't expect
- * any readahead in this case.
+ * performs the same steps as the previous one.
  */
 TEST(check_tmpfs_mmap)
 {
@@ -298,7 +297,6 @@ TEST(check_tmpfs_mmap)
 	int page_size;
 	int fd;
 	int i;
-	int ra_pages = 0;
 
 	page_size = sysconf(_SC_PAGESIZE);
 	vec_size = FILE_SIZE / page_size;
@@ -341,8 +339,7 @@ TEST(check_tmpfs_mmap)
 	}
 
 	/*
-	 * Touch a page in the middle of the mapping. We expect only
-	 * that page to be fetched into memory.
+	 * Touch a page in the middle of the mapping.
 	 */
 	addr[FILE_SIZE / 2] = 1;
 	retval = mincore(addr, FILE_SIZE, vec);
@@ -351,15 +348,6 @@ TEST(check_tmpfs_mmap)
 		TH_LOG("Page not found in memory after use");
 	}
 
-	i = FILE_SIZE / 2 / page_size + 1;
-	while (i < vec_size && vec[i]) {
-		ra_pages++;
-		i++;
-	}
-	ASSERT_EQ(ra_pages, 0) {
-		TH_LOG("Read-ahead pages found in memory");
-	}
-
 	munmap(addr, FILE_SIZE);
 	close(fd);
 	free(vec);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch

