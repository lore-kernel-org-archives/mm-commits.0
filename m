From: akpm@linux-foundation.org
Subject: [merged] ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:54 -0800
Message-ID: <200912162037.nBGKbsMn013383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964833AbZLPUiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: cleanup ptrace_init_task()->ptrace_link() path
has been removed from the -mm tree.  Its filename was
     ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: cleanup ptrace_init_task()->ptrace_link() path
From: Oleg Nesterov <oleg@redhat.com>

No functional changes.

ptrace_init_task() looks confusing, as if we always auto-attach when "bool
ptrace" argument is true, while in fact we attach only if current is
traced.

Make the code more explicit and kill now unused ptrace_link().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-cleanup-ptrace_init_task-ptrace_link-path include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-cleanup-ptrace_init_task-ptrace_link-path
+++ a/include/linux/ptrace.h
@@ -105,12 +105,7 @@ static inline int ptrace_reparented(stru
 {
 	return child->real_parent != child->parent;
 }
-static inline void ptrace_link(struct task_struct *child,
-			       struct task_struct *new_parent)
-{
-	if (unlikely(child->ptrace))
-		__ptrace_link(child, new_parent);
-}
+
 static inline void ptrace_unlink(struct task_struct *child)
 {
 	if (unlikely(child->ptrace))
@@ -169,9 +164,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptraced);
 	child->parent = child->real_parent;
 	child->ptrace = 0;
-	if (unlikely(ptrace)) {
+	if (unlikely(ptrace) && (current->ptrace & PT_PTRACED)) {
 		child->ptrace = current->ptrace;
-		ptrace_link(child, current->parent);
+		__ptrace_link(child, current->parent);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

