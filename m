From: akpm@linux-foundation.org
Subject: + generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:31:41 -0700
Message-ID: <200907292331.n6TNVfiI031589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889AbZG2XcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au


The patch titled
     generic-ipi: cleanup for generic_smp_call_function_interrupt()
has been added to the -mm tree.  Its filename is
     generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch

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
Subject: generic-ipi: cleanup for generic_smp_call_function_interrupt()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Use smp_processor_id() instead of get_cpu() and put_cpu() in
generic_smp_call_function_interrupt(), It's no need to disable preempt,
beacuse we must call generic_smp_call_function_interrupt() with interrupts
disabled

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
@@ -174,7 +174,7 @@ void generic_exec_single(int cpu, struct
 void generic_smp_call_function_interrupt(void)
 {
 	struct call_function_data *data;
-	int cpu = get_cpu();
+	int cpu = smp_processor_id();
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -217,7 +217,6 @@ void generic_smp_call_function_interrupt
 		csd_unlock(&data->csd);
 	}
 
-	put_cpu();
 }
 
 /*
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

generic-ipi-fix-hotplug_cfd.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch

