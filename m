Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31780C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFEDE23A54
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgLQXDJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731489AbgLQXDJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:09 -0500
Date:   Thu, 17 Dec 2020 15:02:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246149;
        bh=ZYuEdu4GwgHU6ElCcGwIV4vwWOQaVBb7Dk9r3vr1xvc=;
        h=From:To:Subject:From;
        b=kr9z4lEzLv+qJZog4VXIVvGeaO0amlTIC8ACrwRMiG05MyAQ93jagLg5U32fC3LIs
         3yKbaaD0HNHVNq49oC0ZBB0gsS/yjzDBfoJBovvtXoH1/f6MwY8CjKb7QYVpMZE7kq
         A4zCpyLGf5/6lj3cMVyyGkZ2xGUm9MZXRdjqvpdQ=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        skhan@linuxfoundation.org, matti.vaittinen@fi.rohmeurope.com,
        davidgow@google.com, broonie@kernel.org, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch removed
 from -mm tree
Message-ID: <20201217230227.9U_85%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_kunit: follow new file name convention for KUnit tests
has been removed from the -mm tree.  Its filename was
     lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/list_kunit: follow new file name convention for KUnit tests

Follow new file name convention for the KUnit tests.  Since we have
lib/*test*.c in a few variations, use 'kunit' suffix to distinguish usual
test cases with KUnit-based ones.

Link: https://lkml.kernel.org/r/20201112180732.75589-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: David Gow <davidgow@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS  |    2 +-
 lib/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Makefile~lib-list_kunit-follow-new-file-name-convention-for-kunit-tests
+++ a/lib/Makefile
@@ -350,6 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
-obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
+obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
--- a/MAINTAINERS~lib-list_kunit-follow-new-file-name-convention-for-kunit-tests
+++ a/MAINTAINERS
@@ -10176,7 +10176,7 @@ M:	David Gow <davidgow@google.com>
 L:	linux-kselftest@vger.kernel.org
 L:	kunit-dev@googlegroups.com
 S:	Maintained
-F:	lib/list-test.c
+F:	lib/list_kunit.c
 
 LIVE PATCHING
 M:	Josh Poimboeuf <jpoimboe@redhat.com>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

