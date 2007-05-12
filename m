From: akpm@linux-foundation.org
Subject: - add-hard_irq_disable.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:52 -0700
Message-ID: <200705120533.l4C5XqOB002146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbXELFd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Add hard_irq_disable()
has been removed from the -mm tree.  Its filename was
     add-hard_irq_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Some architectures, like powerpc, implement lazy disabling of interrupts. 
That means that on those, local_irq_disable() doesn't actually disable
interrupts on the CPU, but only sets some per CPU flag which cause them to be
disabled only if an interrupt actually occurs.

However, in some cases, such as stop_machine, we really want interrupts to be
fully disabled.  For example, I have code using stop machine to do ECC error
injection, used to verify operations of the ECC hardware, that sort of thing. 
It really needs to make sure that nothing is actually writing to memory while
the injection happens.  Similar examples can be found in other low level bits
and pieces.

This patch implements a generic hard_irq_disable() function which is meant to
be called -after- local_irq_disable() and ensures that interrupts are fully
disabled on that CPU.  The default implementation is a nop, though powerpc
does already provide an appropriate one.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/interrupt.h~add-hard_irq_disable include/linux/interrupt.h
--- a/include/linux/interrupt.h~add-hard_irq_disable
+++ a/include/linux/interrupt.h
@@ -241,6 +241,16 @@ static inline void __deprecated save_and
 #define save_and_cli(x)	save_and_cli(&x)
 #endif /* CONFIG_SMP */
 
+/* Some architectures might implement lazy enabling/disabling of
+ * interrupts. In some cases, such as stop_machine, we might want
+ * to ensure that after a local_irq_disable(), interrupts have
+ * really been disabled in hardware. Such architectures need to
+ * implement the following hook.
+ */
+#ifndef hard_irq_disable
+#define hard_irq_disable()	do { } while(0)
+#endif
+
 /* PLEASE, avoid to allocate new softirqs, if you need not _really_ high
    frequency threaded job scheduling. For almost all the purposes
    tasklets are more than enough. F.e. all serial device BHs et
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
do-not-select-macintosh-drivers-by-default.patch
