Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E443EC77B78
	for <mm-commits@archiver.kernel.org>; Mon, 17 Apr 2023 23:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjDQXwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDQXwi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 19:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B89E62
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 16:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84ACC6216B
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 23:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CD8C433EF;
        Mon, 17 Apr 2023 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775556;
        bh=VkGR35O+6vJLfpw7Fqr9jBl1I+a8jaqg7p1T8rZoZLU=;
        h=Date:To:From:Subject:From;
        b=Wc4/eIX/8xew/q/6LesxYmW5C+DqXOELgxZtCjn+ByKg7PvlAB/3qwq2e1CvItE80
         dyENJkvJvM0SDyk0+QeHIry92Leb1WjGdah2mLcfJZ2GSLbEKyg67Acu/qrhcayCtu
         gTve4lcpm+X008ystQF9TBxBy7lOe/KSN6Qzgz8k=
Date:   Mon, 17 Apr 2023 16:52:35 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-extend-and-rename-uffd-pagemap-test.patch added to mm-unstable branch
Message-Id: <20230417235235.D8CD8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: extend and rename uffd pagemap test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-extend-and-rename-uffd-pagemap-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-extend-and-rename-uffd-pagemap-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: extend and rename uffd pagemap test
Date: Mon, 17 Apr 2023 15:53:15 -0400

Extend it to all types of mem, meanwhile add one parallel test when
EVENT_FORK is enabled, where uffd-wp bits should be persisted rather than
dropped.

Since at it, rename the test to "wp-fork" to better show what it means. 
Making the new test called "wp-fork-with-event".

Before:

        Testing pagemap on anon... done

After:

        Testing wp-fork on anon... done
        Testing wp-fork on shmem... done
        Testing wp-fork on shmem-private... done
        Testing wp-fork on hugetlb... done
        Testing wp-fork on hugetlb-private... done
        Testing wp-fork-with-event on anon... done
        Testing wp-fork-with-event on shmem... done
        Testing wp-fork-with-event on shmem-private... done
        Testing wp-fork-with-event on hugetlb... done
        Testing wp-fork-with-event on hugetlb-private... done

Link: https://lkml.kernel.org/r/20230417195317.898696-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  130 +++++++++++++----
 1 file changed, 106 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-extend-and-rename-uffd-pagemap-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -227,25 +227,65 @@ static int pagemap_open(void)
 			err("pagemap uffd-wp bit error: 0x%"PRIx64, value); \
 	} while (0)
 
-static int pagemap_test_fork(bool present)
+typedef struct {
+	int parent_uffd, child_uffd;
+} fork_event_args;
+
+static void *fork_event_consumer(void *data)
 {
-	pid_t child = fork();
+	fork_event_args *args = data;
+	struct uffd_msg msg = { 0 };
+
+	/* Read until a full msg received */
+	while (uffd_read_msg(args->parent_uffd, &msg));
+
+	if (msg.event != UFFD_EVENT_FORK)
+		err("wrong message: %u\n", msg.event);
+
+	/* Just to be properly freed later */
+	args->child_uffd = msg.arg.fork.ufd;
+	return NULL;
+}
+
+static int pagemap_test_fork(int uffd, bool with_event)
+{
+	fork_event_args args = { .parent_uffd = uffd, .child_uffd = -1 };
+	pthread_t thread;
+	pid_t child;
 	uint64_t value;
 	int fd, result;
 
+	/* Prepare a thread to resolve EVENT_FORK */
+	if (with_event) {
+		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
+			err("pthread_create()");
+	}
+
+	child = fork();
 	if (!child) {
 		/* Open the pagemap fd of the child itself */
 		fd = pagemap_open();
 		value = pagemap_get_entry(fd, area_dst);
 		/*
-		 * After fork() uffd-wp bit should be gone as long as we're
-		 * without UFFD_FEATURE_EVENT_FORK
+		 * After fork(), we should handle uffd-wp bit differently:
+		 *
+		 * (1) when with EVENT_FORK, it should persist
+		 * (2) when without EVENT_FORK, it should be dropped
 		 */
-		pagemap_check_wp(value, false);
+		pagemap_check_wp(value, with_event);
 		/* Succeed */
 		exit(0);
 	}
 	waitpid(child, &result, 0);
+
+	if (with_event) {
+		if (pthread_join(thread, NULL))
+			err("pthread_join()");
+		if (args.child_uffd < 0)
+			err("Didn't receive child uffd");
+		close(args.child_uffd);
+	}
+
 	return result;
 }
 
