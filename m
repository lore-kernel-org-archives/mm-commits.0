From: akpm@linux-foundation.org
Subject: - workqueue-make-delayed_work_timer_fn-static.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:49 -0800
Message-ID: <200802082018.m18KIUXY010934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbYBHUpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: make delayed_work_timer_fn() static
has been removed from the -mm tree.  Its filename was
     workqueue-make-delayed_work_timer_fn-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: make delayed_work_timer_fn() static
From: Li Zefan <lizf@cn.fujitsu.com>

delayed_work_timer_fn() is a timer function, make it static.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    2 --
 kernel/workqueue.c    |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/timer.h~workqueue-make-delayed_work_timer_fn-static include/linux/timer.h
--- a/include/linux/timer.h~workqueue-make-delayed_work_timer_fn-static
+++ a/include/linux/timer.h
@@ -124,8 +124,6 @@ static inline void timer_stats_timer_cle
 }
 #endif
 
-extern void delayed_work_timer_fn(unsigned long __data);
-
 /**
  * add_timer - start a timer
  * @timer: the timer to be added
diff -puN kernel/workqueue.c~workqueue-make-delayed_work_timer_fn-static kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-make-delayed_work_timer_fn-static
+++ a/kernel/workqueue.c
@@ -175,7 +175,7 @@ int queue_work(struct workqueue_struct *
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
-void delayed_work_timer_fn(unsigned long __data)
+static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
