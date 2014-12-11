From: akpm@linux-foundation.org
Subject: [merged] exit-reparent-cleanup-the-changing-of-parent.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:20 -0800
Message-ID: <5489e94c.EMMWHVKZanLU1zrx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaLKS6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: cleanup the changing of ->parent
has been removed from the -mm tree.  Its filename was
     exit-reparent-cleanup-the-changing-of-parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: cleanup the changing of ->parent

1. Cosmetic, but "if (t->parent == father)" looks a bit confusing.
   We need to change t->parent if and only if t is not traced.

2. If we actually want this BUG_ON() to ensure that parent/ptrace
   match each other, then we should also take ptrace_reparented()
   case into account too.

3. Change this code to use for_each_thread() instead of deprecated
   while_each_thread().

[dan.carpenter@oracle.com: silence a bogus static checker warning]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent kernel/exit.c
--- a/kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent
+++ a/kernel/exit.c
@@ -557,7 +557,7 @@ static void reparent_leader(struct task_
 
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper;
+	struct task_struct *p, *t, *n, *reaper;
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
@@ -569,18 +569,15 @@ static void forget_original_parent(struc
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		struct task_struct *t = p;
-
-		do {
+		for_each_thread(p, t) {
 			t->real_parent = reaper;
-			if (t->parent == father) {
-				BUG_ON(t->ptrace);
+			BUG_ON((!t->ptrace) != (t->parent == father));
+			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
-			}
 			if (t->pdeath_signal)
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
-		} while_each_thread(p, t);
+		}
 		reparent_leader(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
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

