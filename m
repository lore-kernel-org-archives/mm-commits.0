Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F807C55ABD
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1F021D7E
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUf5Hj4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgKPUTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgKPUTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:19:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49EB217A0;
        Mon, 16 Nov 2020 20:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605557943;
        bh=2XgugIoBWiZmtBAu4+ea8QjRSGGr8YBSJoFJ3oPqYfQ=;
        h=Date:From:To:Subject:From;
        b=nUf5Hj4gqnG4fSafJvZHRpeBK/q1M9cac75Gs652sp6N0Q/OGFxHia2vZHEG+UUat
         rz0iG6b6Cr87BGSHD76tc3k8E2vYe8y2c1V5ObHKkUF8AeqOLl+jZ2BY4Nl0qXnbTH
         AS0GmkBZB+HkF1o+X6rYN5NyBB7HaNm+hexe+sz4=
Date:   Mon, 16 Nov 2020 12:19:02 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch added to
 -mm tree
Message-ID: <20201116201902.YUGWWZpX2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()
has been added to the -mm tree.  Its filename is
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()

modpost complains that module has no licence provided.  Provide it via
meaningful MODULE_LICENSE().

Link: https://lkml.kernel.org/r/20201116104257.15527-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline_kunit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/cmdline_kunit.c~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3
+++ a/lib/cmdline_kunit.c
@@ -96,3 +96,5 @@ static struct kunit_suite cmdline_test_s
 	.test_cases = cmdline_test_cases,
 };
 kunit_test_suite(cmdline_test_suite);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

