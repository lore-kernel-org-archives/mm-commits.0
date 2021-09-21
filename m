Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C127AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2DF4611ED
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 17:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhIURlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 13:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhIURlu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 13:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EAB7611C6;
        Tue, 21 Sep 2021 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632246021;
        bh=Pjw2ghYxKUzAMscKe7w8OFzqZcXQdJYdHN32QuofQmc=;
        h=Date:From:To:Subject:From;
        b=F6QiCvd8z5izb9X3KGEejVrm9npWOZOe/33UK0IQtE9MqrW6ibmYLgJXwlsDrTCsw
         Tn7sA1CiCLL0ajKr7eK9VU3ICkWqXsFLBs5vtB1BMfbo9ihjXd/qguf16Vuffhi1oM
         YY1GJ4Ki45rhAya2Jo45bQwlhdWP9T4t3Z9BgRR0=
Date:   Tue, 21 Sep 2021 10:40:21 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  +
 userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch added to -mm
 tree
Message-ID: <20210921174021.IApfl2-Ck%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix calculation of expected ioctls
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch

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
Subject: userfaultfd/selftests: fix calculation of expected ioctls

Currently, the list of expected ioctls is stored in uffd_test_ops.  This
design comes with the implicit assumption that the set of expected ioctls
is a function of the memory type (anon, shmem, or hugetlb).

However, this is not the case. For example:

- UFFDIO_WRITEPROTECT is supported for anon in general, *but not on
  aarch64* (which lacks CONFIG_HAVE_ARCH_USERFAULTFD_WP).
- UFFDIO_WRITEPROTECT is supported for anon, but only if one registers
  the region with UFFD_REGISTER_MODE_WP.
- We want to test (and expect) UFFDIO_CONTINUE, but only for *shared*
  hugetlb, not private.

So, instead, remove the set of expected ioctls from this structure. 
Define a new function which can compute the correct set by examining the
memory type, the userfaultfd registration mode(s), whether map_shared is
set, and what set of features the kernel reports as supported (from
UFFDIO_API).

In addition to being more correct, this improves code re-use - less
boilerplate in each test trying to perform this assertion.

Link: https://lkml.kernel.org/r/20210921163323.944352-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  103 +++++++++++----------
 1 file changed, 56 insertions(+), 47 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-calculation-of-expected-ioctls
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -304,37 +304,24 @@ static void shmem_alias_mapping(__u64 *s
 }
 
 struct uffd_test_ops {
-	unsigned long expected_ioctls;
 	void (*allocate_area)(void **alloc_area);
 	void (*release_pages)(char *rel_area);
 	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 };
 
-#define SHMEM_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
-					 (1 << _UFFDIO_COPY) | \
-					 (1 << _UFFDIO_ZEROPAGE))
-
-#define ANON_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
-					 (1 << _UFFDIO_COPY) | \
-					 (1 << _UFFDIO_ZEROPAGE) | \
-					 (1 << _UFFDIO_WRITEPROTECT))
-
 static struct uffd_test_ops anon_uffd_test_ops = {
-	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= anon_allocate_area,
 	.release_pages	= anon_release_pages,
 	.alias_mapping = noop_alias_mapping,
 };
 
 static struct uffd_test_ops shmem_uffd_test_ops = {
-	.expected_ioctls = SHMEM_EXPECTED_IOCTLS,
 	.allocate_area	= shmem_allocate_area,
 	.release_pages	= shmem_release_pages,
 	.alias_mapping = shmem_alias_mapping,
 };
 
 static struct uffd_test_ops hugetlb_uffd_test_ops = {
-	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC & ~(1 << _UFFDIO_CONTINUE),
 	.allocate_area	= hugetlb_allocate_area,
 	.release_pages	= hugetlb_release_pages,
 	.alias_mapping = hugetlb_alias_mapping,
@@ -368,6 +355,47 @@ static inline bool uffd_wp_supported(voi
 		(uffd_features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
 }
 
+static inline uint64_t uffd_minor_feature(void)
+{
+	if (test_type == TEST_HUGETLB && map_shared)
+		return UFFD_FEATURE_MINOR_HUGETLBFS;
+	else if (test_type == TEST_SHMEM)
+		return UFFD_FEATURE_MINOR_SHMEM;
+	else
+		return 0;
+}
+
+static inline bool uffd_minor_supported(void)
+{
+	return uffd_features & uffd_minor_feature();
+}
+
+static unsigned long get_expected_ioctls(uint64_t mode)
+{
+	unsigned long ioctls = UFFD_API_RANGE_IOCTLS;
+
+	if (test_type == TEST_HUGETLB)
+		ioctls &= ~(1 << _UFFDIO_ZEROPAGE);
+
+	if (!((mode & UFFDIO_REGISTER_MODE_WP) && uffd_wp_supported()))
+		ioctls &= ~(1 << _UFFDIO_WRITEPROTECT);
+
+	if (!((mode & UFFDIO_REGISTER_MODE_MINOR) && uffd_minor_supported()))
+		ioctls &= ~(1 << _UFFDIO_CONTINUE);
+
+	return ioctls;
+}
+
+static inline void assert_expected_ioctls_present(uint64_t mode, uint64_t ioctls)
+{
+	uint64_t expected = get_expected_ioctls(mode);
+	uint64_t actual = ioctls & expected;
+
+	if (actual != expected)
+		err("missing ioctl(s); expected: %"PRIx64" actual: %"PRIx64,
+		    expected, actual);
+}
+
 static inline void munmap_area(void **area)
 {
 	if (*area)
@@ -1012,11 +1040,9 @@ static int __uffdio_zeropage(int ufd, un
 {
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
-	unsigned long has_zeropage;
+	bool has_zeropage = get_expected_ioctls(0) & (1 << _UFFDIO_ZEROPAGE);
 	__s64 res;
 
-	has_zeropage = uffd_test_ops->expected_ioctls & (1 << _UFFDIO_ZEROPAGE);
-
 	if (offset >= nr_pages * page_size)
 		err("unexpected offset %lu", offset);
 	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
@@ -1056,7 +1082,6 @@ static int uffdio_zeropage(int ufd, unsi
 static int userfaultfd_zeropage_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 
 	printf("testing UFFDIO_ZEROPAGE: ");
 	fflush(stdout);
@@ -1071,9 +1096,8 @@ static int userfaultfd_zeropage_test(voi
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (uffdio_zeropage(uffd, 0))
 		if (my_bcmp(area_dst, zeropage, page_size))
@@ -1086,7 +1110,6 @@ static int userfaultfd_zeropage_test(voi
 static int userfaultfd_events_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	pthread_t uffd_mon;
 	int err;
 	pid_t pid;
@@ -1109,9 +1132,8 @@ static int userfaultfd_events_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
 		err("uffd_poll_thread create");
@@ -1139,7 +1161,6 @@ static int userfaultfd_events_test(void)
 static int userfaultfd_sig_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	unsigned long userfaults;
 	pthread_t uffd_mon;
 	int err;
@@ -1163,9 +1184,8 @@ static int userfaultfd_sig_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (faulting_process(1))
 		err("faulting process failed");
@@ -1200,30 +1220,25 @@ static int userfaultfd_sig_test(void)
 static int userfaultfd_minor_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	unsigned long p;
 	pthread_t uffd_mon;
 	uint8_t expected_byte;
 	void *expected_page;
 	char c;
 	struct uffd_stats stats = { 0 };
-	uint64_t features;
+	uint64_t features = uffd_minor_feature();
 
 	printf("testing minor faults: ");
 	fflush(stdout);
 
-	if (test_type == TEST_HUGETLB && map_shared)
-		features = UFFD_FEATURE_MINOR_HUGETLBFS;
-	else if (test_type == TEST_SHMEM)
-		features = UFFD_FEATURE_MINOR_SHMEM;
-	else {
+	if (!features) {
 		printf("skipping test due to unsupported memory type\n");
+		fflush(stdout);
 		return 0;
 	}
 
 	uffd_test_ctx_init(features);
-	/* If kernel reports required features aren't supported, skip test. */
-	if ((uffd_features & features) != features) {
+	if (!uffd_minor_supported()) {
 		printf("skipping test due to lack of feature support\n");
 		fflush(stdout);
 		return 0;
@@ -1235,10 +1250,8 @@ static int userfaultfd_minor_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	expected_ioctls |= 1 << _UFFDIO_CONTINUE;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl(s)");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	/*
 	 * After registering with UFFD, populate the non-UFFD-registered side of
@@ -1436,8 +1449,6 @@ static int userfaultfd_stress(void)
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
 	while (bounces--) {
-		unsigned long expected_ioctls;
-
 		printf("bounces: %d, mode:", bounces);
 		if (bounces & BOUNCE_RANDOM)
 			printf(" rnd");
@@ -1465,10 +1476,8 @@ static int userfaultfd_stress(void)
 			uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 			err("register failure");
-		expected_ioctls = uffd_test_ops->expected_ioctls;
-		if ((uffdio_register.ioctls & expected_ioctls) !=
-		    expected_ioctls)
-			err("unexpected missing ioctl for anon memory");
+		assert_expected_ioctls_present(
+			uffdio_register.mode, uffdio_register.ioctls);
 
 		if (area_dst_alias) {
 			uffdio_register.range.start = (unsigned long)
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-selftests-fix-feature-support-detection.patch
userfaultfd-selftests-fix-calculation-of-expected-ioctls.patch
userfaultfd-selftests-dont-rely-on-gnu-extensions-for-random-numbers.patch

