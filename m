Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB810EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjHUUrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjHUUrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DFE1A2
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2647C6193B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A59DC433C9;
        Mon, 21 Aug 2023 20:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650829;
        bh=DC+JkGWzpLMhW0MlN/JDnJgSpEFpS3F8zgXmsTPIaAY=;
        h=Date:To:From:Subject:From;
        b=fjmOATpccr855EyVJR/M0UeOVLaCLHqFA9fKWNNQfZEhzuK81FsLCsZUhr356stA9
         99CxD3a7uXGKaCtaxHA6lPqSEQZ8QljLARM3FvQn7LymX5Lnmw5EPn1dTcY4r1gQU1
         tBD/Vjxx4JCQTH79XkYKTGYALr8QJF3XLW8PJ94s=
Date:   Mon, 21 Aug 2023 13:47:08 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        rostedt@goodmis.org, pmladek@suse.com, linux@rasmusvillemoes.dk,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-vsprintf-split-out-sprintf-and-friends.patch removed from -mm tree
Message-Id: <20230821204709.7A59DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/vsprintf: split out sprintf() and friends
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-split-out-sprintf-and-friends.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: split out sprintf() and friends
Date: Mon, 14 Aug 2023 19:33:43 +0300

Patch series "lib/vsprintf: Rework header inclusions", v3.

Some patches that reduce the mess with the header inclusions related to
vsprintf.c module.  Each patch has its own description, and has no
dependencies to each other, except the collisions over modifications of
the same places.  Hence the series.


This patch (of 2):

kernel.h is being used as a dump for all kinds of stuff for a long time. 
sprintf() and friends are used in many drivers without need of the full
kernel.h dependency train with it.

Here is the attempt on cleaning it up by splitting out sprintf() and
friends.

Link: https://lkml.kernel.org/r/20230814163344.17429-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20230814163344.17429-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h  |   30 +-----------------------------
 include/linux/sprintf.h |   25 +++++++++++++++++++++++++
 lib/test_printf.c       |    1 +
 lib/vsprintf.c          |    1 +
 4 files changed, 28 insertions(+), 29 deletions(-)

--- a/include/linux/kernel.h~lib-vsprintf-split-out-sprintf-and-friends
+++ a/include/linux/kernel.h
@@ -29,6 +29,7 @@
 #include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
+#include <linux/sprintf.h>
 #include <linux/static_call_types.h>
 #include <linux/instruction_pointer.h>
 #include <asm/byteorder.h>
@@ -203,35 +204,6 @@ static inline void might_fault(void) { }
 
 void do_exit(long error_code) __noreturn;
 
-extern int num_to_str(char *buf, int size,
-		      unsigned long long num, unsigned int width);
-
-/* lib/printf utilities */
-
-extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
-extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
-extern __printf(3, 4)
-int snprintf(char *buf, size_t size, const char *fmt, ...);
-extern __printf(3, 0)
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
-extern __printf(3, 4)
-int scnprintf(char *buf, size_t size, const char *fmt, ...);
-extern __printf(3, 0)
-int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
-extern __printf(2, 3) __malloc
-char *kasprintf(gfp_t gfp, const char *fmt, ...);
-extern __printf(2, 0) __malloc
-char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
-extern __printf(2, 0)
-const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
-
-extern __scanf(2, 3)
-int sscanf(const char *, const char *, ...);
-extern __scanf(2, 0)
-int vsscanf(const char *, const char *, va_list);
-
-extern int no_hash_pointers_enable(char *str);
-
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
--- /dev/null
+++ a/include/linux/sprintf.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KERNEL_SPRINTF_H_
+#define _LINUX_KERNEL_SPRINTF_H_
+
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+int num_to_str(char *buf, int size, unsigned long long num, unsigned int width);
+
+__printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
+__printf(2, 0) int vsprintf(char *buf, const char *, va_list);
+__printf(3, 4) int snprintf(char *buf, size_t size, const char *fmt, ...);
+__printf(3, 0) int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
+__printf(3, 4) int scnprintf(char *buf, size_t size, const char *fmt, ...);
+__printf(3, 0) int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
+__printf(2, 3) __malloc char *kasprintf(gfp_t gfp, const char *fmt, ...);
+__printf(2, 0) __malloc char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+__printf(2, 0) const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
+
+__scanf(2, 3) int sscanf(const char *, const char *, ...);
+__scanf(2, 0) int vsscanf(const char *, const char *, va_list);
+
+int no_hash_pointers_enable(char *str);
+
+#endif	/* _LINUX_KERNEL_SPRINTF_H */
--- a/lib/test_printf.c~lib-vsprintf-split-out-sprintf-and-friends
+++ a/lib/test_printf.c
@@ -12,6 +12,7 @@
 #include <linux/random.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
+#include <linux/sprintf.h>
 #include <linux/string.h>
 
 #include <linux/bitmap.h>
--- a/lib/vsprintf.c~lib-vsprintf-split-out-sprintf-and-friends
+++ a/lib/vsprintf.c
@@ -34,6 +34,7 @@
 #include <linux/dcache.h>
 #include <linux/cred.h>
 #include <linux/rtc.h>
+#include <linux/sprintf.h>
 #include <linux/time.h>
 #include <linux/uuid.h>
 #include <linux/of.h>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


