From: akpm@linux-foundation.org
Subject: +
 kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe.patch added to
 -mm tree
Date: Mon, 17 Feb 2020 14:01:18 -0800
Message-ID: <20200217220118.O_QeD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgBQWBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 17 Feb 2020 17:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, grygorii.strashko@ti.com, pmladek@suse.com


The patch titled
     Subject: kthread: mark timer used by delayed kthread works as IRQ safe
has been added to the -mm tree.  Its filename is
     kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kthread: mark timer used by delayed kthread works as IRQ safe

The timer used by delayed kthread works are IRQ safe because the used
kthread_delayed_work_timer_fn() is IRQ safe.

It is properly marked when initialized by KTHREAD_DELAYED_WORK_INIT(). 
But TIMER_IRQSAFE flag is missing when initialized by
kthread_init_delayed_work().

The missing flag might trigger invalid warning from del_timer_sync() when
kthread_mod_delayed_work() is called with interrupts disabled.

This patch is result of a discussion about using the API, see
https://lkml.kernel.org/r/cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com

Link: http://lkml.kernel.org/r/20200217120709.1974-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kthread.h~kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe
+++ a/include/linux/kthread.h
@@ -165,7 +165,8 @@ extern void __kthread_init_worker(struct
 	do {								\
 		kthread_init_work(&(dwork)->work, (fn));		\
 		timer_setup(&(dwork)->timer,				\
-			     kthread_delayed_work_timer_fn, 0);		\
+			     kthread_delayed_work_timer_fn,		\
+			     TIMER_IRQSAFE);				\
 	} while (0)
 
 int kthread_worker_fn(void *worker_ptr);
_

Patches currently in -mm which might be from pmladek@suse.com are

kthread-mark-timer-used-by-delayed-kthread-works-as-irq-safe.patch
