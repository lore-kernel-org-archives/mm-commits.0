From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-move-the-comment-of-free_all_bootmem.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:53 -0700
Message-ID: <57fc1a21.PrKMyWZNQ6w+b4/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbcJJWpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanlong.gao@gmail.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: nobootmem: move the comment of free_all_bootmem
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-move-the-comment-of-free_all_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanlong Gao <wanlong.gao@gmail.com>
Subject: mm: nobootmem: move the comment of free_all_bootmem

b4def3509d18c1db9 ("mm, nobootmem: clean-up of
free_low_memory_core_early()") removed the unnecessary nodeid argument,
after that, this comment becomes more confused.  We should move it to the
right place.

Fixes: b4def3509d18c1db9 ("mm, nobootmem: clean-up of free_low_memory_core_early()")
Link: http://lkml.kernel.org/r/1473996082-14603-1-git-send-email-wanlong.gao@gmail.com
Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/nobootmem.c~mm-nobootmem-move-the-comment-of-free_all_bootmem mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-move-the-comment-of-free_all_bootmem
+++ a/mm/nobootmem.c
@@ -137,6 +137,11 @@ static unsigned long __init free_low_mem
 	for_each_reserved_mem_region(i, &start, &end)
 		reserve_bootmem_region(start, end);
 
+	/*
+	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
+	 *  because in some case like Node0 doesn't have RAM installed
+	 *  low ram will be on Node1
+	 */
 	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
 				NULL)
 		count += __free_memory_core(start, end);
@@ -194,11 +199,6 @@ unsigned long __init free_all_bootmem(vo
 
 	reset_all_zones_managed_pages();
 
-	/*
-	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
-	 *  because in some case like Node0 doesn't have RAM installed
-	 *  low ram will be on Node1
-	 */
 	pages = free_low_memory_core_early();
 	totalram_pages += pages;
 
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are


