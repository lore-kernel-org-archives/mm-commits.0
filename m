From: akpm@linux-foundation.org
Subject: [merged] signal-use-current-state-helpers.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:43:00 -0800
Message-ID: <54e4eb44.TPr5acF+dFZ3FyPg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbBRTnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: use current->state helpers
has been removed from the -mm tree.  Its filename was
     signal-use-current-state-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: signal: use current->state helpers

Call __set_current_state() instead of assigning the new state directly. 
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signal-use-current-state-helpers kernel/signal.c
--- a/kernel/signal.c~signal-use-current-state-helpers
+++ a/kernel/signal.c
@@ -3550,7 +3550,7 @@ SYSCALL_DEFINE2(signal, int, sig, __sigh
 SYSCALL_DEFINE0(pause)
 {
 	while (!signal_pending(current)) {
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
 	return -ERESTARTNOHAND;
@@ -3563,7 +3563,7 @@ int sigsuspend(sigset_t *set)
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
 
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	schedule();
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

