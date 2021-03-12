Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41C7C4332D
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C746564F5D
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhCLSgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233634AbhCLSgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A5564DEC;
        Fri, 12 Mar 2021 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574182;
        bh=IaE3tH1YFIgO7C3eaTY6sqoHFmShAHfQ4k/dHk37tUo=;
        h=Date:From:To:Subject:From;
        b=rpoo4ikphrKO1ygYuH5mhxMoxdKr1HCS8aNfqFd0hES4hCjTdu/u5cbhxxg0uIO3z
         424yLUAIRB/OqG7rIT9yHjPjeJ1+aY/Gd27tkK2/UW/JWDml2zz5roynR+We+BGJYp
         vKT8qbMBHxDtLoSJYw6YT8gdnIS6xRXR3xlpiTv0=
Date:   Fri, 12 Mar 2021 10:36:21 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-docs-update-tests-section.patch added to -mm tree
Message-ID: <20210312183621.V6wStlGfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update tests section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-tests-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-tests-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-tests-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -411,19 +411,20 @@ saving and restoring the per-page KASAN
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
 
@@ -451,27 +452,24 @@ Or, if one of the tests failed::
 
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

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

