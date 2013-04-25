From: akpm@linux-foundation.org
Subject: [failures] mm-highmem-remove-useless-virtual-variable-in-page_address_map.patch removed from -mm tree
Date: Thu, 25 Apr 2013 15:02:08 -0700
Message-ID: <20130425220208.EBEE35A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50252 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3DYWCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 18:02:10 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so373996vbb.5
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 15:02:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem.c: remove useless page_address_map.virtual 
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-useless-virtual-variable-in-page_address_map.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/highmem.c: remove useless page_address_map.virtual 

We can get the virtual address without page_address_map.virtual, so remove
it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/highmem.c~mm-highmem-remove-useless-virtual-variable-in-page_address_map mm/highmem.c
--- a/mm/highmem.c~mm-highmem-remove-useless-virtual-variable-in-page_address_map
+++ a/mm/highmem.c
@@ -320,7 +320,6 @@ EXPORT_SYMBOL(kunmap_high);
  */
 struct page_address_map {
 	struct page *page;
-	void *virtual;
 	struct list_head list;
 };
 
@@ -362,7 +361,10 @@ void *page_address(const struct page *pa
 
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
-				ret = pam->virtual;
+				int nr;
+
+				nr = pam - page_address_map;
+				ret = PKMAP_ADDR(nr);
 				goto done;
 			}
 		}
@@ -391,7 +393,6 @@ void set_page_address(struct page *page,
 	if (virtual) {		/* Add */
 		pam = &page_address_maps[PKMAP_NR((unsigned long)virtual)];
 		pam->page = page;
-		pam->virtual = virtual;
 
 		spin_lock_irqsave(&pas->lock, flags);
 		list_add_tail(&pam->list, &pas->lh);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

linux-next.patch
mm-vmalloc-change-iterating-a-vmlist-to-find_vm_area.patch
mm-vmalloc-move-get_vmalloc_info-to-vmallocc.patch
mm-vmalloc-protect-va-vm-by-vmap_area_lock.patch
mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vread-vwrite.patch
mm-vmalloc-iterate-vmap_area_list-in-get_vmalloc_info.patch
mm-vmalloc-iterate-vmap_area_list-instead-of-vmlist-in-vmallocinfo.patch
mm-vmalloc-export-vmap_area_list-instead-of-vmlist.patch
mm-vmalloc-remove-list-management-of-vmlist-after-initializing-vmalloc.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-nobootmem-clean-up-of-free_low_memory_core_early.patch
mm-nobootmem-do-memset-after-memblock_reserve.patch

