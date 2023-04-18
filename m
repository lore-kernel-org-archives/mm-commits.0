Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EAAC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjDRXiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0764AAD2F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCB1C634A5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B81FC433D2;
        Tue, 18 Apr 2023 23:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860932;
        bh=+a20yitY3gn9skrKqVogrqWzg7AXLe0oqhf+Pa/Wqj0=;
        h=Date:To:From:Subject:From;
        b=wBwJM3ugoQ81S1jHV+GIT/dNKVRMbfJH7NHY8mhLm5wZX9pvOjhw79CcVjLDjEELB
         epnzymxm74RjBPJktBKBSqHIIcFzW4DCIGZLHhdGeme9vkB824SSRDhl1J6q8XCHbS
         WUpkfvS6mmZjGa0lzqVuzCY+uPPtoo2QNicsI/4c=
Date:   Tue, 18 Apr 2023 16:35:31 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-move-uffd-pagemap-test-to-unit-test.patch removed from -mm tree
Message-Id: <20230418233532.2B81FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: move uffd pagemap test to unit test
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-uffd-pagemap-test-to-unit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: move uffd pagemap test to unit test
Date: Wed, 12 Apr 2023 12:43:52 -0400

Move it over and make it split into two tests, one for pagemap and one for
the new WP_UNPOPULATED (to be a separate one).

The thp pagemap test wasn't really working (with MADV_HUGEPAGE).  Let's
just drop it (since it never really worked anyway..) and leave that for
later.

Link: https://lkml.kernel.org/r/20230412164352.328733-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c     |  166 -----------------
 tools/testing/selftests/mm/uffd-unit-tests.c |  145 ++++++++++++++
 2 files changed, 145 insertions(+), 166 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-move-uffd-pagemap-test-to-unit-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -670,157 +670,6 @@ static int userfaultfd_minor_test(void)
 	return args.missing_faults != 0 || args.minor_faults != nr_pages;
 }
 
-static int pagemap_open(void)
-{
-	int fd = open("/proc/self/pagemap", O_RDONLY);
-
-	if (fd < 0)
-		err("open pagemap");
-
-	return fd;
-}
-
-/* This macro let __LINE__ works in err() */
-#define  pagemap_check_wp(value, wp) do {				\
-		if (!!(value & PM_UFFD_WP) != wp)			\
-			err("pagemap uffd-wp bit error: 0x%"PRIx64, value); \
-	} while (0)
-
-static int pagemap_test_fork(bool present)
-{
-	pid_t child = fork();
-	uint64_t value;
-	int fd, result;
-
-	if (!child) {
-		/* Open the pagemap fd of the child itself */
-		fd = pagemap_open();
-		value = pagemap_get_entry(fd, area_dst);
-		/*
-		 * After fork() uffd-wp bit should be gone as long as we're
-		 * without UFFD_FEATURE_EVENT_FORK
-		 */
-		pagemap_check_wp(value, false);
-		/* Succeed */
-		exit(0);
-	}
-	waitpid(child, &result, 0);
-	return result;
-}
-
-static void userfaultfd_wp_unpopulated_test(int pagemap_fd)
-{
-	uint64_t value;
-
-	/* Test applying pte marker to anon unpopulated */
-	wp_range(uffd, (uint64_t)area_dst, page_size, true);
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, true);
-
-	/* Test unprotect on anon pte marker */
-	wp_range(uffd, (uint64_t)area_dst, page_size, false);
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, false);
-
-	/* Test zap on anon marker */
-	wp_range(uffd, (uint64_t)area_dst, page_size, true);
-	if (madvise(area_dst, page_size, MADV_DONTNEED))
-		err("madvise(MADV_DONTNEED) failed");
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, false);
-
-	/* Test fault in after marker removed */
-	*area_dst = 1;
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, false);
-	/* Drop it to make pte none again */
-	if (madvise(area_dst, page_size, MADV_DONTNEED))
-		err("madvise(MADV_DONTNEED) failed");
-
-	/* Test read-zero-page upon pte marker */
-	wp_range(uffd, (uint64_t)area_dst, page_size, true);
-	*(volatile char *)area_dst;
-	/* Drop it to make pte none again */
-	if (madvise(area_dst, page_size, MADV_DONTNEED))
-		err("madvise(MADV_DONTNEED) failed");
-}
-
-static void userfaultfd_pagemap_test(unsigned int test_pgsize)
-{
-	int pagemap_fd;
-	uint64_t value;
-
-	/* Pagemap tests uffd-wp only */
-	if (!test_uffdio_wp)
-		return;
-
-	/* Not enough memory to test this page size */
-	if (test_pgsize > nr_pages * page_size)
-		return;
-
-	printf("testing uffd-wp with pagemap (pgsize=%u): ", test_pgsize);
-	/* Flush so it doesn't flush twice in parent/child later */
-	fflush(stdout);
-
-	uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED);
-
-	if (test_pgsize > page_size) {
-		/* This is a thp test */
-		if (madvise(area_dst, nr_pages * page_size, MADV_HUGEPAGE))
-			err("madvise(MADV_HUGEPAGE) failed");
-	} else if (test_pgsize == page_size) {
-		/* This is normal page test; force no thp */
-		if (madvise(area_dst, nr_pages * page_size, MADV_NOHUGEPAGE))
-			err("madvise(MADV_NOHUGEPAGE) failed");
-	}
-
-	if (uffd_register(uffd, area_dst, nr_pages * page_size,
-			  false, true, false))
-		err("register failed");
-
-	pagemap_fd = pagemap_open();
-
-	/* Smoke test WP_UNPOPULATED first when it's still empty */
-	if (test_pgsize == page_size)
-		userfaultfd_wp_unpopulated_test(pagemap_fd);
-
-	/* Touch the page */
-	*area_dst = 1;
-	wp_range(uffd, (uint64_t)area_dst, test_pgsize, true);
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, true);
-	/* Make sure uffd-wp bit dropped when fork */
-	if (pagemap_test_fork(true))
-		err("Detected stall uffd-wp bit in child");
-
-	/* Exclusive required or PAGEOUT won't work */
-	if (!(value & PM_MMAP_EXCLUSIVE))
-		err("multiple mapping detected: 0x%"PRIx64, value);
-
-	if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
-		err("madvise(MADV_PAGEOUT) failed");
-
-	/* Uffd-wp should persist even swapped out */
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, true);
-	/* Make sure uffd-wp bit dropped when fork */
-	if (pagemap_test_fork(false))
-		err("Detected stall uffd-wp bit in child");
-
-	/* Unprotect; this tests swap pte modifications */
-	wp_range(uffd, (uint64_t)area_dst, page_size, false);
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, false);
-
-	/* Fault in the page from disk */
-	*area_dst = 2;
-	value = pagemap_get_entry(pagemap_fd, area_dst);
-	pagemap_check_wp(value, false);
-
-	close(pagemap_fd);
-	printf("done\n");
-}
-
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -932,21 +781,6 @@ static int userfaultfd_stress(void)
 		uffd_stats_report(args, nr_cpus);
 	}
 
