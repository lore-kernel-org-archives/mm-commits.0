From: akpm@osdl.org
Subject: + restore-pdeath_signal-behaviour.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:58:49 -0800
Message-ID: <200612270758.kBR7wnLj004966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38099 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986AbWL0H7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com


The patch titled
     restore ->pdeath_signal behaviour
has been added to the -mm tree.  Its filename is
     restore-pdeath_signal-behaviour.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: restore ->pdeath_signal behaviour
From: Oleg Nesterov <oleg@tv-sign.ru>

Commit b2b2cbc4b2a2f389442549399a993a8306420baf introduced a user-visible
change: ->pdeath_signal is sent only when the entire thread group exits.

While this change is imho good, it may break things. Restore an old behaviour
for now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~restore-pdeath_signal-behaviour kernel/exit.c
--- a/kernel/exit.c~restore-pdeath_signal-behaviour
+++ a/kernel/exit.c
@@ -597,6 +597,10 @@ choose_new_parent(struct task_struct *p,
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
 	/* Move the child from its dying parent to the new one.  */
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
@@ -631,10 +635,6 @@ reparent_thread(struct task_struct *p, s
 	/* We don't want people slaying init.  */
 	if (p->exit_signal != -1)
 		p->exit_signal = SIGCHLD;
-		
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

restore-pdeath_signal-behaviour.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch

