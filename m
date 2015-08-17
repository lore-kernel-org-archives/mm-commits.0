From: akpm@linux-foundation.org
Subject: + x86-numa-kill-useless-code-to-improve-code-readability.patch
 added to -mm tree
Date: Mon, 17 Aug 2015 14:36:11 -0700
Message-ID: <55d253cb.S3SuK8S3KocJxxf4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbHQVgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, numa: kill useless code to improve code readability
has been added to the -mm tree.  Its filename is
     x86-numa-kill-useless-code-to-improve-code-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-numa-kill-useless-code-to-improve-code-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-numa-kill-useless-code-to-improve-code-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: x86, numa: kill useless code to improve code readability

According to x86 boot sequence, early_cpu_to_node() always returns
NUMA_NO_NODE when called from numa_init().  So kill useless code to
improve code readability.

Related code sequence as below:
x86_cpu_to_node_map is set until step 2, so it is still the default
value (NUMA_NO_NODE) when accessed at step 1.

start_kernel()
	setup_arch()
		initmem_init()
			x86_numa_init()
				numa_init()
					early_cpu_to_node()
1)						return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
		acpi_boot_init();
		sfi_init()
		x86_dtb_init()
			generic_processor_info()
				early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
		init_cpu_to_node()
			numa_set_node(cpu, node);
2)				per_cpu(x86_cpu_to_node_map, cpu) = node;

	rest_init()
		kernel_init()
			smp_init()
				native_cpu_up()
					start_secondary()
						numa_set_node()
							per_cpu(x86_cpu_to_node_map, cpu) = node;

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/x86/mm/numa.c~x86-numa-kill-useless-code-to-improve-code-readability arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-numa-kill-useless-code-to-improve-code-readability
+++ a/arch/x86/mm/numa.c
@@ -593,8 +593,6 @@ static void __init numa_init_array(void)
 
 	rr = first_node(node_online_map);
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (early_cpu_to_node(i) != NUMA_NO_NODE)
-			continue;
 		numa_set_node(i, rr);
 		rr = next_node(rr, node_online_map);
 		if (rr == MAX_NUMNODES)
@@ -646,14 +644,6 @@ static int __init numa_init(int (*init_f
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int nid = early_cpu_to_node(i);
