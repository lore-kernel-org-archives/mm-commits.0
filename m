Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44919C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiCYWpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiCYWpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DD720D537
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA819614D8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B26C004DD;
        Fri, 25 Mar 2022 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248182;
        bh=1q0Zee1nbQIJdWamgWFG97k2+y+xWGxcVmMIw4YVjW0=;
        h=Date:To:From:Subject:From;
        b=Cn93bxHdX+upLt7bR1Uh6tTM1okPnMgKdz6+4tOBwx66HiaqgDCBuJX7OP9+l6MO5
         /KgSGNbzipXMXQKmwb2eW/jDnJnB1W57Ho0cQxisgyPd9js2+NsSBiKqJo00WlO6z9
         jUuiCHHAoPTrvnJRAzqHyobyXSHKrdv9loX+KxD4=
Date:   Fri, 25 Mar 2022 15:43:01 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-disable-lockdep-when-printing-reports.patch removed from -mm tree
Message-Id: <20220325224302.49B26C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: disable LOCKDEP when printing reports
has been removed from the -mm tree.  Its filename was
     kasan-disable-lockdep-when-printing-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: disable LOCKDEP when printing reports

If LOCKDEP detects a bug while KASAN is printing a report and if
panic_on_warn is set, KASAN will not be able to finish.  Disable LOCKDEP
while KASAN is printing a report.

See https://bugzilla.kernel.org/show_bug.cgi?id=202115 for an example
of the issue.

Link: https://lkml.kernel.org/r/c48a2a3288200b07e1788b77365c2f02784cfeb4.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-disable-lockdep-when-printing-reports
+++ a/mm/kasan/report.c
@@ -13,6 +13,7 @@
 #include <linux/ftrace.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/lockdep.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/sched.h>
@@ -148,6 +149,8 @@ static void start_report(unsigned long *
 	disable_trace_on_warning();
 	/* Update status of the currently running KASAN test. */
 	update_kunit_status(sync);
+	/* Do not allow LOCKDEP mangling KASAN reports. */
+	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, *flags);
@@ -160,12 +163,13 @@ static void end_report(unsigned long *fl
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
-	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
 	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		panic("panic_on_warn set ...\n");
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	lockdep_on();
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

