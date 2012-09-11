From: akpm@linux-foundation.org
Subject: [merged] mm-ia64-fix-a-node-distance-bug.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:30 -0700
Message-ID: <20120911193231.386FF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34527 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2IKTce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:34 -0400
Received: by lbbge1 with SMTP id ge1so69820lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, jiang.liu@huawei.com, rientjes@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ia64: fix a node distance bug
has been removed from the -mm tree.  Its filename was
     mm-ia64-fix-a-node-distance-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/ia64: fix a node distance bug

ia64 has the following definition:

extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
#define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])

num_online_nodes() is a variable value, it can be changed after
hot-remove/add a node.

I my practice, I found node distance is wrong after offline a node in IA64
platform.  For example system has 4 nodes: node distances:

node   0   1   2   3
  0:  10  21  21  32
  1:  21  10  32  21
  2:  21  32  10  21
  3:  32  21  21  10

linux-drf:/sys/devices/system/node/node0 # cat distance
10  21  21  32
linux-drf:/sys/devices/system/node/node1 # cat distance
21  10  32  21

After offline node2:
linux-drf:/sys/devices/system/node/node0 # cat distance
10 21 32
linux-drf:/sys/devices/system/node/node1 # cat distance
32 21 32	--------->expected value is: 21  10  21

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/numa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/numa.h~mm-ia64-fix-a-node-distance-bug arch/ia64/include/asm/numa.h
--- a/arch/ia64/include/asm/numa.h~mm-ia64-fix-a-node-distance-bug
+++ a/arch/ia64/include/asm/numa.h
@@ -59,7 +59,7 @@ extern struct node_cpuid_s node_cpuid[NR
  */
 
 extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
-#define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])
+#define node_distance(from,to) (numa_slit[(from) * MAX_NUMNODES + (to)])
 
 extern int paddr_to_nid(unsigned long paddr);
 
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-ia64-fix-a-memory-block-size-bug.patch
linux-next.patch

