From: akpm@linux-foundation.org
Subject: + vmalloc-allow-to-account-vmalloc-to-memcg.patch added to -mm
 tree
Date: Wed, 11 Nov 2015 13:52:11 -0800
Message-ID: <5643b88b.it5d5wwQ33t+6LI4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbbKKVwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: allow to account vmalloc to memcg
has been added to the -mm tree.  Its filename is
     vmalloc-allow-to-account-vmalloc-to-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-allow-to-account-vmalloc-to-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-allow-to-account-vmalloc-to-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: vmalloc: allow to account vmalloc to memcg

Make vmalloc family functions allocate vmalloc area pages with
alloc_kmem_pages so that if __GFP_ACCOUNT is set they will be accounted to
memcg.  This is needed, at least, to account alloc_fdmem allocations.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -1478,7 +1478,7 @@ static void __vunmap(const void *addr, i
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
-			__free_page(page);
+			__free_kmem_pages(page, 0);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -1609,9 +1609,9 @@ static void *__vmalloc_area_node(struct
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

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch

