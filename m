Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A75C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 28 Nov 2023 23:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346685AbjK1X6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 18:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345005AbjK1X6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 18:58:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D52198D
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 15:58:58 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFAAC433C9;
        Tue, 28 Nov 2023 23:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701215937;
        bh=nbn8rD82IbdHXgDKcjrQg6j8bTP6kg5QVSj21V4rPnE=;
        h=Date:To:From:Subject:From;
        b=rfeV3UWU37CyFrUF4fYN1jsiUkoy/Dvf8DJN5i4dHL5XwJlFVsAt7wvNoxShpBptm
         Gufa4rqUmzxce5vDl+3xmuYDsQkcYXO+G3hgLpn1tgFWyHtCsLGq+h3ZIE8k1McepG
         lXtkg018ow3e/eRGHDAdWX42IY8LCEdwRrs+L0hQ=
Date:   Tue, 28 Nov 2023 15:58:57 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch added to mm-unstable branch
Message-Id: <20231128235857.AAFAAC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/memory_hotplug: introduce MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Tue, 28 Nov 2023 16:52:23 +0100

Patch series "implement "memmap on memory" feature on s390", v5.

Introduce MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE memory notifiers to
prepare the transition of memory to and from a physically accessible
state.  This enhancement is crucial for implementing the "memmap on
memory" feature for s390 in a subsequent patch.

Platforms such as x86 can support physical memory hotplug via ACPI. When
there is physical memory hotplug, ACPI event leads to the memory
addition with the following callchain:
acpi_memory_device_add()
  -> acpi_memory_enable_device()
     -> __add_memory()

After this, the hotplugged memory is physically accessible, and altmap
support prepared, before the "memmap on memory" initialization in
memory_block_online() is called.

On s390, memory hotplug works in a different way.  The available hotplug
memory has to be defined upfront in the hypervisor, but it is made
physically accessible only when the user sets it online via sysfs,
currently in the MEM_GOING_ONLINE notifier.  This is too late and "memmap
on memory" initialization is performed before calling MEM_GOING_ONLINE
notifier.

During the memory hotplug addition phase, altmap support is prepared and
during the memory onlining phase s390 requires memory to be physically
accessible and then subsequently initiate the "memmap on memory"
initialization process.

The memory provider will handle new MEM_PREPARE_ONLINE /
MEM_FINISH_OFFLINE notifications and make the memory accessible.

The mhp_flag MHP_OFFLINE_INACCESSIBLE is introduced and is relevant when
used along with MHP_MEMMAP_ON_MEMORY, because the altmap cannot be written
(e.g., poisoned) when adding memory -- before it is set online.  This
allows for adding memory with an altmap that is not currently made
available by a hypervisor.  When onlining that memory, the hypervisor can
be instructed to make that memory accessible via the new notifiers and the
onlining phase will not require any memory allocations, which is helpful
in low-memory situations.

All architectures ignore unknown memory notifiers.  Therefore, the
introduction of these new notifiers does not result in any functional
modifications across architectures.

Link: https://lkml.kernel.org/r/20231128155227.1315063-1-sumanthk@linux.ibm.com
Link: https://lkml.kernel.org/r/20231128155227.1315063-2-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   23 ++++++++++++++++++++++-
 include/linux/memory.h         |    9 +++++++++
 include/linux/memory_hotplug.h |   18 +++++++++++++++++-
 include/linux/memremap.h       |    1 +
 mm/memory_hotplug.c            |   13 ++++++++++++-
 mm/sparse.c                    |    3 ++-
 6 files changed, 63 insertions(+), 4 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/drivers/base/memory.c
@@ -188,6 +188,7 @@ static int memory_block_online(struct me
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = 0;
+	struct memory_notify arg;
 	struct zone *zone;
 	int ret;
 
@@ -207,9 +208,19 @@ static int memory_block_online(struct me
 	if (mem->altmap)
 		nr_vmemmap_pages = mem->altmap->free;
 
+	arg.altmap_start_pfn = start_pfn;
+	arg.altmap_nr_pages = nr_vmemmap_pages;
+	arg.start_pfn = start_pfn + nr_vmemmap_pages;
+	arg.nr_pages = nr_pages - nr_vmemmap_pages;
 	mem_hotplug_begin();
+	ret = memory_notify(MEM_PREPARE_ONLINE, &arg);
+	ret = notifier_to_errno(ret);
+	if (ret)
+		goto out_notifier;
+
 	if (nr_vmemmap_pages) {
-		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
+		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages,
+						zone, mem->altmap->inaccessible);
 		if (ret)
 			goto out;
 	}
@@ -231,7 +242,11 @@ static int memory_block_online(struct me
 					  nr_vmemmap_pages);
 
 	mem->zone = zone;
+	mem_hotplug_done();
+	return ret;
 out:
+	memory_notify(MEM_FINISH_OFFLINE, &arg);
+out_notifier:
 	mem_hotplug_done();
 	return ret;
 }
