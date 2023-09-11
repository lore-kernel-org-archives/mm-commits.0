Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C24CA0EC3
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbjIKWXB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243929AbjIKS0B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:26:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A65A110
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:25:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7D7C433C7;
        Mon, 11 Sep 2023 18:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694456757;
        bh=Ucgmt2LfXJHKEAp3qm8vW4y+SKIjcB+QcvLw9fIF5N0=;
        h=Date:To:From:Subject:From;
        b=SSl72FggsxDvBMfxP+AYJnCPeB7Xz4OemWOjMf43S7EK9YumMNEI21WFD+3zWhwEX
         DaW+QVDTJYgvmx8j03AFfxOeZxfQle5Q2/4mmYOKGSpFKY76LEK6XA/LeRkCp+1B2p
         +zAapb5D/sfFAqZCNPJGqltk/b9cIul0EtScykyM=
Date:   Mon, 11 Sep 2023 11:25:56 -0700
To:     mm-commits@vger.kernel.org, herve.codina@bootlin.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-deduplicate-__unconst_integer_typeof.patch added to mm-nonmm-unstable branch
Message-Id: <20230911182556.ED7D7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: deduplicate __unconst_integer_typeof()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-deduplicate-__unconst_integer_typeof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-deduplicate-__unconst_integer_typeof.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: minmax: deduplicate __unconst_integer_typeof()
Date: Mon, 11 Sep 2023 18:49:13 +0300

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h~minmax-deduplicate-__unconst_integer_typeof
+++ a/include/linux/minmax.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/compiler_types.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
@@ -135,27 +136,6 @@
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
 /*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
-/*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
  * __must_be_array() will return a failure.
@@ -169,13 +149,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

minmax-deduplicate-__unconst_integer_typeof.patch

