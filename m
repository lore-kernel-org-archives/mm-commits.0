Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF14BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4CC2063A
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597808349;
	bh=Q/D5mnhx4sdKq4hI/yJYa5aEEW+anTVnhncx2x5jwZ4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=W8eskiQL02LNlNc/JdswtMfR/SgS4yuTCoIo8u6M844leZB9Gp1jvS89B6mfPtVNA
	 mlh4wG1YGZKE3vox+ByIW6RB1is3Y81qezOJcECAg2tAWSfONsPJYOuUO0MBbHFoLT
	 Q02uJUDJQC08exAmJaxwdB9vhD4o9xgl5GcTTrF0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHSDjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbgHSDjI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:39:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01D6E2078B;
        Wed, 19 Aug 2020 03:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808347;
        bh=Q/D5mnhx4sdKq4hI/yJYa5aEEW+anTVnhncx2x5jwZ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bwJZ9lL9RGPpMwsgzt51l1xuJKb+u4SvS6uCJ8Hq0s7bjGND1alNa4+L7fGfXa+/f
         nrW7Peu8SAdFQebEFjEnkumn/FvlDk+9xfMdMWZYCUXcZ+4Kur+KDc9dmDxTSFLf6z
         8ZbWJgFQrXzwH+24G4IZ2UuLiubsFZY2sadOYf68=
Date:   Tue, 18 Aug 2020 20:39:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, david@redhat.com, ego@linux.vnet.ibm.com,
        kirill@shutemov.name, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        sathnaga@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com,
        vbabka@suse.cz
Subject:  [to-be-updated]
 mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch removed from -mm
 tree
Message-ID: <20200819033906.3wZufhUOM%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: keep memoryless cpuless node 0 offline
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-keep-memoryless-cpuless-node-0-offline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: mm/page_alloc: keep memoryless cpuless node 0 offline

Currently Linux kernel with CONFIG_NUMA on a system with multiple possible
nodes, marks node 0 as online at boot.  However in practice, there are
systems which have node 0 as memoryless and cpuless.

This can cause numa_balancing to be enabled on systems with only one node
with memory and CPUs.  The existence of this dummy node which is cpuless
and memoryless node can confuse users/scripts looking at output of lscpu /
numactl.

By marking, N_ONLINE as NODE_MASK_NONE, lets stop assuming that Node 0 is
always online.

v5.8-rc2
 available: 2 nodes (0,2)
 node 0 cpus:
 node 0 size: 0 MB
 node 0 free: 0 MB
 node 2 cpus: 0 1 2 3 4 5 6 7
 node 2 size: 32625 MB
 node 2 free: 31490 MB
 node distances:
 node   0   2
   0:  10  20
   2:  20  10

proc and sys files
------------------
 /sys/devices/system/node/online:            0,2
 /proc/sys/kernel/numa_balancing:            1
 /sys/devices/system/node/has_cpu:           2
 /sys/devices/system/node/has_memory:        2
 /sys/devices/system/node/has_normal_memory: 2
 /sys/devices/system/node/possible:          0-31

v5.8-rc2 + patch
------------------
 available: 1 nodes (2)
 node 2 cpus: 0 1 2 3 4 5 6 7
 node 2 size: 32625 MB
 node 2 free: 31487 MB
 node distances:
 node   2
   2:  10

proc and sys files
------------------
/sys/devices/system/node/online:            2
/proc/sys/kernel/numa_balancing:            0
/sys/devices/system/node/has_cpu:           2
/sys/devices/system/node/has_memory:        2
/sys/devices/system/node/has_normal_memory: 2
/sys/devices/system/node/possible:          0-31

Note: On Powerpc, cpu_to_node of possible but not present cpus would
previously return 0.  Hence this commit depends on commit ("powerpc/numa:
Set numa_node for all possible cpus") and commit ("powerpc/numa: Prefer
node id queried from vphn").  Without the 2 commits, Powerpc system might
crash.

1. User space applications like Numactl, lscpu, that parse the sysfs
   tend to believe there is an extra online node.  This tends to confuse
   users and applications.  Other user space applications start believing
   that system was not able to use all the resources (i.e missing
   resources) or the system was not setup correctly.

2. Also existence of dummy node also leads to inconsistent
   information.  The number of online nodes is inconsistent with the
   information in the device-tree and resource-dump

3. When the dummy node is present, single node non-Numa systems end up
   showing up as NUMA systems and numa_balancing gets enabled.  This will
   mean we take the hit from the unnecessary numa hinting faults.

Link: http://lkml.kernel.org/r/20200624092846.9194-4-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christopher Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-keep-memoryless-cpuless-node-0-offline
+++ a/mm/page_alloc.c
@@ -117,8 +117,10 @@ EXPORT_SYMBOL(latent_entropy);
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_POSSIBLE] = NODE_MASK_ALL,
+#ifdef CONFIG_NUMA
+	[N_ONLINE] = NODE_MASK_NONE,
+#else
 	[N_ONLINE] = { { [0] = 1UL } },
-#ifndef CONFIG_NUMA
 	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

powerpc-numa-set-numa_node-for-all-possible-cpus.patch
powerpc-numa-prefer-node-id-queried-from-vphn.patch

