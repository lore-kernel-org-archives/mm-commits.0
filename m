From: akpm@linux-foundation.org
Subject: - futex-cleanup-futex_unlock_pi-fault-handling.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:38 -0800
Message-ID: <200812291919.mBTJJcq9031826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYL2TUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:20:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvhltc@us.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     futex: cleanup futex_(un)lock_pi fault handling
has been removed from the -mm tree.  Its filename was
     futex-cleanup-futex_unlock_pi-fault-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: cleanup futex_(un)lock_pi fault handling
From: Darren Hart <dvhltc@us.ibm.com>

Some apparently left over cruft code was complicating the fault logic. 
Testing if uval != -EFAULT doesn't have any meaning, get_user() sets ret
to either 0 or -EFAULT, there's no need to compare uval, especially not
against EFAULT which it will never be.  This patch removes the superfluous
test and clarifies the comment blocks.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN kernel/futex.c~futex-cleanup-futex_unlock_pi-fault-handling kernel/futex.c
--- a/kernel/futex.c~futex-cleanup-futex_unlock_pi-fault-handling
+++ a/kernel/futex.c
@@ -1572,12 +1572,11 @@ static int futex_lock_pi(u32 __user *uad
 
  uaddr_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. :-) --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	queue_unlock(&q, hb);
 
@@ -1589,7 +1588,7 @@ static int futex_lock_pi(u32 __user *uad
 	}
 
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	if (to)
@@ -1683,12 +1682,11 @@ out:
 
 pi_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	spin_unlock(&hb->lock);
 
@@ -1701,7 +1699,7 @@ pi_faulted:
 	}
 
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	return ret;
_

Patches currently in -mm which might be from dvhltc@us.ibm.com are

linux-next.patch

