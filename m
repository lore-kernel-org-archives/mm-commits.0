Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E678AC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6D861153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347339AbhIHC76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHC74 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4114561131;
        Wed,  8 Sep 2021 02:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069929;
        bh=XoUzPCtxcqUfdjIC+/tFcSNU7G9Unpq6zUFsA0psL7M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JNT6KY2w+fiokEI7OpPEChvKWu8vKTwJjxmkTSyBDRkGLnVAufv7jolfoeKs0TlFZ
         S/tRJ4guOg6biaEHSEuBkJf2UgnYUmFpyF4WAPdNcufkWJMaOge/tLxBfZR5d2a/yK
         sHRGU6tPhPuLAB1UXcWESGFcyAeIILmltUthUwb8=
Date:   Tue, 07 Sep 2021 19:58:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        davidgow@google.com, dlatypov@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pravin.shedge4linux@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 104/147] lib/test: convert test_sort.c to use
 KUnit
Message-ID: <20210908025848.Tq7nq4SWt%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Latypov <dlatypov@google.com>
Subject: lib/test: convert test_sort.c to use KUnit

This follows up commit ebd09577be6c ("lib/test: convert
lib/test_list_sort.c to use KUnit").

Converting this test to KUnit makes the test a bit shorter, standardizes
how it reports pass/fail, and adds an easier way to run the test [1].

Like ebd09577be6c, this leaves the file and Kconfig option name the same,
but slightly changes their dependencies (needs CONFIG_KUNIT).

[1] Can be run via
$ ./tools/testing/kunit/kunit.py run --kunitconfig /dev/stdin <<EOF
CONFIG_KUNIT=y
CONFIG_TEST_SORT=y
EOF

[11:30:27] Starting KUnit Kernel ...
[11:30:30] ============================================================
[11:30:30] ======== [PASSED] lib_sort ========
[11:30:30] [PASSED] test_sort
[11:30:30] ============================================================
[11:30:30] Testing complete. 1 tests run. 0 failed. 0 crashed. 0 skipped.
[11:30:30] Elapsed time: 37.032s total, 0.001s configuring, 34.090s building, 0.000s running

Note: this is the time it took after a `make mrproper`.

With an incremental rebuild, this looks more like:
[11:38:58] Elapsed time: 6.444s total, 0.001s configuring, 3.416s building, 0.000s running

Since the test has no dependencies, it can also be run (with some other
tests) with just:
$ ./tools/testing/kunit/kunit.py run

Link: https://lkml.kernel.org/r/20210715232441.1380885-1-dlatypov@google.com
Signed-off-by: Daniel Latypov <dlatypov@google.com>
Cc: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    5 +++--
 lib/test_sort.c   |   40 +++++++++++++++++++---------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

--- a/lib/Kconfig.debug~lib-test-convert-test_sortc-to-use-kunit
+++ a/lib/Kconfig.debug
@@ -2078,8 +2078,9 @@ config TEST_MIN_HEAP
 	  If unsure, say N.
 
 config TEST_SORT
-	tristate "Array-based sort test"
-	depends on DEBUG_KERNEL || m
+	tristate "Array-based sort test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This option enables the self-test function of 'sort()' at boot,
 	  or at module load time.
--- a/lib/test_sort.c~lib-test-convert-test_sortc-to-use-kunit
+++ a/lib/test_sort.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+
 #include <linux/sort.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -7,18 +10,17 @@
 
 #define TEST_LEN 1000
 
-static int __init cmpint(const void *a, const void *b)
+static int cmpint(const void *a, const void *b)
 {
 	return *(int *)a - *(int *)b;
 }
 
-static int __init test_sort_init(void)
+static void test_sort(struct kunit *test)
 {
-	int *a, i, r = 1, err = -ENOMEM;
+	int *a, i, r = 1;
 
-	a = kmalloc_array(TEST_LEN, sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return err;
+	a = kunit_kmalloc_array(test, TEST_LEN, sizeof(*a), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a);
 
 	for (i = 0; i < TEST_LEN; i++) {
 		r = (r * 725861) % 6599;
@@ -27,24 +29,20 @@ static int __init test_sort_init(void)
 
 	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
 
-	err = -EINVAL;
 	for (i = 0; i < TEST_LEN-1; i++)
-		if (a[i] > a[i+1]) {
-			pr_err("test has failed\n");
-			goto exit;
-		}
-	err = 0;
-	pr_info("test passed\n");
-exit:
-	kfree(a);
-	return err;
+		KUNIT_ASSERT_LE(test, a[i], a[i + 1]);
 }
 
-static void __exit test_sort_exit(void)
-{
-}
+static struct kunit_case sort_test_cases[] = {
+	KUNIT_CASE(test_sort),
+	{}
+};
+
+static struct kunit_suite sort_test_suite = {
+	.name = "lib_sort",
+	.test_cases = sort_test_cases,
+};
 
-module_init(test_sort_init);
-module_exit(test_sort_exit);
+kunit_test_suites(&sort_test_suite);
 
 MODULE_LICENSE("GPL");
_