@@ -295,7 +335,8 @@ static void uffd_wp_unpopulated_test(uff
 	uffd_test_pass();
 }
 
-static void uffd_pagemap_test(uffd_test_args_t *args)
+static void uffd_wp_fork_test_common(uffd_test_args_t *args,
+				     bool with_event)
 {
 	int pagemap_fd;
 	uint64_t value;
@@ -311,23 +352,42 @@ static void uffd_pagemap_test(uffd_test_
 	wp_range(uffd, (uint64_t)area_dst, page_size, true);
 	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
-	/* Make sure uffd-wp bit dropped when fork */
-	if (pagemap_test_fork(true))
-		err("Detected stall uffd-wp bit in child");
-
-	/* Exclusive required or PAGEOUT won't work */
-	if (!(value & PM_MMAP_EXCLUSIVE))
-		err("multiple mapping detected: 0x%"PRIx64, value);
+	if (pagemap_test_fork(uffd, with_event)) {
+		uffd_test_fail("Detected %s uffd-wp bit in child in present pte",
+			       with_event ? "missing" : "stall");
+		goto out;
+	}
 
-	if (madvise(area_dst, page_size, MADV_PAGEOUT))
-		err("madvise(MADV_PAGEOUT) failed");
+	/*
+	 * This is an attempt for zapping the pgtable so as to test the
+	 * markers.
+	 *
+	 * For private mappings, PAGEOUT will only work on exclusive ptes
+	 * (PM_MMAP_EXCLUSIVE) which we should satisfy.
+	 *
+	 * For shared, PAGEOUT may not work.  Use DONTNEED instead which
+	 * plays a similar role of zapping (rather than freeing the page)
+	 * to expose pte markers.
+	 */
+	if (args->mem_type->shared) {
+		if (madvise(area_dst, page_size, MADV_DONTNEED))
+			err("MADV_DONTNEED");
+	} else {
+		/*
+		 * NOTE: ignore retval because private-hugetlb doesn't yet
+		 * support swapping, so it could fail.
+		 */
+		madvise(area_dst, page_size, MADV_PAGEOUT);
+	}
 
 	/* Uffd-wp should persist even swapped out */
 	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, true);
-	/* Make sure uffd-wp bit dropped when fork */
-	if (pagemap_test_fork(false))
-		err("Detected stall uffd-wp bit in child");
+	if (pagemap_test_fork(uffd, with_event)) {
+		uffd_test_fail("Detected %s uffd-wp bit in child in zapped pte",
+			       with_event ? "missing" : "stall");
+		goto out;
+	}
 
 	/* Unprotect; this tests swap pte modifications */
 	wp_range(uffd, (uint64_t)area_dst, page_size, false);
@@ -338,9 +398,21 @@ static void uffd_pagemap_test(uffd_test_
 	*area_dst = 2;
 	value = pagemap_get_entry(pagemap_fd, area_dst);
 	pagemap_check_wp(value, false);
-
-	close(pagemap_fd);
 	uffd_test_pass();
+out:
+	if (uffd_unregister(uffd, area_dst, nr_pages * page_size))
+		err("unregister failed");
+	close(pagemap_fd);
+}
+
+static void uffd_wp_fork_test(uffd_test_args_t *args)
+{
+	uffd_wp_fork_test_common(args, false);
+}
+
+static void uffd_wp_fork_with_event_test(uffd_test_args_t *args)
+{
+	uffd_wp_fork_test_common(args, true);
 }
 
 static void check_memory_contents(char *p)
@@ -836,10 +908,20 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = 0,
 	},
 	{
-		.name = "pagemap",
-		.uffd_fn = uffd_pagemap_test,
-		.mem_targets = MEM_ANON,
-		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		.name = "wp-fork",
+		.uffd_fn = uffd_wp_fork_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
+	{
+		.name = "wp-fork-with-event",
+		.uffd_fn = uffd_wp_fork_with_event_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
+		/* when set, child process should inherit uffd-wp bits */
+		UFFD_FEATURE_EVENT_FORK,
 	},
 	{
 		.name = "wp-unpopulated",
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
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

