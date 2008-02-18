From: akpm@linux-foundation.org
Subject: + simplify-cpu_hotplug_begin-put_online_cpus.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:17:56 -0800
Message-ID: <200802181018.m1IAIsvo019921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYBRKUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:20:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dipankar@in.ibm.com, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com


The patch titled
     simplify cpu_hotplug_begin()/put_online_cpus()
has been added to the -mm tree.  Its filename is
     simplify-cpu_hotplug_begin-put_online_cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: simplify cpu_hotplug_begin()/put_online_cpus()
From: Oleg Nesterov <oleg@tv-sign.ru>

cpu_hotplug_begin() must be always called under cpu_add_remove_lock, this
means that only one process can be cpu_hotplug.active_writer.  So we don't
need the cpu_hotplug.writer_queue, we can wake up the ->active_writer
directly.

Also, fix the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff -puN kernel/cpu.c~simplify-cpu_hotplug_begin-put_online_cpus kernel/cpu.c
--- a/kernel/cpu.c~simplify-cpu_hotplug_begin-put_online_cpus
+++ a/kernel/cpu.c
@@ -33,17 +33,13 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-	wait_queue_head_t writer_queue;
 } cpu_hotplug;
 
-#define writer_exists() (cpu_hotplug.active_writer != NULL)
-
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
 	mutex_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
-	init_waitqueue_head(&cpu_hotplug.writer_queue);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -65,11 +61,8 @@ void put_online_cpus(void)
 	if (cpu_hotplug.active_writer == current)
 		return;
 	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount--;
-
-	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
-		wake_up(&cpu_hotplug.writer_queue);
-
+	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
+		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
 
 }
@@ -98,8 +91,8 @@ void cpu_maps_update_done(void)
  * Note that during a cpu-hotplug operation, the new readers, if any,
  * will be blocked by the cpu_hotplug.lock
  *
- * Since cpu_maps_update_begin is always called after invoking
- * cpu_maps_update_begin, we can be sure that only one writer is active.
+ * Since cpu_hotplug_begin() is always called after invoking
+ * cpu_maps_update_begin(), we can be sure that only one writer is active.
  *
  * Note that theoretically, there is a possibility of a livelock:
  * - Refcount goes to zero, last reader wakes up the sleeping
@@ -115,19 +108,16 @@ void cpu_maps_update_done(void)
  */
 static void cpu_hotplug_begin(void)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&cpu_hotplug.lock);
-
 	cpu_hotplug.active_writer = current;
-	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
-	while (cpu_hotplug.refcount) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		mutex_lock(&cpu_hotplug.lock);
+		if (likely(!cpu_hotplug.refcount))
+			break;
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
-		mutex_lock(&cpu_hotplug.lock);
 	}
-	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
 }
 
 static void cpu_hotplug_done(void)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
