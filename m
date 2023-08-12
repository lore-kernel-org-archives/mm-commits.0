Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AD0C41513
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjHLWFQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjHLWFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9E9173D
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7093560F60
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C529EC433C9;
        Sat, 12 Aug 2023 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877916;
        bh=PK/vK35Dd05VBiIRi/mM80AQG1NQvv+Nhw7mLLbxWS8=;
        h=Date:To:From:Subject:From;
        b=DFRlRJkNLYpGEln6j+S5qoOUvV6ASmsVTY8XWa+R4ceA0oqVO0f2C2fdJRGQKmfTv
         96CO43iLYGL02lqJhKvFmtAwqGaHEeu9l9DU3wOZQZZuVI1CAddiqJh8kWrptuk8zw
         aILdTdk92qRhqu4DbKXkb+S/3bvu2cp3pjAcqd0w=
Date:   Sat, 12 Aug 2023 15:05:16 -0700
To:     mm-commits@vger.kernel.org, vgupta@kernel.org, tj@kernel.org,
        mingo@kernel.org, vincent.whitchurch@axis.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] signal-print-comm-and-exe-name-on-fatal-signals.patch removed from -mm tree
Message-Id: <20230812220516.C529EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: signal: print comm and exe name on fatal signals
has been removed from the -mm tree.  Its filename was
     signal-print-comm-and-exe-name-on-fatal-signals.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: don't include linux/file.h twice]
Link: https://lkml.kernel.org/r/20230707-fatal-comm-v1-1-400363905d5e@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/signal.c~signal-print-comm-and-exe-name-on-fatal-signals
+++ a/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
@@ -1260,7 +1261,17 @@ int send_signal_locked(int sig, struct k
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


