Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0D0C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 702E7230FA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgLPRKO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:14 -0500
Date:   Wed, 16 Dec 2020 09:09:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138546;
        bh=qLFKakocm1bLClNMkaUNDj6bHIE8XjDikf9VlZjSKuU=;
        h=From:To:Subject:From;
        b=CwE7/av6aUkxFqhNZtWo/MmgOTf/VBJt4xEf6l3MI14g5PR0ZolRd7K6nc933gMtM
         MGOyasGWGP575WXyy454Y7Ag+K4Flze+LppBlL7lU9MtYaW6ZRHmX5J2en3Fd9OD5l
         3wyfCMzuEh9kM0h1UZ0mYYkjbCfvl5iYxmq3qrrg=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  [merged]
 lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch removed
 from -mm tree
Message-ID: <20201216170906.KiQHyaCdF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: fix get_option() for strings starting with hyphen
has been removed from the -mm tree.  Its filename was
     lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


