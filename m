Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3B5C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66CE964F38
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhB0Ccp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhB0Cch (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7064D64F41;
        Sat, 27 Feb 2021 02:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393100;
        bh=sGMgzhg02oGbnirXLNNwXvwBGCGRK7xdlYiSTIwOVT8=;
        h=Date:From:To:Subject:From;
        b=MrrmKVe8OrOI03tFTt0+PWzwV+5Ts66g4fLS3dZF2Bpv4L8QLXri7eJk5EVWw3NCE
         WRFvw3rD6sA0hIAVrzSemwUoYralGsTmSU87JAUAMxry8SC1dVbtFd7uGtbyGw8C75
         ZSJh/iulYrSPN0YkAO5YCtfwuf91I9Rv8/3q02x0=
Date:   Fri, 26 Feb 2021 18:31:40 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, deller@gmx.de, mm-commits@vger.kernel.org
Subject:  [merged]
 proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch removed
 from -mm tree
Message-ID: <20210227023140.z77eA67g3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/wchan: use printk format instead of lookup_symbol_name()
has been removed from the -mm tree.  Its filename was
     proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from deller@gmx.de are


