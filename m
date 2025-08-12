Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6302512F5
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755038237; cv=none; b=KUmGdz7AkQVK4AR+z9BIQwr5T93ea3JKi7tIV3u3X/O3T8qOdSx7NhcbbglAVCwnLE2rCqhuuz1mDrNjje4mnT6HuuQpnmmlSmuo7VbnJCs5hXEIzPpMS8TNWlLfcW2B/ByIjIP7Trw3IECI8csKuRGfv9d6KkydT6ZfmdeWqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755038237; c=relaxed/simple;
	bh=kC641bjWEuWZeNcmNv27/d2F8LsHZjsdc4/Wl/Ksvqw=;
	h=Date:To:From:Subject:Message-Id; b=S1ZbQf2BVMq3PCBY4KRptTTXxC5JS+b2DloH69+lyDY0cWL1EN91Y2+khcTfllISFEA4TZKXW+Rc70ytvOxf9yW8EphlS6cTa5JjpG3lKh8cLeBAYzHPWMjQuNzQ3ajaEFguOmOMowhpBapga9/onfdaaP++IRXQKHIS0qSrrcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f04bbAu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f04bbAu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A18C4CEF0;
	Tue, 12 Aug 2025 22:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755038237;
	bh=kC641bjWEuWZeNcmNv27/d2F8LsHZjsdc4/Wl/Ksvqw=;
	h=Date:To:From:Subject:From;
	b=f04bbAu3axqLKU3LaSyiFwrLPx7CeYlk868mRJ9/SMDqSMgZWaDM0QuTVGth4tZs6
	 KhkjFEAHuogcIUAiNRvY5iHiCza9t6UH78WqC3WnDcfwOJAVrWs5PI2ins1f7qXGo3
	 b/KozPS56MtBVbodCL2FLXlvAjdgGFRKLq2SemR8=
Date: Tue, 12 Aug 2025 15:37:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch added to mm-new branch
Message-Id: <20250812223717.78A18C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check after-split folio orders in split_huge_page_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: selftests/mm: check after-split folio orders in split_huge_page_test
Date: Tue, 12 Aug 2025 11:55:12 -0400

Instead of just checking the existence of PMD folios before and after
folio split tests, use check_folio_orders() to check after-split folio
orders.

The following tests are not changed:
1. split_pte_mapped_thp: the test already uses kpageflags to check;
2. split_file_backed_thp: no vaddr available.

Link: https://lkml.kernel.org/r/20250812155512.926011-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   85 ++++++++----
 1 file changed, 61 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-after-split-folio-orders-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -26,6 +26,7 @@ uint64_t pagesize;
 unsigned int pageshift;
 uint64_t pmd_pagesize;
 unsigned int pmd_order;
+int *expected_orders;
 
 #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
 #define SMAP_PATH "/proc/self/smaps"
@@ -37,6 +38,11 @@ unsigned int pmd_order;
 
 #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
+const char *pagemap_proc = "/proc/self/pagemap";
+const char *kpageflags_proc = "/proc/kpageflags";
+int pagemap_fd;
+int kpageflags_fd;
+
 int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd)
 {
 	unsigned long pfn_head;
@@ -49,18 +55,21 @@ int is_backed_by_folio(char *vaddr, int
 
 	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
 
+	/* non present page */
 	if (pfn == -1UL)
 		return 0;
 
 	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
 		return 0;
 
+	/* check for order-0 pages */
 	if (!order) {
 		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
 			return 0;
 		return 1;
 	}
 
+	/* non THP folio */
 	if (!(pfn_flags & KPF_THP))
 		return 0;
 
@@ -69,9 +78,11 @@ int is_backed_by_folio(char *vaddr, int
 	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
 		return 0;
 
+	/* head PFN has no compound_head flag set */
 	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
 		return 0;
 
+	/* check all tail PFN flags */
 	for (i = 1; i < (1UL << order) - 1; i++) {
 		if (get_pfn_flags(pfn_head + i, kpageflags_fd, &pfn_flags))
 			return 0;
@@ -198,6 +209,12 @@ void split_pmd_thp_to_order(int order)
 		if (one_page[i] != (char)i)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
+	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
+	expected_orders[order] = 4 << (pmd_order - order);
+
+	if (check_folio_orders(one_page, len, pagemap_fd, kpageflags_fd,
+			       expected_orders, (pmd_order + 1)))
+		ksft_exit_fail_msg("Unexpected THP split\n");
 
 	if (!check_huge_anon(one_page, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
@@ -212,22 +229,6 @@ void split_pte_mapped_thp(void)
 	size_t len = 4 * pmd_pagesize;
 	uint64_t thp_size;
 	size_t i;
-	const char *pagemap_template = "/proc/%d/pagemap";
-	const char *kpageflags_proc = "/proc/kpageflags";
-	char pagemap_proc[255];
-	int pagemap_fd;
-	int kpageflags_fd;
-
-	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0)
-		ksft_exit_fail_msg("get pagemap proc error: %s\n", strerror(errno));
-
-	pagemap_fd = open(pagemap_proc, O_RDONLY);
-	if (pagemap_fd == -1)
-		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
-
-	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
-	if (kpageflags_fd == -1)
-		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
 
 	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
@@ -285,8 +286,6 @@ void split_pte_mapped_thp(void)
 
 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
 	munmap(one_page, len);
-	close(pagemap_fd);
-	close(kpageflags_fd);
 }
 
 void split_file_backed_thp(int order)
@@ -489,6 +488,7 @@ void split_thp_in_pagecache_to_order_at(
 		int order, int offset)
 {
 	int fd;
+	char *split_addr;
 	char *addr;
 	size_t i;
 	char testfile[INPUT_MAX];
@@ -502,14 +502,27 @@ void split_thp_in_pagecache_to_order_at(
 	err = create_pagecache_thp_and_fd(testfile, fd_size, &fd, &addr);
 	if (err)
 		return;
+
 	err = 0;
 
-	if (offset == -1)
-		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
-			      (uint64_t)addr + fd_size, order);
-	else
-		write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)addr,
-			      (uint64_t)addr + fd_size, order, offset);
+	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
+	if (offset == -1) {
+		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
+			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
+				      (uint64_t)split_addr + pagesize, order);
+
+		expected_orders[order] = fd_size / (pagesize << order);
+	} else {
+		int times = fd_size / pmd_pagesize;
+
+		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
+			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
+				      (uint64_t)split_addr + pagesize, order, offset);
+
+		for (i = order + 1; i < pmd_order; i++)
+			expected_orders[i] = times;
+		expected_orders[order] = 2 * times;
+	}
 
 	for (i = 0; i < fd_size; i++)
 		if (*(addr + i) != (char)i) {
@@ -518,6 +531,13 @@ void split_thp_in_pagecache_to_order_at(
 			goto out;
 		}
 
+	if (check_folio_orders(addr, fd_size, pagemap_fd, kpageflags_fd,
+			       expected_orders, (pmd_order + 1))) {
+		ksft_print_msg("Unexpected THP split\n");
+		err = 1;
+		goto out;
+	}
+
 	if (!check_huge_file(addr, 0, pmd_pagesize)) {
 		ksft_print_msg("Still FilePmdMapped not split\n");
 		err = EXIT_FAILURE;
@@ -569,9 +589,22 @@ int main(int argc, char **argv)
 
 	nr_pages = pmd_pagesize / pagesize;
 	pmd_order = GET_ORDER(nr_pages);
+
+	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
+	if (!expected_orders)
+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+
 	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
+	pagemap_fd = open(pagemap_proc, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
+
+	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
+	if (kpageflags_fd == -1)
+		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
+
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
@@ -596,6 +629,10 @@ int main(int argc, char **argv)
 			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
 	cleanup_thp_fs(fs_loc, created_tmp);
 
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	free(expected_orders);
+
 	ksft_finished();
 
 	return 0;
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-add-check_folio_orders-helper.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

