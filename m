From: akpm@linux-foundation.org
Subject: - time-simplify-smp_call_function_single-call-sequence.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:51 -0700
Message-ID: <200710180653.l9I6rpa0030474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351AbXJRHnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: simplify smp_call_function_single() call sequence
has been removed from the -mm tree.  Its filename was
     time-simplify-smp_call_function_single-call-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN kernel/time/tick-broadcast.c~time-simplify-smp_call_function_single-call-sequence kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~time-simplify-smp_call_function_single-call-sequence
+++ a/kernel/time/tick-broadcast.c
@@ -274,21 +274,12 @@ out:
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

origin.patch
git-kvm.patch
