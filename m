From: akpm@linux-foundation.org
Subject: + mm-nobootmem-clean-up-of-free_low_memory_core_early.patch added to -mm tree
Date: Tue, 23 Apr 2013 16:03:59 -0700
Message-ID: <20130423230359.CEE3431C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:37809 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3DWXEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 19:04:01 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so127611ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 16:04:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org


The patch titled
     Subject: mm, nobootmem: clean-up of free_low_memory_core_early()
has been added to the -mm tree.  Its filename is
     mm-nobootmem-clean-up-of-free_low_memory_core_early.patch

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
Subject: mm, nobootmem: clean-up of free_low_memory_core_early()

Remove unused argument and make function static, because there is no user
outside of nobootmem.c

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    1 -
 mm/nobootmem.c          |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-nobootmem-clean-up-of-free_low_memory_core_early include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-nobootmem-clean-up-of-free_low_memory_core_early
+++ a/include/linux/bootmem.h
@@ -44,7 +44,6 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-extern unsigned long free_low_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
diff -puN mm/nobootmem.c~mm-nobootmem-clean-up-of-free_low_memory_core_early mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-clean-up-of-free_low_memory_core_early
+++ a/mm/nobootmem.c
@@ -120,7 +120,7 @@ static unsigned long __init __free_memor
 	return end_pfn - start_pfn;
 }
 
-unsigned long __init free_low_memory_core_early(int nodeid)
+static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
 	phys_addr_t start, end, size;
@@ -170,7 +170,7 @@ unsigned long __init free_all_bootmem(vo
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
 	 */
-	return free_low_memory_core_early(MAX_NUMNODES);
+	return free_low_memory_core_early();
 }
 
 /**
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

