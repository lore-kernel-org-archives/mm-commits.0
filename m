From: akpm@linux-foundation.org
Subject: [merged] exit-reparent-introduce-find_alive_thread.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:08:37 -0800
Message-ID: <5489ebb5.OXUSW5Jfes/Y1SMK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLKTIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: introduce find_alive_thread()
has been removed from the -mm tree.  Its filename was
     exit-reparent-introduce-find_alive_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: introduce find_alive_thread()

Add the new simple helper to factor out the for_each_thread() code in
find_child_reaper() and find_new_reaper().  It can also simplify the
potential PF_EXITING -> exit_state change, plus perhaps we can change this
code to take SIGNAL_GROUP_EXIT into account.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~exit-reparent-introduce-find_alive_thread kernel/exit.c
--- a/kernel/exit.c~exit-reparent-introduce-find_alive_thread
+++ a/kernel/exit.c
@@ -459,6 +459,17 @@ static void exit_mm(struct task_struct *
 	clear_thread_flag(TIF_MEMDIE);
 }
 
+static struct task_struct *find_alive_thread(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		if (!(t->flags & PF_EXITING))
+			return t;
+	}
+	return NULL;
+}
+
 static struct task_struct *find_child_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
 	__acquires(&tasklist_lock)
@@ -469,9 +480,8 @@ static struct task_struct *find_child_re
 	if (likely(reaper != father))
 		return reaper;
 
-	for_each_thread(father, reaper) {
-		if (reaper->flags & PF_EXITING)
-			continue;
+	reaper = find_alive_thread(father);
+	if (reaper) {
 		pid_ns->child_reaper = reaper;
 		return reaper;
 	}
@@ -497,16 +507,13 @@ static struct task_struct *find_child_re
 static struct task_struct *find_new_reaper(struct task_struct *father,
 					   struct task_struct *child_reaper)
 {
-	struct task_struct *thread;
+	struct task_struct *thread, *reaper;
 
-	for_each_thread(father, thread) {
-		if (thread->flags & PF_EXITING)
-			continue;
+	thread = find_alive_thread(father);
+	if (thread)
 		return thread;
-	}
 
 	if (father->signal->has_child_subreaper) {
-		struct task_struct *reaper;
 		/*
 		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
 		 * We start from father to ensure we can not look into another
@@ -520,10 +527,9 @@ static struct task_struct *find_new_reap
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			for_each_thread(reaper, thread) {
-				if (!(thread->flags & PF_EXITING))
-					return thread;
-			}
+			thread = find_alive_thread(reaper);
+			if (thread)
+				return thread;
 		}
 	}
 
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

