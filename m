Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D73EC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjDUVwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjDUVwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192271728
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A92EB65327
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BF3C433D2;
        Fri, 21 Apr 2023 21:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113958;
        bh=X5DqoR12mwM58jZELpUW6sKl2mgzM41JUCduDO+BcDE=;
        h=Date:To:From:Subject:From;
        b=R/wzAsbmpVXoAYTrwQQTLeVxiUld9RQk8j7YheAuTssSSdl6tYTc6LFWRbFK0dFOo
         GMVNa5pQPjs84aNPpTBFdlLAEpJ+bjw13zRQTKztopyOysdXmgUqZuT49eGvdas1IT
         VL1h1PmXP/CeKXVsvId/SJ6JpXYjDyJOlxTAH70U=
Date:   Fri, 21 Apr 2023 14:52:37 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-tests-for-ro-pinning-vs-fork.patch removed from -mm tree
Message-Id: <20230421215238.09BF3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add tests for RO pinning vs fork()
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: add tests for RO pinning vs fork()
Date: Mon, 17 Apr 2023 15:53:17 -0400

Add a test suite (with 10 more sub-tests) to cover RO pinning against
fork() over uffd-wp.  It covers both:

  (1) Early CoW test in fork() when page pinned,
  (2) page unshare due to RO longterm pin.

They are:

  Testing wp-fork-pin on anon... done
  Testing wp-fork-pin on shmem... done
  Testing wp-fork-pin on shmem-private... done
  Testing wp-fork-pin on hugetlb... done
  Testing wp-fork-pin on hugetlb-private... done
  Testing wp-fork-pin-with-event on anon... done
  Testing wp-fork-pin-with-event on shmem... done
  Testing wp-fork-pin-with-event on shmem-private... done
  Testing wp-fork-pin-with-event on hugetlb... done
  Testing wp-fork-pin-with-event on hugetlb-private... done

CONFIG_GUP_TEST needed or they'll be skipped.

  Testing wp-fork-pin on anon... skipped [reason: Possibly CONFIG_GUP_TEST missing or unprivileged]

Note that the major test goal is on private memory, but no hurt to also run
all of them over shared because shared memory should work the same.

Link: https://lkml.kernel.org/r/20230417195317.898696-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  144 ++++++++++++++++-
 1 file changed, 141 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-tests-for-ro-pinning-vs-fork
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -7,6 +7,8 @@
 
 #include "uffd-common.h"
 
+#include "../../../../mm/gup_test.h"
+
 #ifdef __NR_userfaultfd
 
 /* The unit test doesn't need a large or random size, make it 32MB for now */
@@ -247,7 +249,53 @@ static void *fork_event_consumer(void *d
 	return NULL;
 }
 
