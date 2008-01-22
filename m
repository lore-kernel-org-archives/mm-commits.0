From: akpm@linux-foundation.org
Subject: + x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:34:12 -0800
Message-ID: <200801220233.m0M2Xqhh032480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYAVCeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix early cpu_to_node panic from nr_free_zone_pages
has been added to the -mm tree.  Its filename is
     x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix early cpu_to_node panic from nr_free_zone_pages
From: Mike Travis <travis@sgi.com>

An early call to nr_free_zone_pages() calls numa_node_id() which needs to
call early_cpu_to_node() since per_cpu(cpu_to_node_map) might not be setup
yet.

I also had to export x86_cpu_to_node_map_early_ptr because of some calls
from the network code to numa_node_id():

	net/ipv4/netfilter/arp_tables.c:
	net/ipv4/netfilter/ip_tables.c:
	net/ipv4/netfilter/ip_tables.c:

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa_64.c      |    2 --
 include/asm-x86/topology.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/numa_64.c~x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages
+++ a/arch/x86/mm/numa_64.c
@@ -37,9 +37,7 @@ u16 x86_cpu_to_node_map_init[NR_CPUS] = 
 void *x86_cpu_to_node_map_early_ptr;
 DEFINE_PER_CPU(u16, x86_cpu_to_node_map) = NUMA_NO_NODE;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-#ifdef	CONFIG_DEBUG_PER_CPU_MAPS
 EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
-#endif
 
 u16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
diff -puN include/asm-x86/topology.h~x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages
+++ a/include/asm-x86/topology.h
@@ -37,6 +37,8 @@ extern u8 cpu_to_node_map[];
 DECLARE_PER_CPU(u16, x86_cpu_to_node_map);
 extern u16 x86_cpu_to_node_map_init[];
 extern void *x86_cpu_to_node_map_early_ptr;
+/* Returns the number of the current Node. */
+#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
 #endif
 
 extern cpumask_t node_to_cpumask_map[];
_

Patches currently in -mm which might be from travis@sgi.com are

git-x86.patch
x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages.patch
vmstat-remove-prefetch.patch
