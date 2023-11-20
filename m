Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5437C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjKTSRb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjKTSRa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:17:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47723B9;
        Mon, 20 Nov 2023 10:17:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EF2C433C7;
        Mon, 20 Nov 2023 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700504246;
        bh=dOE9h8d1vJKr0brM57NUgJNNrEZ/Q90jQZFpdfMHOM0=;
        h=Date:To:From:Subject:From;
        b=xLtwAtPbhw2wAONSwLs4IVpGxlrmq1OD+OEFqtF3w30prE1fvkXAOIQtwYr/lmhIW
         9JMRWmDT/6ERL6FrS8PaavJS3RSRRotNOwlixjrnEBmRrc+a5hJgWDMTJj6Q7EckA7
         WSNRz5M1Am76tZoVmqUkYWPRe8zEb+3hnBrZ4Jnk=
Date:   Mon, 20 Nov 2023 10:17:26 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, mhocko@suse.com, lkp@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-add-missing-mem_hotplug_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20231120181726.D6EF2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: add missing mem_hotplug_lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory_hotplug-add-missing-mem_hotplug_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-add-missing-mem_hotplug_lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm/memory_hotplug: add missing mem_hotplug_lock
Date: Mon, 20 Nov 2023 15:53:52 +0100

From Documentation/core-api/memory-hotplug.rst:
When adding/removing/onlining/offlining memory or adding/removing
heterogeneous/device memory, we should always hold the mem_hotplug_lock
in write mode to serialise memory hotplug (e.g. access to global/zone
variables).

mhp_(de)init_memmap_on_memory() functions can change zone stats and
struct page content, but they are currently called w/o the
mem_hotplug_lock.

When memory block is being offlined and when kmemleak goes through each
populated zone, the following theoretical race conditions could occur:
CPU 0:					     | CPU 1:
memory_offline()			     |
-> offline_pages()			     |
	-> mem_hotplug_begin()		     |
	   ...				     |
	-> mem_hotplug_done()		     |
					     | kmemleak_scan()
					     | -> get_online_mems()
					     |    ...
-> mhp_deinit_memmap_on_memory()	     |
  [not protected by mem_hotplug_begin/done()]|
  Marks memory section as offline,	     |   Retrieves zone_start_pfn
  poisons vmemmap struct pages and updates   |   and struct page members.
  the zone related data			     |
   					     |    ...
   					     | -> put_online_mems()

Fix this by ensuring mem_hotplug_lock is taken before performing
mhp_init_memmap_on_memory().  Also ensure that
mhp_deinit_memmap_on_memory() holds the lock.

online/offline_pages() are currently only called from
memory_block_online/offline(), so it is safe to move the locking there.

Link: https://lkml.kernel.org/r/20231120145354.308999-2-sumanthk@linux.ibm.com
Fixes: a08a2ae34613 ("mm,memory_hotplug: allocate memmap from the added memory range")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   18 +++++++++++++++---
 mm/memory_hotplug.c   |   13 ++++++-------
 2 files changed, 21 insertions(+), 10 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-add-missing-mem_hotplug_lock
+++ a/drivers/base/memory.c
@@ -180,6 +180,9 @@ static inline unsigned long memblk_nr_po
 }
 #endif
 
+/*
+ * Must acquire mem_hotplug_lock in write mode.
+ */
 static int memory_block_online(struct memory_block *mem)
 {
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
@@ -204,10 +207,11 @@ static int memory_block_online(struct me
 	if (mem->altmap)
 		nr_vmemmap_pages = mem->altmap->free;
 
+	mem_hotplug_begin();
 	if (nr_vmemmap_pages) {
 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	ret = online_pages(start_pfn + nr_vmemmap_pages,
@@ -215,7 +219,7 @@ static int memory_block_online(struct me
 	if (ret) {
 		if (nr_vmemmap_pages)
 			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -227,9 +231,14 @@ static int memory_block_online(struct me
 					  nr_vmemmap_pages);
 
 	mem->zone = zone;
+out:
+	mem_hotplug_done();
 	return ret;
 }
 
+/*
+ * Must acquire mem_hotplug_lock in write mode.
+ */
 static int memory_block_offline(struct memory_block *mem)
 {
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
@@ -247,6 +256,7 @@ static int memory_block_offline(struct m
 	if (mem->altmap)
 		nr_vmemmap_pages = mem->altmap->free;
 
+	mem_hotplug_begin();
 	if (nr_vmemmap_pages)
 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
@@ -258,13 +268,15 @@ static int memory_block_offline(struct m
 		if (nr_vmemmap_pages)
 			adjust_present_page_count(pfn_to_page(start_pfn),
 						  mem->group, nr_vmemmap_pages);
-		return ret;
+		goto out;
 	}
 
 	if (nr_vmemmap_pages)
 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
 
 	mem->zone = NULL;
+out:
+	mem_hotplug_done();
 	return ret;
 }
 
--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-missing-mem_hotplug_lock
+++ a/mm/memory_hotplug.c
@@ -1129,6 +1129,9 @@ void mhp_deinit_memmap_on_memory(unsigne
 	kasan_remove_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 }
 
+/*
+ * Must be called with mem_hotplug_lock in write mode.
+ */
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
 		       struct zone *zone, struct memory_group *group)
 {
@@ -1149,7 +1152,6 @@ int __ref online_pages(unsigned long pfn
 			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
-	mem_hotplug_begin();
 
 	/* associate pfn range with the zone */
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
@@ -1208,7 +1210,6 @@ int __ref online_pages(unsigned long pfn
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_ONLINE, &arg);
-	mem_hotplug_done();
 	return 0;
 
 failed_addition:
@@ -1217,7 +1218,6 @@ failed_addition:
 		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_ONLINE, &arg);
 	remove_pfn_range_from_zone(zone, pfn, nr_pages);
-	mem_hotplug_done();
 	return ret;
 }
 
@@ -1863,6 +1863,9 @@ static int count_system_ram_pages_cb(uns
 	return 0;
 }
 
+/*
+ * Must be called with mem_hotplug_lock in write mode.
+ */
 int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group)
 {
@@ -1885,8 +1888,6 @@ int __ref offline_pages(unsigned long st
 			 !IS_ALIGNED(start_pfn + nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
-	mem_hotplug_begin();
-
 	/*
 	 * Don't allow to offline memory blocks that contain holes.
 	 * Consequently, memory blocks with holes can never get onlined
@@ -2031,7 +2032,6 @@ int __ref offline_pages(unsigned long st
 
 	memory_notify(MEM_OFFLINE, &arg);
 	remove_pfn_range_from_zone(zone, start_pfn, nr_pages);
-	mem_hotplug_done();
 	return 0;
 
 failed_removal_isolated:
@@ -2046,7 +2046,6 @@ failed_removal:
 		 (unsigned long long) start_pfn << PAGE_SHIFT,
 		 ((unsigned long long) end_pfn << PAGE_SHIFT) - 1,
 		 reason);
-	mem_hotplug_done();
 	return ret;
 }
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch

