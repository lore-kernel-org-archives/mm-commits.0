From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-dont-set-area-caller-twice.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:17 -0800
Message-ID: <5283e339.HYMQmhx7Bhha/7fn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KMUiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, rientjes@google.com, mitsuo.hayasaka.hu@hitachi.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-vmalloc-dont-set-area-caller-twice.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,mitsuo.hayasaka.hu@hitachi.com,rientjes@google.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:17 -0800


The patch titled
     Subject: mm/vmalloc: don't set area->caller twice
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-set-area-caller-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: don't set area->caller twice

The caller address has already been set in set_vmalloc_vm(), there's no
need to set it again in __vmalloc_area_node.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-set-area-caller-twice mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-set-area-caller-twice
+++ a/mm/vmalloc.c
@@ -1546,7 +1546,7 @@ static void *__vmalloc_node(unsigned lon
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				 pgprot_t prot, int node, const void *caller)
+				 pgprot_t prot, int node)
 {
 	const int order = 0;
 	struct page **pages;
@@ -1560,13 +1560,12 @@ static void *__vmalloc_area_node(struct
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
-				PAGE_KERNEL, node, caller);
+				PAGE_KERNEL, node, area->caller);
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
-	area->caller = caller;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
@@ -1634,7 +1633,7 @@ void *__vmalloc_node_range(unsigned long
 	if (!area)
 		goto fail;
 
-	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node);
 	if (!addr)
 		goto fail;
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

