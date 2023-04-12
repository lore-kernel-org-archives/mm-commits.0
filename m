Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C7CC77B73
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjDLUDT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDLUDD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594814231
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAA95638C1
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E887C433D2;
        Wed, 12 Apr 2023 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329781;
        bh=sBRJ4kUvTK8dK+swvZJjKEcqNIcBxfKSLMkpEzsMZ5w=;
        h=Date:To:From:Subject:From;
        b=nyMQBu07k4aRgX1PNjOaRSdfHRJB3OM4UVf80VisEmKLmTqruyMtSF2UAAQHnnF3t
         fACJCOKhbhYYuxKh0P8ocGv5cqsUqd/UHcIvn8T5EsKGaYEjUMyu5iNrZVirr/k6C8
         JyBESTyZ1A1UWuMwjYsKq0UHfnRM274Ij50si/h4=
Date:   Wed, 12 Apr 2023 13:03:00 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch added to mm-unstable branch
Message-Id: <20230412200301.3E887C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: let uffd_handle_page_fault() take wp parameter
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch

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
Subject: selftests/mm: let uffd_handle_page_fault() take wp parameter
Date: Wed, 12 Apr 2023 12:43:41 -0400

Make the handler optionally apply WP bit when resolving page faults for
either missing or minor page faults.  This moves towards removing global
test_uffdio_wp outside of the common code.

Link: https://lkml.kernel.org/r/20230412164341.328618-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   17 +++++++++--------
 tools/testing/selftests/mm/uffd-common.h |    6 ++++--
 tools/testing/selftests/mm/uffd-stress.c |   16 ++++++++++------
 3 files changed, 23 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-let-uffd_handle_page_fault-take-wp-parameter
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -353,7 +353,7 @@ void wp_range(int ufd, __u64 start, __u6
 		err("clear WP failed: address=0x%"PRIx64, (uint64_t)start);
 }
 
