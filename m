Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400FEC5519F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1122223F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RImZEGQt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKLTcY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:32:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgKLTcY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 14:32:24 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A8A20A8B;
        Thu, 12 Nov 2020 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605209543;
        bh=50l1T8wjC83plrOuUtmZQckPpO+j0Rtito07mAWv9OY=;
        h=Date:From:To:Subject:From;
        b=RImZEGQtEO/OQWHDnRiEO+M2sUFcB3O1RbtPQEKhOT3UzLwnBkAuI6ke4FlND6qlZ
         9hck3d4HJTwUD7VYhQjgyr8lZTtSQqqAl0nikn63gp5dqklv7PjW0zZG9chQRMkgOq
         fJ7EU6+pUViKjEATZ1xxP+UIw3TE2ksca7OHvZyw=
Date:   Thu, 12 Nov 2020 11:32:22 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  +
 lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch added to
 -mm tree
Message-ID: <20201112193222.BmC7J2J6g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: fix get_option() for strings starting with hyphen
has been added to the -mm tree.  Its filename is
     lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch

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
Subject: lib/cmdline: fix get_option() for strings starting with hyphen

When string doesn't have an integer and starts from hyphen get_option()
may return interesting results.  Fix it to return 0.

The simple_strtoull() is used due to absence of simple_strtoul() in a boot
code on some architectures.

Note, the Fixes tag below is rather for anthropological curiosity.

Link: https://lkml.kernel.org/r/20201112180732.75589-4-andriy.shevchenko@linux.intel.com
Fixes: f68565831e72 ("Import 2.4.0-test2pre3")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/cmdline.c~lib-cmdline-fix-get_option-for-strings-starting-with-hyphen
+++ a/lib/cmdline.c
@@ -45,6 +45,9 @@ static int get_range(char **str, int *pi
  *	1 - int found, no subsequent comma
  *	2 - int found including a subsequent comma
  *	3 - hyphen found to denote a range
+ *
+ *	Leading hyphen without integer is no integer case, but we consume it
+ *	for the sake of simplification.
  */
 
 int get_option(char **str, int *pint)
@@ -53,7 +56,10 @@ int get_option(char **str, int *pint)
 
 	if (!cur || !(*cur))
 		return 0;
-	*pint = simple_strtol(cur, str, 0);
+	if (*cur == '-')
+		*pint = -simple_strtoull(++cur, str, 0);
+	else
+		*pint = simple_strtoull(cur, str, 0);
 	if (cur == *str)
 		return 0;
 	if (**str == ',') {
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

