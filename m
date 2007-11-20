From: akpm@linux-foundation.org
Subject: + wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:08:15 -0800
Message-ID: <200711200008.lAK08FE7003722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbXKTAIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:08:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     wait_task_stopped(): don't use task_pid_nr_ns() lockless
has been added to the -mm tree.  Its filename is
     wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_stopped(): don't use task_pid_nr_ns() lockless
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_stopped(WNOWAIT) does task_pid_nr_ns() without tasklist/rcu lock,
we can read an already freed memory.  Use the cached pid_t value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Looks-good-to: Roland McGrath <roland@redhat.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-dont-use-task_pid_nr_ns-lockless kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-dont-use-task_pid_nr_ns-lockless
+++ a/kernel/exit.c
@@ -1357,7 +1357,7 @@ static int wait_task_stopped(struct task
 			     int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval, exit_code;
-	struct pid_namespace *ns;
+	pid_t pid;
 
 	if (!p->exit_code)
 		return 0;
@@ -1376,12 +1376,11 @@ static int wait_task_stopped(struct task
 	 * keep holding onto the tasklist_lock while we call getrusage and
 	 * possibly take page faults for user memory.
 	 */
-	ns = current->nsproxy->pid_ns;
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
 	if (unlikely(noreap)) {
-		pid_t pid = task_pid_nr_ns(p, ns);
 		uid_t uid = p->uid;
 		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 
@@ -1451,11 +1450,11 @@ bail_ref:
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
-		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
+		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
 	if (!retval)
-		retval = task_pid_nr_ns(p, ns);
+		retval = pid;
 	put_task_struct(p);
 
 	BUG_ON(!retval);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
add-task_wakekill.patch
