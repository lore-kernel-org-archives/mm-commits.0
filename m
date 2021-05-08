Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC395C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EB5F61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWpS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CFDC6100C;
        Sat,  8 May 2021 22:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513856;
        bh=c7Jdj+r/CtvPA4yFeCfNbsJ0kFInDgiAmkOF49rvoJU=;
        h=Date:From:To:Subject:From;
        b=IWM8a63IPb5cI1usbQyoP/uw2oj5d/3QvVoXr6LyoRR+5ju2l1y3Oibw283FK+VQx
         o58EhZcp7Y4yRK9DonMyCHIrhdr0B/0Wi7VgmgUsXwb8UQ9UovV+n8lTVZYE8JeZnh
         cxgtPxm/OMSmeeRmyCvdNTLteaUTr9hc9uNcrYpw=
Date:   Sat, 08 May 2021 15:44:16 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-docs-clean-up-sections.patch removed from
 -mm tree
Message-ID: <20210508224416.eRMzitR2g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: clean up sections
has been removed from the -mm tree.  Its filename was
     kasan-docs-clean-up-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: clean up sections

Update KASAN documentation:

- Give some sections clearer names.
- Remove unneeded subsections in the "Tests" section.
- Move the "For developers" section and split into subsections.

Link: https://lkml.kernel.org/r/c2bbb56eaea80ad484f0ee85bb71959a3a63f1d7.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   54 ++++++++++++++--------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-clean-up-sections
+++ a/Documentation/dev-tools/kasan.rst
@@ -177,24 +177,6 @@ particular KASAN features.
   report or also panic the kernel (default: ``report``). Note, that tag
   checking gets disabled after the first reported bug.
 
-For developers
-~~~~~~~~~~~~~~
-
-Software KASAN modes use compiler instrumentation to insert validity checks.
-Such instrumentation might be incompatible with some part of the kernel, and
-therefore needs to be disabled. To disable instrumentation for specific files
-or directories, add a line similar to the following to the respective kernel
-Makefile:
-
-- For a single file (e.g. main.o)::
-
-    KASAN_SANITIZE_main.o := n
-
-- For all files in one directory::
-
-    KASAN_SANITIZE := n
-
-
 Implementation details
 ----------------------
 
@@ -308,8 +290,8 @@ support MTE (but supports TBI).
 Hardware tag-based KASAN only reports the first found bug. After that MTE tag
 checking gets disabled.
 
-What memory accesses are sanitised by KASAN?
---------------------------------------------
+Shadow memory
+-------------
 
 The kernel maps memory in a number of different parts of the address
 space. This poses something of a problem for KASAN, which requires
@@ -320,8 +302,8 @@ The range of kernel virtual addresses is
 real memory to support a real shadow region for every address that
 could be accessed by the kernel.
 
-By default
-~~~~~~~~~~
+Default behaviour
+~~~~~~~~~~~~~~~~~
 
 By default, architectures only map real memory over the shadow region
 for the linear mapping (and potentially other small areas). For all
@@ -371,8 +353,29 @@ unmapped. This will require changes in a
 This allows ``VMAP_STACK`` support on x86, and can simplify support of
 architectures that do not have a fixed module region.
 
-CONFIG_KASAN_KUNIT_TEST and CONFIG_KASAN_MODULE_TEST
-----------------------------------------------------
+For developers
+--------------
+
+Ignoring accesses
+~~~~~~~~~~~~~~~~~
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
+
+
+Tests
+~~~~~
 
 KASAN tests consist of two parts:
 
@@ -418,21 +421,18 @@ Or, if one of the tests failed::
 There are a few ways to run KUnit-compatible KASAN tests.
 
 1. Loadable module
-~~~~~~~~~~~~~~~~~~
 
 With ``CONFIG_KUNIT`` enabled, ``CONFIG_KASAN_KUNIT_TEST`` can be built as
 a loadable module and run on any architecture that supports KASAN by loading
 the module with insmod or modprobe. The module is called ``test_kasan``.
 
 2. Built-In
-~~~~~~~~~~~
 
 With ``CONFIG_KUNIT`` built-in, ``CONFIG_KASAN_KUNIT_TEST`` can be built-in
 on any architecure that supports KASAN. These and any other KUnit tests enabled
 will run and print the results at boot as a late-init call.
 
 3. Using kunit_tool
-~~~~~~~~~~~~~~~~~~~
 
 With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, it's also
 possible use ``kunit_tool`` to see the results of these and other KUnit tests
_

Patches currently in -mm which might be from andreyknvl@google.com are


