From: akpm@linux-foundation.org
Subject: [merged] vmalloc-allow-to-account-vmalloc-to-memcg.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:32:22 -0800
Message-ID: <56997376.9A7iF9UWi+NS0XnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbcAOWcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: allow to account vmalloc to memcg
has been removed from the -mm tree.  Its filename was
     vmalloc-allow-to-account-vmalloc-to-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: vmalloc: allow to account vmalloc to memcg

Make vmalloc family functions allocate vmalloc area pages with
alloc_kmem_pages so that if __GFP_ACCOUNT is set they will be accounted to
memcg.  This is needed, at least, to account alloc_fdmem allocations.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-allow-to-account-vmalloc-to-memcg mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-allow-to-account-vmalloc-to-memcg
+++ a/mm/vmalloc.c
@@ -1477,7 +1477,7 @@ static void __vunmap(const void *addr, i
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
-			__free_page(page);
+			__free_kmem_pages(page, 0);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -1608,9 +1608,9 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_page(alloc_mask);
+			page = alloc_kmem_pages(alloc_mask, order);
 		else
-			page = alloc_pages_node(node, alloc_mask, order);
+			page = alloc_kmem_pages_node(node, alloc_mask, order);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-add-page_check_address_transhuge-helper.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

