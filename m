Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C18C0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 20:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjGSUDc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjGSUDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 16:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38F11FD3
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 13:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4962E617D6
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 20:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974EFC433C7;
        Wed, 19 Jul 2023 20:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689797000;
        bh=Sp7oAiCCqUGXYS8dcPaEkZXII23YFTiRxWmGdJwdRrQ=;
        h=Date:To:From:Subject:From;
        b=iKGBtoUdV/adg+ztMC35PKVOfEg2ZP4J/tRqcwWvQzVs0t220R0LqV2b/Mvj5d8Ze
         bb0vYCEpEkHQ5CDQ062wQvwA9Mj15wNC1YD72mN3Bd9wi58GKyoEosGfBgyUNHINUH
         g1dNqqSniL8uuJMMg2nm30xPvHAYWlIO2vagdznI=
Date:   Wed, 19 Jul 2023 13:03:19 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sudeep.holla@arm.com, skhan@linuxfoundation.org,
        rostedt@goodmis.org, mingo@redhat.com, mhiramat@kernel.org,
        mark.rutland@arm.com, lpieralisi@kernel.org, hpa@zytor.com,
        dlatypov@google.com, davidgow@google.com,
        dave.hansen@linux.intel.com, brendan.higgins@linux.dev,
        bp@alien8.de, bhelgaas@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-split-out-count_args-and-concatenate-to-argsh.patch added to mm-nonmm-unstable branch
Message-Id: <20230719200320.974EFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out COUNT_ARGS() and CONCATENATE() to args.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-split-out-count_args-and-concatenate-to-argsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-split-out-count_args-and-concatenate-to-argsh.patch

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
Subject: kernel.h: split out COUNT_ARGS() and CONCATENATE() to args.h
Date: Wed, 19 Jul 2023 00:11:44 +0300

Patch series "kernel.h: Split out a couple of macros to args.h", v4.

There are macros in kernel.h that can be used outside of that header. 
Split them to args.h and replace open coded variants.


This patch (of 4):

kernel.h is being used as a dump for all kinds of stuff for a long time. 
The COUNT_ARGS() and CONCATENATE() macros may be used in some places
without need of the full kernel.h dependency train with it.

Here is the attempt on cleaning it up by splitting out these macros().

While at it, include new header where it's being used.

Link: https://lkml.kernel.org/r/20230718211147.18647-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20230718211147.18647-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/kunit/test.h      |    1 +
 include/linux/args.h      |   28 ++++++++++++++++++++++++++++
 include/linux/kernel.h    |    7 -------
 include/linux/pci.h       |    2 +-
 include/trace/bpf_probe.h |    2 ++
 5 files changed, 32 insertions(+), 8 deletions(-)

--- a/include/kunit/test.h~kernelh-split-out-count_args-and-concatenate-to-argsh
+++ a/include/kunit/test.h
@@ -12,6 +12,7 @@
 #include <kunit/assert.h>
 #include <kunit/try-catch.h>
 
+#include <linux/args.h>
 #include <linux/compiler.h>
 #include <linux/container_of.h>
 #include <linux/err.h>
--- /dev/null
+++ a/include/linux/args.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_ARGS_H
+#define _LINUX_ARGS_H
+
+/*
+ * How do these macros work?
+ *
+ * In __COUNT_ARGS() _0 to _12 are just placeholders from the start
+ * in order to make sure _n is positioned over the correct number
+ * from 12 to 0 (depending on X, which is a variadic argument list).
+ * They serve no purpose other than occupying a position. Since each
+ * macro parameter must have a distinct identifier, those identifiers
+ * are as good as any.
+ *
+ * In COUNT_ARGS() we use actual integers, so __COUNT_ARGS() returns
+ * that as _n.
+ */
+
+/* This counts to 12. Any more, it will return 13th argument. */
+#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
+#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+
+/* Concatenate two parameters, but allow them to be expanded beforehand. */
+#define __CONCAT(a, b) a ## b
+#define CONCATENATE(a, b) __CONCAT(a, b)
+
+#endif	/* _LINUX_ARGS_H */
--- a/include/linux/kernel.h~kernelh-split-out-count_args-and-concatenate-to-argsh
+++ a/include/linux/kernel.h
@@ -457,13 +457,6 @@ ftrace_vprintk(const char *fmt, va_list
 static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
-/* This counts to 12. Any more, it will return 13th argument. */
-#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
-#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
-
-#define __CONCAT(a, b) a ## b
-#define CONCATENATE(a, b) __CONCAT(a, b)
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
--- a/include/linux/pci.h~kernelh-split-out-count_args-and-concatenate-to-argsh
+++ a/include/linux/pci.h
@@ -23,7 +23,7 @@
 #ifndef LINUX_PCI_H
 #define LINUX_PCI_H
 
-
+#include <linux/args.h>
 #include <linux/mod_devicetable.h>
 
 #include <linux/types.h>
--- a/include/trace/bpf_probe.h~kernelh-split-out-count_args-and-concatenate-to-argsh
+++ a/include/trace/bpf_probe.h
@@ -12,6 +12,8 @@
 #undef __perf_task
 #define __perf_task(t)	(t)
 
+#include <linux/args.h>
+
 /* cast any integer, pointer, or small struct to u64 */
 #define UINTTYPE(size) \
 	__typeof__(__builtin_choose_expr(size == 1,  (u8)1, \
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-count_args-and-concatenate-to-argsh.patch
x86-asm-replace-custom-count_args-concatenate-implementations.patch
arm64-smccc-replace-custom-count_args-concatenate-implementations.patch
genetlink-replace-custom-concatenate-implementation.patch

