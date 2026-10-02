Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C923D28C
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901206; cv=none; b=gyLHzvp1dkI+9IRrbuavI6tZLQdi3MjFo41oB4XizyAJIJYweYRO21ulvgxCELdYMoq/QAIwoJKHacDHFS9uEVNknQ+SKDc1CeyJAj8WNHn19O4iao3RO4DoFWBfVzLdYX4omyvZyF5JBW4cLol8zoPkh9bLQWvFektsCCC0aL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901206; c=relaxed/simple;
	bh=HMDQLTzl8UwjiDBfRUyvpNBLu38L0cjP1nm5vo7PxCw=;
	h=Date:To:From:Subject:Message-Id; b=uQtrbpjOzcA5nBIT8/Hz3tBQnOXo4zU8AChsEseK0wWLPM3QHDzgIo4K41+d/2esE1KGqo3Fmvv+P4gutymFo1cXSAUlVvTvhzgx+qGSTpTG7ThZrjwPd0ai/vYTmmpOrt059lnYbhCMmCY+K+9JJGIptULpFgJVdc0Cro5xlrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7n0FSdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7n0FSdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C51F00893;
	Fri,  2 Oct 2026 00:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901204;
	bh=76ugTGLmt0Uu4nVdPKAOPzzaCwN3vYO88YPSH+3VXio=;
	h=Date:To:From:Subject;
	b=M7n0FSdhuf33AfqJC9M5r0rsod+5yDflhLYl7oKCosVE+AlraCv+FnD+XsJSWcyj+
	 0rRPWXGfGRAwbocX4tW6tOFPqs0nL70tG3Ia5pIUELUqKOpBefDv7UBSLm76lV18Pd
	 upkX9kZIIg3APeJDKHCXcAvYCrobz9V1XsXThB5E=
Date: Thu, 01 Oct 2026 17:33:24 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch removed from -mm tree
Message-Id: <20261002003324.835C51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge()
has been removed from the -mm tree.  Its filename was
     kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge()
Date: Thu, 24 Sep 2026 20:11:17 +0100

Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on
AArch64”), glibc may call madvise(MADV_HUGEPAGE) for sufficiently large
allocations made by memalign().

The underlying VMA may start at a different address from the aligned
address returned by memalign().  Furthermore, a subsequent
madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
already set.

This causes split_huge_page_test to fail because the check_pmd_huge()
helpers incorrectly require the address returned by memalign() to match
the VMA start address reported in /proc/self/smaps.

Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE and
PAGE_IS_FILE according to type of huge page.

Since shmem pages are also file-backed, simply check whether the page is
file-backed.

Link: https://lore.kernel.org/20260924-fix_split-v8-2-cba7359d882a@arm.com
Fixes: 642bc52aed9c ("selftests: vm: bring common functions to a new file")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
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

 tools/testing/selftests/mm/vm_util.c |   78 +++++++++++++++----------
 1 file changed, 49 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -351,24 +351,6 @@ err_out:
 	return entry;
 }
 
-static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
-		  uint64_t hpage_size)
-{
-	char buffer[MAX_LINE_LENGTH];
-	uint64_t thp = -1;
-	char *entry;
-
-	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
-	if (!entry)
-		goto err_out;
-
-	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
-		ksft_exit_fail_msg("Reading smap error\n");
-
-err_out:
-	return thp == (nr_hpages * (hpage_size >> 10));
-}
-
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
@@ -410,20 +392,51 @@ out:
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+};
+
+static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	const bool file = categories & PAGE_IS_FILE;
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	switch (type) {
+	case CHECK_HUGE_ANON:
+		return !file;
+	case CHECK_HUGE_FILE:
+		return file;
+	}
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	return false;
+}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
+		  uint64_t hpage_size, enum check_huge_type type)
+{
+	int pagemap_fd;
+	int nr_pmd_mappings = 0;
+	uint64_t categories;
+	char *start = addr;
+	char *end = start + len;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
+
+	for (; start < end; start += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (check_huge_type(categories, type))
+			nr_pmd_mappings++;
+	}
+	close(pagemap_fd);
+
+	return nr_hpages == nr_pmd_mappings;
 }
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -431,12 +444,13 @@ bool check_huge_file(void *addr, size_t
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_ANON);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -444,11 +458,17 @@ bool check_huge_shmem(void *addr, size_t
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_FILE);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return check_huge_file(addr, len, nr_hpages, hpage_size);
+}
+
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

