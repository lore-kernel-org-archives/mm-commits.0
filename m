Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA582C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C050661104
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhDICkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhDICkk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 22:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D361E610C9;
        Fri,  9 Apr 2021 02:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617936027;
        bh=VKCYkn++aXWMAbi0Evwqlb7KCPiA2XuK2JxLnahN5pM=;
        h=Date:From:To:Subject:From;
        b=G85Z+G9jWaJ1Hckiq02PV20CZjSWOZRA+C/dowB8l0aIP61JKKBfbwdNd40g4qxPA
         mLMebUXpR8R2HG6MzHdxLbpWJBTayk3jQ5XKPVnR5XYRRdqN64M4G+msbGlK6eaavW
         38sXq1tQxUQbriQG/QlSAh4Ju4fjDKEfBmrtr0tQ=
Date:   Thu, 08 Apr 2021 19:40:26 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com,
        cannonmatthews@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, lokeshgidra@google.com,
        mm-commits@vger.kernel.org, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com,
        shuah@kernel.org, viro@zeniv.linux.org.uk, walken@google.com,
        wangqing@vivo.com
Subject:  [to-be-updated]
 userfaultfd-selftests-reinitialize-test-context-in-each-test.patch removed
 from -mm tree
Message-ID: <20210409024026.SbeCn4hee%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: reinitialize test context in each test
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-reinitialize-test-context-in-each-test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: reinitialize test context in each test

Currently, the context (fds, mmap-ed areas, etc.) are global.  Each test
mutates this state in some way, in some cases really "clobbering it"
(e.g., the events test mremap-ing area_dst over the top of area_src, or
the minor faults tests overwriting the count_verify values in the test
areas).  We run the tests in a particular order, each test is careful to
make the right assumptions about its starting state, etc.

But, this is fragile.  It's better for a test's success or failure to not
depend on what some other prior test case did to the global state.

To that end, clear and reinitialize the test context at the start of each
test case, so whatever prior test cases did doesn't affect future tests.

This is particularly relevant to this series because the events test's
mremap of area_dst screws up assumptions the minor fault test was relying
on.  This wasn't a problem for hugetlb, as we don't mremap in that case.

Link: https://lkml.kernel.org/r/20210302000133.272579-5-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  249 ++++++++++++---------
 1 file changed, 151 insertions(+), 98 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-reinitialize-test-context-in-each-test
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -89,7 +89,8 @@ static int shm_fd;
 static int huge_fd;
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
-static int uffd, uffd_flags, finished, *pipefd;
+static int uffd = -1;
+static int uffd_flags, finished, *pipefd;
 static char *area_src, *area_src_alias, *area_dst, *area_dst_alias;
 static char *zeropage;
 pthread_attr_t attr;
@@ -376,6 +377,146 @@ static struct uffd_test_ops hugetlb_uffd
 
 static struct uffd_test_ops *uffd_test_ops;
 
