From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:19 -0800
Message-ID: <5283e33b.clLHUIyOA68CXbI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, mitsuo.hayasaka.hu@hitachi.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mitsuo.hayasaka.hu@hitachi.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:19 -0800


The patch titled
     Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: revert "mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of show_numa_info"

The VM_UNINITIALIZED/VM_UNLIST flag introduced by f5252e00 ("mm:
avoid null pointer access in vm_struct via /proc/vmallocinfo") is used to
avoid accessing the pages field with unallocated page when
show_numa_info() is called.  This patch move the check just before
show_numa_info in order that some messages still can be dumped via
/proc/vmallocinfo.  This patch revert commit d157a558 ("mm/vmalloc.c: check
VM_UNINITIALIZED flag in s_show instead of show_numa_info");

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info
+++ a/mm/vmalloc.c
@@ -2562,6 +2562,11 @@ static void show_numa_info(struct seq_fi
 		if (!counters)
 			return;
 
+		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+		smp_rmb();
+		if (v->flags & VM_UNINITIALIZED)
+			return;
+
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 		for (nr = 0; nr < v->nr_pages; nr++)
@@ -2587,11 +2592,6 @@ static int s_show(struct seq_file *m, vo
 
 	v = va->vm;
 
-	/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-	smp_rmb();
-	if (v->flags & VM_UNINITIALIZED)
-		return 0;
