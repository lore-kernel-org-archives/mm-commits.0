From: akpm@linux-foundation.org
Subject: +
 fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch added to
 -mm tree
Date: Fri, 22 Nov 2013 14:52:57 -0800
Message-ID: <528fe049.KZe+CILHiSKLIiUT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KVWw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:52:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, snanda@chromium.org, kosaki.motohiro@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com

Subject: + fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,kosaki.motohiro@jp.fujitsu.com,snanda@chromium.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:52:57 -0800


The patch titled
     Subject: fs/proc/array.c: change do_task_stat() to use while_each_thread()
has been added to the -mm tree.  Its filename is
     fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch

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
Subject: fs/proc/array.c: change do_task_stat() to use while_each_thread()

Change the remaining next_thread (ab)users to use while_each_thread().

The last user which should be changed is next_tid(), but we can't do this
now.

__exit_signal() and complete_signal() are fine, they actually need
next_thread() logic.


This patch (of 3):

do_task_stat() can use while_each_thread(), no changes in
the compiled code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/array.c~fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread
+++ a/fs/proc/array.c
@@ -444,8 +444,7 @@ static int do_task_stat(struct seq_file
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-				t = next_thread(t);
-			} while (t != task);
+			} while_each_thread(task, t);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
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
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

