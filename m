Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB0FC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBE4613D6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhGIVgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhGIVgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8277613DC;
        Fri,  9 Jul 2021 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866435;
        bh=Tw4modhrj5aMJytXKRPAHvFsEGD67SzWhpx/7CzkwXc=;
        h=Date:From:To:Subject:From;
        b=Iy1nBjQwfUPLLftdhBgIHXZwg5f/X/IMcDRmfI64hMBKv8gn08vaYa9Vs9Q24o20E
         dGUrXixRoPWYdSj9VUlfez53a1bou+gFUoXb3360x7Fcr/MVQjjamhGMPqFFk12gAC
         RyrU1VS5MLbiMJI925WIp5uAk/GpVXueEZ0mwLsc=
Date:   Fri, 09 Jul 2021 14:33:54 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [merged]
 selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
 removed from -mm tree
Message-ID: <20210709213354.lWURj_0uT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/mremap_test: update the test to handle pagesize other than 4K
has been removed from the -mm tree.  Its filename was
     selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: selftest/mremap_test: update the test to handle pagesize other than 4K

Patch series "mrermap fixes", v2.


This patch (of 6):

Instead of hardcoding 4K page size fetch it using sysconf().  For the
performance measurements test still assume 2M and 1G are hugepage sizes.

Link: https://lkml.kernel.org/r/20210616045239.370802-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20210616045239.370802-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |  111 +++++++++++----------
 1 file changed, 60 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -45,14 +45,15 @@ enum {
 	_4MB = 4ULL << 20,
 	_1GB = 1ULL << 30,
 	_2GB = 2ULL << 30,
-	PTE = _4KB,
 	PMD = _2MB,
 	PUD = _1GB,
 };
 
+#define PTE page_size
+
 #define MAKE_TEST(source_align, destination_align, size,	\
 		  overlaps, should_fail, test_name)		\
