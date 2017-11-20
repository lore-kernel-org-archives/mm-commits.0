From: akpm@linux-foundation.org
Subject: [merged] fs-nilfs2-convert-timers-to-use-timer_setup.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:25:22 -0800
Message-ID: <20171120212522.jLAxyIa5Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdKTVZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: convert timers to use timer_setup()
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-convert-timers-to-use-timer_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs/nilfs2: convert timers to use timer_setup()

In preparation for unconditionally passing the struct timer_list pointer
to all timer callbacks, switch to using the new timer_setup() and
from_timer() to pass the timer pointer explicitly.  This requires adding a
pointer to hold the timer's target task, as the lifetime of sc_task
doesn't appear to match the timer's task.

Link: http://lkml.kernel.org/r/20171016235900.GA102729@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   11 +++++------
 fs/nilfs2/segment.h |    1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/nilfs2/segment.c~fs-nilfs2-convert-timers-to-use-timer_setup fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~fs-nilfs2-convert-timers-to-use-timer_setup
+++ a/fs/nilfs2/segment.c
@@ -2400,11 +2400,11 @@ static int nilfs_segctor_construct(struc
 	return err;
 }
 
-static void nilfs_construction_timeout(unsigned long data)
+static void nilfs_construction_timeout(struct timer_list *t)
 {
-	struct task_struct *p = (struct task_struct *)data;
+	struct nilfs_sc_info *sci = from_timer(sci, t, sc_timer);
 
-	wake_up_process(p);
+	wake_up_process(sci->sc_timer_task);
 }
 
 static void
@@ -2542,8 +2542,7 @@ static int nilfs_segctor_thread(void *ar
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	sci->sc_timer.data = (unsigned long)current;
-	sci->sc_timer.function = nilfs_construction_timeout;
+	sci->sc_timer_task = current;
 
 	/* start sync. */
 	sci->sc_task = current;
@@ -2674,7 +2673,7 @@ static struct nilfs_sc_info *nilfs_segct
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
 	INIT_LIST_HEAD(&sci->sc_iput_queue);
 	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
-	init_timer(&sci->sc_timer);
+	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
 	sci->sc_mjcp_freq = HZ * NILFS_SC_DEFAULT_SR_FREQ;
diff -puN fs/nilfs2/segment.h~fs-nilfs2-convert-timers-to-use-timer_setup fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~fs-nilfs2-convert-timers-to-use-timer_setup
+++ a/fs/nilfs2/segment.h
@@ -180,6 +180,7 @@ struct nilfs_sc_info {
 	unsigned long		sc_watermark;
 
 	struct timer_list	sc_timer;
+	struct task_struct     *sc_timer_task;
 	struct task_struct     *sc_task;
 };
 
_

Patches currently in -mm which might be from keescook@chromium.org are


