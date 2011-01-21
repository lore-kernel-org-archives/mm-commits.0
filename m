From: akpm@linux-foundation.org
Subject: [merged] memblock-fix-memblock_is_region_memory.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:26 -0800
Message-ID: <201101212031.p0LKVQFo031603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab1AUUcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomi.valkeinen@nokia.com, benh@kernel.crashing.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memblock: fix memblock_is_region_memory()
has been removed from the -mm tree.  Its filename was
     memblock-fix-memblock_is_region_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memblock: fix memblock_is_region_memory()
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>

memblock_is_region_memory() uses reserved memblocks to search for the
given region, while it should use the memory memblocks.

I encountered the problem with OMAP's framebuffer ram allocation. 
Normally the ram is allocated dynamically, and this function is not
called.  However, if we want to pass the framebuffer from the bootloader
to the kernel (to retain the boot image), this function is used to check
the validity of the kernel parameters for the framebuffer ram area.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~memblock-fix-memblock_is_region_memory mm/memblock.c
--- a/mm/memblock.c~memblock-fix-memblock_is_region_memory
+++ a/mm/memblock.c
@@ -683,13 +683,13 @@ int __init_memblock memblock_is_memory(p
 
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
-	int idx = memblock_search(&memblock.reserved, base);
+	int idx = memblock_search(&memblock.memory, base);
 
 	if (idx == -1)
 		return 0;
-	return memblock.reserved.regions[idx].base <= base &&
-		(memblock.reserved.regions[idx].base +
-		 memblock.reserved.regions[idx].size) >= (base + size);
+	return memblock.memory.regions[idx].base <= base &&
+		(memblock.memory.regions[idx].base +
+		 memblock.memory.regions[idx].size) >= (base + size);
 }
 
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
_

Patches currently in -mm which might be from tomi.valkeinen@nokia.com are

origin.patch

