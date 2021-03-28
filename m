Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AFC6C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55A506196E
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhC1TLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231448AbhC1TLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B0656197F;
        Sun, 28 Mar 2021 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958694;
        bh=X6z1FScFWcA5RF/dBLyhwl9feuYkzWnHR6KT+W2Td3g=;
        h=Date:From:To:Subject:From;
        b=nO+j5m+KKJKUNAJ3b86GVGORBSi6kbk3dzEU9EJdu1wI4/yYYGd9LgFMVX4mZB/H/
         lQ4HSCZhQ6OaDAVlrgmsn9mKCmL0TSI4uP2C5khWbK+sNj6JbE1eZCDLct7lQ+NTRb
         W2bN8lA9unhSLW387LCttbOthvCz5JTg8ckbTEMU=
Date:   Sun, 28 Mar 2021 12:11:33 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yury.norov@gmail.com
Subject:  + kernelh-drop-inclusion-in-bitmaph.patch added to -mm
 tree
Message-ID: <20210328191133.QpT-cPP0Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: drop inclusion in bitmap.h
has been added to the -mm tree.  Its filename is
     kernelh-drop-inclusion-in-bitmaph.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-drop-inclusion-in-bitmaph.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-drop-inclusion-in-bitmaph.patch

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
Subject: kernel.h: drop inclusion in bitmap.h

The bitmap.h header is used in a lot of code around the kernel.  Besides
that it includes kernel.h which sometimes makes a loop.

The problem here is many unneeded loops that make header hell
dependencies.  For example, how may you move bitmap_zalloc() from C-file
to the header?  Currently it's impossible.  And bitmap.h here is only the
tip of an iceberg.

kerne.h is a dump of everything that even has nothing in common at all. 
We may still have it, but in my new code I prefer to include only the
headers that I want to use, without the bulk of unneeded kernel code.

Break the loop by introducing align.h, including it in kernel.h and
bitmap.h followed by replacing kernel.h with limits.h.

Link: https://lkml.kernel.org/r/20210326170347.37441-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/align.h  |   15 +++++++++++++++
 include/linux/bitmap.h |    3 ++-
 include/linux/kernel.h |    9 +--------
 3 files changed, 18 insertions(+), 9 deletions(-)

--- /dev/null
+++ a/include/linux/align.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ALIGN_H
+#define _LINUX_ALIGN_H
+
+#include <linux/const.h>
+
+/* @a is a power of 2 value */
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
+#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
+#define PTR_ALIGN_DOWN(p, a)	((typeof(p))ALIGN_DOWN((unsigned long)(p), (a)))
+#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+
+#endif	/* _LINUX_ALIGN_H */
--- a/include/linux/bitmap.h~kernelh-drop-inclusion-in-bitmaph
+++ a/include/linux/bitmap.h
@@ -4,10 +4,11 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/align.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/limits.h>
 #include <linux/string.h>
-#include <linux/kernel.h>
 
 /*
  * bitmaps provide bit arrays that consume one or more unsigned
--- a/include/linux/kernel.h~kernelh-drop-inclusion-in-bitmaph
+++ a/include/linux/kernel.h
@@ -3,6 +3,7 @@
 #define _LINUX_KERNEL_H
 
 #include <stdarg.h>
+#include <linux/align.h>
 #include <linux/limits.h>
 #include <linux/linkage.h>
 #include <linux/stddef.h>
@@ -30,14 +31,6 @@
  */
 #define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
 
-/* @a is a power of 2 value */
-#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
-#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
-#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
-#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define PTR_ALIGN_DOWN(p, a)	((typeof(p))ALIGN_DOWN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
-
 /* generic data direction definitions */
 #define READ			0
 #define WRITE			1
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-drop-inclusion-in-bitmaph.patch

