From: akpm@linux-foundation.org
Subject: + softirq-reduce-invoke_softirq-code-duplication.patch added to -mm tree
Date: Mon, 13 Feb 2012 14:42:42 -0800
Message-ID: <20120213224242.AD459A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39736 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2BMWmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 17:42:43 -0500
Received: by yhgm50 with SMTP id m50so643627yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 14:42:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Subject: softirq: reduce invoke_softirq() code duplication
has been added to the -mm tree.  Its filename is
     softirq-reduce-invoke_softirq-code-duplication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: softirq: reduce invoke_softirq() code duplication

The two invoke_softirq() variants are identical except for a single
line. So move the #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED inside one of
the functions and get rid of the other one.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN kernel/softirq.c~softirq-reduce-invoke_softirq-code-duplication kernel/softirq.c
--- a/kernel/softirq.c~softirq-reduce-invoke_softirq-code-duplication
+++ a/kernel/softirq.c
@@ -310,31 +310,21 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-}
 #else
-static inline void invoke_softirq(void)
-{
-	if (!force_irqthreads)
 		do_softirq();
-	else {
+#endif
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
_
Subject: Subject: softirq: reduce invoke_softirq() code duplication

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
softirq-reduce-invoke_softirq-code-duplication.patch
posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch
posix_types-make-it-possible-to-override-__kernel_fsid_t.patch
s390-use-generic-posix_typesh.patch
posix_types-remove-fd_set-macros.patch
bitops-introduce-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

