From: akpm@linux-foundation.org
Subject: + mm-nobootmem-do-memset-after-memblock_reserve.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:04:01 -0700
Message-ID: <20130423230401.D95D15A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51573 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DWXED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:04:03 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so58045qad.4
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:04:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org


The patch titled
     Subject: mm, nobootmem: do memset() after memblock_reserve()
has been added to the -mm tree.  Its filename is
     mm-nobootmem-do-memset-after-memblock_reserve.patch

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
Subject: mm, nobootmem: do memset() after memblock_reserve()

Currently, we do memset() before reserving the area.  This may not cause
any problem, but it is somewhat weird.  So change execution order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmem-do-memset-after-memblock_reserve mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-do-memset-after-memblock_reserve
+++ a/mm/nobootmem.c
@@ -45,9 +45,9 @@ static void * __init __alloc_memory_core
 	if (!addr)
 		return NULL;
 
+	memblock_reserve(addr, size);
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
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

