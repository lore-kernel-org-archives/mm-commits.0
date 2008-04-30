From: akpm@linux-foundation.org
Subject: - kthread-call-wake_up_process-without-the-lock-being-held.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:36 -0700
Message-ID: <200804300540.m3U5eagf028984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756867AbYD3Flx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mm-co


The patch titled
     kthread: call wake_up_process() without the lock being held
has been removed from the -mm tree.  Its filename was
     kthread-call-wake_up_process-without-the-lock-being-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: call wake_up_process() without the lock being held
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

From the POV of synchronization, there should be no need to call
wake_up_process() with the 'kthread_create_lock' being held.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~kthread-call-wake_up_process-without-the-lock-being-held kernel/kthread.c
--- a/kernel/kthread.c~kthread-call-wake_up_process-without-the-lock-being-held
+++ a/kernel/kthread.c
@@ -144,9 +144,9 @@ struct task_struct *kthread_create(int (
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
 
+	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch

