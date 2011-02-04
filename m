From: akpm@linux-foundation.org
Subject: [wrecked] x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch removed from -mm tree
Date: Fri, 04 Feb 2011 12:44:53 -0800
Message-ID: <201102042044.p14Kirxk017965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab1BDUpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2011 15:45:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     x86, numa: add error handling for bad cpu-to-node mappings
has been removed from the -mm tree.  Its filename was
     x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, numa: add error handling for bad cpu-to-node mappings
From: David Rientjes <rientjes@google.com>

CONFIG_DEBUG_PER_CPU_MAPS may return NUMA_NO_NODE when an
early_cpu_to_node() mapping hasn't been initialized.  In such a case, it
emits a warning and continues without an issue but callers may try to use
the return value to index into an array.

We can catch those errors and fail silently since a warning has already
been emitted.  No current user of numa_add_cpu() requires this error
checking to avoid a crash, but it's better to be proactive in case a
future user happens to have a bug and a user tries to diagnose it with
CONFIG_DEBUG_PER_CPU_MAPS.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_64.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/mm/numa_64.c~x86-numa-add-error-handling-for-bad-cpu-to-node-mappings arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86-numa-add-error-handling-for-bad-cpu-to-node-mappings
+++ a/arch/x86/mm/numa_64.c
@@ -839,6 +839,10 @@ static struct cpumask __cpuinit *debug_c
 	struct cpumask *mask;
 	char buf[64];
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return NULL;
+	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
 		pr_err("node_to_cpumask_map[%i] NULL\n", node);
@@ -877,6 +881,10 @@ static void __cpuinit numa_set_cpumask(i
 	struct cpumask *mask;
 	int i;
 
+	if (node == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
 	for_each_online_node(i) {
 		unsigned long addr;
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch

