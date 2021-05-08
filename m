Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23226C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ADEF61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhEHWpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhEHWpi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913EB613C5;
        Sat,  8 May 2021 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513876;
        bh=FphjXGVMzUIQq7T7i4zLa8d4SaKK/uxq/FPXoxdVkH8=;
        h=Date:From:To:Subject:From;
        b=WXJoZRdbc7AdU4RXq87N2E6ujwxZqnqAPvssZ0bRVPg/HUGpbs4hFi7YTgBNskUHv
         e4l+mYYpqdUT85GIrOAjtY6NC3jlHYRrAU/R7EU159ac6pL23Sw6RQdggHn5N2XLWE
         dVQx/o4/GqKb8Orv/kj41C3Z6CB3FZzLtvMZHAwA=
Date:   Sat, 08 May 2021 15:44:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-docs-update-tests-section.patch removed
 from -mm tree
Message-ID: <20210508224436.uWS_boeIs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update tests section
has been removed from the -mm tree.  Its filename was
     kasan-docs-update-tests-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update tests section

Update the "Tests" section in KASAN documentation:

- Add an introductory sentence.
- Add proper indentation for the list of ways to run KUnit tests.
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/fb08845e25c8847ffda271fa19cda2621c04a65b.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   32 +++++++++++++---------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-tests-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -420,19 +420,20 @@ saving and restoring the per-page KASAN
 Tests
 ~~~~~
 
-KASAN tests consist of two parts:
+There are KASAN tests that allow verifying that KASAN works and can detect
+certain types of memory corruptions. The tests consist of two parts:
 
 1. Tests that are integrated with the KUnit Test Framework. Enabled with
 ``CONFIG_KASAN_KUNIT_TEST``. These tests can be run and partially verified
-automatically in a few different ways, see the instructions below.
+automatically in a few different ways; see the instructions below.
 
 2. Tests that are currently incompatible with KUnit. Enabled with
 ``CONFIG_KASAN_MODULE_TEST`` and can only be run as a module. These tests can
-only be verified manually, by loading the kernel module and inspecting the
+only be verified manually by loading the kernel module and inspecting the
 kernel log for KASAN reports.
 
-Each KUnit-compatible KASAN test prints a KASAN report if an error is detected.
-Then the test prints its number and status.
+Each KUnit-compatible KASAN test prints one of multiple KASAN reports if an
+error is detected. Then the test prints its number and status.
 
 When a test passes::
 
@@ -460,27 +461,24 @@ Or, if one of the tests failed::
 
         not ok 1 - kasan
 
-
 There are a few ways to run KUnit-compatible KASAN tests.
 
 1. Loadable module
 
-With ``CONFIG_KUNIT`` enabled, ``CONFIG_KASAN_KUNIT_TEST`` can be built as
-a loadable module and run on any architecture that supports KASAN by loading
-the module with insmod or modprobe. The module is called ``test_kasan``.
+   With ``CONFIG_KUNIT`` enabled, KASAN-KUnit tests can be built as a loadable
+   module and run by loading ``test_kasan.ko`` with ``insmod`` or ``modprobe``.
 
 2. Built-In
 
-With ``CONFIG_KUNIT`` built-in, ``CONFIG_KASAN_KUNIT_TEST`` can be built-in
-on any architecure that supports KASAN. These and any other KUnit tests enabled
-will run and print the results at boot as a late-init call.
+   With ``CONFIG_KUNIT`` built-in, KASAN-KUnit tests can be built-in as well.
+   In this case, the tests will run at boot as a late-init call.
 
 3. Using kunit_tool
 
-With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, it's also
-possible use ``kunit_tool`` to see the results of these and other KUnit tests
-in a more readable way. This will not print the KASAN reports of the tests that
-passed. Use `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
-for more up-to-date information on ``kunit_tool``.
+   With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, it is also
+   possible to use ``kunit_tool`` to see the results of KUnit tests in a more
+   readable way. This will not print the KASAN reports of the tests that passed.
+   See `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
+   for more up-to-date information on ``kunit_tool``.
 
 .. _KUnit: https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html
_

Patches currently in -mm which might be from andreyknvl@google.com are


