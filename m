From: akpm@linux-foundation.org
Subject: - reparent_thread-use-same_thread_group.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:30 -0700
Message-ID: <200805010927.m419RUYn030424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757495AbYEAJ2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     reparent_thread: use same_thread_group()
has been removed from the -mm tree.  Its filename was
     reparent_thread-use-same_thread_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reparent_thread: use same_thread_group()
From: Oleg Nesterov <oleg@tv-sign.ru>

Trivial, use same_thread_group() in reparent_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~reparent_thread-use-same_thread_group kernel/exit.c
--- a/kernel/exit.c~reparent_thread-use-same_thread_group
+++ a/kernel/exit.c
@@ -722,7 +722,7 @@ reparent_thread(struct task_struct *p, s
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
-	if (p->real_parent->group_leader == father->group_leader)
+	if (same_thread_group(p->real_parent, father))
 		return;
 
 	/* We don't want people slaying init.  */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