-	if (test_type == TEST_ANON) {
-		/*
-		 * shmem/hugetlb won't be able to run since they have different
-		 * behavior on fork() (file-backed memory normally drops ptes
-		 * directly when fork), meanwhile the pagemap test will verify
-		 * pgtable entry of fork()ed child.
-		 */
-		userfaultfd_pagemap_test(page_size);
-		/*
-		 * Hard-code for x86_64 for now for 2M THP, as x86_64 is
-		 * currently the only one that supports uffd-wp
-		 */
-		userfaultfd_pagemap_test(page_size * 512);
-	}
-
 	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-move-uffd-pagemap-test-to-unit-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -197,7 +197,152 @@ static bool uffd_feature_supported(uffd_
 	    test->uffd_feature_required;
 }
 
+static int pagemap_open(void)
+{
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+
+	if (fd < 0)
+		err("open pagemap");
+
+	return fd;
+}
+
+/* This macro let __LINE__ works in err() */
+#define  pagemap_check_wp(value, wp) do {				\
+		if (!!(value & PM_UFFD_WP) != wp)			\
+			err("pagemap uffd-wp bit error: 0x%"PRIx64, value); \
+	} while (0)
+
+static int pagemap_test_fork(bool present)
+{
+	pid_t child = fork();
+	uint64_t value;
+	int fd, result;
+
+	if (!child) {
+		/* Open the pagemap fd of the child itself */
+		fd = pagemap_open();
+		value = pagemap_get_entry(fd, area_dst);
+		/*
+		 * After fork() uffd-wp bit should be gone as long as we're
+		 * without UFFD_FEATURE_EVENT_FORK
+		 */
+		pagemap_check_wp(value, false);
+		/* Succeed */
+		exit(0);
+	}
+	waitpid(child, &result, 0);
+	return result;
+}
+
+static void uffd_wp_unpopulated_test(void)
+{
+	uint64_t value;
+	int pagemap_fd;
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  false, true, false))
+		err("register failed");
+
+	pagemap_fd = pagemap_open();
+
+	/* Test applying pte marker to anon unpopulated */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+
+	/* Test unprotect on anon pte marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, false);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Test zap on anon marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Test fault in after marker removed */
+	*area_dst = 1;
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+	/* Drop it to make pte none again */
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+
+	/* Test read-zero-page upon pte marker */
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	*(volatile char *)area_dst;
+	/* Drop it to make pte none again */
+	if (madvise(area_dst, page_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failed");
+
+	uffd_test_pass();
+}
+
+static void uffd_pagemap_test(void)
+{
+	int pagemap_fd;
+	uint64_t value;
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  false, true, false))
+		err("register failed");
+
+	pagemap_fd = pagemap_open();
+
+	/* Touch the page */
+	*area_dst = 1;
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+	/* Make sure uffd-wp bit dropped when fork */
+	if (pagemap_test_fork(true))
+		err("Detected stall uffd-wp bit in child");
+
+	/* Exclusive required or PAGEOUT won't work */
+	if (!(value & PM_MMAP_EXCLUSIVE))
+		err("multiple mapping detected: 0x%"PRIx64, value);
+
+	if (madvise(area_dst, page_size, MADV_PAGEOUT))
+		err("madvise(MADV_PAGEOUT) failed");
+
+	/* Uffd-wp should persist even swapped out */
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, true);
+	/* Make sure uffd-wp bit dropped when fork */
+	if (pagemap_test_fork(false))
+		err("Detected stall uffd-wp bit in child");
+
+	/* Unprotect; this tests swap pte modifications */
+	wp_range(uffd, (uint64_t)area_dst, page_size, false);
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	/* Fault in the page from disk */
+	*area_dst = 2;
+	value = pagemap_get_entry(pagemap_fd, area_dst);
+	pagemap_check_wp(value, false);
+
+	close(pagemap_fd);
+	uffd_test_pass();
+}
+
 uffd_test_case_t uffd_tests[] = {
+	{
+		.name = "pagemap",
+		.uffd_fn = uffd_pagemap_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+	},
+	{
+		.name = "wp-unpopulated",
+		.uffd_fn = uffd_wp_unpopulated_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
+	},
 };
 
 int main(int argc, char *argv[])
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

