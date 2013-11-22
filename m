From: akpm@linux-foundation.org
Subject: +
 exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 14:49:28 -0800
Message-ID: <528fdf78.60GPrBAsSCaO1ojS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3KVWt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:49:28 -0800


The patch titled
     Subject: exec:check_unsafe_exec: use while_each_thread() rather than next_thread()
has been added to the -mm tree.  Its filename is
     exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch

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
Subject: exec:check_unsafe_exec: use while_each_thread() rather than next_thread()

next_thread() should be avoided, change check_unsafe_exec() to use
while_each_thread().

Nobody except signal->curr_target actually needs next_thread-like code,
and we need to change (fix) this interface.  This particular code is fine,
p == current.  But in general the code like this can loop forever if p
exits and next_thread(t) can't reach the unhashed thread.

This also saves 32 bytes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread fs/exec.c
--- a/fs/exec.c~exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread
+++ a/fs/exec.c
@@ -1243,10 +1243,11 @@ static int check_unsafe_exec(struct linu
 	if (current->no_new_privs)
 		bprm->unsafe |= LSM_UNSAFE_NO_NEW_PRIVS;
 
+	t = p;
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
 	rcu_read_lock();
-	for (t = next_thread(p); t != p; t = next_thread(t)) {
+	while_each_thread(p, t) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
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

