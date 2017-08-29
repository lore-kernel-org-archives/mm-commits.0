From: akpm@linux-foundation.org
Subject: [merged] mm-reversed-logic-in-memblock_discard.patch
 removed from -mm tree
Date: Tue, 29 Aug 2017 11:14:39 -0700
Message-ID: <20170829181439.l1B6yLmGE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2SOk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2017 14:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, stable@vger.kernel.org, terraluna977@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm/memblock.c: reversed logic in memblock_discard()
has been removed from the -mm tree.  Its filename was
     mm-reversed-logic-in-memblock_discard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memblock.c: reversed logic in memblock_discard()

In recently introduced memblock_discard() there is a reversed logic bug. 
Memory is freed of static array instead of dynamically allocated one.

Link: http://lkml.kernel.org/r/1503511441-95478-2-git-send-email-pasha.tatashin@oracle.com
Fixes: 3010f876500f ("mm: discard memblock data later")
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reported-by: Woody Suwalski <terraluna977@gmail.com>
Tested-by: Woody Suwalski <terraluna977@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-reversed-logic-in-memblock_discard mm/memblock.c
--- a/mm/memblock.c~mm-reversed-logic-in-memblock_discard
+++ a/mm/memblock.c
@@ -299,7 +299,7 @@ void __init memblock_discard(void)
 		__memblock_free_late(addr, size);
 	}
 
-	if (memblock.memory.regions == memblock_memory_init_regions) {
+	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch

