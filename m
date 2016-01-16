From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-stop_machinec-remove-config_smp-dependencies-fix.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 16:34:59 -0800
Message-ID: <56999033.ULJq2He6jaDMcj9c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801AbcAPAe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chris-wilson.co.uk, mingo@kernel.org, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-stop_machinec-remove-config_smp-dependencies-fix
has been removed from the -mm tree.  Its filename was
     kernel-stop_machinec-remove-config_smp-dependencies-fix.patch

This patch was dropped because it was folded into kernel-stop_machinec-remove-config_smp-dependencies.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-stop_machinec-remove-config_smp-dependencies-fix

stop_machine.o is only built if CONFIG_SMP=y, so this ifdef always
evaluates to true.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/stop_machine.c~kernel-stop_machinec-remove-config_smp-dependencies-fix kernel/stop_machine.c
--- a/kernel/stop_machine.c~kernel-stop_machinec-remove-config_smp-dependencies-fix
+++ a/kernel/stop_machine.c
@@ -529,8 +529,6 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int __stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 {
 	struct multi_stop_data msdata = {
@@ -628,5 +626,3 @@ int stop_machine_from_inactive_cpu(cpu_s
 	mutex_unlock(&stop_cpus_mutex);
 	return ret ?: done.ret;
 }
