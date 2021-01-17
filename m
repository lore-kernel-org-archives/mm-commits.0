Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD26C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6532B224B8
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbhAQVna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQVna (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:43:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40EC2224B8;
        Sun, 17 Jan 2021 21:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919769;
        bh=B29Vp1TtjJqO1HOLM3llWW0gEulI64II+TQOArAwbds=;
        h=Date:From:To:Subject:From;
        b=PlpCQ+LXPeeUuHty476enxTMxmTuIYclN60wGlxG+1GFd/2FW2jPK0JcfpIT/TFlH
         QfW4vOtv9mMwwZaIO1LLLD6nRoDVQYb2xJO3y7W0RxdSHjAWYAudVqZsCTaO1QXOaL
         /NSUJEoJaqGJX5q4xeJpWdyV+Xtz9vIHVqvuSJEY=
Date:   Sun, 17 Jan 2021 13:42:47 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, avagin@gmail.com, bernd.edlinger@hotmail.de,
        christian.brauner@ubuntu.com, ckennelly@google.com,
        ebiederm@xmission.com, figiel@google.com, gladkov.alexey@gmail.com,
        keescook@chromium.org, mathieu.desnoyers@efficios.com,
        mm-commits@vger.kernel.org, pjt@google.com, posk@google.com,
        walken@google.com
Subject:  [to-be-updated] fs-proc-expose-rseq-configuration.patch
 removed from -mm tree
Message-ID: <20210117214247.qmdxVsqY-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: expose RSEQ configuration
has been removed from the -mm tree.  Its filename was
     fs-proc-expose-rseq-configuration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Piotr Figiel <figiel@google.com>
Subject: fs/proc: expose RSEQ configuration

For userspace checkpoint and restore (C/R) some way of getting process
state containing RSEQ configuration is needed.

There are two ways this information is going to be used:
 - to re-enable RSEQ for threads which had it enabled before C/R
 - to detect if a thread was in a critical section during C/R

Since C/R preserves TLS memory and addresses RSEQ ABI will be restored
using the address registered before C/R.

Detection whether the thread is in a critical section during C/R is needed
to enforce behavior of RSEQ abort during C/R.  Attaching with ptrace()
before registers are dumped itself doesn't cause RSEQ abort.  Restoring
the instruction pointer within the critical section is problematic because
rseq_cs may get cleared before the control is passed to the migrated
application code leading to RSEQ invariants not being preserved.

Link: https://lkml.kernel.org/r/20210113174127.2500051-1-figiel@google.com
Signed-off-by: Piotr Figiel <figiel@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Oskolkov <posk@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/proc/base.c~fs-proc-expose-rseq-configuration
+++ a/fs/proc/base.c
@@ -659,6 +659,20 @@ static int proc_pid_syscall(struct seq_f
 
 	return 0;
 }
+
+#ifdef CONFIG_RSEQ
+static int proc_pid_rseq(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	int res = lock_trace(task);
+
+	if (res)
+		return res;
+	seq_printf(m, "0x%llx 0x%x\n", (uint64_t)task->rseq, task->rseq_sig);
+	unlock_trace(task);
+	return 0;
+}
+#endif /* CONFIG_RSEQ */
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
 /************************************************************************/
@@ -3179,6 +3193,9 @@ static const struct pid_entry tgid_base_
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
+#ifdef CONFIG_RSEQ
+	ONE("rseq",       S_IRUSR, proc_pid_rseq),
+#endif
 #endif
 	REG("cmdline",    S_IRUGO, proc_pid_cmdline_ops),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -3519,6 +3536,9 @@ static const struct pid_entry tid_base_s
 			 &proc_pid_set_comm_operations, {}),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
+#ifdef CONFIG_RSEQ
+	ONE("rseq",      S_IRUSR, proc_pid_rseq),
+#endif
 #endif
 	REG("cmdline",   S_IRUGO, proc_pid_cmdline_ops),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
_

Patches currently in -mm which might be from figiel@google.com are


