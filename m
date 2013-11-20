From: akpm@linux-foundation.org
Subject: + proc-fix-the-potential-use-after-free-in-first_tid.patch added
 to -mm tree
Date: Wed, 20 Nov 2013 14:53:07 -0800
Message-ID: <528d3d53.qTEsLN2cpORBh6RE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KTWxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:53:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snanda@chromium.org, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + proc-fix-the-potential-use-after-free-in-first_tid.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,snanda@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:53:07 -0800


The patch titled
     Subject: proc: fix the potential use-after-free in first_tid()
has been added to the -mm tree.  Its filename is
     proc-fix-the-potential-use-after-free-in-first_tid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-the-potential-use-after-free-in-first_tid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-the-potential-use-after-free-in-first_tid.patch

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
Subject: proc: fix the potential use-after-free in first_tid()

proc_task_readdir() verifies that the result of get_proc_task() is
pid_alive() and thus its ->group_leader is fine too.  However this is not
necessarily true after rcu_read_unlock(), we need to recheck this again
after first_tid() does rcu_read_lock().  Otherwise
leader->thread_group.next (used by next_thread()) can be invalid if the
rcu grace period expires in between.

The race is subtle and unlikely, but still it is possible afaics.  To
simplify lets ignore the "likely" case when tid != 0, f_version can be
cleared by proc_task_operations->llseek().

Suppose we have a main thread M and its subthread T.  Suppose that f_pos
== 3, iow first_tid() should return T.  Now suppose that the following
happens between rcu_read_unlock() and rcu_read_lock():

	1. T execs and becomes the new leader. This removes M from
	    ->thread_group but next_thread(M) is still T.

	2. T creates another thread X which does exec as well, T
	   goes away.

	3. X creates another subthread, this increments nr_threads.

	4. first_tid() does next_thread(M) and returns the already
	   dead T.

Note also that we need 2.  and 3.  only because of get_nr_threads() check,
and this check was supposed to be optimization only.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/base.c~proc-fix-the-potential-use-after-free-in-first_tid fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-the-potential-use-after-free-in-first_tid
+++ a/fs/proc/base.c
@@ -3103,6 +3103,9 @@ static struct task_struct *first_tid(str
 	pos = NULL;
 	if (nr && nr >= get_nr_threads(leader))
 		goto out;
+	/* It could be unhashed before we take rcu lock */
+	if (!pid_alive(leader))
+		goto out;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
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
linux-next.patch

