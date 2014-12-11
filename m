From: akpm@linux-foundation.org
Subject: [merged] exit-wait-dont-use-zombie-real_parent.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:11 -0800
Message-ID: <5489eb9b.DTDmnImaupNfdiHz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaLKTIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: wait: don't use zombie->real_parent
has been removed from the -mm tree.  Its filename was
     exit-wait-dont-use-zombie-real_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: wait: don't use zombie->real_parent

1. wait_task_zombie() uses p->real_parent to get psig/siglock. This is
   correct but needs tasklist_lock, ->real_parent can exit.

   We can use "current" instead. This is our natural child, its parent
   must be our sub-thread.

2. Read psig/sig outside of ->siglock, ->signal is no longer protected
   by this lock.

3. Fix the outdated comments about tasklist_lock. We can not race with
   __exit_signal(), the whole thread group is dead, nobody but us can
   call it.

   Also clarify the usage of ->stats_lock and ->siglock.

Note: thread_group_cputime_adjusted() is sub-optimal in this case, we
probably want to export cputime_adjust() to avoid thread_group_cputime(). 
The comment says "all threads" but there are no other threads.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~exit-wait-dont-use-zombie-real_parent kernel/exit.c
--- a/kernel/exit.c~exit-wait-dont-use-zombie-real_parent
+++ a/kernel/exit.c
@@ -1010,8 +1010,8 @@ static int wait_task_zombie(struct wait_
 	 * Check thread_group_leader() to exclude the traced sub-threads.
 	 */
 	if (state == EXIT_DEAD && thread_group_leader(p)) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
+		struct signal_struct *sig = p->signal;
+		struct signal_struct *psig = current->signal;
 		unsigned long maxrss;
 		cputime_t tgutime, tgstime;
 
@@ -1023,21 +1023,20 @@ static int wait_task_zombie(struct wait_
 		 * accumulate in the parent's signal_struct c* fields.
 		 *
 		 * We don't bother to take a lock here to protect these
-		 * p->signal fields, because they are only touched by
-		 * __exit_signal, which runs with tasklist_lock
-		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
+		 * p->signal fields because the whole thread group is dead
+		 * and nobody can change them.
+		 *
+		 * psig->stats_lock also protects us from our sub-theads
+		 * which can reap other children at the same time. Until
+		 * we change k_getrusage()-like users to rely on this lock
+		 * we have to take ->siglock as well.
 		 *
 		 * We use thread_group_cputime_adjusted() to get times for
 		 * the thread group, which consolidates times for all threads
 		 * in the group including the group leader.
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
-		spin_lock_irq(&p->real_parent->sighand->siglock);
-		psig = p->real_parent->signal;
-		sig = p->signal;
+		spin_lock_irq(&current->sighand->siglock);
 		write_seqlock(&psig->stats_lock);
 		psig->cutime += tgutime + sig->cutime;
 		psig->cstime += tgstime + sig->cstime;
@@ -1062,7 +1061,7 @@ static int wait_task_zombie(struct wait_
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		write_sequnlock(&psig->stats_lock);
-		spin_unlock_irq(&p->real_parent->sighand->siglock);
+		spin_unlock_irq(&current->sighand->siglock);
 	}
 
 	/*
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

