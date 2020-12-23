Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9F6C43332
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663D320705
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 03:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgLWDFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 22:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgLWCTN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D639B22248;
        Wed, 23 Dec 2020 02:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608689913;
        bh=qg3j03cVLtTOYYZXzN2t+163ofvwHmkA+jOMpZIYP9g=;
        h=Date:From:To:Subject:From;
        b=oRNRWnlTyx0U7rahZfhwHayTMo9s+bY0RfDy21BxQ/i1CvO7LMWIz4S+Vpi5Y7F0l
         YWHbgfllYn0YrvlySHCE3wELLha6g+Xr3banBcGYKdl5pRvsThtgaYr8jscJcuPrxE
         O+CSt9MBvCr+eie194HEoBRJHL66v/DoBqYgaGVw=
Date:   Tue, 22 Dec 2020 18:18:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, deller@gmx.de
Subject:  +
 proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch added to -mm
 tree
Message-ID: <20201223021832.A9AW7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/wchan: use printk format instead of lookup_symbol_name()
has been added to the -mm tree.  Its filename is
     proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

proc-wchan-use-printk-format-instead-of-lookup_symbol_name.patch

