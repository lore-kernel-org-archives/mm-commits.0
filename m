From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 043/127] powerpc/pseries/hotplug-memory: stop
 checking is_mem_section_removable()
Date: Thu, 04 Jun 2020 16:48:28 -0700
Message-ID: <20200604234828.9QfSL0WRV%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:31 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, osalvador@suse.de, paulus@samba.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pseries/hotplug-memory: stop checking is_mem_section_removable()

In commit 53cdc1cb29e8 ("drivers/base/memory.c: indicate all memory blocks
as removable"), the user space interface to compute whether a memory block
can be offlined (exposed via /sys/devices/system/memory/memoryX/removable)
has effectively been deprecated.  We want to remove the leftovers of the
kernel implementation.

When offlining a memory block (mm/memory_hotplug.c:__offline_pages()),
we'll start by:
1. Testing if it contains any holes, and reject if so
2. Testing if pages belong to different zones, and reject if so
3. Isolating the page range, checking if it contains any unmovable pages

Using is_mem_section_removable() before trying to offline is not only
racy, it can easily result in false positives/negatives.  Let's stop
manually checking is_mem_section_removable(), and let device_offline()
handle it completely instead.  We can remove the racy
is_mem_section_removable() implementation next.

We now take more locks (e.g., memory hotplug lock when offlining and the
zone lock when isolating), but maybe we should optimize that
implementation instead if this ever becomes a real problem (after all,
memory unplug is already an expensive operation).  We started using
is_mem_section_removable() in commit 51925fb3c5c9 ("powerpc/pseries:
Implement memory hotplug remove in the kernel"), with the initial
hotremove support of lmbs.

Link: http://lkml.kernel.org/r/20200407135416.24093-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |   26 +-------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~powerpc-pseries-hotplug-memory-stop-checking-is_mem_section_removable
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -337,39 +337,19 @@ static int pseries_remove_mem_node(struc
 
 static bool lmb_is_removable(struct drmem_lmb *lmb)
 {
-	int i, scns_per_block;
-	bool rc = true;
-	unsigned long pfn, block_sz;
-	u64 phys_addr;
-
 	if (!(lmb->flags & DRCONF_MEM_ASSIGNED))
 		return false;
 
-	block_sz = memory_block_size_bytes();
-	scns_per_block = block_sz / MIN_MEMORY_BLOCK_SIZE;
-	phys_addr = lmb->base_addr;
-
 #ifdef CONFIG_FA_DUMP
 	/*
 	 * Don't hot-remove memory that falls in fadump boot memory area
 	 * and memory that is reserved for capturing old kernel memory.
 	 */
-	if (is_fadump_memory_area(phys_addr, block_sz))
+	if (is_fadump_memory_area(lmb->base_addr, memory_block_size_bytes()))
 		return false;
 #endif
-
-	for (i = 0; i < scns_per_block; i++) {
-		pfn = PFN_DOWN(phys_addr);
-		if (!pfn_in_present_section(pfn)) {
-			phys_addr += MIN_MEMORY_BLOCK_SIZE;
-			continue;
-		}
-
-		rc = rc && is_mem_section_removable(pfn, PAGES_PER_SECTION);
-		phys_addr += MIN_MEMORY_BLOCK_SIZE;
-	}
