From: akpm@linux-foundation.org
Subject: - ptrace_check_attach-remove-unneeded-signal-=-null-check.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:26 -0800
Message-ID: <200802082013.m18KD73v010263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759618AbYBHU5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, hch@lst.de, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace_check_attach: remove unneeded ->signal != NULL check
has been removed from the -mm tree.  Its filename was
     ptrace_check_attach-remove-unneeded-signal-=-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace_check_attach: remove unneeded ->signal != NULL check
From: Oleg Nesterov <oleg@tv-sign.ru>

It is not possible to see the PT_PTRACED task without ->signal/sighand under
tasklist_lock, release_task() does ptrace_unlink() first.  If the task was
already released before, ptrace_attach() can't succeed and set PT_PTRACED. 
Remove this check.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/ptrace.c~ptrace_check_attach-remove-unneeded-signal-=-null-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_check_attach-remove-unneeded-signal-=-null-check
+++ a/kernel/ptrace.c
@@ -99,9 +99,12 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	     child->signal != NULL) {
+	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
 		ret = 0;
+		/*
+		 * child->sighand can't be NULL, release_task()
+		 * does ptrace_unlink() before __exit_signal().
+		 */
 		spin_lock_irq(&child->sighand->siglock);
 		if (task_is_stopped(child))
 			child->state = TASK_TRACED;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
