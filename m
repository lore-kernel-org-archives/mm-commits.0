From: akpm@linux-foundation.org
Subject: + irq_workh-fix-warning-when-config_irq_work=n.patch added to -mm tree
Date: Thu, 14 Mar 2013 13:33:44 -0700
Message-ID: <20130314203344.8EC8C5A4213@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44908 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3CNUdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 16:33:46 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so269838qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 13:33:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james.hogan@imgtec.com, fweisbec@gmail.com, mingo@kernel.org, paul.gortmaker@windriver.com, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     Subject: irq_work.h: fix warning when CONFIG_IRQ_WORK=n
has been added to the -mm tree.  Its filename is
     irq_workh-fix-warning-when-config_irq_work=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: irq_work.h: fix warning when CONFIG_IRQ_WORK=n

A randconfig caught repeated compiler warnings when CONFIG_IRQ_WORK=n due
to the definition of a non-inline static function in <linux/irq_work.h>:

include/linux/irq_work.h +40 : warning: 'irq_work_needs_cpu' defined but not used

Make it inline to supress the warning.  This is caused by the following
commit:

Commit 00b429591 ("irq_work: Don't stop the tick with pending works")
merged in v3.9-rc1.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq_work.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/irq_work.h~irq_workh-fix-warning-when-config_irq_work=n include/linux/irq_work.h
--- a/include/linux/irq_work.h~irq_workh-fix-warning-when-config_irq_work=n
+++ a/include/linux/irq_work.h
@@ -37,7 +37,7 @@ void irq_work_sync(struct irq_work *work
 #ifdef CONFIG_IRQ_WORK
 bool irq_work_needs_cpu(void);
 #else
-static bool irq_work_needs_cpu(void) { return false; }
+static inline bool irq_work_needs_cpu(void) { return false; }
 #endif
 
 #endif /* _LINUX_IRQ_WORK_H */
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

linux-next.patch
irq_workh-fix-warning-when-config_irq_work=n.patch
printk-provide-a-wake_up_klogd-off-case.patch
debug_locksh-make-warning-more-verbose.patch
mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

