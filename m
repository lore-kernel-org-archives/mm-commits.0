From: akpm@linux-foundation.org
Subject: +
 mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 13:12:17 -0700
Message-ID: <571a85a1.I0JYXBolNLGN1k2E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbcDVUMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, ard.biesheuvel@linaro.org, david@gibson.dropbear.id.au, mgorman@suse.de, penberg@kernel.org, tangchen@cn.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: move memblock_{add,reserve}_region into memblock_{add,reserve}
has been added to the -mm tree.  Its filename is
     mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: move memblock_{add,reserve}_region into memblock_{add,reserve}

memblock_add_region() and memblock_reserve_region() do nothing specific
before the call of memblock_add_range(), only print debug output.

We can do the same in memblock_add() and memblock_reserve() since both
memblock_add_region() and memblock_reserve_region() are not used by
anybody outside of memblock.c and memblock_{add,reserve}() have the same
set of flags and nids.

Since memblock_add_region() and memblock_reserve_region() will be inlined,
there will not be functional changes, but will improve code readability a
little.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff -puN mm/memblock.c~mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve mm/memblock.c
--- a/mm/memblock.c~mm-memblock-move-memblock_addreserve_region-into-memblock_addreserve
+++ a/mm/memblock.c
@@ -606,22 +606,14 @@ int __init_memblock memblock_add_node(ph
 	return memblock_add_range(&memblock.memory, base, size, nid, 0);
 }
 
-static int __init_memblock memblock_add_region(phys_addr_t base,
-						phys_addr_t size,
-						int nid,
-						unsigned long flags)
+int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
-		     flags, (void *)_RET_IP_);
-
-	return memblock_add_range(&memblock.memory, base, size, nid, flags);
-}
+		     0UL, (void *)_RET_IP_);
 
-int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
-{
-	return memblock_add_region(base, size, MAX_NUMNODES, 0);
+	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
 }
 
 /**
@@ -732,22 +724,14 @@ int __init_memblock memblock_free(phys_a
 	return memblock_remove_range(&memblock.reserved, base, size);
 }
 
-static int __init_memblock memblock_reserve_region(phys_addr_t base,
-						   phys_addr_t size,
-						   int nid,
-						   unsigned long flags)
+int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
-		     flags, (void *)_RET_IP_);