-{								\
+(struct test){							\
 	.name = test_name,					\
 	.config = {						\
 		.src_alignment = source_align,			\
@@ -252,12 +253,17 @@ static int parse_args(int argc, char **a
 	return 0;
 }
 
+#define MAX_TEST 13
+#define MAX_PERF_TEST 3
 int main(int argc, char **argv)
 {
 	int failures = 0;
 	int i, run_perf_tests;
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
+	struct test test_cases[MAX_TEST];
+	struct test perf_test_cases[MAX_PERF_TEST];
+	int page_size;
 	time_t t;
 
 	pattern_seed = (unsigned int) time(&t);
@@ -268,56 +274,59 @@ int main(int argc, char **argv)
 	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
 		       threshold_mb, pattern_seed);
 
-	struct test test_cases[] = {
-		/* Expected mremap failures */
-		MAKE_TEST(_4KB, _4KB, _4KB, OVERLAPPING, EXPECT_FAILURE,
-		  "mremap - Source and Destination Regions Overlapping"),
-		MAKE_TEST(_4KB, _1KB, _4KB, NON_OVERLAPPING, EXPECT_FAILURE,
-		  "mremap - Destination Address Misaligned (1KB-aligned)"),
-		MAKE_TEST(_1KB, _4KB, _4KB, NON_OVERLAPPING, EXPECT_FAILURE,
-		  "mremap - Source Address Misaligned (1KB-aligned)"),
-
-		/* Src addr PTE aligned */
-		MAKE_TEST(PTE, PTE, _8KB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "8KB mremap - Source PTE-aligned, Destination PTE-aligned"),
-
-		/* Src addr 1MB aligned */
-		MAKE_TEST(_1MB, PTE, _2MB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2MB mremap - Source 1MB-aligned, Destination PTE-aligned"),
-		MAKE_TEST(_1MB, _1MB, _2MB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2MB mremap - Source 1MB-aligned, Destination 1MB-aligned"),
-
-		/* Src addr PMD aligned */
-		MAKE_TEST(PMD, PTE, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "4MB mremap - Source PMD-aligned, Destination PTE-aligned"),
-		MAKE_TEST(PMD, _1MB, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "4MB mremap - Source PMD-aligned, Destination 1MB-aligned"),
-		MAKE_TEST(PMD, PMD, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "4MB mremap - Source PMD-aligned, Destination PMD-aligned"),
-
-		/* Src addr PUD aligned */
-		MAKE_TEST(PUD, PTE, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2GB mremap - Source PUD-aligned, Destination PTE-aligned"),
-		MAKE_TEST(PUD, _1MB, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2GB mremap - Source PUD-aligned, Destination 1MB-aligned"),
-		MAKE_TEST(PUD, PMD, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2GB mremap - Source PUD-aligned, Destination PMD-aligned"),
-		MAKE_TEST(PUD, PUD, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "2GB mremap - Source PUD-aligned, Destination PUD-aligned"),
-	};
+	page_size = sysconf(_SC_PAGESIZE);
 
-	struct test perf_test_cases[] = {
-		/*
-		 * mremap 1GB region - Page table level aligned time
-		 * comparison.
-		 */
-		MAKE_TEST(PTE, PTE, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "1GB mremap - Source PTE-aligned, Destination PTE-aligned"),
-		MAKE_TEST(PMD, PMD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "1GB mremap - Source PMD-aligned, Destination PMD-aligned"),
-		MAKE_TEST(PUD, PUD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
-		  "1GB mremap - Source PUD-aligned, Destination PUD-aligned"),
-	};
+	/* Expected mremap failures */
+	test_cases[0] =	MAKE_TEST(page_size, page_size, page_size,
+				  OVERLAPPING, EXPECT_FAILURE,
+				  "mremap - Source and Destination Regions Overlapping");
+
+	test_cases[1] = MAKE_TEST(page_size, page_size/4, page_size,
+				  NON_OVERLAPPING, EXPECT_FAILURE,
+				  "mremap - Destination Address Misaligned (1KB-aligned)");
+	test_cases[2] = MAKE_TEST(page_size/4, page_size, page_size,
+				  NON_OVERLAPPING, EXPECT_FAILURE,
+				  "mremap - Source Address Misaligned (1KB-aligned)");
+
+	/* Src addr PTE aligned */
+	test_cases[3] = MAKE_TEST(PTE, PTE, PTE * 2,
+				  NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "8KB mremap - Source PTE-aligned, Destination PTE-aligned");
+
+	/* Src addr 1MB aligned */
+	test_cases[4] = MAKE_TEST(_1MB, PTE, _2MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "2MB mremap - Source 1MB-aligned, Destination PTE-aligned");
+	test_cases[5] = MAKE_TEST(_1MB, _1MB, _2MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "2MB mremap - Source 1MB-aligned, Destination 1MB-aligned");
+
+	/* Src addr PMD aligned */
+	test_cases[6] = MAKE_TEST(PMD, PTE, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "4MB mremap - Source PMD-aligned, Destination PTE-aligned");
+	test_cases[7] =	MAKE_TEST(PMD, _1MB, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "4MB mremap - Source PMD-aligned, Destination 1MB-aligned");
+	test_cases[8] = MAKE_TEST(PMD, PMD, _4MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "4MB mremap - Source PMD-aligned, Destination PMD-aligned");
+
+	/* Src addr PUD aligned */
+	test_cases[9] = MAKE_TEST(PUD, PTE, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "2GB mremap - Source PUD-aligned, Destination PTE-aligned");
+	test_cases[10] = MAKE_TEST(PUD, _1MB, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				   "2GB mremap - Source PUD-aligned, Destination 1MB-aligned");
+	test_cases[11] = MAKE_TEST(PUD, PMD, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				   "2GB mremap - Source PUD-aligned, Destination PMD-aligned");
+	test_cases[12] = MAKE_TEST(PUD, PUD, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				   "2GB mremap - Source PUD-aligned, Destination PUD-aligned");
+
+	perf_test_cases[0] =  MAKE_TEST(page_size, page_size, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+					"1GB mremap - Source PTE-aligned, Destination PTE-aligned");
+	/*
+	 * mremap 1GB region - Page table level aligned time
+	 * comparison.
+	 */
+	perf_test_cases[1] = MAKE_TEST(PMD, PMD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				       "1GB mremap - Source PMD-aligned, Destination PMD-aligned");
+	perf_test_cases[2] = MAKE_TEST(PUD, PUD, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				       "1GB mremap - Source PUD-aligned, Destination PUD-aligned");
 
 	run_perf_tests =  (threshold_mb == VALIDATION_NO_THRESHOLD) ||
 				(threshold_mb * _1MB >= _1GB);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