+static int userfaultfd_open(uint64_t *features)
+{
+	struct uffdio_api uffdio_api;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0) {
+		fprintf(stderr,
+			"userfaultfd syscall not available in this kernel\n");
+		return 1;
+	}
+	uffd_flags = fcntl(uffd, F_GETFD, NULL);
+
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = *features;
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
+		fprintf(stderr, "UFFDIO_API failed.\nPlease make sure to "
+			"run with either root or ptrace capability.\n");
+		return 1;
+	}
+	if (uffdio_api.api != UFFD_API) {
+		fprintf(stderr, "UFFDIO_API error: %" PRIu64 "\n",
+			(uint64_t)uffdio_api.api);
+		return 1;
+	}
+
+	*features = uffdio_api.features;
+	return 0;
+}
+
+static int uffd_test_ctx_init_ext(uint64_t *features)
+{
+	unsigned long nr, cpu;
+
+	uffd_test_ops->allocate_area((void **)&area_src);
+	if (!area_src)
+		return 1;
+	uffd_test_ops->allocate_area((void **)&area_dst);
+	if (!area_dst)
+		return 1;
+
+	if (uffd_test_ops->release_pages(area_src))
+		return 1;
+
+	if (uffd_test_ops->release_pages(area_dst))
+		return 1;
+
+	if (userfaultfd_open(features))
+		return 1;
+
+	count_verify = malloc(nr_pages * sizeof(unsigned long long));
+	if (!count_verify) {
+		perror("count_verify");
+		return 1;
+	}
+
+	for (nr = 0; nr < nr_pages; nr++) {
+		*area_mutex(area_src, nr) =
+			(pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
+		count_verify[nr] = *area_count(area_src, nr) = 1;
+		/*
+		 * In the transition between 255 to 256, powerpc will
+		 * read out of order in my_bcmp and see both bytes as
+		 * zero, so leave a placeholder below always non-zero
+		 * after the count, to avoid my_bcmp to trigger false
+		 * positives.
+		 */
+		*(area_count(area_src, nr) + 1) = 1;
+	}
+
+	pipefd = malloc(sizeof(int) * nr_cpus * 2);
+	if (!pipefd) {
+		perror("pipefd");
+		return 1;
+	}
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK)) {
+			perror("pipe");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline int uffd_test_ctx_init(uint64_t features)
+{
+	return uffd_test_ctx_init_ext(&features);
+}
+
+static inline int munmap_area(void **area)
+{
+	if (*area) {
+		if (munmap(*area, nr_pages * page_size)) {
+			perror("munmap");
+			return 1;
+		}
+	}
+
+	*area = NULL;
+	return 0;
+}
+
+static int uffd_test_ctx_clear(void)
+{
+	int ret = 0;
+	size_t i;
+
+	if (pipefd) {
+		for (i = 0; i < nr_cpus * 2; ++i) {
+			if (close(pipefd[i])) {
+				perror("close pipefd");
+				ret = 1;
+			}
+		}
+		free(pipefd);
+		pipefd = NULL;
+	}
+
+	if (count_verify) {
+		free(count_verify);
+		count_verify = NULL;
+	}
+
+	if (uffd != -1) {
+		if (close(uffd)) {
+			perror("close uffd");
+			ret = 1;
+		}
+		uffd = -1;
+	}
+
+	huge_fd_off0 = NULL;
+	ret |= munmap_area((void **)&area_src);
+	ret |= munmap_area((void **)&area_src_alias);
+	ret |= munmap_area((void **)&area_dst);
+	ret |= munmap_area((void **)&area_dst_alias);
+
+	return ret;
+}
+
 static int my_bcmp(char *str1, char *str2, size_t n)
 {
 	unsigned long i;
@@ -872,40 +1013,6 @@ static int stress(struct uffd_stats *uff
 	return 0;
 }
 
-static int userfaultfd_open_ext(uint64_t *features)
-{
-	struct uffdio_api uffdio_api;
-
-	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	if (uffd < 0) {
-		fprintf(stderr,
-			"userfaultfd syscall not available in this kernel\n");
-		return 1;
-	}
-	uffd_flags = fcntl(uffd, F_GETFD, NULL);
-
-	uffdio_api.api = UFFD_API;
-	uffdio_api.features = *features;
-	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
-		fprintf(stderr, "UFFDIO_API failed.\nPlease make sure to "
-			"run with either root or ptrace capability.\n");
-		return 1;
-	}
-	if (uffdio_api.api != UFFD_API) {
-		fprintf(stderr, "UFFDIO_API error: %" PRIu64 "\n",
-			(uint64_t)uffdio_api.api);
-		return 1;
-	}
-
-	*features = uffdio_api.features;
-	return 0;
-}
-
-static int userfaultfd_open(uint64_t features)
-{
-	return userfaultfd_open_ext(&features);
-}
-
 sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1023,6 +1130,8 @@ static int faulting_process(int signal_t
 		perror("mremap");
 		exit(1);
 	}
+	/* Reset area_src since we just clobbered it */
+	area_src = NULL;
 
 	for (; nr < nr_pages; nr++) {
 		count = *area_count(area_dst, nr);
@@ -1126,11 +1235,9 @@ static int userfaultfd_zeropage_test(voi
 	printf("testing UFFDIO_ZEROPAGE: ");
 	fflush(stdout);
 
-	if (uffd_test_ops->release_pages(area_dst))
+	if (uffd_test_ctx_clear() || uffd_test_ctx_init(0))
 		return 1;
 
-	if (userfaultfd_open(0))
-		return 1;
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
@@ -1156,7 +1263,6 @@ static int userfaultfd_zeropage_test(voi
 		}
 	}
 
-	close(uffd);
 	printf("done.\n");
 	return 0;
 }
@@ -1174,13 +1280,11 @@ static int userfaultfd_events_test(void)
 	printf("testing events (fork, remap, remove): ");
 	fflush(stdout);
 
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
-
 	features = UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
 		UFFD_FEATURE_EVENT_REMOVE;
-	if (userfaultfd_open(features))
+	if (uffd_test_ctx_clear() || uffd_test_ctx_init(features))
 		return 1;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	uffdio_register.range.start = (unsigned long) area_dst;
@@ -1226,8 +1330,6 @@ static int userfaultfd_events_test(void)
 	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
-	close(uffd);
-
 	uffd_stats_report(&stats, 1);
 
 	return stats.missing_faults != nr_pages;
@@ -1247,12 +1349,10 @@ static int userfaultfd_sig_test(void)
 	printf("testing signal delivery: ");
 	fflush(stdout);
 
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
-
 	features = UFFD_FEATURE_EVENT_FORK|UFFD_FEATURE_SIGBUS;
-	if (userfaultfd_open(features))
+	if (uffd_test_ctx_clear() || uffd_test_ctx_init(features))
 		return 1;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	uffdio_register.range.start = (unsigned long) area_dst;
@@ -1310,7 +1410,6 @@ static int userfaultfd_sig_test(void)
 	if (userfaults)
 		fprintf(stderr, "Signal test failed, userfaults: %ld\n",
 			userfaults);
-	close(uffd);
 	return userfaults != 0;
 }
 