@@ -244,6 +259,7 @@ static int memory_block_offline(struct m
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = 0;
+	struct memory_notify arg;
 	int ret;
 
 	if (!mem->zone)
@@ -275,6 +291,11 @@ static int memory_block_offline(struct m
 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
 
 	mem->zone = NULL;
+	arg.altmap_start_pfn = start_pfn;
+	arg.altmap_nr_pages = nr_vmemmap_pages;
+	arg.start_pfn = start_pfn + nr_vmemmap_pages;
+	arg.nr_pages = nr_pages - nr_vmemmap_pages;
+	memory_notify(MEM_FINISH_OFFLINE, &arg);
 out:
 	mem_hotplug_done();
 	return ret;
--- a/include/linux/memory.h~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/include/linux/memory.h
@@ -96,8 +96,17 @@ int set_memory_block_size_order(unsigned
 #define	MEM_GOING_ONLINE	(1<<3)
 #define	MEM_CANCEL_ONLINE	(1<<4)
 #define	MEM_CANCEL_OFFLINE	(1<<5)
+#define	MEM_PREPARE_ONLINE	(1<<6)
+#define	MEM_FINISH_OFFLINE	(1<<7)
 
 struct memory_notify {
+	/*
+	 * The altmap_start_pfn and altmap_nr_pages fields are designated for
+	 * specifying the altmap range and are exclusively intended for use in
+	 * MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
+	 */
+	unsigned long altmap_start_pfn;
+	unsigned long altmap_nr_pages;
 	unsigned long start_pfn;
 	unsigned long nr_pages;
 	int status_change_nid_normal;
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/include/linux/memory_hotplug.h
@@ -106,6 +106,22 @@ typedef int __bitwise mhp_t;
  * implies the node id (nid).
  */
 #define MHP_NID_IS_MGID		((__force mhp_t)BIT(2))
+/*
+ * The hotplugged memory is completely inaccessible while the memory is
+ * offline. The memory provider will handle MEM_PREPARE_ONLINE /
+ * MEM_FINISH_OFFLINE notifications and make the memory accessible.
+ *
+ * This flag is only relevant when used along with MHP_MEMMAP_ON_MEMORY,
+ * because the altmap cannot be written (e.g., poisoned) when adding
+ * memory -- before it is set online.
+ *
+ * This allows for adding memory with an altmap that is not currently
+ * made available by a hypervisor. When onlining that memory, the
+ * hypervisor can be instructed to make that memory available, and
+ * the onlining phase will not require any memory allocations, which is
+ * helpful in low-memory situations.
+ */
+#define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
 
 /*
  * Extended parameters for memory hotplug:
@@ -154,7 +170,7 @@ extern void adjust_present_page_count(st
 				      long nr_pages);
 /* VM interface that may be used by firmware interface */
 extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-				     struct zone *zone);
+				     struct zone *zone, bool mhp_off_inaccessible);
 extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group);
--- a/include/linux/memremap.h~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/include/linux/memremap.h
@@ -25,6 +25,7 @@ struct vmem_altmap {
 	unsigned long free;
 	unsigned long align;
 	unsigned long alloc;
+	bool inaccessible;
 };
 
 /*
--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/mm/memory_hotplug.c
@@ -1084,7 +1084,7 @@ void adjust_present_page_count(struct pa
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
-			      struct zone *zone)
+			      struct zone *zone, bool mhp_off_inaccessible)
 {
 	unsigned long end_pfn = pfn + nr_pages;
 	int ret, i;
@@ -1093,6 +1093,15 @@ int mhp_init_memmap_on_memory(unsigned l
 	if (ret)
 		return ret;
 
+	/*
+	 * Memory block is accessible at this stage and hence poison the struct
+	 * pages now.  If the memory block is accessible during memory hotplug
+	 * addition phase, then page poisining is already performed in
+	 * sparse_add_section().
+	 */
+	if (mhp_off_inaccessible)
+		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
+
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE);
 
 	for (i = 0; i < nr_pages; i++)
@@ -1428,6 +1437,8 @@ static int create_altmaps_and_memory_blo
 		};
 
 		mhp_altmap.free = memory_block_memmap_on_memory_pages();
+		if (mhp_flags & MHP_OFFLINE_INACCESSIBLE)
+			mhp_altmap.inaccessible = true;
 		params.altmap = kmemdup(&mhp_altmap, sizeof(struct vmem_altmap),
 					GFP_KERNEL);
 		if (!params.altmap) {
--- a/mm/sparse.c~mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers
+++ a/mm/sparse.c
@@ -908,7 +908,8 @@ int __meminit sparse_add_section(int nid
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!altmap || !altmap->inaccessible)
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch
mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

