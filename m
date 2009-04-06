From: akpm@linux-foundation.org
Subject: [merged] reparent_thread-fix-the-is-it-traced-check.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:44 -0700
Message-ID: <200904061935.n36JZiDG012145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092AbZDFTjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     reparent_thread: fix the "is it traced" check
has been removed from the -mm tree.  Its filename was
     reparent_thread-fix-the-is-it-traced-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reparent_thread: fix the "is it traced" check
From: Oleg Nesterov <oleg@redhat.com>

reparent_thread() uses ptrace_reparented() to check whether this thread is
ptraced, in that case we should not notify the new parent.

But ptrace_reparented() is not exactly correct when the reparented thread
is traced by /sbin/init, because forget_original_parent() has already
changed ->real_parent.

Currently, the only problem is the false notification.  But with the next
patch the kernel crash in this (yes, pathological) case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~reparent_thread-fix-the-is-it-traced-check kernel/exit.c
--- a/kernel/exit.c~reparent_thread-fix-the-is-it-traced-check
+++ a/kernel/exit.c
@@ -832,7 +832,7 @@ static void reparent_thread(struct task_
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!ptrace_reparented(p) &&
+	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

