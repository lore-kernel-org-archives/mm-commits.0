From: akpm@linux-foundation.org
Subject: + fs-nilfs2-convert-timers-to-use-timer_setup.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 15:48:27 -0700
Message-ID: <59e688bb.uYLhVLCPIrG7s+Mj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbdJQWs2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: convert timers to use timer_setup()
has been added to the -mm tree.  Its filename is
     fs-nilfs2-convert-timers-to-use-timer_setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nilfs2-convert-timers-to-use-timer_setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nilfs2-convert-timers-to-use-timer_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
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

writeback-convert-timers-to-use-timer_setup.patch
sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
fs-nilfs2-convert-timers-to-use-timer_setup.patch

