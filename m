Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1999C2BBD4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C842D23A51
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgLQXDR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgLQXDR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:17 -0500
Date:   Thu, 17 Dec 2020 15:02:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246156;
        bh=QvHEiX09z/Vr8waxfFOKK10sT9uHJ3u2yaEzjqkZ48U=;
        h=From:To:Subject:From;
        b=TzZqdJeNj55ad9RPuzEzN4SAtTNJRvRDLDdoQjeXzTsimU7w64ZoV4oICa7FuqiQc
         mm9CdM4hd8/61RowIXGFaxb8V423Mtl7qpOcbjLLFib8SNH2BnAVtEZA703cpPtMVz
         D0hVO+DTPshKKNrOVcoF4jZsnB6UhpBuWO++hZeU=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        skhan@linuxfoundation.org, matti.vaittinen@fi.rohmeurope.com,
        davidgow@google.com, broonie@kernel.org, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-cmdline-allow-null-to-be-an-output-for-get_option.patch removed from -mm
 tree
Message-ID: <20201217230236.0A7rp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: allow NULL to be an output for get_option()
has been removed from the -mm tree.  Its filename was
     lib-cmdline-allow-null-to-be-an-output-for-get_option.patch

This patch was dropped because an updated version will be merged

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
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

