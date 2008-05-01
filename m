From: akpm@linux-foundation.org
Subject: - ptrace-allow-to-ptrace-sbin-init.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:41 -0700
Message-ID: <200805010927.m419Rf1G030439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191AbYEAJ2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ptrace: permit ptracing of /sbin/init
has been removed from the -mm tree.  Its filename was
     ptrace-allow-to-ptrace-sbin-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: permit ptracing of /sbin/init
From: Oleg Nesterov <oleg@tv-sign.ru>

Afaics, currently there are no kernel problems with ptracing init, it can't
lose SIGNAL_UNKILLABLE flag and be killed/stopped by accident.

The ability to strace/debug init can be very useful if you try to figure out
why it does not work as expected.

However, admin should know what he does, "gdb /sbin/init 1" stops init, it
can't reap orphaned zombies or take care of /etc/inittab until continued.  It
is even possible to crash init (and thus the whole system) if you wish,
ptracer has full control.

See also the long discussion: http://marc.info/?t=120628018600001

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN kernel/ptrace.c~ptrace-allow-to-ptrace-sbin-init kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-allow-to-ptrace-sbin-init
+++ a/kernel/ptrace.c
@@ -168,8 +168,6 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (task->pid <= 1)
-		goto out;
 	if (same_thread_group(task, current))
 		goto out;
 
@@ -521,12 +519,6 @@ struct task_struct *ptrace_get_task_stru
 {
 	struct task_struct *child;
 
-	/*
-	 * Tracing init is not allowed.
-	 */
-	if (pid == 1)
-		return ERR_PTR(-EPERM);
