From: akpm@linux-foundation.org
Subject: [merged] generic-ipi-fix-hotplug_cfd.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:08 -0700
Message-ID: <200908101927.n7AJR8Zv025384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZHJT2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@cn.fujitsu.com, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     generic-ipi: fix hotplug_cfd()
has been removed from the -mm tree.  Its filename was
     generic-ipi-fix-hotplug_cfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic-ipi: fix hotplug_cfd()
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Use CONFIG_HOTPLUG_CPU, not CONFIG_CPU_HOTPLUG

When hot-unpluging a cpu, it will leak memory allocated at cpu hotplug,
but only if CPUMASK_OFFSTACK=y, which is default to n.

The bug was introduced by 8969a5ede0f9e17da4b943712429aef2c9bcd82b
("generic-ipi: remove kmalloc()").

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~generic-ipi-fix-hotplug_cfd kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-hotplug_cfd
+++ a/kernel/smp.c
@@ -57,7 +57,7 @@ hotplug_cfd(struct notifier_block *nfb, 
 			return NOTIFY_BAD;
 		break;
 
-#ifdef CONFIG_CPU_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
_

Patches currently in -mm which might be from xiaoguangrong@cn.fujitsu.com are

origin.patch
linux-next.patch
generic-ipi-make-struct-call_function_data-lockless.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
kernel-smpc-relocate-some-code.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd-fix.patch

