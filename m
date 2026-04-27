Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07F4224234
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777307371; cv=none; b=Yu1gRPodNAlrDFhceLPBBk5U4e5/6F57YnpHGEM6pfYjg673WfcCg2kkholgOG79qmNvpuK+sAgG60QcLJWZfr6evmtE4nk2LeUvFvjIfW1JCOQiseiH4pebKIgi1RKbgnWjSKZzPOZ6GcU8MItKHGqlhEBC6Ilw6la8kQUlN34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777307371; c=relaxed/simple;
	bh=Yp1fwU7igm7E1epJupoM0T6E5T4nScxpYgZroSBEDOc=;
	h=Date:To:From:Subject:Message-Id; b=cXcJNZ6tDsmeypWCKDt0fZD+8MPobBQ56sWFnVhjYk1qCSov8IFZTbBQSkkTMguU+RQPIgdkVI0Se2E4fZgDZmvY0QVVH9mcB3XXBbGkZCS61FP9f3yLaN2JqYw0dA0MJXiZM5pMH2CYW5XKyn9XTMYJTmvu/tIcp0Asmti2ysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fryTlxaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fryTlxaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6FCC19425;
	Mon, 27 Apr 2026 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777307370;
	bh=Yp1fwU7igm7E1epJupoM0T6E5T4nScxpYgZroSBEDOc=;
	h=Date:To:From:Subject:From;
	b=fryTlxaEYR3oXYb5c3N2UU/9OPtiDJ0BiRcvYwheUOOXKMwuEzVYNwcW/tQdwJ3mw
	 64zsYYtwsv8WX9yPZ1NFvLBImI0eC588us0B4FZXv1Us7ghe/nuE2Zeon4chPHjCrz
	 mupxGOHjo3rEHS3qM6YX37fja4UItia+8ZmFvnFQ=
Date: Mon, 27 Apr 2026 09:29:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch removed from -mm tree
Message-Id: <20260427162930.8C6FCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
Date: Wed, 18 Mar 2026 12:18:11 +0800

The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage PMD
path in move_pages_huge_pmd().

Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
relatively comprehensively.

Link: https://lkml.kernel.org/r/abongwF3X0G8xY1I@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  100 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         |   12 ++
 tools/testing/selftests/mm/vm_util.h         |    1 
 3 files changed, 113 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1227,6 +1227,99 @@ static void uffd_move_pmd_test(uffd_glob
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
+	/* Fault in a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!pagemap_is_huge_zero(pagemap_fd, aligned_src)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not fault in the huge zeropage");
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
+	} else if (!pagemap_is_huge_zero(pagemap_fd, gopts->area_dst)) {
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
+		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	} else {
+		uffd_test_pass();
+	}
+
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -1549,6 +1642,13 @@ uffd_test_case_t uffd_tests[] = {
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
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -120,6 +120,18 @@ bool pagemap_is_populated(int fd, char *
 				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
+bool pagemap_is_huge_zero(int fd, char *start)
+{
+	uint64_t categories;
+
+	if (!pagemap_scan_supported(fd, start))
+		return false;
+
+	categories = pagemap_scan_get_categories(fd, start);
+	return (categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) ==
+		(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE);
+}
+
 unsigned long pagemap_get_pfn(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -85,6 +85,7 @@ uint64_t pagemap_get_entry(int fd, char
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
 bool pagemap_is_populated(int fd, char *start);
+bool pagemap_is_huge_zero(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
_

Patches currently in -mm which might be from chris@chrisdown.name are


