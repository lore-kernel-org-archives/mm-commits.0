From: akpm@linux-foundation.org
Subject: [merged] mm-update-the-document-of-numa_zonelist_order.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:54 -0700
Message-ID: <5723dac2.jHvn2PzZC/GLnrbq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbcD2WFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: update numa_zonelist_order description
has been removed from the -mm tree.  Its filename was
     mm-update-the-document-of-numa_zonelist_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: Documentation/sysctl/vm.txt: update numa_zonelist_order description

3193913ce62c ("mm: page_alloc: default node-ordering on 64-bit NUMA,
zone-ordering on 32-bit") changes the default value of
numa_zonelist_order.  Update the document.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-update-the-document-of-numa_zonelist_order Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-update-the-document-of-numa_zonelist_order
+++ a/Documentation/sysctl/vm.txt
@@ -581,15 +581,16 @@ Specify "[Nn]ode" for node order
 "Zone Order" orders the zonelists by zone type, then by node within each
 zone.  Specify "[Zz]one" for zone order.
 
-Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
-will select "node" order in following case.
-(1) if the DMA zone does not exist or
-(2) if the DMA zone comprises greater than 50% of the available memory or
-(3) if any node's DMA zone comprises greater than 70% of its local memory and
-    the amount of local memory is big enough.
+Specify "[Dd]efault" to request automatic configuration.
 
-Otherwise, "zone" order will be selected. Default order is recommended unless
-this is causing problems for your system/application.
+On 32-bit, the Normal zone needs to be preserved for allocations accessible
+by the kernel, so "zone" order will be selected.
+
+On 64-bit, devices that require DMA32/DMA are relatively rare, so "node"
+order will be selected.
+
+Default order is recommended unless this is causing problems for your
+system/application.
 
 ==============================================================
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


