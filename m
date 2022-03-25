Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEB3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354616AbiCYBOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354593AbiCYBOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13866271F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E4561808
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09800C340EC;
        Fri, 25 Mar 2022 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170796;
        bh=FL25tss9M28fF1QRYqtI+0AFYi/7qNprC4pGvmQy5pg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=aTN15rQ/5+0W8ljaMEb+NI1CB8ctmwS8pZXLkqubxZ59yKRkBtC7Vnr+G6vX98Z5t
         bxhM0kixFydAXhGS/Fphsi+m6BG0Hi08BYzDbrZgNQOxdBCwiiueZ1IheGvgvDkXxb
         fwD9Ea7XZeUXee4VdXfGaYnGwbodO2VrThwOjTpM=
Date:   Thu, 24 Mar 2022 18:13:15 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 094/114] kasan: disable LOCKDEP when printing reports
Message-Id: <20220325011316.09800C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
