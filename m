From: akpm@linux-foundation.org
Subject: + mm-remove-unused-parameter-of-pages_correctly_reserved.patch added to -mm tree
Date: Tue, 16 Apr 2013 14:16:34 -0700
Message-ID: <20130416211634.7BDF85A4145@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:59909 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab3DPVQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 17:16:35 -0400
Received: by mail-qe0-f74.google.com with SMTP id b10so95554qen.5
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 14:16:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, gregkh@linuxfoundation.org, wangsl-fnst@cn.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: Remove unused parameter of pages_correctly_reserved()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-parameter-of-pages_correctly_reserved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm: Remove unused parameter of pages_correctly_reserved()

nr_pages is not used in pages_correctly_reserved().
So remove it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~mm-remove-unused-parameter-of-pages_correctly_reserved drivers/base/memory.c
--- a/drivers/base/memory.c~mm-remove-unused-parameter-of-pages_correctly_reserved
+++ a/drivers/base/memory.c
@@ -207,8 +207,7 @@ int memory_isolate_notify(unsigned long
  * The probe routines leave the pages reserved, just as the bootmem code does.
  * Make sure they're still that way.
  */
-static bool pages_correctly_reserved(unsigned long start_pfn,
-					unsigned long nr_pages)
+static bool pages_correctly_reserved(unsigned long start_pfn)
 {
 	int i, j;
 	struct page *page;
@@ -256,7 +255,7 @@ memory_block_action(unsigned long phys_i
 
 	switch (action) {
 		case MEM_ONLINE:
-			if (!pages_correctly_reserved(start_pfn, nr_pages))
+			if (!pages_correctly_reserved(start_pfn))
 				return -EBUSY;
 
 			ret = online_pages(start_pfn, nr_pages, online_type);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

linux-next.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
firmware-memmap-fix-firmware_map_entry-leak.patch
mm-remove-unused-parameter-of-pages_correctly_reserved.patch
mem-hotplug-put-kernel_physical_mapping_remove-declaration-in-config_memory_hotremove.patch
memblock-fix-missing-comment-of-memblock_insert_region.patch

