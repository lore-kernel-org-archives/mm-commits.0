Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335CB547048
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901207; cv=none; b=LfoKREXNdlesQ6aBUA0GET8ffyYRle6OK3dZn7TrdNjrIne64c+/Zr/C5AopcfB3aa8JtGjLtgqbo0roo3jR20D1h5fvHNSmKdi25P8JBwlYKAezyGtAmZ6BRISRvpc+3wM/tGOCpa6Fsl9rRpkzbtsg+cad5FrrPvRj8pvU2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901207; c=relaxed/simple;
	bh=dPuG/jT9uYxOcBYAK9XBjkTHJO/a4nTF+3GvAijDx0w=;
	h=Date:To:From:Subject:Message-Id; b=OWNbqcrFUkrQ89pD+E/hDWNvwb2sfRxbQ/f5a+FezS0thEtiPptUCwf9OTvcU93bzJGppNT48/MYZ3p7l1g11MDJqxRje2tGaPDAC7lEwTMotBVDQtQkWqERZEELgq/wN2D9sJOF8xrAIwPLcyRZ9E1YKi/fGKZUr3nLThiAHIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1IyNnWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1IyNnWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3A01F000FF;
	Fri,  2 Oct 2026 00:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901205;
	bh=9xi/ogP7fjJMOJ4tfehdf/uU3vyuH0kffoKPYUQAvxw=;
	h=Date:To:From:Subject;
	b=a1IyNnWoI1QmF3gOGcYIZ7pUMTh85ILWCY8TSlByV6Y/aRnuV36bqNI4Gbe4b0MXx
	 pirXcKrSEJA0MNV+6xqrkao5qDDg5iBGsKzdu57Y863QcHuaF/JUdcuXqWWn95s9Cu
	 uBuqm6zZQRC4hUBp7ZTcgi2n+qKrjee2zk0174lo=
Date: Thu, 01 Oct 2026 17:33:25 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-integrate-huge-page-checks.patch removed from -mm tree
Message-Id: <20261002003325.AD3A01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: integrate huge page checks
has been removed from the -mm tree.  Its filename was
     kselftest-mm-integrate-huge-page-checks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: integrate huge page checks
Date: Thu, 24 Sep 2026 20:11:18 +0100

check_large_folios() only checks for large folios without distinguishing
between anonymous and file-backed huge pages.

To add huge page type checking, integrate the huge page checks into
__check_huge():

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
     check_large_folios(), since only the mapping type matters. This
     identifies PMD-mapped huge pages.

  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.

  3. Check the folio flags according to the huge page type.

Link: https://lore.kernel.org/20260924-fix_split-v8-3-cba7359d882a@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
---

 tools/testing/selftests/mm/vm_util.c |   90 +++++++++++++------------
 1 file changed, 48 insertions(+), 42 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-integrate-huge-page-checks
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -351,13 +351,13 @@ err_out:
 	return entry;
 }
 
-static bool check_large_folios(void *addr, size_t len, int nr_hpages,
+static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
+		void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
 	int order = 0, pagesize = getpagesize();
 	unsigned int nr_pages = hpage_size / pagesize;
 	int orders[MAX_NR_ORDERS], status;
-	int pagemap_fd, kpageflags_fd;
 	bool ret = false;
 
 	if (!nr_pages)
@@ -368,15 +368,6 @@ static bool check_large_folios(void *add
 		ksft_exit_fail_msg("invalid order\n");
 
 	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
-	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
-	if (pagemap_fd == -1)
-		ksft_exit_fail_msg("read pagemap fail\n");
-
-	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
-	if (kpageflags_fd == -1) {
-		close(pagemap_fd);
-		ksft_exit_fail_msg("read kpageflags fail\n");
-	}
 
 	status = gather_folio_orders(addr, len, pagemap_fd,
 			kpageflags_fd, orders, MAX_NR_ORDERS);
@@ -387,8 +378,6 @@ static bool check_large_folios(void *add
 		ret = true;
 
 out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
@@ -411,57 +400,74 @@ static bool check_huge_type(uint64_t cat
 	return false;
 }
 
-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-		  uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size, enum check_huge_type type)
 {
-	int pagemap_fd;
+	bool ret = false;
+	int pagemap_fd, kpageflags_fd;
 	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize, scan_mapping_size;
 	uint64_t categories;
+	unsigned long pfn;
+	bool check_pmd_mapping, allow_nonpresent;
 	char *start = addr;
 	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	check_pmd_mapping = hpage_size == pmd_pagesize;
+	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+	/* Some mTHP tests check a partially populated PMD-sized range. */
+	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
+
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("open pagemap fail\n");
 
-	for (; start < end; start += hpage_size) {
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_fail_msg("open kpageflags fail\n");
+
+	if (!check_pmd_mapping &&
+	    !check_large_folios(pagemap_fd, kpageflags_fd,
+				addr, len, nr_hpages, hpage_size))
+		goto out;
+
+	for (; start < end; start += scan_mapping_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		if (!(categories & PAGE_IS_HUGE))
-			continue;
-		if (check_huge_type(categories, type))
+		pfn = pagemap_get_pfn(pagemap_fd, start);
+		if (pfn == -1UL) {
+			if (!allow_nonpresent)
+				goto out;
+			else
+				continue;
+		}
+		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
 			nr_pmd_mappings++;
+		if (!check_huge_type(categories, type))
+			goto out;
 	}
-	close(pagemap_fd);
 
-	return nr_hpages == nr_pmd_mappings;
+	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
+		goto out;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_ANON);
-
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_FILE);
-
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-remove-check_huge_shmem.patch

