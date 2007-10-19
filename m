From: akpm@linux-foundation.org
Subject: - freezer-measure-freezing-time.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:11 -0700
Message-ID: <200710190341.l9J3fBUo012781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966484AbXJSDzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: measure freezing time
has been removed from the -mm tree.  Its filename was
     freezer-measure-freezing-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: measure freezing time
From: Rafael J. Wysocki <rjw@sisk.pl>

Measure the time of the freezing of tasks, even if it doesn't fail.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN kernel/power/process.c~freezer-measure-freezing-time kernel/power/process.c
--- a/kernel/power/process.c~freezer-measure-freezing-time
+++ a/kernel/power/process.c
@@ -168,6 +168,11 @@ static int try_to_freeze_tasks(int freez
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	struct timeval start, end;
+	s64 elapsed_csecs64;
+	unsigned int elapsed_csecs;
+
+	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
 	do {
@@ -194,6 +199,11 @@ static int try_to_freeze_tasks(int freez
 			break;
 	} while (todo);
 
+	do_gettimeofday(&end);
+	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
+	do_div(elapsed_csecs64, NSEC_PER_SEC / 100);
+	elapsed_csecs = elapsed_csecs64;
+
 	if (todo) {
 		/* This does not unfreeze processes that are already frozen
 		 * (we have slightly ugly calling convention in that respect,
@@ -201,10 +211,9 @@ static int try_to_freeze_tasks(int freez
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Freezing of %s timed out after %d seconds "
+		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
 				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space " : "tasks ",
-				TIMEOUT / HZ, todo);
+				elapsed_csecs / 100, elapsed_csecs % 100, todo);
 		show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
@@ -215,6 +224,9 @@ static int try_to_freeze_tasks(int freez
 			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
+	} else {
+		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
+			elapsed_csecs % 100);
 	}
 
 	return todo ? -EBUSY : 0;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
