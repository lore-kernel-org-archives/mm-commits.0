From: akpm@linux-foundation.org
Subject: + workqueue-make-delayed_work_timer_fn-static.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:15 -0800
Message-ID: <200801270518.m0R5IC9D031180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbYA0FS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com


The patch titled
     workqueue: make delayed_work_timer_fn() static
has been added to the -mm tree.  Its filename is
     workqueue-make-delayed_work_timer_fn-static.patch

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
git-powerpc.patch
git-drm.patch
git-hid.patch
git-net.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
workqueue-make-delayed_work_timer_fn-static.patch
