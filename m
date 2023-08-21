Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FE9EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjHUUrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjHUUrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FCF1AB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E4F646DE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F3C433C8;
        Mon, 21 Aug 2023 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650830;
        bh=XY5WxD+iQkCIXo41PYnFb4vNh5QLUk+FNo1qOQ8amW0=;
        h=Date:To:From:Subject:From;
        b=ingyteNz2Og2pd5skacA38I/szgSBeTog/oQS5V7TzpCwfVY55AmUs34ZaMT/0XjB
         DYJibduhnz8/rpI8Nv1YleWy5LrtDIXrxC5WvSQ88zw5V7p7LVExmIz+2Rq6cTK9sB
         DTRMX30+XLrsrJtWmVRFhN7Jcfh80gXtGP4FoRws=
Date:   Mon, 21 Aug 2023 13:47:10 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        rostedt@goodmis.org, pmladek@suse.com, linux@rasmusvillemoes.dk,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch removed from -mm tree
Message-Id: <20230821204710.9A2F3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/vsprintf: declare no_hash_pointers in sprintf.h
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: declare no_hash_pointers in sprintf.h
Date: Mon, 14 Aug 2023 19:33:44 +0300

Sparse is not happy to see non-static variable without declaration:
lib/vsprintf.c:61:6: warning: symbol 'no_hash_pointers' was not declared. 
Should it be static?

Declare respective variable in the sprintf.h.  With this, add a comment to
discourage its use if no real need.

Link: https://lkml.kernel.org/r/20230814163344.17429-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sprintf.h |    2 ++
 lib/test_printf.c       |    2 --
 mm/kfence/report.c      |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/sprintf.h~lib-vsprintf-declare-no_hash_pointers-in-sprintfh
+++ a/include/linux/sprintf.h
@@ -20,6 +20,8 @@ __printf(2, 0) const char *kvasprintf_co
 __scanf(2, 3) int sscanf(const char *, const char *, ...);
 __scanf(2, 0) int vsscanf(const char *, const char *, va_list);
 
+/* These are for specific cases, do not use without real need */
+extern bool no_hash_pointers;
 int no_hash_pointers_enable(char *str);
 
 #endif	/* _LINUX_KERNEL_SPRINTF_H */
--- a/lib/test_printf.c~lib-vsprintf-declare-no_hash_pointers-in-sprintfh
+++ a/lib/test_printf.c
@@ -42,8 +42,6 @@ KSTM_MODULE_GLOBALS();
 static char *test_buffer __initdata;
 static char *alloced_buffer __initdata;
 
-extern bool no_hash_pointers;
-
 static int __printf(4, 0) __init
 do_test(int bufsize, const char *expect, int elen,
 	const char *fmt, va_list ap)
--- a/mm/kfence/report.c~lib-vsprintf-declare-no_hash_pointers-in-sprintfh
+++ a/mm/kfence/report.c
@@ -13,6 +13,7 @@
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
 #include <linux/seq_file.h>
+#include <linux/sprintf.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
 #include <trace/events/error_report.h>
@@ -26,8 +27,6 @@
 #define ARCH_FUNC_PREFIX ""
 #endif
 
-extern bool no_hash_pointers;
-
 /* Helper function to either print to a seq_file or to console. */
 __printf(2, 3)
 static void seq_con_printf(struct seq_file *seq, const char *fmt, ...)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


