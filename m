Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BCE1C75F9
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 00:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901461; cv=none; b=bg45fFjgOX2dshVTY1KcEs2ufCAwInTyC2GapuUwXz8yFDjZkysAyHYiRNoImjlPCHQ8fWpzZHqFROw5LT69jL0i03vMdMYeNhmXe8+KqfELEwSYll7nfcbGp+9ckwoTi8H5bivKugVhJW0oukxRPU3yrHYosHn3ZBIF1Z/RHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901461; c=relaxed/simple;
	bh=tGy6cGQReRlZ2rD9/jigEcDq+Z+Laq2wF1O4u6umRzo=;
	h=Date:To:From:Subject:Message-Id; b=KKBahwtL5/z0+jlHMAEWriT+x8vKX0qWFOYodAfP7tzniexpA4Z59Gqg0XMVyvbiGUlP4v+eg+bQZUcQ4/FX7MIf9MNCH6Yl/mKT6lNkb9tR20z7atwal23UDjJcxSu4Ovkkec2M0w1joCCeredz7I4kmC1rYDL9F3tS/h6MfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBAQ8yI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBAQ8yI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AAF1F000FF;
	Fri,  2 Oct 2026 00:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901459;
	bh=R8qRwBzQqwl6Nk+nzBE6c8FwQfacwts5LFwlh8ZzBkU=;
	h=Date:To:From:Subject;
	b=HBAQ8yI2xFkdufCsScPUkBC0x146KhVfU8QKQZ8AqKLIdvq4ytIG1aSalHWuZPCGH
	 XbNdptu00BIshRt1pw5PGJWkqrK8SLXz68N18YVtj6qQ27iPhrlCEUNpEK+8V9sfen
	 xKzwfdDlmtmNCpOt5pzJ0Fl1AWVhkcFxn44b9G60=
Date: Thu, 01 Oct 2026 17:37:38 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch added to mm-unstable branch
Message-Id: <20261002003739.48AAF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: prevent random failure of huge page split for khugepaged
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch

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
Subject: kselftest: mm: prevent random failure of huge page split for khugepaged
Date: Thu, 01 Oct 2026 22:17:51 +0100

Patch series "kselftest: mm: fix some failure of split_huge_page_test",
v9.

split_huge_page_test can fail for the following reasons:

  1. During the test, khugepaged may collapse previously split pages again,
     causing intermittent failures.

  2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
     glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
     made by memalign(). The underlying VMA may start at a different address
     from the aligned address returned by memalign(). Moreover, a subsequent
     madvise(MADV_HUGEPAGE) call does not split the VMA because it already
     has the same advice.

     This causes the test to fail because the check_huge_xxx() helpers
     incorrectly require the address returned by memalign() to match the
     VMA start address reported in /proc/self/smaps.

Address these issues by applying MADV_NOHUGEPAGE after faulting in the
huge page, preventing khugepaged from collapsing it again, and instead of
relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings and large folios:

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
     using check_large_folios(), since only the mapping type matters.
     This identifies PMD-mapped huge pages.
  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.
  3. Check the folio flags according to the type of huge page.

Since check_huge_shmem() was required to distinguish shmem huge pages
because /proc/self/smaps reports them using a dedicated “ShmemPmdMapped”
entry, as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
 between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead.


This patch (of 4):

There're some random failure for split_huge_page_test when khugepaged
collapses pages into pmd again which had split by the test.

Prevent the khugepaged's collapses for split page by setting the
mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Link: https://lore.kernel.org/20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com
Link: https://lore.kernel.org/20261001-fix_split-v9-1-0f4ba8bbdbdf@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
---

 tools/testing/selftests/mm/split_huge_page_test.c |   16 ++++++++++++
 1 file changed, 16 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -108,6 +108,15 @@ static char *allocate_zero_filled_hugepa
 	return result;
 }
 
+static void disable_khugepaged(void *addr, size_t len)
+{
+	/* Disables khugepaged from collapsing pages in range into THPs */
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_perror("MADV_NOHUGEPAGE failed");
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -120,6 +129,8 @@ static void verify_rss_anon_split_huge_p
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -167,6 +178,8 @@ static void split_pmd_thp_to_order(int o
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -215,6 +228,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -482,6 +497,7 @@ static int create_pagecache_thp_and_fd(c
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);
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

