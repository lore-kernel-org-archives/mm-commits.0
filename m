Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB93C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F5A22245
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RaWMmzar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgKPUrm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgKPUrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:47:42 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E90E206D8;
        Mon, 16 Nov 2020 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605559662;
        bh=V21MC/eTN5nwr2bikTC5Tu3+UTYN5inSwoZERrCADdg=;
        h=Date:From:To:Subject:From;
        b=RaWMmzarGRMiKyLWofkxZPmd8UBIceGv2yvZZKfuvsisnUn5bCPzbsvZW14/SOe1A
         +pryVUBjVsaGYHp3aOsLq7XcSjPPDfzd1Bj8x92fCM+chkVHfCMm3TKLsHp3dVHebo
         VST1qU+cNo8aqTVzv1wUAPEyC0e04oQYMuCX4yd8=
Date:   Mon, 16 Nov 2020 12:47:41 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dan.j.williams@intel.com,
        dave.hansen@intel.com, hpa@zytor.com, jgross@suse.com,
        jinyuqi@huawei.com, mhocko@suse.com, mingo@elte.hu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul.burton@mips.com, rppt@linux.ibm.com, rusty@rustcorp.com.au,
        tglx@linutronix.de, zhangshaokun@hisilicon.com
Subject:  [to-be-updated] lib-optimize-cpumask_local_spread.patch
 removed from -mm tree
Message-ID: <20201116204741.bktzYDQQn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: optimize cpumask_local_spread()
has been removed from the -mm tree.  Its filename was
     lib-optimize-cpumask_local_spread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yuqi Jin <jinyuqi@huawei.com>
Subject: lib: optimize cpumask_local_spread()

In multi-processor and NUMA system, I/O driver will find cpu cores that
which shall be bound IRQ.  When cpu cores in the local numa have been
used, it is better to find the node closest to the local numa node for
performance, instead of choosing any online cpu immediately.

Currently, Intel DDIO affects only local sockets, so its performance
improvement is due to the relative difference in performance between the
local socket I/O and remote socket I/O.To ensure that Intel DDIO's
benefits are available to applications where they are most useful, the irq
can be pinned to particular sockets using Intel DDIO.  This arrangement is
called socket affinityi.  So this patch can help Intel DDIO work.  The
same I/O stash function for most processors

On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
system(0 - 1). The topology of this server is followed:
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
node 0 size: 63379 MB
node 0 free: 61899 MB
node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 64509 MB
node 1 free: 63942 MB
node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 2 size: 64509 MB
node 2 free: 63056 MB
node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
node 3 size: 63997 MB
node 3 free: 63420 MB
node distances:
node   0   1   2   3
  0:  10  16  32  33
  1:  16  10  25  32
  2:  32  25  10  16
  3:  33  32  16  10

We perform PS (parameter server) business test, the behavior of the
service is that the client initiates a request through the network card,
the server responds to the request after calculation.  When two PS
processes run on node2 and node3 separately and the network card is
located on 'node2' which is in cpu1, the performance of node2 (26W QPS)
and node3 (22W QPS) is different.

It is better that the NIC queues are bound to the cpu1 cores in turn, then
XPS will also be properly initialized, while cpumask_local_spread only
considers the local node.  When the number of NIC queues exceeds the
number of cores in the local node, it returns to the online core directly.
So when PS runs on node3 sending a calculated request, the performance is
not as good as the node2.

The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
patch, before the patch:

Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
0
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
1
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
22
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
23
After the patch:
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
72
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
73
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
94
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
95

So the performance of the node3 is the same as node2 that is 26W QPS when
the network card is still in 'node2' with the patch.

It is considered that the NIC and other I/O devices shall initialize the
interrupt binding, if the cores of the local node are used up, it is
reasonable to return the node closest to it.  Let's optimize it and find
the nearest node through NUMA distance for the non-local NUMA nodes.

Link: https://lkml.kernel.org/r/1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |   66 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 11 deletions(-)

--- a/lib/cpumask.c~lib-optimize-cpumask_local_spread
+++ a/lib/cpumask.c
@@ -193,6 +193,38 @@ void __init free_bootmem_cpumask_var(cpu
 }
 #endif
 
+static void calc_node_distance(int *node_dist, int node)
+{
+	int i;
+
+	for (i = 0; i < nr_node_ids; i++)
+		node_dist[i] = node_distance(node, i);
+}
+
+static int find_nearest_node(int *node_dist, bool *used)
+{
+	int i, min_dist = node_dist[0], node_id = -1;
+
+	/* Choose the first unused node to compare */
+	for (i = 0; i < nr_node_ids; i++) {
+		if (used[i] == 0) {
+			min_dist = node_dist[i];
+			node_id = i;
+			break;
+		}
+	}
+
+	/* Compare and return the nearest node */
+	for (i = 0; i < nr_node_ids; i++) {
+		if (node_dist[i] < min_dist && used[i] == 0) {
+			min_dist = node_dist[i];
+			node_id = i;
+		}
+	}
+
+	return node_id;
+}
+
 /**
  * cpumask_local_spread - select the i'th cpu with local numa cpu's first
  * @i: index number
@@ -206,7 +238,11 @@ void __init free_bootmem_cpumask_var(cpu
  */
 unsigned int cpumask_local_spread(unsigned int i, int node)
 {
-	int cpu, hk_flags;
+	static DEFINE_SPINLOCK(spread_lock);
+	static int node_dist[MAX_NUMNODES];
+	static bool used[MAX_NUMNODES];
+	unsigned long flags;
+	int cpu, hk_flags, j, id;
 	const struct cpumask *mask;
 
 	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
@@ -220,20 +256,28 @@ unsigned int cpumask_local_spread(unsign
 				return cpu;
 		}
 	} else {
-		/* NUMA first. */
-		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
-			if (i-- == 0)
-				return cpu;
-		}
+		spin_lock_irqsave(&spread_lock, flags);
+		memset(used, 0, nr_node_ids * sizeof(bool));
+		calc_node_distance(node_dist, node);
+		/* Local node first then the nearest node is used */
+		for (j = 0; j < nr_node_ids; j++) {
+			id = find_nearest_node(node_dist, used);
+			if (id < 0)
+				break;
 
-		for_each_cpu(cpu, mask) {
-			/* Skip NUMA nodes, done above. */
-			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
-				continue;
+			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
+				if (i-- == 0) {
+					spin_unlock_irqrestore(&spread_lock,
+							       flags);
+					return cpu;
+				}
+			used[id] = 1;
+		}
+		spin_unlock_irqrestore(&spread_lock, flags);
 
+		for_each_cpu(cpu, mask)
 			if (i-- == 0)
 				return cpu;
-		}
 	}
 	BUG();
 }
_

Patches currently in -mm which might be from jinyuqi@huawei.com are


