Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7D4C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB98220B80
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tc1DL8GI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgKLTc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgKLTc1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 14:32:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 155202222F;
        Thu, 12 Nov 2020 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605209546;
        bh=kRnZxmsPpLQu+ikADb5bZp8fxFrSk+T+CUsLFr+uJus=;
        h=Date:From:To:Subject:From;
        b=Tc1DL8GI6NZ/KjwVrlg2ve6206hzvx8hP4awv+Uw6CPYHxbecSRdFz1LXNJzAhT/v
         y62NobBRhXpcaBajS7zepwrm04z33Q9ybYNc3ahFNNP1F1Z8iURzdQzCu/oaJFU/QZ
         yl4sGrSEikr+oKtsxW3ApwHwCa875F5Vv+1BirIk=
Date:   Thu, 12 Nov 2020 11:32:25 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  +
 lib-cmdline-allow-null-to-be-an-output-for-get_option.patch added to -mm
 tree
Message-ID: <20201112193225.iA3zKlbMb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: allow NULL to be an output for get_option()
has been added to the -mm tree.  Its filename is
     lib-cmdline-allow-null-to-be-an-output-for-get_option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline-allow-null-to-be-an-output-for-get_option.patch

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
Subject: lib/cmdline: allow NULL to be an output for get_option()

In the future we would like to use get_option() to only validate the
string and parse it separately.  To achieve this, allow NULL to be an
output for get_option().

Link: https://lkml.kernel.org/r/20201112180732.75589-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/cmdline.c~lib-cmdline-allow-null-to-be-an-output-for-get_option
+++ a/lib/cmdline.c
@@ -35,11 +35,14 @@ static int get_range(char **str, int *pi
 /**
  *	get_option - Parse integer from an option string
  *	@str: option string
- *	@pint: (output) integer value parsed from @str
+ *	@pint: (optional output) integer value parsed from @str
  *
  *	Read an int from an option string; if available accept a subsequent
  *	comma as well.
  *
+ *	When @pint is NULL the function can be used as a validator of
+ *	the current option in the string.
+ *
  *	Return values:
  *	0 - no int in string
  *	1 - int found, no subsequent comma
@@ -53,13 +56,16 @@ static int get_range(char **str, int *pi
 int get_option(char **str, int *pint)
 {
 	char *cur = *str;
+	int value;
 
 	if (!cur || !(*cur))
 		return 0;
 	if (*cur == '-')
-		*pint = -simple_strtoull(++cur, str, 0);
+		value = -simple_strtoull(++cur, str, 0);
 	else
-		*pint = simple_strtoull(cur, str, 0);
+		value = simple_strtoull(cur, str, 0);
+	if (pint)
+		*pint = value;
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

