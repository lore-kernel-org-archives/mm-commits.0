From: akpm@linux-foundation.org
Subject: + smp_call_function_any-pass-the-node-value-to-cpumask_of_node.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:14:29 -0800
Message-ID: <201001090014.o090ETJ9022858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233Ab0AIAPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidjon@xenontk.org, hpa@zytor.com, mingo@elte.hu, rusty@rustcorp.com.au, suresh.b.siddha@intel.com, tglx@linutronix.de


The patch titled
     smp_call_function_any(): pass the node value to cpumask_of_node()
has been added to the -mm tree.  Its filename is
     smp_call_function_any-pass-the-node-value-to-cpumask_of_node.patch

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

linux-next.patch
smp_call_function_any-pass-the-node-value-to-cpumask_of_node.patch

