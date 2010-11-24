From: akpm@linux-foundation.org
Subject: + memblock-fix-memblock_is_region_memory.patch added to -mm tree
Date: Wed, 24 Nov 2010 15:32:04 -0800
Message-ID: <201011242332.oAONW4d0010500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab0KXXcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 18:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomi.valkeinen@nokia.com, benh@kernel.crashing.org, yinghai@kernel.org


The patch titled
     memblock: fix memblock_is_region_memory()
has been added to the -mm tree.  Its filename is
     memblock-fix-memblock_is_region_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memblock: fix memblock_is_region_memory()
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>

memblock_is_region_memory() uses reserved memblocks to search for the
given region, while it should use the memory memblocks.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

memblock-fix-memblock_is_region_memory.patch

