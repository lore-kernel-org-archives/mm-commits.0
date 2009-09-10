From: akpm@linux-foundation.org
Subject: - generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch removed from -mm tree
Date: Thu, 10 Sep 2009 14:25:21 -0700
Message-ID: <200909102125.n8ALPLKf018477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbZIJVbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 17:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd fix
has been removed from the -mm tree.  Its filename was
     generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch

This patch was dropped because of confusion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd fix
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

This patch is incomplete and thanks for Peter Zijlstra to point out

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix
+++ a/kernel/smp.c
@@ -136,7 +136,8 @@ __generic_smp_call_function_interrupt(in
 		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
 
-		data->csd.func(data->csd.info);
+		if (run_callbacks)
+			data->csd.func(data->csd.info);
 
 		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
@@ -187,7 +188,8 @@ __generic_smp_call_function_single_inter
 		 */
 		data_flags = data->flags;
 
-		data->func(data->info);
+		if (run_callbacks)
+			data->func(data->info);
 
 		/*
 		 * Unlocked CSDs are valid through generic_exec_single():
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

linux-next.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch

