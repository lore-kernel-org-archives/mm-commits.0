Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95764C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDRXiY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjDRXgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11748D32F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95AC61528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B355C433D2;
        Tue, 18 Apr 2023 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860934;
        bh=F+slbD87aoL6JSfD2rKJ5Rp7GC1tWSYsNVYoZvjw1BY=;
        h=Date:To:From:Subject:From;
        b=kznsQ5r+AtejNYN/8oPwiMG5siTNsik09gUacNqEIQTSHTyzkq1wfZ7Y+dOxaTMri
         w4N1tw3Qjzer6yi+KibclISsTFE6tzc5rtNkPVAz+vyTFRAJ+S8P+wD7ShiloZG1q0
         2aJO3YWUocGaG9UOTYWOTPDpouoV5rdDG2Tg8c7w=
Date:   Tue, 18 Apr 2023 16:35:33 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch removed from -mm tree
Message-Id: <20230418233534.3B355C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: move uffd sig/events tests into uffd unit tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: move uffd sig/events tests into uffd unit tests
Date: Wed, 12 Apr 2023 12:44:00 -0400

Move the two tests into the unit test, and convert it into 20 standalone
tests:

  - events test on all 5 mem types, with wp on/off
  - signal test on all 5 mem types, with wp on/off

  Testing sigbus on anon... done
  Testing sigbus on shmem... done
  Testing sigbus on shmem-private... done
  Testing sigbus on hugetlb... done
  Testing sigbus on hugetlb-private... done
  Testing sigbus-wp on anon... done
  Testing sigbus-wp on shmem... done
  Testing sigbus-wp on shmem-private... done
  Testing sigbus-wp on hugetlb... done
  Testing sigbus-wp on hugetlb-private... done
  Testing events on anon... done
  Testing events on shmem... done
  Testing events on shmem-private... done
  Testing events on hugetlb... done
  Testing events on hugetlb-private... done
  Testing events-wp on anon... done
  Testing events-wp on shmem... done
  Testing events-wp on shmem-private... done
  Testing events-wp on hugetlb... done
  Testing events-wp on hugetlb-private... done

It'll also remove a lot of global references along the way,
e.g. test_uffdio_wp will be replaced with the wp value passed over.

Link: https://lkml.kernel.org/r/20230412164400.328798-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c     |  227 --------------
 tools/testing/selftests/mm/uffd-unit-tests.c |  264 +++++++++++++++++
 2 files changed, 265 insertions(+), 226 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -273,133 +273,6 @@ static int stress(struct uffd_args *args
 	return 0;
 }
 
-sigjmp_buf jbuf, *sigbuf;
-
-static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
-{
-	if (sig == SIGBUS) {
-		if (sigbuf)
-			siglongjmp(*sigbuf, 1);
-		abort();
-	}
-}
-
-/*
- * For non-cooperative userfaultfd test we fork() a process that will
- * generate pagefaults, will mremap the area monitored by the
- * userfaultfd and at last this process will release the monitored
- * area.
- * For the anonymous and shared memory the area is divided into two
- * parts, the first part is accessed before mremap, and the second
- * part is accessed after mremap. Since hugetlbfs does not support
- * mremap, the entire monitored area is accessed in a single pass for
- * HUGETLB_TEST.
- * The release of the pages currently generates event for shmem and
- * anonymous memory (UFFD_EVENT_REMOVE), hence it is not checked
- * for hugetlb.
- * For signal test(UFFD_FEATURE_SIGBUS), signal_test = 1, we register
- * monitored area, generate pagefaults and test that signal is delivered.
- * Use UFFDIO_COPY to allocate missing page and retry. For signal_test = 2
- * test robustness use case - we release monitored area, fork a process
- * that will generate pagefaults and verify signal is generated.
- * This also tests UFFD_FEATURE_EVENT_FORK event along with the signal
- * feature. Using monitor thread, verify no userfault events are generated.
- */
-static int faulting_process(int signal_test, bool wp)
-{
-	unsigned long nr;
-	unsigned long long count;
-	unsigned long split_nr_pages;
-	unsigned long lastnr;
-	struct sigaction act;
-	volatile unsigned long signalled = 0;
-
-	split_nr_pages = (nr_pages + 1) / 2;
-
-	if (signal_test) {
-		sigbuf = &jbuf;
-		memset(&act, 0, sizeof(act));
-		act.sa_sigaction = sighndl;
-		act.sa_flags = SA_SIGINFO;
-		if (sigaction(SIGBUS, &act, 0))
-			err("sigaction");
-		lastnr = (unsigned long)-1;
-	}
-
-	for (nr = 0; nr < split_nr_pages; nr++) {
-		volatile int steps = 1;
-		unsigned long offset = nr * page_size;
-
-		if (signal_test) {
-			if (sigsetjmp(*sigbuf, 1) != 0) {
-				if (steps == 1 && nr == lastnr)
-					err("Signal repeated");
-
-				lastnr = nr;
-				if (signal_test == 1) {
-					if (steps == 1) {
-						/* This is a MISSING request */
-						steps++;
-						if (copy_page(uffd, offset, wp))
-							signalled++;
-					} else {
-						/* This is a WP request */
-						assert(steps == 2);
-						wp_range(uffd,
-							 (__u64)area_dst +
-							 offset,
-							 page_size, false);
-					}
-				} else {
-					signalled++;
-					continue;
-				}
-			}
-		}
-
-		count = *area_count(area_dst, nr);
-		if (count != count_verify[nr])
-			err("nr %lu memory corruption %llu %llu\n",
-			    nr, count, count_verify[nr]);
-		/*
-		 * Trigger write protection if there is by writing
-		 * the same value back.
-		 */
-		*area_count(area_dst, nr) = count;
-	}
-
-	if (signal_test)
-		return signalled != split_nr_pages;
-
-	area_dst = mremap(area_dst, nr_pages * page_size,  nr_pages * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, area_src);
-	if (area_dst == MAP_FAILED)
-		err("mremap");
-	/* Reset area_src since we just clobbered it */
-	area_src = NULL;
-
-	for (; nr < nr_pages; nr++) {
-		count = *area_count(area_dst, nr);
-		if (count != count_verify[nr]) {
-			err("nr %lu memory corruption %llu %llu\n",
-			    nr, count, count_verify[nr]);
-		}
-		/*
-		 * Trigger write protection if there is by writing
-		 * the same value back.
-		 */
-		*area_count(area_dst, nr) = count;
-	}
-
-	uffd_test_ops->release_pages(area_dst);
-
-	for (nr = 0; nr < nr_pages; nr++)
-		if (my_bcmp(area_dst + nr * page_size, zeropage, page_size))
-			err("nr %lu is not zero", nr);
-
-	return 0;
-}
-
 static void retry_uffdio_zeropage(int ufd,
 				  struct uffdio_zeropage *uffdio_zeropage,
 				  unsigned long offset)
@@ -483,103 +356,6 @@ static int userfaultfd_zeropage_test(voi
 	return 0;
 }
 
-static int userfaultfd_events_test(void)
-{
-	pthread_t uffd_mon;
-	int err, features;
-	pid_t pid;
-	char c;
-	struct uffd_args args = { 0 };
-
-	printf("testing events (fork, remap, remove): ");
-	fflush(stdout);
-
-	features = UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
-		UFFD_FEATURE_EVENT_REMOVE;
-	uffd_test_ctx_init(features);
-
-	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
-
-	if (uffd_register(uffd, area_dst, nr_pages * page_size,
-			  true, test_uffdio_wp, false))
-		err("register failure");
-
-	args.apply_wp = test_uffdio_wp;
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &args))
-		err("uffd_poll_thread create");
-
-	pid = fork();
-	if (pid < 0)
-		err("fork");
-
-	if (!pid)
-		exit(faulting_process(0, test_uffdio_wp));
-
-	waitpid(pid, &err, 0);
-	if (err)
-		err("faulting process failed");
-	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
-		err("pipe write");
-	if (pthread_join(uffd_mon, NULL))
-		return 1;
-
-	uffd_stats_report(&args, 1);
-
-	return args.missing_faults != nr_pages;
-}
-
-static int userfaultfd_sig_test(void)
-{
-	unsigned long userfaults;
-	pthread_t uffd_mon;
-	int err, features;
-	pid_t pid;
-	char c;
-	struct uffd_args args = { 0 };
-
-	printf("testing signal delivery: ");
-	fflush(stdout);
-
-	features = UFFD_FEATURE_EVENT_FORK|UFFD_FEATURE_SIGBUS;
-	uffd_test_ctx_init(features);
-
-	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
-
-	if (uffd_register(uffd, area_dst, nr_pages * page_size,
-			  true, test_uffdio_wp, false))
-		err("register failure");
-
-	if (faulting_process(1, test_uffdio_wp))
-		err("faulting process failed");
-
-	uffd_test_ops->release_pages(area_dst);
-
-	args.apply_wp = test_uffdio_wp;
-	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &args))
-		err("uffd_poll_thread create");
-
-	pid = fork();
-	if (pid < 0)
-		err("fork");
-
-	if (!pid)
-		exit(faulting_process(2, test_uffdio_wp));
-
-	waitpid(pid, &err, 0);
-	if (err)
-		err("faulting process failed");
-	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
-		err("pipe write");
-	if (pthread_join(uffd_mon, (void **)&userfaults))
-		return 1;
-
-	printf("done.\n");
-	if (userfaults)
-		err("Signal test failed, userfaults: %ld", userfaults);
-
-	return userfaults != 0;
-}
-
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -691,8 +467,7 @@ static int userfaultfd_stress(void)
 		uffd_stats_report(args, nr_cpus);
 	}
 
