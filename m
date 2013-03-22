From: akpm@linux-foundation.org
Subject: [merged] mm-ia64-fix-build-error-for-numa_clear_node-under-ia64.patch removed from -mm tree
Date: Fri, 22 Mar 2013 11:56:33 -0700
Message-ID: <20130322185633.8C4695A440C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53725 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3CVS4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 14:56:41 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so407121vcb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 11:56:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangyijing@huawei.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ia64: fix build error for numa_clear_node() under IA64
has been removed from the -mm tree.  Its filename was
     mm-ia64-fix-build-error-for-numa_clear_node-under-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yijing Wang <wangyijing@huawei.com>
Subject: mm/ia64: fix build error for numa_clear_node() under IA64

numa_clear_node() function is not implemented under IA64,
it will be called in unmap_cpu_on_node() in mm/memory_hotplug.c.
This cause build error under IA64, this patch add numa_clear_node()
in IA64 to fix this problem.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/numa.h |    5 ++---
 arch/ia64/mm/numa.c          |    5 +++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/ia64/include/asm/numa.h~mm-ia64-fix-build-error-for-numa_clear_node-under-ia64 arch/ia64/include/asm/numa.h
--- a/arch/ia64/include/asm/numa.h~mm-ia64-fix-build-error-for-numa_clear_node-under-ia64
+++ a/arch/ia64/include/asm/numa.h
@@ -67,14 +67,13 @@ extern int paddr_to_nid(unsigned long pa
 
 extern void map_cpu_to_node(int cpu, int nid);
 extern void unmap_cpu_from_node(int cpu, int nid);
-
+extern void numa_clear_node(int cpu);
 
 #else /* !CONFIG_NUMA */
 #define map_cpu_to_node(cpu, nid)	do{}while(0)
 #define unmap_cpu_from_node(cpu, nid)	do{}while(0)
-
 #define paddr_to_nid(addr)	0
-
+#define numa_clear_node(cpu)	do { } while (0)
 #endif /* CONFIG_NUMA */
 
 #endif /* _ASM_IA64_NUMA_H */
diff -puN arch/ia64/mm/numa.c~mm-ia64-fix-build-error-for-numa_clear_node-under-ia64 arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-ia64-fix-build-error-for-numa_clear_node-under-ia64
+++ a/arch/ia64/mm/numa.c
@@ -73,6 +73,11 @@ int __meminit __early_pfn_to_nid(unsigne
 	return -1;
 }
 
+void numa_clear_node(int cpu)
+{
+	unmap_cpu_from_node(cpu, NUMA_NO_NODE);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  *  SRAT information is stored in node_memblk[], then we can use SRAT
_

Patches currently in -mm which might be from wangyijing@huawei.com are

linux-next.patch

