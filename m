Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E699C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKIBjv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKIBip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1161165E4A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3BAB617F0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF2DC433D6;
        Wed,  9 Nov 2022 01:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957920;
        bh=0mCcoNbeqWI0e3gBzoZBd58snZ3yAV/IULbs4eygfPE=;
        h=Date:To:From:Subject:From;
        b=mPycXWRIKBFTSyfDa/fgPhTO3D8o1pVq5fbDPy3d083JMwsmuvlK+smfHdpEuRpP6
         rzXUw6s4XxwVyaACLzRep7qY+NmwxtX6nivEpQp3/lRTicq8YdJYbPi8keY+mcemWk
         fblNIj38uI1MxHL25eEyML0uk2KEWCHkVy0wg1xE=
Date:   Tue, 08 Nov 2022 17:38:39 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch removed from -mm tree
Message-Id: <20221109013840.4CF2DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: anon_cow: add R/O longterm tests via gup_test
has been removed from the -mm tree.  Its filename was
     selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

