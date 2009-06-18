From: akpm@linux-foundation.org
Subject: [merged] shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:54 -0700
Message-ID: <200906182246.n5IMksMC005990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759237AbZFRWrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     shift "ptrace implies WUNTRACED" from ptrace_do_wait() to wait_task_stopped()
has been removed from the -mm tree.  Its filename was
     shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shift "ptrace implies WUNTRACED" from ptrace_do_wait() to wait_task_stopped()
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for the next patch.

ptrace_do_wait() adds WUNTRACED to options for wait_task_stopped() which
should always accept the stopped tracee, even if do_wait() was called
without WUNTRACED.

Change wait_task_stopped() to check "ptrace || WUNTRACED" instead.  This
makes the code more explicit, and "int options" argument becomes const in
do_wait() pathes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped kernel/exit.c
--- a/kernel/exit.c~shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped
+++ a/kernel/exit.c
@@ -1330,7 +1330,10 @@ static int wait_task_stopped(int ptrace,
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!(options & WUNTRACED))
+	/*
+	 * Traditionally we see ptrace'd stopped tasks regardless of options.
+	 */
+	if (!ptrace && !(options & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1548,11 +1551,6 @@ static int ptrace_do_wait(struct task_st
 {
 	struct task_struct *p;
 
-	/*
-	 * Traditionally we see ptrace'd stopped tasks regardless of options.
-	 */
-	options |= WUNTRACED;
