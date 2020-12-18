Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69F5C3526B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F10623B5D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgLRWFr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgLRWFq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:46 -0500
Date:   Fri, 18 Dec 2020 14:05:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329129;
        bh=8DcJNR4WmHnL0Hv0fKmZFOYV6gb4BwyMrwvUViDgsMg=;
        h=From:To:Subject:In-Reply-To:From;
        b=BEpwRlOUax5N9jns6SFi8qxB0bZYKAAxZck4YI6iOMXgHJ1P5CGO9OFaIPfe1WdEp
         QMJQCYrd1/ncfA9k1f7lHS+U3HQXXHf8v+XF7WiaHNkQ2bhsB8WjqpCaJpokQO5qUp
         llD/pOi9j9x53c0upBUrc5ULvbArRuBXTRVdLbsA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 73/78] kasan: update documentation
Message-ID: <20201218220528.rMPAjuQZl%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update documentation

This change updates KASAN documentation to reflect the addition of boot
parameters and also reworks and clarifies some of the existing sections,
in particular: defines what a memory granule is, mentions quarantine,
makes Kunit section more readable.

Link: https://lkml.kernel.org/r/748daf013e17d925b0fe00c1c3b5dce726dd2430.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ib1f83e91be273264b25f42b04448ac96b858849f
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |  188 +++++++++++++++++-----------
 1 file changed, 117 insertions(+), 71 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-documentation
+++ a/Documentation/dev-tools/kasan.rst
@@ -4,8 +4,9 @@ The Kernel Address Sanitizer (KASAN)
 Overview
 --------
 
-KernelAddressSANitizer (KASAN) is a dynamic memory error detector designed to
-find out-of-bound and use-after-free bugs. KASAN has three modes:
+KernelAddressSANitizer (KASAN) is a dynamic memory safety error detector
+designed to find out-of-bound and use-after-free bugs. KASAN has three modes:
+
 1. generic KASAN (similar to userspace ASan),
 2. software tag-based KASAN (similar to userspace HWASan),
 3. hardware tag-based KASAN (based on hardware memory tagging).
@@ -39,23 +40,13 @@ CONFIG_KASAN_INLINE. Outline and inline
 The former produces smaller binary while the latter is 1.1 - 2 times faster.
 
 Both software KASAN modes work with both SLUB and SLAB memory allocators,
-hardware tag-based KASAN currently only support SLUB.
-For better bug detection and nicer reporting, enable CONFIG_STACKTRACE.
+while the hardware tag-based KASAN currently only support SLUB.
+
+For better error reports that include stack traces, enable CONFIG_STACKTRACE.
 
 To augment reports with last allocation and freeing stack of the physical page,
 it is recommended to enable also CONFIG_PAGE_OWNER and boot with page_owner=on.
 
-To disable instrumentation for specific files or directories, add a line
-similar to the following to the respective kernel Makefile:
-
-- For a single file (e.g. main.o)::
-
-    KASAN_SANITIZE_main.o := n
-
-- For all files in one directory::
-
-    KASAN_SANITIZE := n
-
 Error reports
 ~~~~~~~~~~~~~
 
@@ -140,22 +131,75 @@ freed (in case of a use-after-free bug r
 the accessed slab object and information about the accessed memory page.
 
 In the last section the report shows memory state around the accessed address.
-Reading this part requires some understanding of how KASAN works.
-
-The state of each 8 aligned bytes of memory is encoded in one shadow byte.
-Those 8 bytes can be accessible, partially accessible, freed or be a redzone.
-We use the following encoding for each shadow byte: 0 means that all 8 bytes
-of the corresponding memory region are accessible; number N (1 <= N <= 7) means
-that the first N bytes are accessible, and other (8 - N) bytes are not;
-any negative value indicates that the entire 8-byte word is inaccessible.
-We use different negative values to distinguish between different kinds of
-inaccessible memory like redzones or freed memory (see mm/kasan/kasan.h).
+Internally KASAN tracks memory state separately for each memory granule, which
+is either 8 or 16 aligned bytes depending on KASAN mode. Each number in the
+memory state section of the report shows the state of one of the memory
+granules that surround the accessed address.
+
+For generic KASAN the size of each memory granule is 8. The state of each
+granule is encoded in one shadow byte. Those 8 bytes can be accessible,
+partially accessible, freed or be a part of a redzone. KASAN uses the following
+encoding for each shadow byte: 0 means that all 8 bytes of the corresponding
+memory region are accessible; number N (1 <= N <= 7) means that the first N
+bytes are accessible, and other (8 - N) bytes are not; any negative value
+indicates that the entire 8-byte word is inaccessible. KASAN uses different
+negative values to distinguish between different kinds of inaccessible memory
+like redzones or freed memory (see mm/kasan/kasan.h).
 
 In the report above the arrows point to the shadow byte 03, which means that
 the accessed address is partially accessible.
 
 For tag-based KASAN this last report section shows the memory tags around the
-accessed address (see Implementation details section).
+accessed address (see `Implementation details`_ section).
+
+Boot parameters
+~~~~~~~~~~~~~~~
+
+Hardware tag-based KASAN mode (see the section about different mode below) is
+intended for use in production as a security mitigation. Therefore it supports
+boot parameters that allow to disable KASAN competely or otherwise control
+particular KASAN features.
+
+The things that can be controlled are:
+
+1. Whether KASAN is enabled at all.
+2. Whether KASAN collects and saves alloc/free stacks.
+3. Whether KASAN panics on a detected bug or not.
+
+The ``kasan.mode`` boot parameter allows to choose one of three main modes:
+
+- ``kasan.mode=off`` - KASAN is disabled, no tag checks are performed
+- ``kasan.mode=prod`` - only essential production features are enabled
+- ``kasan.mode=full`` - all KASAN features are enabled
+
+The chosen mode provides default control values for the features mentioned
+above. However it's also possible to override the default values by providing:
+
+- ``kasan.stacktrace=off`` or ``=on`` - enable alloc/free stack collection
+					(default: ``on`` for ``mode=full``,
+					 otherwise ``off``)
+- ``kasan.fault=report`` or ``=panic`` - only print KASAN report or also panic
+					 (default: ``report``)
+
+If ``kasan.mode`` parameter is not provided, it defaults to ``full`` when
+``CONFIG_DEBUG_KERNEL`` is enabled, and to ``prod`` otherwise.
+
+For developers
+~~~~~~~~~~~~~~
+
+Software KASAN modes use compiler instrumentation to insert validity checks.
+Such instrumentation might be incompatible with some part of the kernel, and
+therefore needs to be disabled. To disable instrumentation for specific files
+or directories, add a line similar to the following to the respective kernel
+Makefile:
+
+- For a single file (e.g. main.o)::
+
+    KASAN_SANITIZE_main.o := n
+
+- For all files in one directory::
+
+    KASAN_SANITIZE := n
 
 
 Implementation details
@@ -164,10 +208,10 @@ Implementation details
 Generic KASAN
 ~~~~~~~~~~~~~
 
-From a high level, our approach to memory error detection is similar to that
-of kmemcheck: use shadow memory to record whether each byte of memory is safe
-to access, and use compile-time instrumentation to insert checks of shadow
-memory on each memory access.
+From a high level perspective, KASAN's approach to memory error detection is
+similar to that of kmemcheck: use shadow memory to record whether each byte of
+memory is safe to access, and use compile-time instrumentation to insert checks
+of shadow memory on each memory access.
 
 Generic KASAN dedicates 1/8th of kernel memory to its shadow memory (e.g. 16TB
 to cover 128TB on x86_64) and uses direct mapping with a scale and offset to
@@ -198,6 +242,9 @@ Generic KASAN also reports the last 2 ca
 potentially has access to an object. Call stacks for the following are shown:
 call_rcu() and workqueue queuing.
 
+Generic KASAN is the only mode that delays the reuse of freed object via
+quarantine (see mm/kasan/quarantine.c for implementation).
+
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -305,15 +352,15 @@ therefore be wasteful. Furthermore, to e
 use different shadow pages, mappings would have to be aligned to
 ``KASAN_GRANULE_SIZE * PAGE_SIZE``.
 
-Instead, we share backing space across multiple mappings. We allocate
+Instead, KASAN shares backing space across multiple mappings. It allocates
 a backing page when a mapping in vmalloc space uses a particular page
 of the shadow region. This page can be shared by other vmalloc
 mappings later on.
 
-We hook in to the vmap infrastructure to lazily clean up unused shadow
+KASAN hooks into the vmap infrastructure to lazily clean up unused shadow
 memory.
 
-To avoid the difficulties around swapping mappings around, we expect
+To avoid the difficulties around swapping mappings around, KASAN expects
 that the part of the shadow region that covers the vmalloc space will
 not be covered by the early shadow page, but will be left
 unmapped. This will require changes in arch-specific code.
@@ -324,24 +371,31 @@ architectures that do not have a fixed m
 CONFIG_KASAN_KUNIT_TEST & CONFIG_TEST_KASAN_MODULE
 --------------------------------------------------
 
-``CONFIG_KASAN_KUNIT_TEST`` utilizes the KUnit Test Framework for testing.
-This means each test focuses on a small unit of functionality and
-there are a few ways these tests can be run.
+KASAN tests consist on two parts:
+
+1. Tests that are integrated with the KUnit Test Framework. Enabled with
+``CONFIG_KASAN_KUNIT_TEST``. These tests can be run and partially verified
+automatically in a few different ways, see the instructions below.
+
+2. Tests that are currently incompatible with KUnit. Enabled with
+``CONFIG_TEST_KASAN_MODULE`` and can only be run as a module. These tests can
+only be verified manually, by loading the kernel module and inspecting the
+kernel log for KASAN reports.
 
-Each test will print the KASAN report if an error is detected and then
-print the number of the test and the status of the test:
+Each KUnit-compatible KASAN test prints a KASAN report if an error is detected.
+Then the test prints its number and status.
 
-pass::
+When a test passes::
 
         ok 28 - kmalloc_double_kzfree
 
-or, if kmalloc failed::
+When a test fails due to a failed ``kmalloc``::
 
         # kmalloc_large_oob_right: ASSERTION FAILED at lib/test_kasan.c:163
         Expected ptr is not null, but is
         not ok 4 - kmalloc_large_oob_right
 
-or, if a KASAN report was expected, but not found::
+When a test fails due to a missing KASAN report::
 
         # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:629
         Expected kasan_data->report_expected == kasan_data->report_found, but
@@ -349,46 +403,38 @@ or, if a KASAN report was expected, but
         kasan_data->report_found == 0
         not ok 28 - kmalloc_double_kzfree
 
-All test statuses are tracked as they run and an overall status will
-be printed at the end::
+At the end the cumulative status of all KASAN tests is printed. On success::
 
         ok 1 - kasan
 
-or::
+Or, if one of the tests failed::
 
         not ok 1 - kasan
 
-(1) Loadable Module
-~~~~~~~~~~~~~~~~~~~~
+
+There are a few ways to run KUnit-compatible KASAN tests.
+
+1. Loadable module
+~~~~~~~~~~~~~~~~~~
 
 With ``CONFIG_KUNIT`` enabled, ``CONFIG_KASAN_KUNIT_TEST`` can be built as
-a loadable module and run on any architecture that supports KASAN
-using something like insmod or modprobe. The module is called ``test_kasan``.
+a loadable module and run on any architecture that supports KASAN by loading
+the module with insmod or modprobe. The module is called ``test_kasan``.
 
-(2) Built-In
-~~~~~~~~~~~~~
+2. Built-In
+~~~~~~~~~~~
 
 With ``CONFIG_KUNIT`` built-in, ``CONFIG_KASAN_KUNIT_TEST`` can be built-in
-on any architecture that supports KASAN. These and any other KUnit
-tests enabled will run and print the results at boot as a late-init
-call.
-
-(3) Using kunit_tool
-~~~~~~~~~~~~~~~~~~~~~
-
-With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, we can also
-use kunit_tool to see the results of these along with other KUnit
-tests in a more readable way. This will not print the KASAN reports
-of tests that passed. Use `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_ for more up-to-date
-information on kunit_tool.
+on any architecure that supports KASAN. These and any other KUnit tests enabled
+will run and print the results at boot as a late-init call.
 
-.. _KUnit: https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html
+3. Using kunit_tool
+~~~~~~~~~~~~~~~~~~~
 
-``CONFIG_TEST_KASAN_MODULE`` is a set of KASAN tests that could not be
-converted to KUnit. These tests can be run only as a module with
-``CONFIG_TEST_KASAN_MODULE`` built as a loadable module and
-``CONFIG_KASAN`` built-in. The type of error expected and the
-function being run is printed before the expression expected to give
-an error. Then the error is printed, if found, and that test
-should be interpreted to pass only if the error was the one expected
-by the test.
+With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, it's also
+possible use ``kunit_tool`` to see the results of these and other KUnit tests
+in a more readable way. This will not print the KASAN reports of the tests that
+passed. Use `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
+for more up-to-date information on ``kunit_tool``.
+
+.. _KUnit: https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html
_
