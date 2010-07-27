From: akpm@linux-foundation.org
Subject: + asm-generic-use-raw_local_irq_save-restore-instead-local_irq_save-restore.patch added to -mm tree
Date: Tue, 27 Jul 2010 16:18:47 -0700
Message-ID: <201007272318.o6RNIlxX011021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab0G0XTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jul 2010 19:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: monstr@monstr.eu, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     asm-generic: use raw_local_irq_save/restore instead local_irq_save/restore
has been added to the -mm tree.  Its filename is
     asm-generic-use-raw_local_irq_save-restore-instead-local_irq_save-restore.patch

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
Subject: asm-generic: use raw_local_irq_save/restore instead local_irq_save/restore
From: Michal Simek <monstr@monstr.eu>

The start/stop_critical_timing functions for preemptirqsoff, preemptoff
and irqsoff tracers contain atomic_inc() and atomic_dec() operations.

Atomic operations use local_irq_save/restore macros to ensure atomic
access but they are traced by the same function which is causing recursion
problem.

The reason is when these tracers are turn ON then the
local_irq_save/restore macros are changed in include/linux/irqflags.h to
call trace_hardirqs_on/off which call start/stop_critical_timing.

Microblaze was affected because it uses generic atomic implementation. 

Signed-off-by: Michal Simek <monstr@monstr.eu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/atomic.h~asm-generic-use-raw_local_irq_save-restore-instead-local_irq_save-restore include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-use-raw_local_irq_save-restore-instead-local_irq_save-restore
+++ a/include/asm-generic/atomic.h
@@ -57,11 +57,11 @@ static inline int atomic_add_return(int 
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -78,11 +78,11 @@ static inline int atomic_sub_return(int 
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	temp = v->counter;
 	temp -= i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -135,9 +135,9 @@ static inline void atomic_clear_mask(uns
 	unsigned long flags;
 
 	mask = ~mask;
-	local_irq_save(flags);
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
 	*addr &= mask;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
_

Patches currently in -mm which might be from monstr@monstr.eu are

asm-generic-use-raw_local_irq_save-restore-instead-local_irq_save-restore.patch
linux-next.patch

