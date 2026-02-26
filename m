Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9283A372B43
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772123937; cv=none; b=M/opSq7Qv60KXHWIOfIkg37tSJ8fEngWa19cUxfsebPVLLZkdR9O/AeJsMnYzowtxlXxY1pXozPCtIPfblzv2NGp52qRRx+ERGP0X2IJeE++rvDYCcXVJJFoFxpp2EbL26ubBDjgDPwEpBzrSWpb0eKYBwBkngy0qnl2gpFc2Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772123937; c=relaxed/simple;
	bh=rSfoHgUcikcbvB2CgnBx/aop1xwNgDS3u7YnkCxL3cE=;
	h=Date:To:From:Subject:Message-Id; b=RLQDBZypOre2gQCJJzWixYIwqQhkhngKuaIDc38ALcPrsXJCVCWf2HPINFqgL5drDV/iM+J85V/Ebp/Kkqp5gJn8rHAPQlgNfUX8XWRX4+8DLrTAFkKPEspPntP38lo7wmVCVrVYNWGeUlpiZc3abwxBsl8q19odVM6hdEVAF7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PrY/pLgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PrY/pLgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205E8C19425;
	Thu, 26 Feb 2026 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772123937;
	bh=rSfoHgUcikcbvB2CgnBx/aop1xwNgDS3u7YnkCxL3cE=;
	h=Date:To:From:Subject:From;
	b=PrY/pLgP0Bc0NGg4zFCG3uBCKWeb/jrR8R366/BehV2ayoeLPRfvbH0VYwfmhX3tS
	 hPjgfaJCju2lJjyIEEIRQmdnSgjmYvtFDH9Q3Fiz5WFVsLqhq1TIp8yh3SJG3SUKUo
	 Aydp0+SkU1xrZUPHAo2T/HAGc2aVgK8mJPVn9OU4=
Date: Thu, 26 Feb 2026 08:38:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch added to mm-new branch
Message-Id: <20260226163857.205E8C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chris Down <chris@chrisdown.name>
Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
Date: Thu, 26 Feb 2026 22:18:03 +0800

The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage PMD
path in move_pages_huge_pmd().

Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
relatively comprehensively.

Link: https://lkml.kernel.org/r/aaBWG4fajXXbjpVN@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  176 +++++++++++++++++
 1 file changed, 176 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -203,6 +203,62 @@ static int pagemap_open(void)
 	return fd;
 }
 
+static long uffd_pagemap_scan_get_categories_raw(int fd, char *start,
+						 struct page_region *r)
+{
+	struct pm_scan_arg arg = { 0 };
+
+	arg.start = (uintptr_t)start;
+	arg.end = (uintptr_t)(start + psize());
+	arg.vec = (uintptr_t)r;
+	arg.vec_len = 1;
+	arg.flags = 0;
+	arg.size = sizeof(struct pm_scan_arg);
+	arg.max_pages = 0;
+	arg.category_inverted = 0;
+	arg.category_mask = 0;
+	arg.category_anyof_mask = PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |
+				  PAGE_IS_FILE | PAGE_IS_PRESENT |
+				  PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
+	arg.return_mask = arg.category_anyof_mask;
+
+	return ioctl(fd, PAGEMAP_SCAN, &arg);
+}
+
+static bool uffd_pagemap_scan_supported(int fd, char *start)
+{
+	static int supported = -1;
+	int ret;
+
+	if (supported != -1)
+		return supported;
+
+	ret = uffd_pagemap_scan_get_categories_raw(fd, start,
+						   (struct page_region *)~0UL);
+	if (ret == 0)
+		err("PAGEMAP_SCAN succeeded unexpectedly");
+
+	supported = errno == EFAULT;
+	return supported;
+}
+
+static bool uffd_pagemap_scan_get_categories(int fd, char *start, uint64_t *categories)
+{
+	struct page_region r = { 0 };
+	long ret;
+
+	if (!uffd_pagemap_scan_supported(fd, start))
+		return false;
+
+	ret = uffd_pagemap_scan_get_categories_raw(fd, start, &r);
+	if (ret < 0)
+		err("PAGEMAP_SCAN failed: %s", strerror(errno));
+
+	*categories = ret ? r.categories : 0;
+	return true;
+}
+
 /* This macro let __LINE__ works in err() */
 #define  pagemap_check_wp(value, wp) do {				\
 		if (!!(value & PM_UFFD_WP) != wp)			\
@@ -1227,6 +1283,119 @@ static void uffd_move_pmd_test(uffd_glob
 			      uffd_move_pmd_handle_fault);
 }
 
+static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
+					     uffd_test_args_t *targs)
+{
+	unsigned long pmd_size = read_pmd_pagesize();
+	unsigned long pmd_pages;
+	unsigned long bytes = gopts->nr_pages * gopts->page_size;
+	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
+	char *aligned_src, *aligned_dst;
+	unsigned long src_offs, dst_offs, max_offs;
+	pthread_t uffd_mon;
+	struct uffd_args args = { 0 };
+	char c = '\0';
+	int pagemap_fd;
+	uint64_t categories;
+	unsigned long i;
+
+	if (pmd_size <= gopts->page_size) {
+		uffd_test_skip("huge page size is 0, feature missing?");
+		return;
+	}
+	if (!detect_huge_zeropage()) {
+		uffd_test_skip("transparent huge zeropage disabled");
+		return;
+	}
+
+	pmd_pages = pmd_size / gopts->page_size;
+	if (bytes < pmd_size) {
+		uffd_test_skip("not enough pages for one PMD-sized move");
+		return;
+	}
+
+	aligned_src = ALIGN_UP(orig_area_src, pmd_size);
+	aligned_dst = ALIGN_UP(orig_area_dst, pmd_size);
+	src_offs = (aligned_src - orig_area_src) / gopts->page_size;
+	dst_offs = (aligned_dst - orig_area_dst) / gopts->page_size;
+	max_offs = src_offs > dst_offs ? src_offs : dst_offs;
+	if (max_offs + pmd_pages > gopts->nr_pages) {
+		uffd_test_skip("could not find aligned PMD-sized src/dst window");
+		return;
+	}
+
+	if (madvise(orig_area_dst, bytes, MADV_HUGEPAGE))
+		err("madvise(MADV_HUGEPAGE) failure");
+	if (madvise(orig_area_src, bytes, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failure");
+	if (madvise(aligned_src, pmd_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failure");
+
+	/* Materialise a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!uffd_pagemap_scan_get_categories(pagemap_fd, aligned_src, &categories)) {
+		close(pagemap_fd);
+		uffd_test_skip("PAGEMAP_SCAN unsupported");
+		return;
+	}
+	if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) !=
+	    (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not materialise a huge zeropage PMD mapping");
+		return;
+	}
+	gopts->area_src = aligned_src;
+	gopts->area_dst = aligned_dst;
+
+	if (uffd_register(gopts->uffd, gopts->area_dst, pmd_size, true, false, false))
+		err("register failure");
+
+	args.gopts = gopts;
+	args.handle_fault = uffd_move_pmd_handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	/*
+	 * One fault on dst should trigger a single PMD-sized UFFDIO_MOVE from
+	 * the huge zeropage PMD we populated in the source.
+	 */
+	force_read_pages(gopts->area_dst, pmd_pages, gopts->page_size);
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != 1 || args.minor_faults != 0) {
+		uffd_test_fail("stats check error");
+	} else if (!uffd_pagemap_scan_get_categories(pagemap_fd, gopts->area_dst,
+						     &categories)) {
+		uffd_test_fail("PAGEMAP_SCAN unsupported");
+	} else if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE)) !=
+			(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
+		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	} else {
+		for (i = 0; i < pmd_size; i++) {
+			if (gopts->area_dst[i]) {
+				uffd_test_fail("moved huge zeropage PMD data is not zero");
+				goto out_restore;
+			}
+		}
+		uffd_test_pass();
+	}
+
+out_restore:
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -1549,6 +1718,13 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_ANON,
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
+	{
+		.name = "move-pmd-huge-zeropage",
+		.uffd_fn = uffd_move_pmd_huge_zeropage_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
 	{
 		.name = "move-pmd-split",
_

Patches currently in -mm which might be from chris@chrisdown.name are

selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

