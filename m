From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch added to -mm tree
Date: Fri, 30 Oct 2009 15:51:12 -0700
Message-ID: <200910302251.n9UMpCiq002109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbZJ3Wvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 18:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: cleanup ptrace_init_task()->ptrace_link() path
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch

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
linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
utrace-core.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch

