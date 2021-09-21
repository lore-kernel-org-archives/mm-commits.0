Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42343C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18CFC611C6
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhIURls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhIURlr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 13:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE7F61178;
        Tue, 21 Sep 2021 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632246018;
        bh=n5W+Vjz3/00Yx2xmjlQW11Q1VO60P1jmwOSRVC+lVPM=;
        h=Date:From:To:Subject:From;
        b=O3LpQM1dDeSMBaH1ZXqfhSaKMxWXyPJETzBA24yFoILk7y0kR1gH5j8gIKjtU4foQ
         J6C29sdHEeRcLLYmnC2DXTspgeTGos8denp1Guwz5iZwpX2XLF8XHNhGml2P6fgzry
         4si+ySaSggYZALk5C96RXrbLnxTRDoX54gq7TAqQ=
Date:   Tue, 21 Sep 2021 10:40:18 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  +
 userfaultfd-selftests-fix-feature-support-detection.patch added to -mm tree
Message-ID: <20210921174018.4VWQw5Aok%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix feature support detection
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-fix-feature-support-detection.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-fix-feature-support-detection.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-fix-feature-support-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: fix feature support detection

Currently, the test decides whether or not to test certain features (e.g.,
writeprotect support) essentially by examining command-line arguments. 
For example, if we're testing anonymous memory, then we should test
writeprotect support as well (since it generally is supported for
anonymous).

This is broken, however.  Take writeprotect support as an example: sure
it's supported for anon, but it also requires that we have
CONFIG_HAVE_ARCH_USERFAULTFD_WP.  I.e., it is not supported at all on
aarch64.  So, running the test on such an arch fails: it tries to test
writeprotect for anon, but since it isn't *actually* supported, it fails.

So, instead of checking command-line arguments to the test, check the
features the way the UFFD API intends: when we open a new userfaultfd,
pass in the feature(s) this test case would like to try to exercise.  The
kernel reports back a subset of those features which are actually
supported: check these returned flags to see if the features are
*actually* supported.

(For a couple of cases, where *registration* would fail [with -EINVAL]
even though UFFDIO_API reports the feature as supported, we have to check
test_type as well as the feature flag.)

In some cases, we check immediately after opening the userfaultfd, and if
the features are missing, we skip the entire test.  In some other cases,
we can proceed with "most" of the test, only skipping a few pieces.

This lets us remove the global test_uffdio_wp and test_uffdio_minor
variables entirely.

Link: https://lkml.kernel.org/r/20210921163323.944352-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   94 +++++++++------------
 1 file changed, 43 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-feature-support-detection
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -79,10 +79,6 @@ static int test_type;
 #define ALARM_INTERVAL_SECS 10
 static volatile bool test_uffdio_copy_eexist = true;
 static volatile bool test_uffdio_zeropage_eexist = true;
-/* Whether to test uffd write-protection */
-static bool test_uffdio_wp = false;
-/* Whether to test uffd minor faults */
-static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int shm_fd;
@@ -90,6 +86,7 @@ static int huge_fd;
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
+static uint64_t uffd_features;
 static int uffd_flags, finished, *pipefd;
 static char *area_src, *area_src_alias, *area_dst, *area_dst_alias;
 static char *zeropage;
@@ -345,7 +342,7 @@ static struct uffd_test_ops hugetlb_uffd
 
 static struct uffd_test_ops *uffd_test_ops;
 
-static void userfaultfd_open(uint64_t *features)
+static void userfaultfd_open(uint64_t features)
 {
 	struct uffdio_api uffdio_api;
 
@@ -355,14 +352,20 @@ static void userfaultfd_open(uint64_t *f
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
-	uffdio_api.features = *features;
+	uffdio_api.features = features;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api))
 		err("UFFDIO_API failed.\nPlease make sure to "
 		    "run with either root or ptrace capability.");
 	if (uffdio_api.api != UFFD_API)
 		err("UFFDIO_API error: %" PRIu64, (uint64_t)uffdio_api.api);
 
-	*features = uffdio_api.features;
+	uffd_features = uffdio_api.features;
+}
+
+static inline bool uffd_wp_supported(void)
+{
+	return test_type == TEST_ANON &&
+		(uffd_features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 }
 
 static inline void munmap_area(void **area)
@@ -397,6 +400,7 @@ static void uffd_test_ctx_clear(void)
 			err("close uffd");
 		uffd = -1;
 	}
+	uffd_features = 0;
 
 	huge_fd_off0 = NULL;
 	munmap_area((void **)&area_src);
@@ -405,7 +409,7 @@ static void uffd_test_ctx_clear(void)
 	munmap_area((void **)&area_dst_alias);
 }
 
-static void uffd_test_ctx_init_ext(uint64_t *features)
+static void uffd_test_ctx_init(uint64_t features)
 {
 	unsigned long nr, cpu;
 
@@ -445,11 +449,6 @@ static void uffd_test_ctx_init_ext(uint6
 			err("pipe");
 }
 
-static inline void uffd_test_ctx_init(uint64_t features)
-{
-	uffd_test_ctx_init_ext(&features);
-}
-
 static int my_bcmp(char *str1, char *str2, size_t n)
 {
 	unsigned long i;
@@ -587,7 +586,7 @@ static int __copy_page(int ufd, unsigned
 	uffdio_copy.dst = (unsigned long) area_dst + offset;
 	uffdio_copy.src = (unsigned long) area_src + offset;
 	uffdio_copy.len = page_size;
-	if (test_uffdio_wp)
+	if (uffd_wp_supported())
 		uffdio_copy.mode = UFFDIO_COPY_MODE_WP;
 	else
 		uffdio_copy.mode = 0;
@@ -778,7 +777,7 @@ static void *background_thread(void *arg
 	 * at least the first half of the pages mapped already which
 	 * can be write-protected for testing
 	 */
-	if (test_uffdio_wp)
+	if (uffd_wp_supported())
 		wp_range(uffd, (unsigned long)area_dst + start_nr * page_size,
 			nr_pages_per_cpu * page_size, true);
 
@@ -1062,12 +1061,12 @@ static int userfaultfd_zeropage_test(voi
 	printf("testing UFFDIO_ZEROPAGE: ");
 	fflush(stdout);
 
-	uffd_test_ctx_init(0);
+	uffd_test_ctx_init(UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
+	if (uffd_wp_supported())
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
@@ -1089,7 +1088,7 @@ static int userfaultfd_events_test(void)
 	struct uffdio_register uffdio_register;
 	unsigned long expected_ioctls;
 	pthread_t uffd_mon;
-	int err, features;
+	int err;
 	pid_t pid;
 	char c;
 	struct uffd_stats stats = { 0 };
@@ -1097,16 +1096,15 @@ static int userfaultfd_events_test(void)
 	printf("testing events (fork, remap, remove): ");
 	fflush(stdout);
 
-	features = UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
-		UFFD_FEATURE_EVENT_REMOVE;
-	uffd_test_ctx_init(features);
+	uffd_test_ctx_init(UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
+			   UFFD_FEATURE_EVENT_REMOVE | UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
+	if (uffd_wp_supported())
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
@@ -1144,7 +1142,7 @@ static int userfaultfd_sig_test(void)
 	unsigned long expected_ioctls;
 	unsigned long userfaults;
 	pthread_t uffd_mon;
-	int err, features;
+	int err;
 	pid_t pid;
 	char c;
 	struct uffd_stats stats = { 0 };
@@ -1152,15 +1150,15 @@ static int userfaultfd_sig_test(void)
 	printf("testing signal delivery: ");
 	fflush(stdout);
 
-	features = UFFD_FEATURE_EVENT_FORK|UFFD_FEATURE_SIGBUS;
-	uffd_test_ctx_init(features);
+	uffd_test_ctx_init(UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_SIGBUS |
+			   UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	uffdio_register.range.start = (unsigned long) area_dst;
 	uffdio_register.range.len = nr_pages * page_size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-	if (test_uffdio_wp)
+	if (uffd_wp_supported())
 		uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
@@ -1209,25 +1207,23 @@ static int userfaultfd_minor_test(void)
 	void *expected_page;
 	char c;
 	struct uffd_stats stats = { 0 };
-	uint64_t req_features, features_out;
-
-	if (!test_uffdio_minor)
-		return 0;
+	uint64_t features;
 
 	printf("testing minor faults: ");
 	fflush(stdout);
 
-	if (test_type == TEST_HUGETLB)
-		req_features = UFFD_FEATURE_MINOR_HUGETLBFS;
+	if (test_type == TEST_HUGETLB && map_shared)
+		features = UFFD_FEATURE_MINOR_HUGETLBFS;
 	else if (test_type == TEST_SHMEM)
-		req_features = UFFD_FEATURE_MINOR_SHMEM;
-	else
-		return 1;
+		features = UFFD_FEATURE_MINOR_SHMEM;
+	else {
+		printf("skipping test due to unsupported memory type\n");
+		return 0;
+	}
 
-	features_out = req_features;
-	uffd_test_ctx_init_ext(&features_out);
+	uffd_test_ctx_init(features);
 	/* If kernel reports required features aren't supported, skip test. */
-	if ((features_out & req_features) != req_features) {
+	if ((uffd_features & features) != features) {
 		printf("skipping test due to lack of feature support\n");
 		fflush(stdout);
 		return 0;
@@ -1349,10 +1345,6 @@ static void userfaultfd_pagemap_test(uns
 	int pagemap_fd;
 	uint64_t value;
 
-	/* Pagemap tests uffd-wp only */
-	if (!test_uffdio_wp)
-		return;
-
 	/* Not enough memory to test this page size */
 	if (test_pgsize > nr_pages * page_size)
 		return;
@@ -1361,7 +1353,12 @@ static void userfaultfd_pagemap_test(uns
 	/* Flush so it doesn't flush twice in parent/child later */
 	fflush(stdout);
 
-	uffd_test_ctx_init(0);
+	uffd_test_ctx_init(UFFD_FEATURE_PAGEFAULT_FLAG_WP);
+	/* Pagemap tests uffd-wp only */
+	if (!uffd_wp_supported()) {
+		printf("skipping test due to lack of feature support\n");
+		return;
+	}
 
 	if (test_pgsize > page_size) {
 		/* This is a thp test */
@@ -1426,7 +1423,7 @@ static int userfaultfd_stress(void)
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
 
-	uffd_test_ctx_init(0);
+	uffd_test_ctx_init(UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 
 	if (posix_memalign(&area, page_size, page_size))
 		err("out of memory");
@@ -1464,7 +1461,7 @@ static int userfaultfd_stress(void)
 		uffdio_register.range.start = (unsigned long) area_dst;
 		uffdio_register.range.len = nr_pages * page_size;
 		uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
-		if (test_uffdio_wp)
+		if (uffd_wp_supported())
 			uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 			err("register failure");
@@ -1513,7 +1510,7 @@ static int userfaultfd_stress(void)
 			return 1;
 
 		/* Clear all the write protections if there is any */
-		if (test_uffdio_wp)
+		if (uffd_wp_supported())
 			wp_range(uffd, (unsigned long)area_dst,
 				 nr_pages * page_size, false);
 
@@ -1595,8 +1592,6 @@ static void set_test_type(const char *ty
 	if (!strcmp(type, "anon")) {
 		test_type = TEST_ANON;
 		uffd_test_ops = &anon_uffd_test_ops;
-		/* Only enable write-protect test for anonymous test */
-		test_uffdio_wp = true;
 	} else if (!strcmp(type, "hugetlb")) {
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
@@ -1604,13 +1599,10 @@ static void set_test_type(const char *ty
 		map_shared = true;
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
-		/* Minor faults require shared hugetlb; only enable here. */
-		test_uffdio_minor = true;
 	} else if (!strcmp(type, "shmem")) {
 		map_shared = true;
 		test_type = TEST_SHMEM;
 		uffd_test_ops = &shmem_uffd_test_ops;
-		test_uffdio_minor = true;
 	} else {
 		err("Unknown test type: %s", type);
 	}
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-selftests-fix-feature-support-detection.patch
userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch
userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch

