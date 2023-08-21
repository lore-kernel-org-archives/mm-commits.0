Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBFFEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjHUV33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjHUV31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EB0D9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8087164701
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8409C433CA;
        Mon, 21 Aug 2023 21:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653364;
        bh=lEGB0Lo3RvhclVo1nvlnw4vX4brQ6gTBB3DrSDXQJMA=;
        h=Date:To:From:Subject:From;
        b=MgdftxI63/FGYW10aXvvPrTHBrc8bIxW65j0fpcYe/df8JekJinF6lPGhjRAU/XmA
         V3dK3EDUyZoEjgNHH217OyZf5wCjqzncy7TY0Pr8srNo7EdxG3PTwyJ+q1Mubai1re
         trM+v4UDbaA67avNjdgATvMVGDuErAnxjQgLVZ1A=
Date:   Mon, 21 Aug 2023 14:29:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch removed from -mm tree
Message-Id: <20230821212924.D8409C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest/mm: ksm_functional_tests: test in mmap_and_merge_range() if anything got merged
has been removed from the -mm tree.  Its filename was
     selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftest/mm: ksm_functional_tests: test in mmap_and_merge_range() if anything got merged
Date: Thu, 3 Aug 2023 16:32:07 +0200

Let's extend mmap_and_merge_range() to test if anything in the current
process was merged. range_maps_duplicates() is too unreliable for that
use case, so instead look at KSM stats.

Trigger a complete unmerge first, to cleanup the stable tree and
stabilize accounting of merged pages.

Note that we're using /proc/self/ksm_merging_pages instead of
/proc/self/ksm_stat, because that one is available in more existing
kernels.

If /proc/self/ksm_merging_pages can't be opened, we can't perform any
checks and simply skip them.

We have to special-case the shared zeropage for now. But the only user
-- test_unmerge_zero_pages() -- performs its own merge checks.

Link: https://lkml.kernel.org/r/20230803143208.383663-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   47 ++++++++++++
 1 file changed, 47 insertions(+)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -30,6 +30,7 @@
 static int ksm_fd;
 static int ksm_full_scans_fd;
 static int proc_self_ksm_stat_fd;
+static int proc_self_ksm_merging_pages_fd;
 static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
@@ -88,6 +89,22 @@ static long get_my_ksm_zero_pages(void)
 	return my_ksm_zero_pages;
 }
 
+static long get_my_merging_pages(void)
+{
+	char buf[10];
+	ssize_t ret;
+
+	if (proc_self_ksm_merging_pages_fd < 0)
+		return proc_self_ksm_merging_pages_fd;
+
+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
 static long ksm_get_full_scans(void)
 {
 	char buf[10];
@@ -120,11 +137,29 @@ static int ksm_merge(void)
 	return 0;
 }
 
+static int ksm_unmerge(void)
+{
+	if (write(ksm_fd, "2", 1) != 1)
+		return -errno;
+	return 0;
+}
+
 static char *mmap_and_merge_range(char val, unsigned long size, bool use_prctl)
 {
 	char *map;
 	int ret;
 
+	/* Stabilize accounting by disabling KSM completely. */
+	if (ksm_unmerge()) {
+		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
+		goto unmap;
+	}
+
+	if (get_my_merging_pages() > 0) {
+		ksft_test_result_fail("Still pages merged\n");
+		goto unmap;
+	}
+
 	map = mmap(NULL, size, PROT_READ|PROT_WRITE,
 		   MAP_PRIVATE|MAP_ANON, -1, 0);
 	if (map == MAP_FAILED) {
@@ -160,6 +195,16 @@ static char *mmap_and_merge_range(char v
 		ksft_test_result_fail("Running KSM failed\n");
 		goto unmap;
 	}
+
+	/*
+	 * Check if anything was merged at all. Ignore the zero page that is
+	 * accounted differently (depending on kernel support).
+	 */
+	if (val && !get_my_merging_pages()) {
+		ksft_test_result_fail("No pages got merged\n");
+		goto unmap;
+	}
+
 	return map;
 unmap:
 	munmap(map, size);
@@ -473,6 +518,8 @@ int main(int argc, char **argv)
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
 	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+					      O_RDONLY);
 	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
 
 	test_unmerge();
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

