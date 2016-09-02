From: akpm@linux-foundation.org
Subject: [merged]
 kernel-fork-fix-clone_child_cleartid-regression-in-nscd.patch removed from
 -mm tree
Date: Fri, 02 Sep 2016 12:01:16 -0700
Message-ID: <57c9cc7c.D3IA3LsXa+q4ZrEB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33019 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755124AbcIBTBR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, roland@hack.frob.com, schwab@suse.com, wpreston@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: fix CLONE_CHILD_CLEARTID regression in nscd
has been removed from the -mm tree.  Its filename was
     kernel-fork-fix-clone_child_cleartid-regression-in-nscd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: kernel/fork: fix CLONE_CHILD_CLEARTID regression in nscd

fec1d0115240 ("[PATCH] Disable CLONE_CHILD_CLEARTID for abnormal exit")
has caused a subtle regression in nscd which uses CLONE_CHILD_CLEARTID to
clear the nscd_certainly_running flag in the shared databases, so that the
clients are notified when nscd is restarted.  Now, when nscd uses a
non-persistent database, clients that have it mapped keep thinking the
database is being updated by nscd, when in fact nscd has created a new
(anonymous) one (for non-persistent databases it uses an unlinked file as
backend).

The original proposal for the CLONE_CHILD_CLEARTID change claimed
(https://lkml.org/lkml/2006/10/25/233):

: The NPTL library uses the CLONE_CHILD_CLEARTID flag on clone() syscalls
: on behalf of pthread_create() library calls.  This feature is used to
: request that the kernel clear the thread-id in user space (at an address
: provided in the syscall) when the thread disassociates itself from the
: address space, which is done in mm_release().
: 
: Unfortunately, when a multi-threaded process incurs a core dump (such as
: from a SIGSEGV), the core-dumping thread sends SIGKILL signals to all of
: the other threads, which then proceed to clear their user-space tids
: before synchronizing in exit_mm() with the start of core dumping.  This
: misrepresents the state of process's address space at the time of the
: SIGSEGV and makes it more difficult for someone to debug NPTL and glibc
: problems (misleading him/her to conclude that the threads had gone away
: before the fault).
: 
: The fix below is to simply avoid the CLONE_CHILD_CLEARTID action if a
: core dump has been initiated.

The resulting patch from Roland (https://lkml.org/lkml/2006/10/26/269)
seems to have a larger scope than the original patch asked for. It seems
that limitting the scope of the check to core dumping should work for
SIGSEGV issue describe above.

[Changelog partly based on Andreas' description]
Fixes: fec1d0115240 ("[PATCH] Disable CLONE_CHILD_CLEARTID for abnormal exit")
Link: http://lkml.kernel.org/r/1471968749-26173-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Tested-by: William Preston <wpreston@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Andreas Schwab <schwab@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~kernel-fork-fix-clone_child_cleartid-regression-in-nscd kernel/fork.c
--- a/kernel/fork.c~kernel-fork-fix-clone_child_cleartid-regression-in-nscd
+++ a/kernel/fork.c
@@ -913,14 +913,12 @@ void mm_release(struct task_struct *tsk,
 	deactivate_mm(tsk, mm);
 
 	/*
-	 * If we're exiting normally, clear a user-space tid field if
-	 * requested.  We leave this alone when dying by signal, to leave
-	 * the value intact in a core dump, and to save the unnecessary
-	 * trouble, say, a killed vfork parent shouldn't touch this mm.
-	 * Userland only wants this done for a sys_exit.
+	 * Signal userspace if we're not exiting with a core dump
+	 * because we want to leave the value intact for debugging
+	 * purposes.
 	 */
 	if (tsk->clear_child_tid) {
-		if (!(tsk->flags & PF_SIGNALED) &&
+		if (!(tsk->signal->flags & SIGNAL_GROUP_COREDUMP) &&
 		    atomic_read(&mm->mm_users) > 1) {
 			/*
 			 * We don't check the error code - if userspace has
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-get-rid-of-throttle_vm_writeout.patch
oom-keep-mm-of-the-killed-task-available.patch
kernel-oom-fix-potential-pgd_lock-deadlock-from-__mmdrop.patch
mm-oom-get-rid-of-signal_struct-oom_victims.patch
oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly.patch
mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch
oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads.patch
oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled.patch

