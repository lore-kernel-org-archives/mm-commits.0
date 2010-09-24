From: akpm@linux-foundation.org
Subject: + timer-del_timer_sync-can-be-used-in-softirq-context.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:09:08 -0700
Message-ID: <201009242209.o8OM98pU028180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297Ab0IXWJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:09:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com


The patch titled
     timer: del_timer_sync() can be used in softirq context
has been added to the -mm tree.  Its filename is
     timer-del_timer_sync-can-be-used-in-softirq-context.patch

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
Subject: timer: del_timer_sync() can be used in softirq context
From: Yong Zhang <yong.zhang@windriver.com>

Actually we have used del_timer_sync() in softirq context for a long time,
such as: __dst_free()::cancel_delayed_work() and maybe the
DEBUG_OBJECTS_TIMERS fundamental code.

So change the comments of it to warn on hardirq context only, and make
lockdep know about this change.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/timer.c~timer-del_timer_sync-can-be-used-in-softirq-context kernel/timer.c
--- a/kernel/timer.c~timer-del_timer_sync-can-be-used-in-softirq-context
+++ a/kernel/timer.c
@@ -979,7 +979,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * interrupt contexts. The caller must not hold locks which would prevent
+ * hardirq contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -989,12 +989,10 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
-	unsigned long flags;
