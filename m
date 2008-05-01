From: akpm@linux-foundation.org
Subject: - ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:37 -0700
Message-ID: <200805010927.m419RbOq030433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbYEAJiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: __ptrace_unlink: use the ptrace_reparented() helper
has been removed from the -mm tree.  Its filename was
     ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: __ptrace_unlink: use the ptrace_reparented() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently __ptrace_unlink() checks list_empty(->ptrace_list) to figure out
whether the child was reparented.  Change the code to use ptrace_reparented()
to make this check more explicit and consistent.

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper
+++ a/kernel/ptrace.c
@@ -73,7 +73,7 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
-	if (!list_empty(&child->ptrace_list)) {
+	if (ptrace_reparented(child)) {
 		list_del_init(&child->ptrace_list);
 		remove_parent(child);
 		child->parent = child->real_parent;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

