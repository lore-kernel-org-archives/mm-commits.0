Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326E2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0716103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhKKCsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234372AbhKKCsP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87DC260F46;
        Thu, 11 Nov 2021 02:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598727;
        bh=5arNZjIV47/6SRw3rBazRfyaWqa4v/uBAIcdrpqnXMk=;
        h=Date:From:To:Subject:From;
        b=QsufKYx/hKOz/kUVDH740nynXBX6/1OwCbKYsZK7ybujls/gmZf3SqJvNlRSwt68O
         ikZw33tCBY9Zvm71v3AQSQoq5xxJCUbGfsOtWQ0iDAjN+dysztFZ7Eh83RsgyF/F8l
         YvRdG41js8bKT881LNFy9AZKnd/U/kbbVT8o/8iQ=
Date:   Wed, 10 Nov 2021 18:45:27 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, shuah@kernel.org
Subject:  [merged]
 userfaultfd-selftests-fix-feature-support-detection.patch removed from -mm
 tree
Message-ID: <20211111024527.fOVQkqat_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix feature support detection
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-fix-feature-support-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: fix feature support detection

Before any tests are run, in set_test_type, we decide what feature(s) we
are going to be testing, based upon our command line arguments.  However,
the supported features are not just a function of the memory type being
used, so this is broken.

For instance, consider writeprotect support.  It is "normally" supported
for anonymous memory, but furthermore it requires that the kernel has
CONFIG_HAVE_ARCH_USERFAULTFD_WP.  So, it is *not* supported at all on
aarch64, for example.

So, this commit fixes this by querying the kernel for the set of features
it supports in set_test_type, by opening a userfaultfd and issuing a
UFFDIO_API ioctl.  Based upon the reported features, we toggle what tests
are enabled.

Link: https://lkml.kernel.org/r/20210930212309.4001967-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   54 ++++++++++++---------
 1 file changed, 31 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-feature-support-detection
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -346,6 +346,16 @@ static struct uffd_test_ops hugetlb_uffd
 
 static struct uffd_test_ops *uffd_test_ops;
 
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
 static void userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
@@ -406,7 +416,7 @@ static void uffd_test_ctx_clear(void)
 	munmap_area((void **)&area_dst_alias);
 }
 
-static void uffd_test_ctx_init_ext(uint64_t *features)
+static void uffd_test_ctx_init(uint64_t features)
 {
 	unsigned long nr, cpu;
 
@@ -415,7 +425,7 @@ static void uffd_test_ctx_init_ext(uint6
 	uffd_test_ops->allocate_area((void **)&area_src);
 	uffd_test_ops->allocate_area((void **)&area_dst);
 
-	userfaultfd_open(features);
+	userfaultfd_open(&features);
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
 	if (!count_verify)
@@ -463,11 +473,6 @@ static void uffd_test_ctx_init_ext(uint6
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
@@ -1208,7 +1213,6 @@ static int userfaultfd_minor_test(void)
 	void *expected_page;
 	char c;
 	struct uffd_stats stats = { 0 };
-	uint64_t req_features, features_out;
 
 	if (!test_uffdio_minor)
 		return 0;
@@ -1216,21 +1220,7 @@ static int userfaultfd_minor_test(void)
 	printf("testing minor faults: ");
 	fflush(stdout);
 
-	if (test_type == TEST_HUGETLB)
-		req_features = UFFD_FEATURE_MINOR_HUGETLBFS;
-	else if (test_type == TEST_SHMEM)
-		req_features = UFFD_FEATURE_MINOR_SHMEM;
-	else
-		return 1;
-
-	features_out = req_features;
-	uffd_test_ctx_init_ext(&features_out);
-	/* If kernel reports required features aren't supported, skip test. */
-	if ((features_out & req_features) != req_features) {
-		printf("skipping test due to lack of feature support\n");
-		fflush(stdout);
-		return 0;
-	}
+	uffd_test_ctx_init(uffd_minor_feature());
 
 	uffdio_register.range.start = (unsigned long)area_dst_alias;
 	uffdio_register.range.len = nr_pages * page_size;
@@ -1591,6 +1581,8 @@ unsigned long default_huge_page_size(voi
 
 static void set_test_type(const char *type)
 {
+	uint64_t features = UFFD_API_FEATURES;
+
 	if (!strcmp(type, "anon")) {
 		test_type = TEST_ANON;
 		uffd_test_ops = &anon_uffd_test_ops;
@@ -1624,6 +1616,22 @@ static void set_test_type(const char *ty
 	if ((unsigned long) area_count(NULL, 0) + sizeof(unsigned long long) * 2
 	    > page_size)
 		err("Impossible to run this test");
+
+	/*
+	 * Whether we can test certain features depends not just on test type,
+	 * but also on whether or not this particular kernel supports the
+	 * feature.
+	 */
+
+	userfaultfd_open(&features);
+
+	test_uffdio_wp = test_uffdio_wp &&
+		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
+	test_uffdio_minor = test_uffdio_minor &&
+		(features & uffd_minor_feature());
+
+	close(uffd);
+	uffd = -1;
 }
 
 static void sigalrm(int sig)
_

Patches currently in -mm which might be from axelrasmussen@google.com are


