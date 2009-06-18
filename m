From: akpm@linux-foundation.org
Subject: [merged] ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:30 -0700
Message-ID: <200906182246.n5IMkU01005586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758255AbZFRW57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: tracehook_unsafe_exec(): remove the stale comment
has been removed from the -mm tree.  Its filename was
     ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: tracehook_unsafe_exec(): remove the stale comment
From: Oleg Nesterov <oleg@redhat.com>

tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment
+++ a/include/linux/tracehook.h
@@ -143,7 +143,7 @@ static inline void tracehook_report_sysc
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
  *
- * Called with task_lock() held on @task.
+ * task->cred_guard_mutex is held by the caller through the do_execve().
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

