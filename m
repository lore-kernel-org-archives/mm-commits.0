Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CC1C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F4422253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709339;
	bh=T6SZuRbm4KjFkVK4c8SEuig3a2/D4XsFZOA1FfCeoX0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=v5lEof9n5UVzVAPuuZRXR1RF0Xq7H1QvjLM1VqQQQyo84LHGUi1hfTOj/emPseeqd
	 norCVSV50BT1XatPKoHaSLZTIkH5LxVBjYdDeWl4Sn1Mb6+UUxlNRXH0GtU7Oke/7e
	 NEEusHj/M5F8FGuQ1g0xGff+W7WviImpX5w4Fwuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbgJNVCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgJNVCQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93238221FF;
        Wed, 14 Oct 2020 21:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709336;
        bh=T6SZuRbm4KjFkVK4c8SEuig3a2/D4XsFZOA1FfCeoX0=;
        h=Date:From:To:Subject:From;
        b=es50idgKUDBy0KbIPkGzcUmVKauCxtHgWieAhnmKs0DFY0fwf3oJB15Vnmuc5sGzS
         8HuW5Qh/8JIw7TeXT7KHVP+R9jSkz/hzlLACCMcHH3r5nuiEL64Y7JPsQkZEFlkBjx
         ZievS4xXpXr1ORdD44DUKpUCWMiwkVUiZ6u/Mb/g=
Date:   Wed, 14 Oct 2020 14:02:15 -0700
From:   akpm@linux-foundation.org
To:     a.p.zijlstra@chello.nl, andreyknvl@google.com,
        aryabinin@virtuozzo.com, brendanhiggins@google.com,
        davidgow@google.com, dvyukov@google.com, juri.lelli@redhat.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, shuah@kernel.org,
        trishalfonso@google.com, vincent.guittot@linaro.org
Subject:  [merged] kasan-testing-documentation.patch removed from
 -mm tree
Message-ID: <20201014210215.7LfH_Xbdd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: KASAN: Testing Documentation
has been removed from the -mm tree.  Its filename was
     kasan-testing-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Patricia Alfonso <trishalfonso@google.com>
Subject: KASAN: Testing Documentation

Include documentation on how to test KASAN using CONFIG_TEST_KASAN_KUNIT
and CONFIG_TEST_KASAN_MODULE.

Link: https://lkml.kernel.org/r/20200915035828.570483-5-davidgow@google.com
Link: https://lkml.kernel.org/r/20200910070331.3358048-5-davidgow@google.com
Signed-off-by: Patricia Alfonso <trishalfonso@google.com>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   70 ++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

--- a/Documentation/dev-tools/kasan.rst~kasan-testing-documentation
+++ a/Documentation/dev-tools/kasan.rst
@@ -281,3 +281,73 @@ unmapped. This will require changes in a
 
 This allows ``VMAP_STACK`` support on x86, and can simplify support of
 architectures that do not have a fixed module region.
+
+CONFIG_KASAN_KUNIT_TEST & CONFIG_TEST_KASAN_MODULE
+--------------------------------------------------
+
+``CONFIG_KASAN_KUNIT_TEST`` utilizes the KUnit Test Framework for testing.
+This means each test focuses on a small unit of functionality and
+there are a few ways these tests can be run.
+
+Each test will print the KASAN report if an error is detected and then
+print the number of the test and the status of the test:
+
+pass::
+
+        ok 28 - kmalloc_double_kzfree
+or, if kmalloc failed::
+
+        # kmalloc_large_oob_right: ASSERTION FAILED at lib/test_kasan.c:163
+        Expected ptr is not null, but is
+        not ok 4 - kmalloc_large_oob_right
+or, if a KASAN report was expected, but not found::
+
+        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:629
+        Expected kasan_data->report_expected == kasan_data->report_found, but
+        kasan_data->report_expected == 1
+        kasan_data->report_found == 0
+        not ok 28 - kmalloc_double_kzfree
+
+All test statuses are tracked as they run and an overall status will
+be printed at the end::
+
+        ok 1 - kasan
+
+or::
+
+        not ok 1 - kasan
+
+(1) Loadable Module
+~~~~~~~~~~~~~~~~~~~~
+
+With ``CONFIG_KUNIT`` enabled, ``CONFIG_KASAN_KUNIT_TEST`` can be built as
+a loadable module and run on any architecture that supports KASAN
+using something like insmod or modprobe. The module is called ``test_kasan``.
+
+(2) Built-In
+~~~~~~~~~~~~~
+
+With ``CONFIG_KUNIT`` built-in, ``CONFIG_KASAN_KUNIT_TEST`` can be built-in
+on any architecure that supports KASAN. These and any other KUnit
+tests enabled will run and print the results at boot as a late-init
+call.
+
+(3) Using kunit_tool
+~~~~~~~~~~~~~~~~~~~~~
+
+With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, we can also
+use kunit_tool to see the results of these along with other KUnit
+tests in a more readable way. This will not print the KASAN reports
+of tests that passed. Use `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_ for more up-to-date
+information on kunit_tool.
+
+.. _KUnit: https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html
+
+``CONFIG_TEST_KASAN_MODULE`` is a set of KASAN tests that could not be
+converted to KUnit. These tests can be run only as a module with
+``CONFIG_TEST_KASAN_MODULE`` built as a loadable module and
+``CONFIG_KASAN`` built-in. The type of error expected and the
+function being run is printed before the expression expected to give
+an error. Then the error is printed, if found, and that test
+should be interpretted to pass only if the error was the one expected
+by the test.
_

Patches currently in -mm which might be from trishalfonso@google.com are


