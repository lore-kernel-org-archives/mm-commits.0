From: akpm@linux-foundation.org
Subject: + use-write_trylock_irqsave-in-ptrace_attach.patch added to -mm tree
Date: Wed, 09 May 2007 18:50:18 -0700
Message-ID: <200705100150.l4A1oIYZ009314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbXEJBu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 21:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sripathik@in.ibm.com


The patch titled
     From: Sripathi Kodi <sripathik@in.ibm.com>
has been added to the -mm tree.  Its filename is
     use-write_trylock_irqsave-in-ptrace_attach.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Sripathi Kodi <sripathik@in.ibm.com>


Hi,

This patch makes ptrace_attach use write_trylock_irqsave.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

---

Index: linux-2.6.21/kernel/ptrace.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/ptrace.c~use-write_trylock_irqsave-in-ptrace_attach kernel/ptrace.c
--- a/kernel/ptrace.c~use-write_trylock_irqsave-in-ptrace_attach
+++ a/kernel/ptrace.c
@@ -160,6 +160,7 @@ int ptrace_may_attach(struct task_struct
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
+	unsigned long flags = 0;
 
 	retval = -EPERM;
 	if (task->pid <= 1)
@@ -178,9 +179,7 @@ repeat:
 	 * cpu's that may have task_lock).
 	 */
 	task_lock(task);
-	local_irq_disable();
-	if (!write_trylock(&tasklist_lock)) {
-		local_irq_enable();
+	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
 		task_unlock(task);
 		do {
 			cpu_relax();
@@ -208,7 +207,7 @@ repeat:
 	force_sig_specific(SIGSTOP, task);
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
 out:
 	return retval;
_

Patches currently in -mm which might be from sripathik@in.ibm.com are

introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
