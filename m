Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EAAC77B73
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDLUDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDLUCu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7242D57
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB89662D10
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FACCC433D2;
        Wed, 12 Apr 2023 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329767;
        bh=w9wQhfl88LtXFTpXMC521ZZRoqr5m/+kEPpKTvqwyxw=;
        h=Date:To:From:Subject:From;
        b=nWpsRZmRYcIJP0/MA6nbukDuiM/ZHdrLN6tDoKLVGQEoBkIXAfko1NS01QaayyJBu
         sPfntoHj3kp5ujM4bRHvOgFwZ5tTPUCyFifBk+bzZBuB4pk0K6tPXQ+OQB54O3wsMr
         GZpsx1fwGFll3GOpDpUqwJZ6tjE+3FYI/A9k9028=
Date:   Wed, 12 Apr 2023 13:02:46 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd_register.patch added to mm-unstable branch
Message-Id: <20230412200247.2FACCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: uffd_[un]register()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd_register.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd_register.patch

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
Subject: selftests/mm: uffd_[un]register()
Date: Wed, 12 Apr 2023 12:42:47 -0400

Add two helpers to register/unregister to an uffd.  Use them to drop
duplicate codes.

This patch also drops assert_expected_ioctls_present() and
get_expected_ioctls().  Reasons:

  - It'll need a lot of effort to pass test_type==HUGETLB into it from
    the upper, so it's the simplest way to get rid of another global var

  - The ioctls returned in UFFDIO_REGISTER is hardly useful at all,
    because any app can already detect kernel support on any ioctl via its
    corresponding UFFD_FEATURE_*.  The check here is for sanity mostly but
    it's probably destined no user app will even use it.

  - It's not friendly to one future goal of uffd to run on old
    kernels, the problem is get_expected_ioctls() compiles against
    UFFD_API_RANGE_IOCTLS, which is a value that can change depending on
    where the test is compiled, rather than reflecting what the kernel
    underneath has.  It means it'll report false negatives on old kernels
    so it's against our will.

So let's make our live easier.

Link: https://lkml.kernel.org/r/20230412164247.328293-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c      |    7 -
 tools/testing/selftests/mm/ksm_functional_tests.c |    6 
 tools/testing/selftests/mm/uffd-common.c          |   27 ---
 tools/testing/selftests/mm/uffd-common.h          |    2 
 tools/testing/selftests/mm/uffd-stress.c          |   83 ++----------
 tools/testing/selftests/mm/vm_util.c              |   37 +++++
 tools/testing/selftests/mm/vm_util.h              |    4 
 7 files changed, 62 insertions(+), 104 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -60,7 +60,6 @@ static void register_region_with_uffd(ch
 {
 	long uffd; /* userfaultfd file descriptor */
 	struct uffdio_api uffdio_api;
-	struct uffdio_register uffdio_register;
 
 	/* Create and enable userfaultfd object. */
 
@@ -96,11 +95,7 @@ static void register_region_with_uffd(ch
 	 * handling by the userfaultfd object. In mode, we request to track
 	 * missing pages (i.e., pages that have not yet been faulted in).
 	 */
-
-	uffdio_register.range.start = (unsigned long)addr;
-	uffdio_register.range.len = len;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1) {
+	if (uffd_register(uffd, addr, len, true, false, false)) {
 		perror("ioctl-UFFDIO_REGISTER");
 		exit(1);
 	}
--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -178,7 +178,6 @@ unmap:
 static void test_unmerge_uffd_wp(void)
 {
 	struct uffdio_writeprotect uffd_writeprotect;
-	struct uffdio_register uffdio_register;
 	const unsigned int size = 2 * MiB;
 	struct uffdio_api uffdio_api;
 	char *map;
@@ -210,10 +209,7 @@ static void test_unmerge_uffd_wp(void)
 	}
 
 	/* Register UFFD-WP, no need for an actual handler. */
-	uffdio_register.range.start = (unsigned long) map;
-	uffdio_register.range.len = size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) < 0) {
+	if (uffd_register(uffd, map, size, false, true, false)) {
 		ksft_test_result_fail("UFFDIO_REGISTER_MODE_WP failed\n");
 		goto close_uffd;
 	}
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -330,33 +330,6 @@ void uffd_test_ctx_init(uint64_t feature
 			err("pipe");
 }
 
-uint64_t get_expected_ioctls(uint64_t mode)
-{
-	uint64_t ioctls = UFFD_API_RANGE_IOCTLS;
-
-	if (test_type == TEST_HUGETLB)
-		ioctls &= ~(1 << _UFFDIO_ZEROPAGE);
-
-	if (!((mode & UFFDIO_REGISTER_MODE_WP) && test_uffdio_wp))
-		ioctls &= ~(1 << _UFFDIO_WRITEPROTECT);
-
-	if (!((mode & UFFDIO_REGISTER_MODE_MINOR) && test_uffdio_minor))
-		ioctls &= ~(1 << _UFFDIO_CONTINUE);
-
-	return ioctls;
-}
-
-void assert_expected_ioctls_present(uint64_t mode, uint64_t ioctls)
-{
-	uint64_t expected = get_expected_ioctls(mode);
-	uint64_t actual = ioctls & expected;
-
-	if (actual != expected) {
-		err("missing ioctl(s): expected %"PRIx64" actual: %"PRIx64,
-		    expected, actual);
-	}
-}
-
 void wp_range(int ufd, __u64 start, __u64 len, bool wp)
 {
 	struct uffdio_writeprotect prms;
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -101,8 +101,6 @@ extern uffd_test_ops_t *uffd_test_ops;
 void uffd_stats_report(struct uffd_stats *stats, int n_cpus);
 void uffd_test_ctx_init(uint64_t features);
 void userfaultfd_open(uint64_t *features);
-uint64_t get_expected_ioctls(uint64_t mode);
-void assert_expected_ioctls_present(uint64_t mode, uint64_t ioctls);
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_stats *stats);
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -463,28 +463,19 @@ static int uffdio_zeropage(int ufd, unsi
 /* exercise UFFDIO_ZEROPAGE */
 static int userfaultfd_zeropage_test(void)
 {
-	struct uffdio_register uffdio_register;
-
 	printf("testing UFFDIO_ZEROPAGE: ");
 	fflush(stdout);
 
 	uffd_test_ctx_init(0);
 
-	uffdio_register.range.start = (unsigned long) area_dst;
-	uffdio_register.range.len = nr_pages * page_size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
-		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, test_uffdio_wp, false))
 		err("register failure");
 
-	assert_expected_ioctls_present(
-		uffdio_register.mode, uffdio_register.ioctls);
-
 	if (area_dst_alias) {
 		/* Needed this to test zeropage-retry on shared memory */
-		uffdio_register.range.start = (unsigned long) area_dst_alias;
-		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		if (uffd_register(uffd, area_dst_alias, nr_pages * page_size,
+				  true, test_uffdio_wp, false))
 			err("register failure");
 	}
 
@@ -498,7 +489,6 @@ static int userfaultfd_zeropage_test(voi
 
 static int userfaultfd_events_test(void)
 {
-	struct uffdio_register uffdio_register;
 	pthread_t uffd_mon;
 	int err, features;
 	pid_t pid;
@@ -514,17 +504,10 @@ static int userfaultfd_events_test(void)
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
-	uffdio_register.range.start = (unsigned long) area_dst;
-	uffdio_register.range.len = nr_pages * page_size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
-		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, test_uffdio_wp, false))
 		err("register failure");
 
-	assert_expected_ioctls_present(
-		uffdio_register.mode, uffdio_register.ioctls);
-
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
 		err("uffd_poll_thread create");
 
@@ -550,7 +533,6 @@ static int userfaultfd_events_test(void)
 
 static int userfaultfd_sig_test(void)
 {
-	struct uffdio_register uffdio_register;
 	unsigned long userfaults;
 	pthread_t uffd_mon;
 	int err, features;
@@ -566,17 +548,10 @@ static int userfaultfd_sig_test(void)
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
-	uffdio_register.range.start = (unsigned long) area_dst;
-	uffdio_register.range.len = nr_pages * page_size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
-		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, test_uffdio_wp, false))
 		err("register failure");
 
-	assert_expected_ioctls_present(
-		uffdio_register.mode, uffdio_register.ioctls);
-
 	if (faulting_process(1))
 		err("faulting process failed");
 
@@ -629,7 +604,6 @@ void check_memory_contents(char *p)
 static int userfaultfd_minor_test(void)
 {
 	unsigned long p;
-	struct uffdio_register uffdio_register;
 	pthread_t uffd_mon;
 	char c;
 	struct uffd_stats stats = { 0 };
@@ -642,17 +616,10 @@ static int userfaultfd_minor_test(void)
 
 	uffd_test_ctx_init(uffd_minor_feature());
 
-	uffdio_register.range.start = (unsigned long)area_dst_alias;
-	uffdio_register.range.len = nr_pages * page_size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_MINOR;
-	if (test_uffdio_wp)
-		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+	if (uffd_register(uffd, area_dst_alias, nr_pages * page_size,
+			  false, test_uffdio_wp, true))
 		err("register failure");
 
-	assert_expected_ioctls_present(
-		uffdio_register.mode, uffdio_register.ioctls);
-
 	/*
 	 * After registering with UFFD, populate the non-UFFD-registered side of
 	 * the shared mapping. This should *not* trigger any UFFD minor faults.
@@ -777,7 +744,6 @@ static void userfaultfd_wp_unpopulated_t
 
 static void userfaultfd_pagemap_test(unsigned int test_pgsize)
 {
-	struct uffdio_register uffdio_register;
 	int pagemap_fd;
 	uint64_t value;
 
@@ -805,10 +771,8 @@ static void userfaultfd_pagemap_test(uns
 			err("madvise(MADV_NOHUGEPAGE) failed");
 	}
 
-	uffdio_register.range.start = (unsigned long) area_dst;
-	uffdio_register.range.len = nr_pages * page_size;
-	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
-	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  false, true, false))
 		err("register failed");
 
 	pagemap_fd = pagemap_open();
@@ -858,8 +822,8 @@ static int userfaultfd_stress(void)
 {
 	void *area;
 	unsigned long nr;
-	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
+	uint64_t mem_size = nr_pages * page_size;
 
 	uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED);
 
@@ -894,20 +858,13 @@ static int userfaultfd_stress(void)
 			fcntl(uffd, F_SETFL, uffd_flags & ~O_NONBLOCK);
 
 		/* register */
-		uffdio_register.range.start = (unsigned long) area_dst;
-		uffdio_register.range.len = nr_pages * page_size;
-		uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-		if (test_uffdio_wp)
-			uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
-		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+		if (uffd_register(uffd, area_dst, mem_size,
+				  true, test_uffdio_wp, false))
 			err("register failure");
-		assert_expected_ioctls_present(
-			uffdio_register.mode, uffdio_register.ioctls);
 
 		if (area_dst_alias) {
-			uffdio_register.range.start = (unsigned long)
-				area_dst_alias;
-			if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
+			if (uffd_register(uffd, area_dst_alias, mem_size,
+					  true, test_uffdio_wp, false))
 				err("register failure alias");
 		}
 
@@ -949,12 +906,10 @@ static int userfaultfd_stress(void)
 				 nr_pages * page_size, false);
 
 		/* unregister */
-		if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
+		if (uffd_unregister(uffd, area_dst, mem_size))
 			err("unregister failure");
 		if (area_dst_alias) {
-			uffdio_register.range.start = (unsigned long) area_dst;
-			if (ioctl(uffd, UFFDIO_UNREGISTER,
-				  &uffdio_register.range))
+			if (uffd_unregister(uffd, area_dst_alias, mem_size))
 				err("unregister failure alias");
 		}
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <string.h>
 #include <fcntl.h>
+#include <sys/ioctl.h>
+#include <linux/userfaultfd.h>
 #include "../kselftest.h"
 #include "vm_util.h"
 
@@ -193,3 +195,38 @@ unsigned long default_huge_page_size(voi
 	fclose(f);
 	return hps;
 }
+
+int uffd_register(int uffd, void *addr, uint64_t len,
+		  bool miss, bool wp, bool minor)
+{
+	struct uffdio_register uffdio_register = { 0 };
+	uint64_t mode = 0;
+	int ret = 0;
+
+	if (miss)
+		mode |= UFFDIO_REGISTER_MODE_MISSING;
+	if (wp)
+		mode |= UFFDIO_REGISTER_MODE_WP;
+	if (minor)
+		mode |= UFFDIO_REGISTER_MODE_MINOR;
+
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = len;
+	uffdio_register.mode = mode;
+
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1)
+		ret = -errno;
+
+	return ret;
+}
+
+int uffd_unregister(int uffd, void *addr, uint64_t len)
+{
+	struct uffdio_range range = { .start = (uintptr_t)addr, .len = len };
+	int ret = 0;
+
+	if (ioctl(uffd, UFFDIO_UNREGISTER, &range) == -1)
+		ret = -errno;
+
+	return ret;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-uffd_register
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -45,6 +45,10 @@ bool check_huge_shmem(void *addr, int nr
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 unsigned long default_huge_page_size(void);
 
+int uffd_register(int uffd, void *addr, uint64_t len,
+		  bool miss, bool wp, bool minor);
+int uffd_unregister(int uffd, void *addr, uint64_t len);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
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

