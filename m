From: akpm@linux-foundation.org
Subject: [merged] generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:31 -0800
Message-ID: <200912152155.nBFLtVIf015494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761359AbZLOWRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     generic-ipi: cleanup for generic_smp_call_function_interrupt()
has been removed from the -mm tree.  Its filename was
     generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic-ipi: cleanup for generic_smp_call_function_interrupt()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Use smp_processor_id() instead of get_cpu() and put_cpu() in
generic_smp_call_function_interrupt(), It's no need to disable preempt,
because we must call generic_smp_call_function_interrupt() with interrupts
disabled.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/smp.c~generic-ipi-cleanup-for-generic_smp_call_function_interrupt kernel/smp.c
--- a/kernel/smp.c~generic-ipi-cleanup-for-generic_smp_call_function_interrupt
+++ a/kernel/smp.c
@@ -171,7 +171,7 @@ void generic_exec_single(int cpu, struct
 void generic_smp_call_function_interrupt(void)
 {
 	struct call_function_data *data;
-	int cpu = get_cpu();
+	int cpu = smp_processor_id();
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
@@ -212,7 +212,6 @@ void generic_smp_call_function_interrupt
 		csd_unlock(&data->csd);
 	}
 
-	put_cpu();
 }
 
 /*
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

origin.patch
linux-next.patch

