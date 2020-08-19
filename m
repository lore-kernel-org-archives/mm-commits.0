Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46457C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2320B2063A
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597808387;
	bh=j43yDmXRNSfzW8/CTwVE6U1P+i/wJ6vVkFI64Mgv90Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=I0Zf1ng9kerCuD/Hxa6DB9BS9grW0aN9lhNXhJe7sNpDFSHm0ZQp5CAKjfMINUKCT
	 9B3PYinA6EYGmF2WAb3IEidpscgf3ELP1GAfuWYCRAM7oukrJO6OSPg/LL09qnr/E0
	 8UrugXNNXpEdTsxIDnjhXPW7a7aZnMNU5qU3IWZ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSDjq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgHSDjo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:39:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 251E62063A;
        Wed, 19 Aug 2020 03:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808383;
        bh=j43yDmXRNSfzW8/CTwVE6U1P+i/wJ6vVkFI64Mgv90Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EGKYv2g6S1CFJW1fOvJwgF0SbVNBI0aTOUju8n/Gb+bG8t8tewIJBR7oZn38fU7np
         wS1/XBNUHvnokzQx218n3HIoi/Kx65I7Etv6A/bfu48hQcgOACKDoiBW3fcG0RaYu8
         DGkait9WvUzlXybpCzwJiuJuy3JsuGYrmyoBfKKQ=
Date:   Tue, 18 Aug 2020 20:39:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, david@redhat.com, ego@linux.vnet.ibm.com,
        kirill@shutemov.name, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        sathnaga@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com,
        vbabka@suse.cz
Subject:  [to-be-updated]
 powerpc-numa-set-numa_node-for-all-possible-cpus.patch removed from -mm
 tree
Message-ID: <20200819033942.zN7mIXdAU%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/numa: set numa_node for all possible cpus
has been removed from the -mm tree.  Its filename was
     powerpc-numa-set-numa_node-for-all-possible-cpus.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: powerpc/numa: set numa_node for all possible cpus

Patch series "Offline memoryless cpuless node 0", v5.

Linux kernel configured with CONFIG_NUMA on a system with multiple
   possible nodes, marks node 0 as online at boot.  However in practice,
   there are systems which have node 0 as memoryless and cpuless.

This can cause
1. numa_balancing to be enabled on systems with only one online node.
2. Existence of dummy (cpuless and memoryless) node which can confuse
users/scripts looking at output of lscpu / numactl.

This patchset wants to correct this anomaly.

This should only affect systems that have CONFIG_MEMORYLESS_NODES. 
   Currently there are only 2 architectures ia64 and powerpc that have
   this config.

Note: Patch 3 in this patch series depends on patches 1 and 2.  Without
   patches 1 and 2, patch 3 might crash powerpc.


This patch (of 3):

A Powerpc system with multiple possible nodes and with CONFIG_NUMA enabled
always used to have a node 0, even if node 0 does not any cpus or memory
attached to it.  As per PAPR, node affinity of a cpu is only available
once its present / online.  For all cpus that are possible but not
present, cpu_to_node() would point to node 0.

To ensure a cpuless, memoryless dummy node is not online, powerpc need to
make sure all possible but not present cpu_to_node are set to a proper
node.

Link: http://lkml.kernel.org/r/20200624092846.9194-1-srikar@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/20200624092846.9194-2-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christopher Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c~powerpc-numa-set-numa_node-for-all-possible-cpus
+++ a/arch/powerpc/mm/numa.c
@@ -506,6 +506,11 @@ static int numa_setup_cpu(unsigned long
 	int fcpu = cpu_first_thread_sibling(lcpu);
 	int nid = NUMA_NO_NODE;
 
+	if (!cpu_present(lcpu)) {
+		set_cpu_numa_node(lcpu, first_online_node);
+		return first_online_node;
+	}
+
 	/*
 	 * If a valid cpu-to-node mapping is already available, use it
 	 * directly instead of querying the firmware, since it represents
@@ -931,8 +936,17 @@ void __init mem_topology_setup(void)
 
 	reset_numa_cpu_lookup_table();
 
-	for_each_present_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		/*
+		 * Powerpc with CONFIG_NUMA always used to have a node 0,
+		 * even if it was memoryless or cpuless. For all cpus that
+		 * are possible but not present, cpu_to_node() would point
+		 * to node 0. To remove a cpuless, memoryless dummy node,
+		 * powerpc need to make sure all possible but not present
+		 * cpu_to_node are set to a proper node.
+		 */
 		numa_setup_cpu(cpu);
+	}
 }
 
 void __init initmem_init(void)
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

powerpc-numa-prefer-node-id-queried-from-vphn.patch

