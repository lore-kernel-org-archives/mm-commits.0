From: akpm@linux-foundation.org
Subject: + freezer-use-wait-queue-instead-of-busy-looping.patch added to -mm tree
Date: Thu, 02 Aug 2007 11:27:33 -0700
Message-ID: <200708021827.l72IRXFk003094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbXHBS15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 14:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     Freezer: use wait queue instead of busy looping
has been added to the -mm tree.  Its filename is
     freezer-use-wait-queue-instead-of-busy-looping.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Freezer: use wait queue instead of busy looping
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

Use the observation that try_to_freeze_tasks() need not loop while wait=
ing for
the freezing tasks to enter the refrigerator and make it use a wait que=
ue.

The idea is that after sending freeze requests to the tasks regarded as
freezable try_to_freeze_tasks() can go to sleep and wait until at least=
 one task
enters the refrigerator. =A0The first task that does it wakes up
try_to_freeze_tasks() and the procedure is repeated. =A0If the refriger=
ator is not
entered by any tasks before TIMEOUT expires, the freezing of tasks fail=
s.

This way, try_to_freeze_tasks() doesn't occupy the CPU unnecessarily wh=
en some
freezing tasks are waiting for I/O to complete.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-use-wait-queue-instead-of-busy=
-looping kernel/power/process.c
--- a/kernel/power/process.c~freezer-use-wait-queue-instead-of-busy-loo=
ping
+++ a/kernel/power/process.c
@@ -19,6 +19,12 @@
  */
 #define TIMEOUT	(20 * HZ)
=20
+/*
+ * Time to wait until one or more tasks enter the refrigerator after s=
ending
+ * freeze requests to them.
+ */
+#define WAIT_TIME (HZ / 5)
+
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
=20
@@ -43,6 +49,12 @@ static inline void frozen_process(void)
 	clear_freeze_flag(current);
 }
=20
+/*
+ * Wait queue head used by try_to_freeze_tasks() to wait for tasks to =
enter the
+ * refrigerator.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(refrigerator_waitq);
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -58,6 +70,9 @@ void refrigerator(void)
 		task_unlock(current);
 		return;
 	}
+
+	wake_up(&refrigerator_waitq);
+
 	save =3D current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
=20
@@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
=20
 	end_time =3D jiffies + TIMEOUT;
 	do {
+		DEFINE_WAIT(wait);
+
+		add_wait_queue(&refrigerator_waitq, &wait);
+
 		todo =3D 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
@@ -189,7 +208,12 @@ static int try_to_freeze_tasks(int freez
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (todo && !list_empty_careful(&wait.task_list))
+			schedule_timeout(WAIT_TIME);
+		finish_wait(&refrigerator_waitq, &wait);
+
 		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
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
