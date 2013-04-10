From: akpm@linux-foundation.org
Subject: + mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:44:33 -0700
Message-ID: <20130410214433.F39FF5A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:58418 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936783Ab3DJVog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:44:36 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so228199obc.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:44:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: change __remove_pages() to call release_mem_region_adjustable()
has been added to the -mm tree.  Its filename is
     mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: change __remove_pages() to call release_mem_region_adjustable()

Chang __remove_pages() to call release_mem_region_adjustable().  This
allows a requested memory range to be released from the iomem_resource
table even if it does not match exactly to an resource entry but still
fits into.  The resource entries initialized at bootup usually cover the
whole contiguous memory ranges and may not necessarily match with the size
of memory hot-delete requests.

If release_mem_region_adjustable() failed, __remove_pages() emits a
warning message and continues to proceed as it was the case with
release_mem_region().  release_mem_region(), which is defined to
__release_region(), emits a warning message and returns no error since a
void function.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by : Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-change-__remove_pages-to-call-release_mem_region_adjustable mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-change-__remove_pages-to-call-release_mem_region_adjustable
+++ a/mm/memory_hotplug.c
@@ -705,8 +705,10 @@ EXPORT_SYMBOL_GPL(__add_pages);
 int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 		 unsigned long nr_pages)
 {
-	unsigned long i, ret = 0;
+	unsigned long i;
 	int sections_to_remove;
+	resource_size_t start, size;
+	int ret = 0;
 
 	/*
 	 * We can only remove entire sections
@@ -714,7 +716,12 @@ int __remove_pages(struct zone *zone, un
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
-	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
+	start = phys_start_pfn << PAGE_SHIFT;
+	size = nr_pages * PAGE_SIZE;
+	ret = release_mem_region_adjustable(&iomem_resource, start, size);
+	if (ret)
+		pr_warn("Unable to release resource <%016llx-%016llx> (%d)\n",
+				start, start + size - 1, ret);
 
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mm-walk_memory_range-fix-typo-in-comment.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch

