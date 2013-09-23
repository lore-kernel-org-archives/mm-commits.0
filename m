From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
Date: Mon, 23 Sep 2013 16:18:50 -0700
Message-ID: <5240cc5a.AcweeKdpeA2b9C73%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3IWXSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 19:18:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [to-be-updated] mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 16:18:50 -0700


The patch titled
     Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"

The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00 ("mm:
avoid null pointer access in vm_struct via /proc/vmallocinfo") is used to
avoid accessing the pages field with unallocated page when
show_numa_info() is called.

This patch moves the check just before show_numa_info in order that some
messages still can be dumped via /proc/vmallocinfo.  This patch reverts
d157a558 ("mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of
show_numa_info").

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info
+++ a/mm/vmalloc.c
@@ -2563,6 +2563,11 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+		if (v->flags & VM_UNINITIALIZED)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2591,11 +2596,6 @@ static int s_show(struct seq_file *m, vo
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
