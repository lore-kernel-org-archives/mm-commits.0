From: akpm@osdl.org
Subject: - file-kill-unnecessary-timer-in-fdtable_defer.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:53 -0800
Message-ID: <200612072301.kB7N1rmd029816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163682AbWLGXCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, dipankar@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     file: kill unnecessary timer in fdtable_defer
has been removed from the -mm tree.  Its filename was
     file-kill-unnecessary-timer-in-fdtable_defer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: file: kill unnecessary timer in fdtable_defer
From: Tejun Heo <htejun@gmail.com>

free_fdtable_rc() schedules timer to reschedule fddef->wq if
schedule_work() on it returns 0.  However, schedule_work() guarantees that
the target work is executed at least once after the scheduling regardless
of its return value.  0 return simply means that the work was already
pending and thus no further action was required.

Another problem is that it used contant '5' as @expires argument to
mod_timer().

Kill unnecessary fddef->timer.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/file.c |   29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff -puN fs/file.c~file-kill-unnecessary-timer-in-fdtable_defer fs/file.c
--- a/fs/file.c~file-kill-unnecessary-timer-in-fdtable_defer
+++ a/fs/file.c
@@ -21,7 +21,6 @@
 struct fdtable_defer {
 	spinlock_t lock;
 	struct work_struct wq;
-	struct timer_list timer;
 	struct fdtable *next;
 };
 
@@ -75,22 +74,6 @@ static void __free_fdtable(struct fdtabl
 	kfree(fdt);
 }
 
-static void fdtable_timer(unsigned long data)
-{
-	struct fdtable_defer *fddef = (struct fdtable_defer *)data;
-
-	spin_lock(&fddef->lock);
-	/*
-	 * If someone already emptied the queue return.
-	 */
-	if (!fddef->next)
-		goto out;
-	if (!schedule_work(&fddef->wq))
-		mod_timer(&fddef->timer, 5);
-out:
-	spin_unlock(&fddef->lock);
-}
-
 static void free_fdtable_work(struct work_struct *work)
 {
 	struct fdtable_defer *f =
@@ -144,13 +127,8 @@ static void free_fdtable_rcu(struct rcu_
 		spin_lock(&fddef->lock);
 		fdt->next = fddef->next;
 		fddef->next = fdt;
-		/*
-		 * vmallocs are handled from the workqueue context.
-		 * If the per-cpu workqueue is running, then we
-		 * defer work scheduling through a timer.
-		 */
-		if (!schedule_work(&fddef->wq))
-			mod_timer(&fddef->timer, 5);
+		/* vmallocs are handled from the workqueue context */
+		schedule_work(&fddef->wq);
 		spin_unlock(&fddef->lock);
 		put_cpu_var(fdtable_defer_list);
 	}
@@ -354,9 +332,6 @@ static void __devinit fdtable_defer_list
 	struct fdtable_defer *fddef = &per_cpu(fdtable_defer_list, cpu);
 	spin_lock_init(&fddef->lock);
 	INIT_WORK(&fddef->wq, free_fdtable_work);
-	init_timer(&fddef->timer);
-	fddef->timer.data = (unsigned long)fddef;
-	fddef->timer.function = fdtable_timer;
 	fddef->next = NULL;
 }
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch

