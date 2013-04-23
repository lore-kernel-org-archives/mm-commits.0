From: akpm@linux-foundation.org
Subject: + mm-highmem-remove-useless-virtual-variable-in-page_address_map.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:07:29 -0700
Message-ID: <20130423230729.7907631C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:47674 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3DWXHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:07:30 -0400
Received: by mail-vb0-f73.google.com with SMTP id p13so24354vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:07:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org


The patch titled
     Subject: mm/highmem.c: remove useless page_address_map.virtual 
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-useless-virtual-variable-in-page_address_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-highmem-remove-useless-virtual-variable-in-page_address_map.patch

