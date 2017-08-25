From: akpm@linux-foundation.org
Subject: [patch 6/6] mm/memblock.c: reversed logic in memblock_discard()
Date: Fri, 25 Aug 2017 15:55:46 -0700
Message-ID: <59a0aaf2.4aPSTUyA2ocnwNkM%akpm__19988.6692026213$1503701763$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755919AbdHYWzz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 18:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pasha.tatashin@oracle.com, mhocko@suse.com, stable@vger.kernel.org, terraluna977@gmail.com, vbabka@suse.cz

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
