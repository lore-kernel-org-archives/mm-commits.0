From: akpm@linux-foundation.org
Subject: +
 exec-move-the-final-allow_write_access-fput-into-free_bprm.patch added to
 -mm tree
Date: Fri, 22 Nov 2013 14:49:30 -0800
Message-ID: <528fdf7a.nEXKi1mM0aqCalYs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KVWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + exec-move-the-final-allow_write_access-fput-into-free_bprm.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:49:30 -0800


The patch titled
     Subject: exec: move the final allow_write_access/fput into free_bprm()
has been added to the -mm tree.  Its filename is
     exec-move-the-final-allow_write_access-fput-into-free_bprm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-move-the-final-allow_write_access-fput-into-free_bprm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: move the final allow_write_access/fput into free_bprm()

Both success/failure paths cleanup bprm->file, we can move this
code into free_bprm() to simlify and cleanup this logic.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN fs/exec.c~exec-move-the-final-allow_write_access-fput-into-free_bprm fs/exec.c
--- a/fs/exec.c~exec-move-the-final-allow_write_access-fput-into-free_bprm
+++ a/fs/exec.c
@@ -1138,9 +1138,7 @@ void setup_new_exec(struct linux_binprm
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-
 	current->self_exec_id++;
-			
 	flush_signal_handlers(current, 0);
 	do_close_on_exec(current->files);
 }
@@ -1172,6 +1170,10 @@ void free_bprm(struct linux_binprm *bprm
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	if (bprm->file) {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+	}
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
@@ -1424,12 +1426,6 @@ static int exec_binprm(struct linux_binp
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
 		proc_exec_connector(current);
-
-		if (bprm->file) {
-			allow_write_access(bprm->file);
-			fput(bprm->file);
-			bprm->file = NULL; /* to catch use-after-free */
-		}
 	}
 
 	return ret;
@@ -1492,7 +1488,7 @@ static int do_execve_common(const char *
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
-		goto out_file;
+		goto out_unmark;
 
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
@@ -1539,12 +1535,6 @@ out:
 		mmput(bprm->mm);
 	}
 
-out_file:
-	if (bprm->file) {
-		allow_write_access(bprm->file);
-		fput(bprm->file);
-	}
-
 out_unmark:
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
linux-next.patch

