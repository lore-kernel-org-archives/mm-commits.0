From: akpm@linux-foundation.org
Subject: + timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:09:06 -0700
Message-ID: <201009242209.o8OM96ds028177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab0IXWJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:09:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com


The patch titled
     timer: make try_to_del_timer_sync() safe on both hardirq context and UP
has been added to the -mm tree.  Its filename is
     timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timer: make try_to_del_timer_sync() safe on both hardirq context and UP
From: Yong Zhang <yong.zhang@windriver.com>

In commit fd450b7318b75343f ("timers: introduce try_to_del_timer_sync()")
, it was saying try_to_del_timer_sync() can be used in interrupt context.

But because base->running_timer is SMP special, this lead to unsymmetry
try_to_del_timer_sync() on UP and SMP.

We can make running_timer live on everywhere, then try_to_del_timer_sync()
is also UP safe and can be used in hardirq context.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    4 ++--
 kernel/timer.c        |    6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/timer.h~timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up include/linux/timer.h
--- a/include/linux/timer.h~timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up
+++ a/include/linux/timer.h
@@ -249,11 +249,11 @@ static inline void timer_stats_timer_cle
 
 extern void add_timer(struct timer_list *timer);
 
+extern int try_to_del_timer_sync(struct timer_list *timer);
+
 #ifdef CONFIG_SMP
-  extern int try_to_del_timer_sync(struct timer_list *timer);
   extern int del_timer_sync(struct timer_list *timer);
 #else
-# define try_to_del_timer_sync(t)	del_timer(t)
 # define del_timer_sync(t)		del_timer(t)
 #endif
 
diff -puN kernel/timer.c~timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up kernel/timer.c
--- a/kernel/timer.c~timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up
+++ a/kernel/timer.c
@@ -347,9 +347,7 @@ EXPORT_SYMBOL_GPL(set_timer_slack);
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
 {
-#ifdef CONFIG_SMP
 	base->running_timer = timer;
-#endif
 }
 
 static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
@@ -936,15 +934,12 @@ int del_timer(struct timer_list *timer)
 }
 EXPORT_SYMBOL(del_timer);
 
-#ifdef CONFIG_SMP
 /**
  * try_to_del_timer_sync - Try to deactivate a timer
  * @timer: timer do del
  *
  * This function tries to deactivate a timer. Upon successful (ret >= 0)
  * exit the timer is not queued and the handler is not running on any CPU.
- *
- * It must not be called from interrupt contexts.
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
@@ -973,6 +968,7 @@ out:
 }
 EXPORT_SYMBOL(try_to_del_timer_sync);
 
+#ifdef CONFIG_SMP
 /**
  * del_timer_sync - deactivate a timer and wait for the handler to finish.
  * @timer: the timer to be deactivated
_

Patches currently in -mm which might be from yong.zhang@windriver.com are

linux-next.patch
timer-make-try_to_del_timer_sync-safe-on-both-hardirq-context-and-up.patch
timer-del_timer_sync-can-be-used-in-softirq-context.patch
timer-warn-when-del_timer_sync-used-in-hardirq-context.patch

