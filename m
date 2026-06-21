Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FCF36F8F0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067200; cv=none; b=COZGrHm9NmHMsforZQ4RKP2Gd6SgY65+THmtiQBwtHIi8vRIGX1rATX1LZNiOiE+HdsEoPVBJcmk8G9U45Lpz2qwjkwMf9J9ZwyVHIwKXnWjL1BrZfj0/L8AujvWhdeD0KTf/QAX8wzojabW4zVr/H7SKlxObPTqRzkj1l29/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067200; c=relaxed/simple;
	bh=o3zNpdiMlAfs3jZG5yXinYJZt+hMxIYfIBVrTi3zktE=;
	h=Date:To:From:Subject:Message-Id; b=KZ0YKZOWlQMw9Hrm3Ngm1x5j1QK1oECQXkDiqEVwtIwUHnn4mPiZEq340UOTW6B9Vmi11BGFPizDmn8c6af5y9Jg0kGZ1AOW+y2ADxDaUWE/AsuRP/vcksFpzbLLzM/MqUg3/i417dK6GxEqzCYldrQEoSOuP9wxUOHYihb4kI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zDYqmANF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zDYqmANF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABCD1F00A3A;
	Sun, 21 Jun 2026 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067199;
	bh=cEj9Iyh4TFMoYXG/0R4upnJ4dNQaaKV/tbQv7tmcv+k=;
	h=Date:To:From:Subject;
	b=zDYqmANFbRLzqj5COd21+fd8rqln2jZf4ch2VISM01AHzDp+A4BqZeBkmvirUSnU1
	 JtDcsX5XnJu7UXqX3fLGG9GSk18yEczLlloGqV4aaQd/fd9FWZIhWthQ2seXjt2Wrv
	 Q3o0yQdc/yH6OrQfFGXiGjLuDayN0nb2RUf5oSRM=
Date: Sun, 21 Jun 2026 11:39:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch removed from -mm tree
Message-Id: <20260621183959.9ABCD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -470,6 +470,8 @@ static void split_file_backed_thp(int or
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -489,7 +491,8 @@ static void split_file_backed_thp(int or
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


