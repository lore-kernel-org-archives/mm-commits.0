From: akpm@linux-foundation.org
Subject: [nacked] jffs2-jffs2_start_garbage_collect_thread-return-value-cleanup.patch removed from -mm tree
Date: Wed, 24 Jun 2009 20:00:46 -0700
Message-ID: <200906250300.n5P30k4S028147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757875AbZFYDAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 23:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerard.lledo@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: jffs2_start_garbage_collect_thread() return value cleanup
has been removed from the -mm tree.  Its filename was
     jffs2-jffs2_start_garbage_collect_thread-return-value-cleanup.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: jffs2_start_garbage_collect_thread() return value cleanup
From: Gerard Lledo <gerard.lledo@gmail.com>

There is no user of this return value in the kernel.  Change it to return void
instead.

Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    7 +------
 fs/jffs2/os-linux.h   |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/jffs2/background.c~jffs2-jffs2_start_garbage_collect_thread-return-value-cleanup fs/jffs2/background.c
--- a/fs/jffs2/background.c~jffs2-jffs2_start_garbage_collect_thread-return-value-cleanup
+++ a/fs/jffs2/background.c
@@ -30,10 +30,9 @@ void jffs2_garbage_collect_trigger(struc
 }
 
 /* This must only ever be called when no GC thread is currently running */
-int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
+void jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 {
 	struct task_struct *tsk;
-	int ret = 0;
 
 	BUG_ON(c->gc_task);
 
@@ -44,15 +43,11 @@ int jffs2_start_garbage_collect_thread(s
 	if (IS_ERR(tsk)) {
 		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
 		complete(&c->gc_thread_exit);
-		ret = PTR_ERR(tsk);
 	} else {
 		/* Wait for it... */
 		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
 		wait_for_completion(&c->gc_thread_start);
-		ret = tsk->pid;
 	}
