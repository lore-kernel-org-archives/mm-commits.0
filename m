From: akpm@linux-foundation.org
Subject: + mm-initialize-per_cpu_nodestats-for-hotadded-pgdats.patch added to -mm tree
Date: Thu, 11 Aug 2016 14:00:16 -0700
Message-ID: <57ace760.TVfyCNx34AKFjhDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcHKVAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, mgorman@techsingularity.net, paulus@ozlabs.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: initialize per_cpu_nodestats for hotadded pgdats
has been added to the -mm tree.  Its filename is
     mm-initialize-per_cpu_nodestats-for-hotadded-pgdats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-per_cpu_nodestats-for-hotadded-pgdats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-per_cpu_nodestats-for-hotadded-pgdats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: mm/memory_hotplug.c: initialize per_cpu_nodestats for hotadded pgdats

The following oops occurs after a pgdat is hotadded:

[   86.839956] Unable to handle kernel paging request for data at address 0x00c30001
[   86.840132] Faulting instruction address: 0xc00000000022f8f4
[   86.840328] Oops: Kernel access of bad area, sig: 11 [#1]
[   86.840468] SMP NR_CPUS=2048 NUMA pSeries
[   86.840612] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter nls_utf8 isofs sg virtio_balloon uio_pdrv_genirq uio ip_tables xfs libcrc32c sr_mod cdrom sd_mod virtio_net ibmvscsi scsi_transport_srp virtio_pci virtio_ring virtio dm_mirror dm_region_hash dm_log dm_mod
[   86.842955] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W 4.8.0-rc1-device #110
[   86.843140] task: c000000000ef3080 task.stack: c000000000f6c000
[   86.843323] NIP: c00000000022f8f4 LR: c00000000022f948 CTR: 0000000000000000
[   86.843595] REGS: c000000000f6fa50 TRAP: 0300   Tainted: G        W (4.8.0-rc1-device)
[   86.843889] MSR: 800000010280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 84002028  XER: 20000000
[   86.844624] CFAR: d000000001d2013c DAR: 0000000000c30001 DSISR: 40000000 SOFTE: 0
GPR00: c00000000022f948 c000000000f6fcd0 c000000000f71400 0000000000000001
GPR04: 0000000000000100 0000000000000000 0000000000000000 0000000000c30000
GPR08: ffffffffffffffff 0000000000000001 0000000000c30000 00000000ffffffff
GPR12: 0000000000002200 c000000001300000 c000000000faefb4 c000000000faefa8
GPR16: c000000000f6c000 c000000000f6c080 c000000000bf15b0 c000000000f6c080
GPR20: c000000000bf4928 0000000000000000 0000000000000003 c000000000bf4968
GPR24: c0000000ffed0000 0000000000000000 0000000000000000 c000000000f6fd58
GPR28: 0000000000000001 0000000000000001 c000000000f6fcf0 c0000000ffed9c08
[   86.847747] NIP [c00000000022f8f4] refresh_cpu_vm_stats+0x1a4/0x2f0
[   86.847897] LR [c00000000022f948] refresh_cpu_vm_stats+0x1f8/0x2f0
[   86.848060] Call Trace:
[   86.848183] [c000000000f6fcd0] [c00000000022f948] refresh_cpu_vm_stats+0x1f8/0x2f0 (unreliable)

Add per_cpu_nodestats initialization to the hotplug codepath.

Link: http://lkml.kernel.org/r/1470931473-7090-1-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory_hotplug.c~mm-initialize-per_cpu_nodestats-for-hotadded-pgdats mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-initialize-per_cpu_nodestats-for-hotadded-pgdats
+++ a/mm/memory_hotplug.c
@@ -1219,6 +1219,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
 	free_area_init_node(nid, zones_size, start_pfn, zholes_size);
+	pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
@@ -1249,6 +1250,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
 {
 	arch_refresh_nodedata(nid, NULL);
+	free_percpu(pgdat->per_cpu_nodestats);
 	arch_free_nodedata(pgdat);
 	return;
 }
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are

mm-initialize-per_cpu_nodestats-for-hotadded-pgdats.patch

