Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E370DC43332
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9998964F4D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBZBWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhBZBV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7516964F37;
        Fri, 26 Feb 2021 01:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302446;
        bh=RIFWirqVoySBFQi0YuQBdwuuYD+3im2cq5Fc5C2gp9M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JM2/8YP7+jksG/fytmuOKE+yEwsG8yy2bNO4GTTxXwyBUGl8t0idLo+MQqCE2b05n
         0r43jZWzEMWTot8IzSQZHwn37kG1+xDlEQV5qSJcwh7lvhdoNYIl4RhSBmjm7/bxoL
         3IjczXPbU6TwEmuKg38dzUdHniFwLH6Z6ZLaiB60=
Date:   Thu, 25 Feb 2021 17:20:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, deller@gmx.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 083/118] proc/wchan: use printk format instead of
 lookup_symbol_name()
Message-ID: <20210226012045.H_Iz_JaD3%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Helge Deller <deller@gmx.de>
Subject: proc/wchan: use printk format instead of lookup_symbol_name()

To resolve the symbol fuction name for wchan, use the printk format
specifier %ps instead of manually looking up the symbol function name
via lookup_symbol_name().

Link: https://lkml.kernel.org/r/20201217165413.GA1959@ls3530.fritz.box
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/fs/proc/base.c~proc-wchan-use-printk-format-instead-of-lookup_symbol_name
+++ a/fs/proc/base.c
@@ -67,7 +67,6 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/rcupdate.h>
-#include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 #include <linux/resource.h>
 #include <linux/module.h>
@@ -386,19 +385,17 @@ static int proc_pid_wchan(struct seq_fil
 			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
-	char symname[KSYM_NAME_LEN];
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
-		goto print0;
+	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		wchan = get_wchan(task);
+	else
+		wchan = 0;
+
+	if (wchan)
+		seq_printf(m, "%ps", (void *) wchan);
+	else
+		seq_putc(m, '0');
 
-	wchan = get_wchan(task);
-	if (wchan && !lookup_symbol_name(wchan, symname)) {
-		seq_puts(m, symname);
-		return 0;
-	}
-
-print0:
-	seq_putc(m, '0');
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
_
