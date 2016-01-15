From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-remove-rgnbase-and-rgnsize-variables.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:12 -0800
Message-ID: <569973e4.RusMpXege2sTazuD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: remove rgnbase and rgnsize variables
has been removed from the -mm tree.  Its filename was
     mm-memblock-remove-rgnbase-and-rgnsize-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock: remove rgnbase and rgnsize variables

Remove rgnbase and rgnsize variables from memblock_overlaps_region().  We
use these variables only for passing to the memblock_addrs_overlap()
function and that's all.  Let's remove them.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memblock.c~mm-memblock-remove-rgnbase-and-rgnsize-variables mm/memblock.c
--- a/mm/memblock.c~mm-memblock-remove-rgnbase-and-rgnsize-variables
+++ a/mm/memblock.c
@@ -96,13 +96,10 @@ bool __init_memblock memblock_overlaps_r
 {
 	unsigned long i;
 
-	for (i = 0; i < type->cnt; i++) {
-		phys_addr_t rgnbase = type->regions[i].base;
-		phys_addr_t rgnsize = type->regions[i].size;
-		if (memblock_addrs_overlap(base, size, rgnbase, rgnsize))
+	for (i = 0; i < type->cnt; i++)
+		if (memblock_addrs_overlap(base, size, type->regions[i].base,
+					   type->regions[i].size))
 			break;
-	}