-static int pagemap_test_fork(int uffd, bool with_event)
+typedef struct {
+	int gup_fd;
+	bool pinned;
+} pin_args;
+
+/*
+ * Returns 0 if succeed, <0 for errors.  pin_pages() needs to be paired
+ * with unpin_pages().  Currently it needs to be RO longterm pin to satisfy
+ * all needs of the test cases (e.g., trigger unshare, trigger fork() early
+ * CoW, etc.).
+ */
+static int pin_pages(pin_args *args, void *buffer, size_t size)
+{
+	struct pin_longterm_test test = {
+		.addr = (uintptr_t)buffer,
+		.size = size,
+		/* Read-only pins */
+		.flags = 0,
+	};
+
+	if (args->pinned)
+		err("already pinned");
+
+	args->gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (args->gup_fd < 0)
+		return -errno;
+
+	if (ioctl(args->gup_fd, PIN_LONGTERM_TEST_START, &test)) {
+		/* Even if gup_test existed, can be an old gup_test / kernel */
+		close(args->gup_fd);
+		return -errno;
+	}
+	args->pinned = true;
+	return 0;
+}
+
+static void unpin_pages(pin_args *args)
+{
+	if (!args->pinned)
+		err("unpin without pin first");
+	if (ioctl(args->gup_fd, PIN_LONGTERM_TEST_STOP))
+		err("PIN_LONGTERM_TEST_STOP");
+	close(args->gup_fd);
+	args->pinned = false;
+}
+
+static int pagemap_test_fork(int uffd, bool with_event, bool test_pin)
 {
 	fork_event_args args = { .parent_uffd = uffd, .child_uffd = -1 };
 	pthread_t thread;
@@ -264,7 +312,17 @@ static int pagemap_test_fork(int uffd, b
 	child = fork();
 	if (!child) {
 		/* Open the pagemap fd of the child itself */
+		pin_args args = {};
+
 		fd = pagemap_open();
+
+		if (test_pin && pin_pages(&args, area_dst, page_size))
+			/*
+			 * Normally when reach here we have pinned in
+			 * previous tests, so shouldn't fail anymore
+			 */
+			err("pin page failed in child");
+
 		value = pagemap_get_entry(fd, area_dst);
 		/*
 		 * After fork(), we should handle uffd-wp bit differently:
@@ -273,6 +331,8 @@ static int pagemap_test_fork(int uffd, b
 		 * (2) when without EVENT_FORK, it should be dropped
 		 */
 		pagemap_check_wp(value, with_event);
+		if (test_pin)
+			unpin_pages(&args);
 		/* Succeed */
 		exit(0);
 	}
@@ -352,7 +412,7 @@ static void uffd_wp_fork_test_common(uff
 	wp_range(uffd, (uint64_t)area_dst, page_size, true);
 	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
-	if (pagemap_test_fork(uffd, with_event)) {
+	if (pagemap_test_fork(uffd, with_event, false)) {
 		uffd_test_fail("Detected %s uffd-wp bit in child in present pte",
 			       with_event ? "missing" : "stall");
 		goto out;
@@ -383,7 +443,7 @@ static void uffd_wp_fork_test_common(uff
 	/* Uffd-wp should persist even swapped out */
 	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
-	if (pagemap_test_fork(uffd, with_event)) {
+	if (pagemap_test_fork(uffd, with_event, false)) {
 		uffd_test_fail("Detected %s uffd-wp bit in child in zapped pte",
 			       with_event ? "missing" : "stall");
 		goto out;
@@ -415,6 +475,68 @@ static void uffd_wp_fork_with_event_test
 	uffd_wp_fork_test_common(args, true);
 }
 
+static void uffd_wp_fork_pin_test_common(uffd_test_args_t *args,
+					 bool with_event)
+{
+	int pagemap_fd;
+	pin_args pin_args = {};
+
+	if (uffd_register(uffd, area_dst, page_size, false, true, false))
+		err("register failed");
+
+	pagemap_fd = pagemap_open();
+
+	/* Touch the page */
+	*area_dst = 1;
+	wp_range(uffd, (uint64_t)area_dst, page_size, true);
+
+	/*
+	 * 1. First pin, then fork().  This tests fork() special path when
+	 * doing early CoW if the page is private.
+	 */
+	if (pin_pages(&pin_args, area_dst, page_size)) {
+		uffd_test_skip("Possibly CONFIG_GUP_TEST missing "
+			       "or unprivileged");
+		close(pagemap_fd);
+		uffd_unregister(uffd, area_dst, page_size);
+		return;
+	}
+
+	if (pagemap_test_fork(uffd, with_event, false)) {
+		uffd_test_fail("Detected %s uffd-wp bit in early CoW of fork()",
+			       with_event ? "missing" : "stall");
+		unpin_pages(&pin_args);
+		goto out;
+	}
+
+	unpin_pages(&pin_args);
+
+	/*
+	 * 2. First fork(), then pin (in the child, where test_pin==true).
+	 * This tests COR, aka, page unsharing on private memories.
+	 */
+	if (pagemap_test_fork(uffd, with_event, true)) {
+		uffd_test_fail("Detected %s uffd-wp bit when RO pin",
+			       with_event ? "missing" : "stall");
+		goto out;
+	}
+	uffd_test_pass();
+out:
+	if (uffd_unregister(uffd, area_dst, page_size))
+		err("register failed");
+	close(pagemap_fd);
+}
+
+static void uffd_wp_fork_pin_test(uffd_test_args_t *args)
+{
+	uffd_wp_fork_pin_test_common(args, false);
+}
+
+static void uffd_wp_fork_pin_with_event_test(uffd_test_args_t *args)
+{
+	uffd_wp_fork_pin_test_common(args, true);
+}
+
 static void check_memory_contents(char *p)
 {
 	unsigned long i, j;
@@ -920,6 +1042,22 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_ALL,
 		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
 		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
+		/* when set, child process should inherit uffd-wp bits */
+		UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "wp-fork-pin",
+		.uffd_fn = uffd_wp_fork_pin_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
+	{
+		.name = "wp-fork-pin-with-event",
+		.uffd_fn = uffd_wp_fork_pin_with_event_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
 		/* when set, child process should inherit uffd-wp bits */
 		UFFD_FEATURE_EVENT_FORK,
 	},
_

Patches currently in -mm which might be from peterx@redhat.com are


