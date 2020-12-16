Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761D9C3526A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406772333F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgLPEnv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgLPEnv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:51 -0500
Date:   Tue, 15 Dec 2020 20:43:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093811;
        bh=dYzhad7ZJ0fx36GnLLU5lopaUG3x56KBRcnwrH6tbnM=;
        h=From:To:Subject:In-Reply-To:From;
        b=Wjs2KkmImc3G/HtgmUC5+F32HUG+rGqDUXZkKA44FLdmx/r+SM2t2afmCa5CcwSOV
         A3SzNfb/En6mEbGRm/b98DqLVHvDlhIMR4EAXg3ddq0KHii5WgsRMe/3aLCMpdgjFY
         0eL/I67DjP0VH+5v6MewkVYrN24rYbwLp8eHv5bA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, broonie@kernel.org, davidgow@google.com,
        linux-mm@kvack.org, matti.vaittinen@fi.rohmeurope.com,
        mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        torvalds@linux-foundation.org, vitor@massaru.org
Subject:  [patch 22/95] lib/cmdline: allow NULL to be an output for
 get_option()
Message-ID: <20201216044330.xDkb95Dmk%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
