From: akpm@linux-foundation.org
Subject: [merged]
 exit-exit_notify-re-use-dead-list-to-autoreap-current.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:08:45 -0800
Message-ID: <5489ebbd.B84PaLfqJTRMtqaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbaLKTIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: exit_notify: re-use "dead" list to autoreap current
has been removed from the -mm tree.  Its filename was
     exit-exit_notify-re-use-dead-list-to-autoreap-current.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: exit_notify: re-use "dead" list to autoreap current

After the previous change we can add just the exiting EXIT_DEAD task to
the "dead" list and remove another release_task(tsk).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~exit-exit_notify-re-use-dead-list-to-autoreap-current kernel/exit.c
--- a/kernel/exit.c~exit-exit_notify-re-use-dead-list-to-autoreap-current
+++ a/kernel/exit.c
@@ -632,6 +632,8 @@ static void exit_notify(struct task_stru
 	}
 
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
+	if (tsk->exit_state == EXIT_DEAD)
+		list_add(&tsk->ptrace_entry, &dead);
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
@@ -642,10 +644,6 @@ static void exit_notify(struct task_stru
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
-
-	/* If the process is dead, release it - nobody will wait for it */
-	if (autoreap)
-		release_task(tsk);
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

