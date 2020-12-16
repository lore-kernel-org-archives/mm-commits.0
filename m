Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF382C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13BC23406
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgLPRJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgLPRJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:47 -0500
Date:   Wed, 16 Dec 2020 09:08:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138538;
        bh=wi2veQS8AUZU0fkZOZ3Gre1i0vPQXu34FuhoqOxYM74=;
        h=From:To:Subject:From;
        b=HeEyHH3k32NPmy97THSxeMeGbkfRTcx/AJ3yBSzZ+6lEL2GCRCaFJP7lpTxTUbNXz
         AXXBuWPHTWxmUqrmwpChW07cTKE0DT5sQDzOva6opsMEVOdYu+O+ehewDB934W46Hk
         rUXS0gNbIaEqAocCXAp/E2ScdgGaHgoNM4N78NJc=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  [merged]
 lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch
 removed from -mm tree
Message-ID: <20201216170857.iehdGSRgG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_kunit: follow new file name convention for KUnit tests
has been removed from the -mm tree.  Its filename was
     lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -10263,7 +10263,7 @@ M:	David Gow <davidgow@google.com>
 L:	linux-kselftest@vger.kernel.org
 L:	kunit-dev@googlegroups.com
 S:	Maintained
-F:	lib/list-test.c
+F:	lib/list_kunit.c
 
 LIVE PATCHING
 M:	Josh Poimboeuf <jpoimboe@redhat.com>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


