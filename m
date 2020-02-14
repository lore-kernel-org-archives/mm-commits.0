From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memoryc-drop-section_count.patch added to
 -mm tree
Date: Thu, 13 Feb 2020 21:30:58 -0800
Message-ID: <20200214053058.qM4EDjWFG%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgBNFbA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:31:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: drivers/base/memory.c: drop section_count
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-drop-section_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memoryc-drop-section_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memoryc-drop-section_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: drop section_count

Patch series "mm: drop superfluous section checks when onlining/offlining".

Let's drop some superfluous section checks on the onlining/offlining path.

This patch (of 3):

Since commit c5e79ef561b0 ("mm/memory_hotplug.c: don't allow to
online/offline memory blocks with holes") we have a generic check in
offline_pages() that disallows offlining memory blocks with holes.

Memory blocks with missing sections are just another variant of these type
of blocks.  We can stop checking (and especially storing) present
sections.  A proper error message is now printed why offlining failed.

section_count was initially introduced in commit 07681215975e ("Driver
core: Add section count to memory_block struct") in order to detect when
it is okay to remove a memory block.  It was used in commit 26bbe7ef6d5c
("drivers/base/memory.c: prohibit offlining of memory blocks with missing
sections") to disallow offlining memory blocks with missing sections.  As
we refactored creation/removal of memory devices and have a proper check
for holes in place, we can drop the section_count.

This also removes a leftover comment regarding the mem_sysfs_mutex, which
was removed in commit 848e19ad3c33 ("drivers/base/memory.c: drop the
mem_sysfs_mutex").

Link: http://lkml.kernel.org/r/20200127110424.5757-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   17 +++--------------
 include/linux/memory.h |    1 -
 2 files changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-drop-section_count
+++ a/drivers/base/memory.c
@@ -275,10 +275,6 @@ static int memory_subsys_offline(struct
 	if (mem->state == MEM_OFFLINE)
 		return 0;
 
-	/* Can't offline block with non-present sections */
-	if (mem->section_count != sections_per_block)
-		return -EINVAL;
-
 	return memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
 }
 
@@ -643,7 +639,7 @@ static int init_memory_block(struct memo
 
 static int add_memory_block(unsigned long base_section_nr)
 {
-	int ret, section_count = 0;
+	int section_count = 0;
 	struct memory_block *mem;
 	unsigned long nr;
 
@@ -654,12 +650,8 @@ static int add_memory_block(unsigned lon
 
 	if (section_count == 0)
 		return 0;
-	ret = init_memory_block(&mem, base_memory_block_id(base_section_nr),
-				MEM_ONLINE);
-	if (ret)
-		return ret;
-	mem->section_count = section_count;
-	return 0;
+	return init_memory_block(&mem, base_memory_block_id(base_section_nr),
+				 MEM_ONLINE);
 }
 
 static void unregister_memory(struct memory_block *memory)
@@ -697,7 +689,6 @@ int create_memory_block_devices(unsigned
 		ret = init_memory_block(&mem, block_id, MEM_OFFLINE);
 		if (ret)
 			break;
-		mem->section_count = sections_per_block;
 	}
 	if (ret) {
 		end_block_id = block_id;
@@ -706,7 +697,6 @@ int create_memory_block_devices(unsigned
 			mem = find_memory_block_by_id(block_id);
 			if (WARN_ON_ONCE(!mem))
 				continue;
-			mem->section_count = 0;
 			unregister_memory(mem);
 		}
 	}
@@ -735,7 +725,6 @@ void remove_memory_block_devices(unsigne
 		mem = find_memory_block_by_id(block_id);
 		if (WARN_ON_ONCE(!mem))
 			continue;
-		mem->section_count = 0;
 		unregister_memory_block_under_nodes(mem);
 		unregister_memory(mem);
 	}
--- a/include/linux/memory.h~drivers-base-memoryc-drop-section_count
+++ a/include/linux/memory.h
@@ -26,7 +26,6 @@
 struct memory_block {
 	unsigned long start_section_nr;
 	unsigned long state;		/* serialized by the dev->lock */
-	int section_count;		/* serialized by mem_sysfs_mutex */
 	int online_type;		/* for passing data to online routine */
 	int phys_device;		/* to which fru does this belong? */
 	struct device dev;
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