@@ -1332,10 +1431,7 @@ static int userfaultfd_minor_test(void)
 	printf("testing minor faults: ");
 	fflush(stdout);
 
-	if (uffd_test_ops->release_pages(area_dst))
-		return 1;
-
-	if (userfaultfd_open_ext(&features))
+	if (uffd_test_ctx_clear() || uffd_test_ctx_init_ext(&features))
 		return 1;
 	/* If kernel reports the feature isn't supported, skip the test. */
 	if (!(features & UFFD_FEATURE_MINOR_HUGETLBFS)) {
@@ -1403,8 +1499,6 @@ static int userfaultfd_minor_test(void)
 	if (pthread_join(uffd_mon, NULL))
 		return 1;
 
-	close(uffd);
-
 	uffd_stats_report(&stats, 1);
 
 	return stats.missing_faults != 0 || stats.minor_faults != nr_pages;
@@ -1416,52 +1510,12 @@ static int userfaultfd_stress(void)
 	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
-	unsigned long cpu;
 	int err;
 	struct uffd_stats uffd_stats[nr_cpus];
 
-	uffd_test_ops->allocate_area((void **)&area_src);
-	if (!area_src)
-		return 1;
-	uffd_test_ops->allocate_area((void **)&area_dst);
-	if (!area_dst)
-		return 1;
-
-	if (userfaultfd_open(0))
+	if (uffd_test_ctx_init(0))
 		return 1;
 
-	count_verify = malloc(nr_pages * sizeof(unsigned long long));
-	if (!count_verify) {
-		perror("count_verify");
-		return 1;
-	}
-
-	for (nr = 0; nr < nr_pages; nr++) {
-		*area_mutex(area_src, nr) = (pthread_mutex_t)
-			PTHREAD_MUTEX_INITIALIZER;
-		count_verify[nr] = *area_count(area_src, nr) = 1;
-		/*
-		 * In the transition between 255 to 256, powerpc will
-		 * read out of order in my_bcmp and see both bytes as
-		 * zero, so leave a placeholder below always non-zero
-		 * after the count, to avoid my_bcmp to trigger false
-		 * positives.
-		 */
-		*(area_count(area_src, nr) + 1) = 1;
-	}
-
-	pipefd = malloc(sizeof(int) * nr_cpus * 2);
-	if (!pipefd) {
-		perror("pipefd");
-		return 1;
-	}
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (pipe2(&pipefd[cpu*2], O_CLOEXEC | O_NONBLOCK)) {
-			perror("pipe");
-			return 1;
-		}
-	}
-
 	if (posix_memalign(&area, page_size, page_size)) {
 		fprintf(stderr, "out of memory\n");
 		return 1;
@@ -1606,7 +1660,6 @@ static int userfaultfd_stress(void)
 	if (err)
 		return err;
 
-	close(uffd);
 	return userfaultfd_zeropage_test() || userfaultfd_sig_test()
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

