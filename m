From: akpm@linux-foundation.org
Subject: [merged] ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:45 -0700
Message-ID: <200906182246.n5IMkj3Y005761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759182AbZFRWra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: don't take tasklist to get/set ->last_siginfo
has been removed from the -mm tree.  Its filename was
     ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: don't take tasklist to get/set ->last_siginfo
From: Oleg Nesterov <oleg@redhat.com>

Change ptrace_getsiginfo/ptrace_setsiginfo to use lock_task_sighand()
without tasklist_lock.  Perhaps it makes sense to make a single helper
with "bool rw" argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/ptrace.c~ptrace-dont-take-tasklist-to-get-set-last_siginfo kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-dont-take-tasklist-to-get-set-last_siginfo
+++ a/kernel/ptrace.c
@@ -424,37 +424,33 @@ static int ptrace_setoptions(struct task
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*info = *child->last_siginfo;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 
 static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*child->last_siginfo = *info;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

