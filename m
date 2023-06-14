Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABA3EB64DB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 19:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbjFNT5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 15:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjFNT5H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 15:57:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781331FEF
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 12:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F3060C1D
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 19:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5557BC433C0;
        Wed, 14 Jun 2023 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686772625;
        bh=U1r6h41Uq/+hJwONS9WI2F3eXkPvA4PwnA9idbT21/w=;
        h=Date:To:From:Subject:From;
        b=QbnCNBvOVTmlpSfoFjohMHZytM3QwJNjJzgk/js4YGsY939Dj7Ha+NsTE44qb7sKF
         FFEqiCrXeUFgP4ACVWHXqoCXf81ZPL0fgL44pQZgDUANV6WX6XCLI0QyeBurcMtVHN
         epwxAlnbiKHnubXn++Rk9RDjMBVNOtCp8yispjLw=
Date:   Wed, 14 Jun 2023 12:57:04 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tarasmadan@google.com, ryabinin.a.a@gmail.com, nogikh@google.com,
        glider@google.com, dvyukov@google.com, corbet@lwn.net,
        andreyknvl@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-support-for-kasanfault=panic_on_write.patch added to mm-unstable branch
Message-Id: <20230614195705.5557BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add support for kasan.fault=panic_on_write
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-support-for-kasanfault=panic_on_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-support-for-kasanfault=panic_on_write.patch

This patch will later appear in the mm-unstable branch at
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
From: Marco Elver <elver@google.com>
Subject: kasan: add support for kasan.fault=panic_on_write
Date: Wed, 14 Jun 2023 11:51:16 +0200

KASAN's boot time kernel parameter 'kasan.fault=' currently supports
'report' and 'panic', which results in either only reporting bugs or also
panicking on reports.

However, some users may wish to have more control over when KASAN reports
result in a kernel panic: in particular, KASAN reported invalid _writes_
are of special interest, because they have greater potential to corrupt
random kernel memory or be more easily exploited.

To panic on invalid writes only, introduce 'kasan.fault=panic_on_write',
which allows users to choose to continue running on invalid reads, but
panic only on invalid writes.

Link: https://lkml.kernel.org/r/20230614095158.1133673-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    7 +++---
 mm/kasan/report.c                 |   31 +++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 8 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-add-support-for-kasanfault=panic_on_write
+++ a/Documentation/dev-tools/kasan.rst
@@ -107,9 +107,10 @@ effectively disables ``panic_on_warn`` f
 Alternatively, independent of ``panic_on_warn``, the ``kasan.fault=`` boot
 parameter can be used to control panic and reporting behaviour:
 
-- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``). The panic happens even
-  if ``kasan_multi_shot`` is enabled.
+- ``kasan.fault=report``, ``=panic``, or ``=panic_on_write`` controls whether
+  to only print a KASAN report, panic the kernel, or panic the kernel on
+  invalid writes only (default: ``report``). The panic happens even if
+  ``kasan_multi_shot`` is enabled.
 
 Software and Hardware Tag-Based KASAN modes (see the section about various
 modes below) support altering stack trace collection behavior:
--- a/mm/kasan/report.c~kasan-add-support-for-kasanfault=panic_on_write
+++ a/mm/kasan/report.c
@@ -43,6 +43,7 @@ enum kasan_arg_fault {
 	KASAN_ARG_FAULT_DEFAULT,
 	KASAN_ARG_FAULT_REPORT,
 	KASAN_ARG_FAULT_PANIC,
+	KASAN_ARG_FAULT_PANIC_ON_WRITE,
 };
 
 static enum kasan_arg_fault kasan_arg_fault __ro_after_init = KASAN_ARG_FAULT_DEFAULT;
@@ -57,6 +58,8 @@ static int __init early_kasan_fault(char
 		kasan_arg_fault = KASAN_ARG_FAULT_REPORT;
 	else if (!strcmp(arg, "panic"))
 		kasan_arg_fault = KASAN_ARG_FAULT_PANIC;
+	else if (!strcmp(arg, "panic_on_write"))
+		kasan_arg_fault = KASAN_ARG_FAULT_PANIC_ON_WRITE;
 	else
 		return -EINVAL;
 
@@ -211,7 +214,7 @@ static void start_report(unsigned long *
 	pr_err("==================================================================\n");
 }
 
-static void end_report(unsigned long *flags, const void *addr)
+static void end_report(unsigned long *flags, const void *addr, bool is_write)
 {
 	if (addr)
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
@@ -220,8 +223,18 @@ static void end_report(unsigned long *fl
 	spin_unlock_irqrestore(&report_lock, *flags);
 	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		check_panic_on_warn("KASAN");
-	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
+	switch (kasan_arg_fault) {
+	case KASAN_ARG_FAULT_DEFAULT:
+	case KASAN_ARG_FAULT_REPORT:
+		break;
+	case KASAN_ARG_FAULT_PANIC:
 		panic("kasan.fault=panic set ...\n");
+		break;
+	case KASAN_ARG_FAULT_PANIC_ON_WRITE:
+		if (is_write)
+			panic("kasan.fault=panic_on_write set ...\n");
+		break;
+	}
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	lockdep_on();
 	report_suppress_stop();
@@ -536,7 +549,11 @@ void kasan_report_invalid_free(void *ptr
 
 	print_report(&info);
 
-	end_report(&flags, ptr);
+	/*
+	 * Invalid free is considered a "write" since the allocator's metadata
+	 * updates involves writes.
+	 */
+	end_report(&flags, ptr, true);
 }
 
 /*
@@ -570,7 +587,7 @@ bool kasan_report(const void *addr, size
 
 	print_report(&info);
 
-	end_report(&irq_flags, (void *)addr);
+	end_report(&irq_flags, (void *)addr, is_write);
 
 out:
 	user_access_restore(ua_flags);
@@ -596,7 +613,11 @@ void kasan_report_async(void)
 	pr_err("Asynchronous fault: no details available\n");
 	pr_err("\n");
 	dump_stack_lvl(KERN_ERR);
-	end_report(&flags, NULL);
+	/*
+	 * Conservatively set is_write=true, because no details are available.
+	 * In this mode, kasan.fault=panic_on_write is like kasan.fault=panic.
+	 */
+	end_report(&flags, NULL, true);
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
_

Patches currently in -mm which might be from elver@google.com are

kasan-add-support-for-kasanfault=panic_on_write.patch

