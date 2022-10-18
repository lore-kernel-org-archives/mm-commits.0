Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15D6C43217
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJRBIw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiJRBIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93E7303E3
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463D161326
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEA9C433C1;
        Tue, 18 Oct 2022 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055317;
        bh=7aOsu6i0BQzchAA9JTNJIR2zPoZn8DRTFCj00g/7wHU=;
        h=Date:To:From:Subject:From;
        b=JjXXKqYkLzH7Afb2d+B5yMpFCsvlkvSHRraPvX1BCgyGLum8EazFzcLF6+3ZkTeWz
         X7m3cJ3MiDTzVb97kuHAQUI4scZXb5saTsO2qdbsmgRpZaWPOE5lDD57sZ6Zxt99dD
         3pp2JnYNqkc+Iw/7stqF2vr/w2xRgVCygzAOcRzs=
Date:   Mon, 17 Oct 2022 18:08:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch added to mm-unstable branch
Message-Id: <20221018010837.9BEA9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: anon_cow: add R/O longterm tests via gup_test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: anon_cow: add R/O longterm tests via gup_test
Date: Tue, 27 Sep 2022 13:01:20 +0200

Let's trigger a R/O longterm pin on three cases of R/O mapped anonymous
pages:
* exclusive (never shared)
* shared (child still alive)
* previously shared (child no longer alive)

... and make sure that the pin is reliable: whatever we write via the page
tables has to be observable via the pin.

Link: https://lkml.kernel.org/r/20220927110120.106906-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/anon_cow.c |  210 ++++++++++++++++++++++++
 1 file changed, 210 insertions(+)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -17,6 +17,7 @@
 #include <dirent.h>
 #include <assert.h>
 #include <sys/mman.h>
+#include <sys/ioctl.h>
 #include <sys/wait.h>
 
 #include "local_config.h"
@@ -24,6 +25,7 @@
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
 
+#include "../../../../mm/gup_test.h"
 #include "../kselftest.h"
 #include "vm_util.h"
 
@@ -32,6 +34,7 @@ static int pagemap_fd;
 static size_t thpsize;
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
+static int gup_fd;
 
 static void detect_thpsize(void)
 {
@@ -503,6 +506,170 @@ static void test_iouring_fork(char *mem,
 
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
 
+enum ro_pin_test {
+	RO_PIN_TEST_SHARED,
+	RO_PIN_TEST_PREVIOUSLY_SHARED,
+	RO_PIN_TEST_RO_EXCLUSIVE,
+};
+
+static void do_test_ro_pin(char *mem, size_t size, enum ro_pin_test test,
+			   bool fast)
+{
+	struct pin_longterm_test args;
+	struct comm_pipes comm_pipes;
+	char *tmp, buf;
+	__u64 tmp_val;
+	int ret;
+
+	if (gup_fd < 0) {
+		ksft_test_result_skip("gup_test not available\n");
+		return;
+	}
+
+	tmp = malloc(size);
+	if (!tmp) {
+		ksft_test_result_fail("malloc() failed\n");
+		return;
+	}
+
+	ret = setup_comm_pipes(&comm_pipes);
+	if (ret) {
+		ksft_test_result_fail("pipe() failed\n");
+		goto free_tmp;
+	}
+
+	switch (test) {
+	case RO_PIN_TEST_SHARED:
+	case RO_PIN_TEST_PREVIOUSLY_SHARED:
+		/*
+		 * Share the pages with our child. As the pages are not pinned,
+		 * this should just work.
+		 */
+		ret = fork();
+		if (ret < 0) {
+			ksft_test_result_fail("fork() failed\n");
+			goto close_comm_pipes;
+		} else if (!ret) {
+			write(comm_pipes.child_ready[1], "0", 1);
+			while (read(comm_pipes.parent_ready[0], &buf, 1) != 1)
+				;
+			exit(0);
+		}
+
+		/* Wait until our child is ready. */
+		while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
+			;
+
+		if (test == RO_PIN_TEST_PREVIOUSLY_SHARED) {
+			/*
+			 * Tell the child to quit now and wait until it quit.
+			 * The pages should now be mapped R/O into our page
+			 * tables, but they are no longer shared.
+			 */
+			write(comm_pipes.parent_ready[1], "0", 1);
+			wait(&ret);
+			if (!WIFEXITED(ret))
+				ksft_print_msg("[INFO] wait() failed\n");
+		}
+		break;
+	case RO_PIN_TEST_RO_EXCLUSIVE:
+		/*
+		 * Map the page R/O into the page table. Enable softdirty
+		 * tracking to stop the page from getting mapped R/W immediately
+		 * again by mprotect() optimizations. Note that we don't have an
+		 * easy way to test if that worked (the pagemap does not export
+		 * if the page is mapped R/O vs. R/W).
+		 */
+		ret = mprotect(mem, size, PROT_READ);
+		clear_softdirty();
+		ret |= mprotect(mem, size, PROT_READ | PROT_WRITE);
+		if (ret) {
+			ksft_test_result_fail("mprotect() failed\n");
+			goto close_comm_pipes;
+		}
+		break;
+	default:
+		assert(false);
+	}
+
+	/* Take a R/O pin. This should trigger unsharing. */
+	args.addr = (__u64)mem;
+	args.size = size;
+	args.flags = fast ? PIN_LONGTERM_TEST_FLAG_USE_FAST : 0;
+	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
+	if (ret) {
+		if (errno == EINVAL)
+			ksft_test_result_skip("PIN_LONGTERM_TEST_START failed\n");
+		else
+			ksft_test_result_fail("PIN_LONGTERM_TEST_START failed\n");
+		goto wait;
+	}
+
+	/* Modify the page. */
+	memset(mem, 0xff, size);
+
+	/*
+	 * Read back the content via the pin to the temporary buffer and
+	 * test if we observed the modification.
+	 */
+	tmp_val = (__u64)tmp;
+	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_READ, &tmp_val);
+	if (ret)
+		ksft_test_result_fail("PIN_LONGTERM_TEST_READ failed\n");
+	else
+		ksft_test_result(!memcmp(mem, tmp, size),
+				 "Longterm R/O pin is reliable\n");
+
+	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_STOP);
+	if (ret)
+		ksft_print_msg("[INFO] PIN_LONGTERM_TEST_STOP failed\n");
+wait:
+	switch (test) {
+	case RO_PIN_TEST_SHARED:
+		write(comm_pipes.parent_ready[1], "0", 1);
+		wait(&ret);
+		if (!WIFEXITED(ret))
+			ksft_print_msg("[INFO] wait() failed\n");
+		break;
+	default:
+		break;
+	}
+close_comm_pipes:
+	close_comm_pipes(&comm_pipes);
+free_tmp:
+	free(tmp);
+}
+
+static void test_ro_pin_on_shared(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, false);
+}
+
+static void test_ro_fast_pin_on_shared(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, true);
+}
+
+static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, false);
+}
+
+static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, true);
+}
+
+static void test_ro_pin_on_ro_exclusive(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, false);
+}
+
+static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, true);
+}
+
 typedef void (*test_fn)(char *mem, size_t size);
 
 static void do_run_with_base_page(test_fn fn, bool swapout)
@@ -850,6 +1017,48 @@ static const struct test_case test_cases
 	},
 
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
+	/*
+	 * Take a R/O longterm pin on a R/O-mapped shared anonymous page.
+	 * When modifying the page via the page table, the page content change
+	 * must be visible via the pin.
+	 */
+	{
+		"R/O GUP pin on R/O-mapped shared page",
+		test_ro_pin_on_shared,
+	},
+	/* Same as above, but using GUP-fast. */
+	{
+		"R/O GUP-fast pin on R/O-mapped shared page",
+		test_ro_fast_pin_on_shared,
+	},
+	/*
+	 * Take a R/O longterm pin on a R/O-mapped exclusive anonymous page that
+	 * was previously shared. When modifying the page via the page table,
+	 * the page content change must be visible via the pin.
+	 */
+	{
+		"R/O GUP pin on R/O-mapped previously-shared page",
+		test_ro_pin_on_ro_previously_shared,
+	},
+	/* Same as above, but using GUP-fast. */
+	{
+		"R/O GUP-fast pin on R/O-mapped previously-shared page",
+		test_ro_fast_pin_on_ro_previously_shared,
+	},
+	/*
+	 * Take a R/O longterm pin on a R/O-mapped exclusive anonymous page.
+	 * When modifying the page via the page table, the page content change
+	 * must be visible via the pin.
+	 */
+	{
+		"R/O GUP pin on R/O-mapped exclusive page",
+		test_ro_pin_on_ro_exclusive,
+	},
+	/* Same as above, but using GUP-fast. */
+	{
+		"R/O GUP-fast pin on R/O-mapped exclusive page",
+		test_ro_fast_pin_on_ro_exclusive,
+	},
 };
 
 static void run_test_case(struct test_case const *test_case)
@@ -902,6 +1111,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(nr_test_cases * tests_per_test_case());
 
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("opening pagemap failed\n");
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

