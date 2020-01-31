From: akpm@linux-foundation.org
Subject: [merged]
 memblock-use-__func__-in-remaining-memblock_dbg-call-sites.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:18:49 -0800
Message-ID: <20200131231849.L5n7HpWga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: memblock: Use __func__ in remaining memblock_dbg() call sites
has been removed from the -mm tree.  Its filename was
     memblock-use-__func__-in-remaining-memblock_dbg-call-sites.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: memblock: Use __func__ in remaining memblock_dbg() call sites

Replace open function name strings with %s (__func__) in all remaining
memblock_dbg() call sites.

Link: http://lkml.kernel.org/r/1578285510-28261-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memblock.c~memblock-use-__func__-in-remaining-memblock_dbg-call-sites
+++ a/mm/memblock.c
@@ -694,7 +694,7 @@ int __init_memblock memblock_add(phys_ad
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("memblock_add: [%pa-%pa] %pS\n",
+	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
@@ -795,7 +795,7 @@ int __init_memblock memblock_remove(phys
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("memblock_remove: [%pa-%pa] %pS\n",
+	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	return memblock_remove_range(&memblock.memory, base, size);
@@ -813,7 +813,7 @@ int __init_memblock memblock_free(phys_a
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("   memblock_free: [%pa-%pa] %pS\n",
+	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	kmemleak_free_part_phys(base, size);
@@ -824,7 +824,7 @@ int __init_memblock memblock_reserve(phy
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("memblock_reserve: [%pa-%pa] %pS\n",
+	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
 		     &base, &end, (void *)_RET_IP_);
 
 	return memblock_add_range(&memblock.reserved, base, size, MAX_NUMNODES, 0);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are