-	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
-	    || userfaultfd_events_test();
+	return userfaultfd_zeropage_test();
 }
 
 static void set_test_type(const char *type)
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -18,6 +18,9 @@
 #define  MEM_HUGETLB                      BIT_ULL(3)
 #define  MEM_HUGETLB_PRIVATE              BIT_ULL(4)
 
+#define  MEM_ALL  (MEM_ANON | MEM_SHMEM | MEM_SHMEM_PRIVATE | \
+		   MEM_HUGETLB | MEM_HUGETLB_PRIVATE)
+
 struct mem_type {
 	const char *name;
 	unsigned int mem_flag;
@@ -426,6 +429,237 @@ void uffd_minor_collapse_test(void)
 	uffd_minor_test_common(true, false);
 }
 
+static sigjmp_buf jbuf, *sigbuf;
+
+static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
+{
+	if (sig == SIGBUS) {
+		if (sigbuf)
+			siglongjmp(*sigbuf, 1);
+		abort();
+	}
+}
+
+/*
+ * For non-cooperative userfaultfd test we fork() a process that will
+ * generate pagefaults, will mremap the area monitored by the
+ * userfaultfd and at last this process will release the monitored
+ * area.
+ * For the anonymous and shared memory the area is divided into two
+ * parts, the first part is accessed before mremap, and the second
+ * part is accessed after mremap. Since hugetlbfs does not support
+ * mremap, the entire monitored area is accessed in a single pass for
+ * HUGETLB_TEST.
+ * The release of the pages currently generates event for shmem and
+ * anonymous memory (UFFD_EVENT_REMOVE), hence it is not checked
+ * for hugetlb.
+ * For signal test(UFFD_FEATURE_SIGBUS), signal_test = 1, we register
+ * monitored area, generate pagefaults and test that signal is delivered.
+ * Use UFFDIO_COPY to allocate missing page and retry. For signal_test = 2
+ * test robustness use case - we release monitored area, fork a process
+ * that will generate pagefaults and verify signal is generated.
+ * This also tests UFFD_FEATURE_EVENT_FORK event along with the signal
+ * feature. Using monitor thread, verify no userfault events are generated.
+ */
+static int faulting_process(int signal_test, bool wp)
+{
+	unsigned long nr, i;
+	unsigned long long count;
+	unsigned long split_nr_pages;
+	unsigned long lastnr;
+	struct sigaction act;
+	volatile unsigned long signalled = 0;
+
+	split_nr_pages = (nr_pages + 1) / 2;
+
+	if (signal_test) {
+		sigbuf = &jbuf;
+		memset(&act, 0, sizeof(act));
+		act.sa_sigaction = sighndl;
+		act.sa_flags = SA_SIGINFO;
+		if (sigaction(SIGBUS, &act, 0))
+			err("sigaction");
+		lastnr = (unsigned long)-1;
+	}
+
+	for (nr = 0; nr < split_nr_pages; nr++) {
+		volatile int steps = 1;
+		unsigned long offset = nr * page_size;
+
+		if (signal_test) {
+			if (sigsetjmp(*sigbuf, 1) != 0) {
+				if (steps == 1 && nr == lastnr)
+					err("Signal repeated");
+
+				lastnr = nr;
+				if (signal_test == 1) {
+					if (steps == 1) {
+						/* This is a MISSING request */
+						steps++;
+						if (copy_page(uffd, offset, wp))
+							signalled++;
+					} else {
+						/* This is a WP request */
+						assert(steps == 2);
+						wp_range(uffd,
+							 (__u64)area_dst +
+							 offset,
+							 page_size, false);
+					}
+				} else {
+					signalled++;
+					continue;
+				}
+			}
+		}
+
+		count = *area_count(area_dst, nr);
+		if (count != count_verify[nr])
+			err("nr %lu memory corruption %llu %llu\n",
+			    nr, count, count_verify[nr]);
+		/*
+		 * Trigger write protection if there is by writing
+		 * the same value back.
+		 */
+		*area_count(area_dst, nr) = count;
+	}
+
+	if (signal_test)
+		return signalled != split_nr_pages;
+
+	area_dst = mremap(area_dst, nr_pages * page_size,  nr_pages * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, area_src);
+	if (area_dst == MAP_FAILED)
+		err("mremap");
+	/* Reset area_src since we just clobbered it */
+	area_src = NULL;
+
+	for (; nr < nr_pages; nr++) {
+		count = *area_count(area_dst, nr);
+		if (count != count_verify[nr]) {
+			err("nr %lu memory corruption %llu %llu\n",
+			    nr, count, count_verify[nr]);
+		}
+		/*
+		 * Trigger write protection if there is by writing
+		 * the same value back.
+		 */
+		*area_count(area_dst, nr) = count;
+	}
+
+	uffd_test_ops->release_pages(area_dst);
+
+	for (nr = 0; nr < nr_pages; nr++)
+		for (i = 0; i < page_size; i++)
+			if (*(area_dst + nr * page_size + i) != 0)
+				err("page %lu offset %lu is not zero", nr, i);
+
+	return 0;
+}
+
+static void uffd_sigbus_test_common(bool wp)
+{
+	unsigned long userfaults;
+	pthread_t uffd_mon;
+	pid_t pid;
+	int err;
+	char c;
+	struct uffd_args args = { 0 };
+
+	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
+
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, wp, false))
+		err("register failure");
+
+	if (faulting_process(1, wp))
+		err("faulting process failed");
+
+	uffd_test_ops->release_pages(area_dst);
+
+	args.apply_wp = wp;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	pid = fork();
+	if (pid < 0)
+		err("fork");
+
+	if (!pid)
+		exit(faulting_process(2, wp));
+
+	waitpid(pid, &err, 0);
+	if (err)
+		err("faulting process failed");
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, (void **)&userfaults))
+		err("pthread_join()");
+
+	if (userfaults)
+		uffd_test_fail("Signal test failed, userfaults: %ld", userfaults);
+	else
+		uffd_test_pass();
+}
+
+static void uffd_sigbus_test(void)
+{
+	uffd_sigbus_test_common(false);
+}
+
+static void uffd_sigbus_wp_test(void)
+{
+	uffd_sigbus_test_common(true);
+}
+
+static void uffd_events_test_common(bool wp)
+{
+	pthread_t uffd_mon;
+	pid_t pid;
+	int err;
+	char c;
+	struct uffd_args args = { 0 };
+
+	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
+	if (uffd_register(uffd, area_dst, nr_pages * page_size,
+			  true, wp, false))
+		err("register failure");
+
+	args.apply_wp = wp;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	pid = fork();
+	if (pid < 0)
+		err("fork");
+
+	if (!pid)
+		exit(faulting_process(0, wp));
+
+	waitpid(pid, &err, 0);
+	if (err)
+		err("faulting process failed");
+	if (write(pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("pthread_join()");
+
+	if (args.missing_faults != nr_pages)
+		uffd_test_fail("Fault counts wrong");
+	else
+		uffd_test_pass();
+}
+
+static void uffd_events_test(void)
+{
+	uffd_events_test_common(false);
+}
+
+static void uffd_events_wp_test(void)
+{
+	uffd_events_test_common(true);
+}
+
 uffd_test_case_t uffd_tests[] = {
 	{
 		.name = "pagemap",
@@ -463,6 +697,36 @@ uffd_test_case_t uffd_tests[] = {
 		/* We can't test MADV_COLLAPSE, so try our luck */
 		.uffd_feature_required = UFFD_FEATURE_MINOR_SHMEM,
 	},
+	{
+		.name = "sigbus",
+		.uffd_fn = uffd_sigbus_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_SIGBUS |
+		UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "sigbus-wp",
+		.uffd_fn = uffd_sigbus_wp_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_SIGBUS |
+		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+	},
+	{
+		.name = "events",
+		.uffd_fn = uffd_events_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_EVENT_FORK |
+		UFFD_FEATURE_EVENT_REMAP | UFFD_FEATURE_EVENT_REMOVE,
+	},
+	{
+		.name = "events-wp",
+		.uffd_fn = uffd_events_wp_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_EVENT_FORK |
+		UFFD_FEATURE_EVENT_REMAP | UFFD_FEATURE_EVENT_REMOVE |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
 };
 
 int main(int argc, char *argv[])
_

Patches currently in -mm which might be from peterx@redhat.com are

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

