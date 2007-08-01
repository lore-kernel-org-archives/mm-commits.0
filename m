From: akpm@linux-foundation.org
Subject: + freezer-measure-freezing-time.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:47:22 -0700
Message-ID: <200708012347.l71NlMrV023481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbXHAXsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     freezer: measure freezing time
has been added to the -mm tree.  Its filename is
     freezer-measure-freezing-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: measure freezing time
From: Rafael J. Wysocki <rjw@sisk.pl>

Measure the time of the freezing of tasks, even if it doesn't fail.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN kernel/power/process.c~freezer-measure-freezing-time kernel/power/process.c
--- a/kernel/power/process.c~freezer-measure-freezing-time
+++ a/kernel/power/process.c
@@ -190,6 +190,11 @@ static int try_to_freeze_tasks(int freez
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	struct timeval start, end;
+	s64 elapsed_csecs64;
+	unsigned int elapsed_csecs;
+
+	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
 	refrigerator_called = 0;
@@ -226,6 +231,11 @@ static int try_to_freeze_tasks(int freez
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
@@ -233,10 +243,9 @@ static int try_to_freeze_tasks(int freez
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
@@ -247,6 +256,9 @@ static int try_to_freeze_tasks(int freez
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
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
shrink_slab-handle-bad-shrinkers.patch
