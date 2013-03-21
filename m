From: akpm@linux-foundation.org
Subject: + mm-ia64-fix-build-error-for-numa_clear_node-under-ia64.patch added to -mm tree
Date: Thu, 21 Mar 2013 14:42:48 -0700
Message-ID: <20130321214248.7DC3331C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:56841 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3CUVmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 17:42:49 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so14350qeb.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 14:42:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangyijing@huawei.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm/ia64: fix build error for numa_clear_node() under IA64
has been added to the -mm tree.  Its filename is
     mm-ia64-fix-build-error-for-numa_clear_node-under-ia64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-ia64-fix-build-error-for-numa_clear_node-under-ia64.patch

