From: akpm@linux-foundation.org
Subject: + new-tsc-based-delay_tsc.patch added to -mm tree
Date: Mon, 26 Nov 2007 00:05:19 -0800
Message-ID: <200711260805.lAQ85J0g023551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbXKZIGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitov@issp.bas.bg, mingo@elte.hu, tglx@linutronix.de


The patch titled
     new TSC-based delay_tsc()
has been added to the -mm tree.  Its filename is
     new-tsc-based-delay_tsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: new TSC-based delay_tsc()
From: Marin Mitov <mitov@issp.bas.bg>

A patch based on Ingo's idea/patch to track delay_tsc() migration to
another cpu by comparing smp_processor_id().

What is different:
1. Using unsigned (instead of long) to unify for i386/x86_64.
2. Minimal preempt_disable/enable() critical sections
   (more room for preemption)
3. some statements have been rearranged, to account for
    possible under/overflow of left/TSC

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/delay_32.c |   35 +++++++++++++++++++++++++++++------
 arch/x86/lib/delay_64.c |   36 ++++++++++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 12 deletions(-)

diff -puN arch/x86/lib/delay_32.c~new-tsc-based-delay_tsc arch/x86/lib/delay_32.c
--- a/arch/x86/lib/delay_32.c~new-tsc-based-delay_tsc
+++ a/arch/x86/lib/delay_32.c
@@ -38,18 +38,41 @@ static void delay_loop(unsigned long loo
 		:"0" (loops));
 }
 
-/* TSC based delay: */
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 static void delay_tsc(unsigned long loops)
 {
-	unsigned long bclock, now;
+	unsigned prev, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
+
+	preempt_disable();
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-	preempt_disable();		/* TSC's are per-cpu */
-	rdtscl(bclock);
 	do {
 		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
+		preempt_disable();
 		rdtscl(now);
-	} while ((now-bclock) < loops);
-	preempt_enable();
+		cpu = smp_processor_id();
+		preempt_enable();
+
+		if (prev_cpu != cpu){
+			/*
+			 * We have migrated, we skip this small amount of time:
+			 */
+			prev = now;
+			prev_cpu = cpu;
+		}
+	} while ((now-prev) < left);
 }
 
 /*
diff -puN arch/x86/lib/delay_64.c~new-tsc-based-delay_tsc arch/x86/lib/delay_64.c
--- a/arch/x86/lib/delay_64.c~new-tsc-based-delay_tsc
+++ a/arch/x86/lib/delay_64.c
@@ -26,18 +26,42 @@ int read_current_timer(unsigned long *ti
 	return 0;
 }
 
+/* TSC based delay:
+ *
+ * We are careful about preemption as TSC's are per-CPU.
+ */
 void __delay(unsigned long loops)
 {
-	unsigned bclock, now;
+	unsigned prev, now;
+	unsigned left = loops;
+	unsigned prev_cpu, cpu;
+
+	preempt_disable();
+	rdtscl(prev);
+	prev_cpu = smp_processor_id();
+	preempt_enable();
+	now = prev;
 
-	preempt_disable();		/* TSC's are pre-cpu */
-	rdtscl(bclock);
 	do {
-		rep_nop(); 
+		rep_nop();
+
+		left -= now - prev;
+		prev = now;
+
+		preempt_disable();
 		rdtscl(now);
+		cpu = smp_processor_id();
+		preempt_enable();
+
+		if (prev_cpu != cpu){
+			/*
+			 * We have migrated, we skip this small amount of time:
+			 */
+			 prev = now;
+			 prev_cpu = cpu;
+		}
 	}
-	while ((now-bclock) < loops);
-	preempt_enable();
+	while ((now-prev) < left);
 }
 EXPORT_SYMBOL(__delay);
 
_

Patches currently in -mm which might be from mitov@issp.bas.bg are

new-tsc-based-delay_tsc.patch
