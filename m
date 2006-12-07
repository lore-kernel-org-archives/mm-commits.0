From: akpm@osdl.org
Subject: - swsusp-untangle-freeze_processes.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:46 -0800
Message-ID: <200612072259.kB7Mxkb1029549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163696AbWLGW7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Untangle freeze_processes
has been removed from the -mm tree.  Its filename was
     swsusp-untangle-freeze_processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Untangle freeze_processes
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Move the loop from freeze_processes() to a separate function and call it
independently for user space processes and kernel threads so that the order
of freezing tasks is clearly visible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/process.c |   84 +++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 30 deletions(-)

diff -puN kernel/power/process.c~swsusp-untangle-freeze_processes kernel/power/process.c
--- a/kernel/power/process.c~swsusp-untangle-freeze_processes
+++ a/kernel/power/process.c
@@ -86,24 +86,23 @@ static inline int is_user_space(struct t
 	return p->mm && !(p->flags & PF_BORROWED_MM);
 }
 
-/* 0 = success, else # of processes that we failed to stop */
-int freeze_processes(void)
+static unsigned int try_to_freeze_tasks(int freeze_user_space)
 {
-	int todo, nr_user, user_frozen;
-	unsigned long start_time;
 	struct task_struct *g, *p;
+	unsigned long end_time;
+	unsigned int todo;
 
-	printk("Stopping tasks... ");
-	start_time = jiffies;
-	user_frozen = 0;
+	end_time = jiffies + TIMEOUT;
 	do {
-		nr_user = todo = 0;
+		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			if (!freezeable(p))
 				continue;
+
 			if (frozen(p))
 				continue;
+
 			if (p->state == TASK_TRACED &&
 			    (frozen(p->parent) ||
 			     p->parent->state == TASK_STOPPED)) {
@@ -111,51 +110,76 @@ int freeze_processes(void)
 				continue;
 			}
 			if (is_user_space(p)) {
+				if (!freeze_user_space)
+					continue;
+
 				/* Freeze the task unless there is a vfork
 				 * completion pending
 				 */
 				if (!p->vfork_done)
 					freeze_process(p);
-				nr_user++;
 			} else {
-				/* Freeze only if the user space is frozen */
-				if (user_frozen)
-					freeze_process(p);
-				todo++;
+				if (freeze_user_space)
+					continue;
+
+				freeze_process(p);
 			}
+			todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		todo += nr_user;
-		if (!user_frozen && !nr_user) {
-			sys_sync();
-			start_time = jiffies;
-		}
-		user_frozen = !nr_user;
 		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, start_time + TIMEOUT))
+		if (todo && time_after(jiffies, end_time))
 			break;
-	} while(todo);
+	} while (todo);
 
-	/* This does not unfreeze processes that are already frozen
-	 * (we have slightly ugly calling convention in that respect,
-	 * and caller must call thaw_processes() if something fails),
-	 * but it cleans up leftover PF_FREEZE requests.
-	 */
 	if (todo) {
+		/* This does not unfreeze processes that are already frozen
+		 * (we have slightly ugly calling convention in that respect,
+		 * and caller must call thaw_processes() if something fails),
+		 * but it cleans up leftover PF_FREEZE requests.
+		 */
 		printk("\n");
-		printk(KERN_ERR "Stopping tasks timed out "
-			"after %d seconds (%d tasks remaining):\n",
-			TIMEOUT / HZ, todo);
+		printk(KERN_ERR "Stopping %s timed out after %d seconds "
+				"(%d tasks refusing to freeze):\n",
+				freeze_user_space ? "user space processes" :
+					"kernel threads",
+				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
+			if (is_user_space(p) == !freeze_user_space)
+				continue;
+
 			if (freezeable(p) && !frozen(p))
 				printk(KERN_ERR " %s\n", p->comm);
+
 			cancel_freezing(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		return todo;
 	}
 
+	return todo;
+}
+
+/**
+ *	freeze_processes - tell processes to enter the refrigerator
+ *
+ *	Returns 0 on success, or the number of processes that didn't freeze,
+ *	although they were told to.
+ */
+int freeze_processes(void)
+{
+	unsigned int nr_unfrozen;
+
+	printk("Stopping tasks ... ");
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
+	sys_sync();
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
 	printk("done.\n");
 	BUG_ON(in_atomic());
 	return 0;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