-static void continue_range(int ufd, __u64 start, __u64 len)
+static void continue_range(int ufd, __u64 start, __u64 len, bool wp)
 {
 	struct uffdio_continue req;
 	int ret;
@@ -361,7 +361,7 @@ static void continue_range(int ufd, __u6
 	req.range.start = start;
 	req.range.len = len;
 	req.mode = 0;
-	if (test_uffdio_wp)
+	if (wp)
 		req.mode |= UFFDIO_CONTINUE_MODE_WP;
 
 	if (ioctl(ufd, UFFDIO_CONTINUE, &req))
@@ -429,7 +429,8 @@ void uffd_handle_page_fault(struct uffd_
 				    area_dst_alias));
 		for (b = 0; b < page_size; ++b)
 			area[b] = ~area[b];
-		continue_range(uffd, msg->arg.pagefault.address, page_size);
+		continue_range(uffd, msg->arg.pagefault.address, page_size,
+			       args->apply_wp);
 		args->minor_faults++;
 	} else {
 		/*
@@ -459,7 +460,7 @@ void uffd_handle_page_fault(struct uffd_
 		offset = (char *)(unsigned long)msg->arg.pagefault.address - area_dst;
 		offset &= ~(page_size-1);
 
-		if (copy_page(uffd, offset))
+		if (copy_page(uffd, offset, args->apply_wp))
 			args->missing_faults++;
 	}
 }
@@ -555,7 +556,7 @@ static void wake_range(int ufd, unsigned
 			addr), exit(1);
 }
 
-int __copy_page(int ufd, unsigned long offset, bool retry)
+int __copy_page(int ufd, unsigned long offset, bool retry, bool wp)
 {
 	struct uffdio_copy uffdio_copy;
 
@@ -564,7 +565,7 @@ int __copy_page(int ufd, unsigned long o
 	uffdio_copy.dst = (unsigned long) area_dst + offset;
 	uffdio_copy.src = (unsigned long) area_src + offset;
 	uffdio_copy.len = page_size;
-	if (test_uffdio_wp)
+	if (wp)
 		uffdio_copy.mode = UFFDIO_COPY_MODE_WP;
 	else
 		uffdio_copy.mode = 0;
@@ -587,7 +588,7 @@ int __copy_page(int ufd, unsigned long o
 	return 0;
 }
 
-int copy_page(int ufd, unsigned long offset)
+int copy_page(int ufd, unsigned long offset, bool wp)
 {
-	return __copy_page(ufd, offset, false);
+	return __copy_page(ufd, offset, false, wp);
 }
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-let-uffd_handle_page_fault-take-wp-parameter
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -72,6 +72,8 @@
 /* Userfaultfd test statistics */
 struct uffd_args {
 	int cpu;
+	/* Whether apply wr-protects when installing pages */
+	bool apply_wp;
 	unsigned long missing_faults;
 	unsigned long wp_faults;
 	unsigned long minor_faults;
@@ -104,8 +106,8 @@ void userfaultfd_open(uint64_t *features
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
-int __copy_page(int ufd, unsigned long offset, bool retry);
-int copy_page(int ufd, unsigned long offset);
+int __copy_page(int ufd, unsigned long offset, bool retry, bool wp);
+int copy_page(int ufd, unsigned long offset, bool wp);
 void *uffd_poll_thread(void *arg);
 
 #define TEST_ANON	1
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-let-uffd_handle_page_fault-take-wp-parameter
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -96,6 +96,7 @@ static void uffd_stats_reset(struct uffd
 
 	for (i = 0; i < n_cpus; i++) {
 		args[i].cpu = i;
+		args[i].apply_wp = test_uffdio_wp;
 		args[i].missing_faults = 0;
 		args[i].wp_faults = 0;
 		args[i].minor_faults = 0;
@@ -155,7 +156,7 @@ static void *locking_thread(void *arg)
 
 static int copy_page_retry(int ufd, unsigned long offset)
 {
-	return __copy_page(ufd, offset, true);
+	return __copy_page(ufd, offset, true, test_uffdio_wp);
 }
 
 pthread_mutex_t uffd_read_mutex = PTHREAD_MUTEX_INITIALIZER;
@@ -308,7 +309,7 @@ static void sighndl(int sig, siginfo_t *
  * This also tests UFFD_FEATURE_EVENT_FORK event along with the signal
  * feature. Using monitor thread, verify no userfault events are generated.
  */
-static int faulting_process(int signal_test)
+static int faulting_process(int signal_test, bool wp)
 {
 	unsigned long nr;
 	unsigned long long count;
@@ -343,7 +344,7 @@ static int faulting_process(int signal_t
 					if (steps == 1) {
 						/* This is a MISSING request */
 						steps++;
-						if (copy_page(uffd, offset))
+						if (copy_page(uffd, offset, wp))
 							signalled++;
 					} else {
 						/* This is a WP request */
@@ -507,6 +508,7 @@ static int userfaultfd_events_test(void)
 			  true, test_uffdio_wp, false))
 		err("register failure");
 
+	args.apply_wp = test_uffdio_wp;
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
@@ -515,7 +517,7 @@ static int userfaultfd_events_test(void)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(0));
+		exit(faulting_process(0, test_uffdio_wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -551,11 +553,12 @@ static int userfaultfd_sig_test(void)
 			  true, test_uffdio_wp, false))
 		err("register failure");
 
-	if (faulting_process(1))
+	if (faulting_process(1, test_uffdio_wp))
 		err("faulting process failed");
 
 	uffd_test_ops->release_pages(area_dst);
 
+	args.apply_wp = test_uffdio_wp;
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
@@ -564,7 +567,7 @@ static int userfaultfd_sig_test(void)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(2));
+		exit(faulting_process(2, test_uffdio_wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -628,6 +631,7 @@ static int userfaultfd_minor_test(void)
 		       page_size);
 	}
 
+	args.apply_wp = test_uffdio_wp;
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
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

