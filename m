Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD793F0AAB
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773862246; cv=none; b=L2wyvFL9koanriMPXfKUdcJ4Lq7lQYN97d4nLK5rqEjLQqAmePnrSDDqUtQq3HxhvBfkU1+84Zzwyn+3Rf/z41mr5ody/ZT0dfsqDTUxGVHpTxd9FMFVNBvV/3+P6bbXW1cjCbGaRijls2R+1D4k6shUga1CwFEHkxx5GBvEOXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773862246; c=relaxed/simple;
	bh=pT7TxMjMAZ1HULBXgw/bEBPMJwunr5HIpYe+u12VBDQ=;
	h=Date:To:From:Subject:Message-Id; b=mnwjUBnxu6AVdQhQYLGEkQbwfnARgD56QR+C2NRHuvteQ3OKUYBzZobuf+sIttNF0GQ0bZYyUxa8xf4iGDIoDxmSYdWxYTK/NEe8QIUDp02BUWniaBZk1Gd+qyWeAr13myP7EAFshv/bDRCXWJ1Ksf19iO1CsPu6ym/y+0RHepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=asARMOGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="asARMOGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7080FC19421;
	Wed, 18 Mar 2026 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773862245;
	bh=pT7TxMjMAZ1HULBXgw/bEBPMJwunr5HIpYe+u12VBDQ=;
	h=Date:To:From:Subject:From;
	b=asARMOGIMOjTmCd7444oXX5TTIMEGH9+4SZFK+qmOlhxWieLuix/1SWo3UK2P2knO
	 sMvh2mQfgYXCm5Hxpqhm3YIjgVxxoy3qFuhZyn761PHYGJ5u4M4GlEDEJUYGG2cONV
	 a0pt4IY8jnkq9+qvmmuC6Q8DgegPOTSBlG+To2Qc=
Date: Wed, 18 Mar 2026 12:30:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,chris@chrisdown.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch added to mm-new branch
Message-Id: <20260318193045.7080FC19421@smtp.kernel.org>
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

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Wed, 18 Mar 2026 12:18:11 +0800

The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage PMD
path in move_pages_huge_pmd().

Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
relatively comprehensively.

Link: https://lkml.kernel.org/r/abongwF3X0G8xY1I@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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
@@ -118,6 +118,18 @@ bool pagemap_is_populated(int fd, char *
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

selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test.patch

