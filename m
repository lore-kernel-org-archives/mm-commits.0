From: akpm@osdl.org
Subject: - swsusp-cleanup-whitespace-in-freezer-output.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:29 -0800
Message-ID: <200612072259.kB7MxTZY029525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163682AbWLGW7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ncunningham@linuxmail.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: clean up whitespace in freezer output
has been removed from the -mm tree.  Its filename was
     swsusp-cleanup-whitespace-in-freezer-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: clean up whitespace in freezer output
From: Nigel Cunningham <ncunningham@linuxmail.org>

Minor whitespace and formatting modifications for the freezer.

Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/process.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/power/process.c~swsusp-cleanup-whitespace-in-freezer-output kernel/power/process.c
--- a/kernel/power/process.c~swsusp-cleanup-whitespace-in-freezer-output
+++ a/kernel/power/process.c
@@ -86,7 +86,7 @@ int freeze_processes(void)
 	unsigned long start_time;
 	struct task_struct *g, *p;
 
-	printk( "Stopping tasks: " );
+	printk("Stopping tasks... ");
 	start_time = jiffies;
 	user_frozen = 0;
 	do {
@@ -134,21 +134,21 @@ int freeze_processes(void)
 	 * but it cleans up leftover PF_FREEZE requests.
 	 */
 	if (todo) {
-		printk( "\n" );
-		printk(KERN_ERR " stopping tasks timed out "
+		printk("\n");
+		printk(KERN_ERR "Stopping tasks timed out "
 			"after %d seconds (%d tasks remaining):\n",
 			TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			if (freezeable(p) && !frozen(p))
-				printk(KERN_ERR "  %s\n", p->comm);
+				printk(KERN_ERR " %s\n", p->comm);
 			cancel_freezing(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		return todo;
 	}
 
-	printk( "|\n" );
+	printk("done.\n");
 	BUG_ON(in_atomic());
 	return 0;
 }
@@ -157,18 +157,18 @@ void thaw_processes(void)
 {
 	struct task_struct *g, *p;
 
-	printk( "Restarting tasks..." );
+	printk("Restarting tasks... ");
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
 		if (!freezeable(p))
 			continue;
 		if (!thaw_process(p))
-			printk(KERN_INFO " Strange, %s not stopped\n", p->comm );
+			printk(KERN_INFO "Strange, %s not stopped\n", p->comm);
 	} while_each_thread(g, p);
 
 	read_unlock(&tasklist_lock);
 	schedule();
-	printk( " done\n" );
+	printk("done.\n");
 }
 
 EXPORT_SYMBOL(refrigerator);
_

Patches currently in -mm which might be from ncunningham@linuxmail.org are

origin.patch

