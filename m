From: akpm@linux-foundation.org
Subject: - pid-namespaces-rename-child_reaper-function.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:50 -0700
Message-ID: <200710192250.l9JMooBj024124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966792AbXJSXHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: rename child_reaper() function
has been removed from the -mm tree.  Its filename was
     pid-namespaces-rename-child_reaper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: rename child_reaper() function
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Rename the child_reaper() function to task_child_reaper() to be similar to
other task_* functions and to distinguish the function from 'struct
pid_namspace.child_reaper'.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzel <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                     |    2 +-
 include/linux/pid_namespace.h |    2 +-
 kernel/exit.c                 |    4 ++--
 kernel/signal.c               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~pid-namespaces-rename-child_reaper-function fs/exec.c
--- a/fs/exec.c~pid-namespaces-rename-child_reaper-function
+++ a/fs/exec.c
@@ -775,7 +775,7 @@ static int de_thread(struct task_struct 
 	 * Reparenting needs write_lock on tasklist_lock,
 	 * so it is safe to do it under read_lock.
 	 */
-	if (unlikely(tsk->group_leader == child_reaper(tsk)))
+	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
 		task_active_pid_ns(tsk)->child_reaper = tsk;
 
 	zap_other_threads(tsk);
diff -puN include/linux/pid_namespace.h~pid-namespaces-rename-child_reaper-function include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-rename-child_reaper-function
+++ a/include/linux/pid_namespace.h
@@ -44,7 +44,7 @@ static inline struct pid_namespace *task
 	return tsk->nsproxy->pid_ns;
 }
 
-static inline struct task_struct *child_reaper(struct task_struct *tsk)
+static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
 {
 	return init_pid_ns.child_reaper;
 }
diff -puN kernel/exit.c~pid-namespaces-rename-child_reaper-function kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-rename-child_reaper-function
+++ a/kernel/exit.c
@@ -674,7 +674,7 @@ forget_original_parent(struct task_struc
 	do {
 		reaper = next_thread(reaper);
 		if (reaper == father) {
-			reaper = child_reaper(father);
+			reaper = task_child_reaper(father);
 			break;
 		}
 	} while (reaper->exit_state);
@@ -874,7 +874,7 @@ static inline void check_stack_usage(voi
 
 static inline void exit_child_reaper(struct task_struct *tsk)
 {
-	if (likely(tsk->group_leader != child_reaper(tsk)))
+	if (likely(tsk->group_leader != task_child_reaper(tsk)))
 		return;
 
 	panic("Attempted to kill init!");
diff -puN kernel/signal.c~pid-namespaces-rename-child_reaper-function kernel/signal.c
--- a/kernel/signal.c~pid-namespaces-rename-child_reaper-function
+++ a/kernel/signal.c
@@ -1839,7 +1839,7 @@ relock:
 		 * within that pid space. It can of course get signals from
 		 * its parent pid space.
 		 */
-		if (current == child_reaper(current))
+		if (current == task_child_reaper(current))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch
