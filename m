From: akpm@linux-foundation.org
Subject: + do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:31:30 -0700
Message-ID: <200907172331.n6HNVULG010229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbZGQXcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, valdis.kletnieks@vt.edu, vmayatsk@redhat.com


The patch titled
     selinux_bprm_committed_creds: use __wake_up_parent()
has been added to the -mm tree.  Its filename is
     do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: selinux_bprm_committed_creds: use __wake_up_parent()
From: Oleg Nesterov <oleg@redhat.com>

(depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
 which exports __wake_up_parent)

Spotted by Valdis.Kletnieks@vt.edu.

selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
that __wake_up_parent() is exported change the code to use this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent security/selinux/hooks.c
--- a/security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent
+++ a/security/selinux/hooks.c
@@ -2404,7 +2404,7 @@ static void selinux_bprm_committed_creds
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
 	read_lock(&tasklist_lock);
-	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	__wake_up_parent(current, current->real_parent);
 	read_unlock(&tasklist_lock);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

