From: akpm@linux-foundation.org
Subject: + time-simplify-smp_call_function_single-call-sequence.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:36:30 -0700
Message-ID: <200707232336.l6NNaUFG017834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757102AbXGWXhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: simplify smp_call_function_single() call sequence
has been added to the -mm tree.  Its filename is
     time-simplify-smp_call_function_single-call-sequence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: simplify smp_call_function_single() call sequence
From: Avi Kivity <avi@qumranet.com>

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff -puN kernel/time/tick-broadcast.c~time-simplify-smp_call_function_single-call-sequence kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~time-simplify-smp_call_function_single-call-sequence
+++ a/kernel/time/tick-broadcast.c
@@ -258,21 +258,12 @@ out:
  */
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
-	int cpu = get_cpu();
-
-	if (!cpu_isset(*oncpu, cpu_online_map)) {
+	if (!cpu_isset(*oncpu, cpu_online_map))
 		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
-	} else {
-
-		if (cpu == *oncpu)
-			tick_do_broadcast_on_off(&reason);
-		else
-			smp_call_function_single(*oncpu,
-						 tick_do_broadcast_on_off,
-						 &reason, 1, 1);
-	}
-	put_cpu();
+	else
+		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
+					 &reason, 1, 1);
 }
 
 /*
_

Patches currently in -mm which might be from avi@qumranet.com are

ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
msr-driver-simplify-smp_call_function_single-call-sequence.patch
time-simplify-smp_call_function_single-call-sequence.patch
