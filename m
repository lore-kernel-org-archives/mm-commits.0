From: akpm@linux-foundation.org
Subject: [merged] smp_call_function_any-pass-the-node-value-to-cpumask_of_node.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:48 -0800
Message-ID: <201001212127.o0LLRmXG030670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab0AUV2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidjon@xenontk.org, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     smp_call_function_any(): pass the node value to cpumask_of_node()
has been removed from the -mm tree.  Its filename was
     smp_call_function_any-pass-the-node-value-to-cpumask_of_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smp_call_function_any(): pass the node value to cpumask_of_node()
From: David John <davidjon@xenontk.org>

The change in acpi_cpufreq to use smp_call_function_any causes a warning
when it is called since the function erroneously passes the cpu id to
cpumask_of_node rather than the node that the cpu is on.  Fix this.

cpumask_of_node(3): node > nr_node_ids(1)
Pid: 1, comm: swapper Not tainted 2.6.33-rc3-00097-g2c1f189 #223
Call Trace:
 [<ffffffff81028bb3>] cpumask_of_node+0x23/0x58
 [<ffffffff81061f51>] smp_call_function_any+0x65/0xfa
 [<ffffffff810160d1>] ? do_drv_read+0x0/0x2f
 [<ffffffff81015fba>] get_cur_val+0xb0/0x102
 [<ffffffff81016080>] get_cur_freq_on_cpu+0x74/0xc5
 [<ffffffff810168a7>] acpi_cpufreq_cpu_init+0x417/0x515
 [<ffffffff81562ce9>] ? __down_write+0xb/0xd
 [<ffffffff8148055e>] cpufreq_add_dev+0x278/0x922

Signed-off-by: David John <davidjon@xenontk.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~smp_call_function_any-pass-the-node-value-to-cpumask_of_node kernel/smp.c
--- a/kernel/smp.c~smp_call_function_any-pass-the-node-value-to-cpumask_of_node
+++ a/kernel/smp.c
@@ -347,7 +347,7 @@ int smp_call_function_any(const struct c
 		goto call;
 
 	/* Try for same node. */
-	nodemask = cpumask_of_node(cpu);
+	nodemask = cpumask_of_node(cpu_to_node(cpu));
 	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
 	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
 		if (cpu_online(cpu))
_

Patches currently in -mm which might be from davidjon@xenontk.org are

origin.patch

