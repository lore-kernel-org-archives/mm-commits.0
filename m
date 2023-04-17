Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E78C77B72
	for <mm-commits@archiver.kernel.org>; Mon, 17 Apr 2023 23:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjDQXwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDQXwm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 19:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF89358C
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 16:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 779D562AEF
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 23:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C463CC433EF;
        Mon, 17 Apr 2023 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775559;
        bh=saSx5YLK+rkSjwhYd/ItJgnvUtK02i2UpDjMl1Dx7q0=;
        h=Date:To:From:Subject:From;
        b=NtDZ6TzDzpQtKtA8dguQ6/Y+vD1GS6J3sfo7LEjPfEv+WMllCYYbEWWb4dUkoNaCJ
         w+4fkwzAU1n+ffs8FXrwCTCyc674Suo7Usht9ViUofu8m0RqAshNzKsZ38kxFxf+B7
         Plan95Gg8vtN3aF6YuVjp44DNvX07zyRZ6Fa+kp0=
Date:   Mon, 17 Apr 2023 16:52:39 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-tests-for-ro-pinning-vs-fork.patch added to mm-unstable branch
Message-Id: <20230417235239.C463CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add tests for RO pinning vs fork()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

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

