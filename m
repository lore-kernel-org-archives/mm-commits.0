From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-use-well-defined-find_last_bit-func.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:37 -0700
Message-ID: <52321969.WgWRm+8n/MTuTxpZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3ILTni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: [merged] mm-vmalloc-use-well-defined-find_last_bit-func.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,liwanp@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:37 -0700


The patch titled
     Subject: mm, vmalloc: use well-defined find_last_bit() func
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-well-defined-find_last_bit-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, vmalloc: use well-defined find_last_bit() func

Our intention in here is to find last_bit within the region to flush. 
There is well-defined function, find_last_bit() for this purpose and its
performance may be slightly better than current implementation.  So change
it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-well-defined-find_last_bit-func mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-well-defined-find_last_bit-func
+++ a/mm/vmalloc.c
@@ -1016,15 +1016,16 @@ void vm_unmap_aliases(void)
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-			int i;
+			int i, j;
 
 			spin_lock(&vb->lock);
 			i = find_first_bit(vb->dirty_map, VMAP_BBMAP_BITS);
-			while (i < VMAP_BBMAP_BITS) {
+			if (i < VMAP_BBMAP_BITS) {
 				unsigned long s, e;
-				int j;
-				j = find_next_zero_bit(vb->dirty_map,
-					VMAP_BBMAP_BITS, i);
+
+				j = find_last_bit(vb->dirty_map,
+							VMAP_BBMAP_BITS);
+				j = j + 1; /* need exclusive index */
 
 				s = vb->va->va_start + (i << PAGE_SHIFT);
 				e = vb->va->va_start + (j << PAGE_SHIFT);
@@ -1034,10 +1035,6 @@ void vm_unmap_aliases(void)
 					start = s;
 				if (e > end)
 					end = e;
