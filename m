Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A37EB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjGGTNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjGGTNS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28FF124
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FA7461A1D
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9383CC433C8;
        Fri,  7 Jul 2023 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688757196;
        bh=qTiBm6DrwbhHnEYR0JkC0pnxbdb+cLP76MoUzBb8iv0=;
        h=Date:To:From:Subject:From;
        b=tt4ay38hLEqRwt/UmaIaw+baE9fMMYY8cPL8BmWiQKHGeJ1ylJiAig11VaXJPjuN6
         CuDDc0di1jo+x4Y95bqMfG0WlnSmAeaW/ghjOXS+6wM8Je2GG44DFswa/2vdZtY8A3
         LcRhv26YhfdmIRgH9rUj1rz2PxyxU5EbKSr8A1gg=
Date:   Fri, 07 Jul 2023 12:13:15 -0700
To:     mm-commits@vger.kernel.org, vgupta@kernel.org, tj@kernel.org,
        mingo@kernel.org, vincent.whitchurch@axis.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-print-comm-and-exe-name-on-fatal-signals.patch added to mm-nonmm-unstable branch
Message-Id: <20230707191316.9383CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: signal: print comm and exe name on fatal signals
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-print-comm-and-exe-name-on-fatal-signals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-print-comm-and-exe-name-on-fatal-signals.patch

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
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: signal: print comm and exe name on fatal signals
Date: Fri, 7 Jul 2023 11:29:36 +0200

Make the print-fatal-signals message more useful by printing the comm
and the exe name for the process which received the fatal signal:

Before:

 potentially unexpected fatal signal 4
 potentially unexpected fatal signal 11

After:

 buggy-program: pool: potentially unexpected fatal signal 4
 some-daemon: gdbus: potentially unexpected fatal signal 11

comm used to be present but was removed in commit 681a90ffe829b8ee25d
("arc, print-fatal-signals: reduce duplicated information") because it's
also included as part of the later stack trace.  Having the comm as part
of the main "unexpected fatal..." print is rather useful though when
analysing logs, and the exe name is also valuable as shown in the
examples above where the comm ends up having some generic name like
"pool".

Link: https://lkml.kernel.org/r/20230707-fatal-comm-v1-1-400363905d5e@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/signal.c~signal-print-comm-and-exe-name-on-fatal-signals
+++ a/kernel/signal.c
@@ -22,8 +22,10 @@
 #include <linux/sched/cputime.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/tty.h>
+#include <linux/file.h>
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
 #include <linux/security.h>
@@ -1256,7 +1258,17 @@ int send_signal_locked(int sig, struct k
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = task_pt_regs(current);
-	pr_info("potentially unexpected fatal signal %d.\n", signr);
+	struct file *exe_file;
+
+	exe_file = get_task_exe_file(current);
+	if (exe_file) {
+		pr_info("%pD: %s: potentially unexpected fatal signal %d.\n",
+			exe_file, current->comm, signr);
+		fput(exe_file);
+	} else {
+		pr_info("%s: potentially unexpected fatal signal %d.\n",
+			current->comm, signr);
+	}
 
 #if defined(__i386__) && !defined(__arch_um__)
 	pr_info("code at %08lx: ", regs->ip);
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

squashfs-fix-cache-race-with-migration.patch
signal-print-comm-and-exe-name-on-fatal-signals.patch

