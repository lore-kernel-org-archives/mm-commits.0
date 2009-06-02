From: akpm@linux-foundation.org
Subject: [to-be-updated] jffs2-move-jffs2_gcd_mtd-threads-to-the-kthread-api.patch removed from -mm tree
Date: Tue, 02 Jun 2009 15:07:56 -0700
Message-ID: <200906022207.n52M7u1u014947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbZFBWIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 18:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerard.lledo@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: move jffs2_gcd_mtd threads to the kthread API
has been removed from the -mm tree.  Its filename was
     jffs2-move-jffs2_gcd_mtd-threads-to-the-kthread-api.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: move jffs2_gcd_mtd threads to the kthread API
From: Gerard Lledo <gerard.lledo@gmail.com>

Move the jffs2 garbage collecting thread to the kthread API.

Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN fs/jffs2/background.c~jffs2-move-jffs2_gcd_mtd-threads-to-the-kthread-api fs/jffs2/background.c
--- a/fs/jffs2/background.c~jffs2-move-jffs2_gcd_mtd-threads-to-the-kthread-api
+++ a/fs/jffs2/background.c
@@ -15,6 +15,7 @@
 #include <linux/completion.h>
 #include <linux/sched.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 #include "nodelist.h"
 
 
@@ -31,7 +32,7 @@ void jffs2_garbage_collect_trigger(struc
 /* This must only ever be called when no GC thread is currently running */
 int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 {
-	pid_t pid;
+	struct task_struct *tsk;
 	int ret = 0;
 
 	BUG_ON(c->gc_task);
@@ -39,15 +40,16 @@ int jffs2_start_garbage_collect_thread(s
 	init_completion(&c->gc_thread_start);
 	init_completion(&c->gc_thread_exit);
 
-	pid = kernel_thread(jffs2_garbage_collect_thread, c, CLONE_FS|CLONE_FILES);
-	if (pid < 0) {
-		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %d\n", -pid);
+	tsk = kthread_create(jffs2_garbage_collect_thread, c, "jffs2_gcd_mtd%d", c->mtd->index);
+	if (IS_ERR(tsk)) {
+		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
 		complete(&c->gc_thread_exit);
-		ret = pid;
+		ret = PTR_ERR(tsk);
 	} else {
-		/* Wait for it... */
-		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", pid));
+		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
+		wake_up_process(tsk);
 		wait_for_completion(&c->gc_thread_start);
+		ret = tsk->pid;
 	}
 
 	return ret;
@@ -71,7 +73,6 @@ static int jffs2_garbage_collect_thread(
 {
 	struct jffs2_sb_info *c = _c;
 
-	daemonize("jffs2_gcd_mtd%d", c->mtd->index);
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
 	allow_signal(SIGCONT);
@@ -107,6 +108,11 @@ static int jffs2_garbage_collect_thread(
 		 * the GC thread get there first. */
 		schedule_timeout_interruptible(msecs_to_jiffies(50));
 
+		if (kthread_should_stop()) {
+			D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread():  kthread_stop() called.\n"));
+			goto die;
+		}
+
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current) || freezing(current)) {
_

Patches currently in -mm which might be from gerard.lledo@gmail.com are

jffs2-move-jffs2_gcd_mtd-threads-to-the-kthread-api.patch

