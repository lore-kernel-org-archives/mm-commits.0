Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B741C75F9
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901465; cv=none; b=Sdj2z/0/e32JlKI6LlchQ2Y3yc2rCSHbGBPPXTAJfh5mUuHK1S+QtWh9Tb/ksXpiqHthKTEZJqz1s7V0X/W7xFWHjw16gaYn+NBGH011MTWr1tBLI9/olV52eNSaHCPyiDtAeGzRayJHXgXTA0aoL+k+9mgEOYGcOGwQyTUICak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901465; c=relaxed/simple;
	bh=gRSSn58Jq4b78HUnyEreTifuZnoezaNbn/YHrScvP3g=;
	h=Date:To:From:Subject:Message-Id; b=mPGDRcHMWSRisXNeRTRZ/lgL2wqa/b4R45awV0NlO0gItsCCGxEOpqBkoEpALJrx69k+clHQTHiDsO0up9gaRyzkUx5knXoiVI79A2p4BwrcQU0COIbTZ1iLHIGqaU+WXOeYb9eNVbYMPPj1iKfftRDZc/5J0SPH6iHuXpq7fh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lJuPNnHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lJuPNnHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E951F000FF;
	Fri,  2 Oct 2026 00:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901463;
	bh=GIq2e7u+LNdXI2HkkTbRgNfk3Q6Xf0cIAo0mYWmTt6w=;
	h=Date:To:From:Subject;
	b=lJuPNnHzj7OfesJss0y/xsZKcvombkacJhzo2pcqvempGJsBSdIkX+N4EtHw3yZ9B
	 zWAQCCBEr9bv55TtQBxUiD4g8v9SSQybYNhe1g8BRL5gcN6O8MiiTBJ5kpeFJFJc4I
	 h7JWN7Wjn01Qrr68rViO2WMucrgxcRgH4cn5qnhk=
Date: Thu, 01 Oct 2026 17:37:42 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-integrate-huge-page-checks.patch added to mm-unstable branch
Message-Id: <20261002003743.47E951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: integrate huge page checks
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-integrate-huge-page-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-integrate-huge-page-checks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: integrate huge page checks
Date: Thu, 01 Oct 2026 22:17:53 +0100

check_large_folios() only checks for large folios without distinguishing
between anonymous and file-backed huge pages.

To add huge page type checking, integrate the huge page checks into
__check_huge() and __check_type():

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
     check_large_folios(), since only the mapping type matters. This
     identifies PMD-mapped huge pages.

  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.

  3. Check the folio flags according to the huge page type via
     __check_type()

Link: https://lore.kernel.org/20261001-fix_split-v9-3-0f4ba8bbdbdf@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 tools/testing/selftests/mm/vm_util.c |   90 +++++++++++++++----------
 1 file changed, 56 insertions(+), 34 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-integrate-huge-page-checks
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -392,76 +392,98 @@ out:
 	return ret;
 }
 
-enum check_huge_type {
-	CHECK_HUGE_ANON,
-	CHECK_HUGE_FILE,
+enum check_type {
+	CHECK_TYPE_ANON,
+	CHECK_TYPE_FILE,
 };
 
-static bool check_huge_type(uint64_t categories, enum check_huge_type type)
+static bool __check_type(void *addr, size_t len, uint64_t page_size,
+		enum check_type type)
 {
-	const bool file = categories & PAGE_IS_FILE;
+	bool ret = false;
+	int pagemap_fd;
+	char *start = addr;
+	char *end = start + len;
+	uint64_t categories;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open pagemap");
 
-	switch (type) {
-	case CHECK_HUGE_ANON:
-		return !file;
-	case CHECK_HUGE_FILE:
-		return file;
+	for (; start < end; start += page_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if ((categories & PAGE_IS_PRESENT) != PAGE_IS_PRESENT)
+			continue;
+
+		if ((type == CHECK_TYPE_FILE) != !!(categories & PAGE_IS_FILE))
+			goto out;
 	}
 
-	return false;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-		  uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size)
 {
+	bool ret = false;
 	int pagemap_fd;
 	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize;
 	uint64_t categories;
 	char *start = addr;
 	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_perror("open pagemap");
 
+	if (hpage_size != pmd_pagesize) {
+		ret = check_large_folios(addr, len, nr_hpages, hpage_size);
+		goto out;
+	}
+
 	for (; start < end; start += hpage_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		if (!(categories & PAGE_IS_HUGE))
-			continue;
-		if (check_huge_type(categories, type))
+		if (categories & PAGE_IS_HUGE)
 			nr_pmd_mappings++;
 	}
-	close(pagemap_fd);
 
-	return nr_hpages == nr_pmd_mappings;
+	if (nr_pmd_mappings != nr_hpages)
+		goto out;
+
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_ANON);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_FILE);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch
kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

