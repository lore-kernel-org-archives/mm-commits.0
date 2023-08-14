Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA32EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 18:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjHNSia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjHNSh4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 14:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8211E63
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 11:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3626152F
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 18:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D684AC433C7;
        Mon, 14 Aug 2023 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692038274;
        bh=DvBL0Lp67PUv4ztyLTc4ParxiBXf3wkyspDW82nkcnQ=;
        h=Date:To:From:Subject:From;
        b=k09pWObDxKXcGl26WzeW/PvEq74h9NRzICNofeiGtsGDl8oQvYai7oE6gEcUcG0th
         lmui31ZNy2V7udetYges2yfsRT90G4L254KZSWKh1iwuSqyvd+W4760xcAVWIYhWdq
         YCs/Yump5ukH1UbdL1nm1wQJoX/xD861ZEHT6Yak=
Date:   Mon, 14 Aug 2023 11:37:54 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        rostedt@goodmis.org, pmladek@suse.com, linux@rasmusvillemoes.dk,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch added to mm-nonmm-unstable branch
Message-Id: <20230814183754.D684AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: declare no_hash_pointers in sprintf.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Petr Mladek <pmladek@suse.com>
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

lib-vsprintf-split-out-sprintf-and-friends.patch
lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch

