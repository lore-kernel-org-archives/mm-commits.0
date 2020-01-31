From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 060/118] memblock: Use __func__ in remaining
 memblock_dbg() call sites
Date: Thu, 30 Jan 2020 22:14:23 -0800
Message-ID: <20200131061423.QakpiPmh1%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:24 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

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
