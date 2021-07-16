Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87D6C07E95
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE62D613BB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhGPEEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 00:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhGPEEa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 00:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4EF6115B;
        Fri, 16 Jul 2021 04:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626408095;
        bh=rRpqD4H5gXCQT+QQlNZRYWecDzRrueGdsJDqATy/Qtc=;
        h=Date:From:To:Subject:From;
        b=Xs8FE0TORnxKcK3Tf0WGXfihVxIEjf7qDVXM6IhJEN8RIxfui9bKwpb6OIiCaL/qu
         goIhpHSi6q1QbSxESVaAnxoBndjJBk2WVMmi+5DZzaByxpiuY86xe5cqAa8lVeuxdr
         8fggaReGS3wYMCM+joXLBGUNCw0IaNsbk8cdF0nQ=
Date:   Thu, 15 Jul 2021 21:01:35 -0700
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, davidgow@google.com,
        dlatypov@google.com, mm-commits@vger.kernel.org,
        pravin.shedge4linux@gmail.com
Subject:  + lib-test-convert-test_sortc-to-use-kunit.patch added to
 -mm tree
Message-ID: <20210716040135.a237LVrwX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test: convert test_sort.c to use KUnit
has been added to the -mm tree.  Its filename is
     lib-test-convert-test_sortc-to-use-kunit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test-convert-test_sortc-to-use-kunit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test-convert-test_sortc-to-use-kunit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2084,8 +2084,9 @@ config TEST_MIN_HEAP
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

Patches currently in -mm which might be from dlatypov@google.com are

lib-test-convert-test_sortc-to-use-kunit.patch

