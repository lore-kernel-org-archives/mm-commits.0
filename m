From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:06 -0800
Message-ID: <58af5116.rV2lqB4qKstdJZ9l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: trivial code refine in memblock_is_region_memory()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-trivial-code-refine-in-memblock_is_region_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memblock.c: trivial code refine in memblock_is_region_memory()

memblock_is_region_memory() invoke memblock_search() to see whether the
base address is in the memory region. If it fails, idx would be -1. Then,
it returns 0.

If the memblock_search() returns a valid index, it means the base address
is guaranteed to be in the range memblock.memory.regions[idx]. Because of
this, it is not necessary to check the base again.

This patch removes the check on "base".

Link: http://lkml.kernel.org/r/1482363033-24754-2-git-send-email-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-trivial-code-refine-in-memblock_is_region_memory mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-trivial-code-refine-in-memblock_is_region_memory
+++ a/mm/memblock.c
@@ -1640,8 +1640,7 @@ int __init_memblock memblock_is_region_m
 
 	if (idx == -1)
 		return 0;
-	return memblock.memory.regions[idx].base <= base &&
-		(memblock.memory.regions[idx].base +
+	return (memblock.memory.regions[idx].base +
 		 memblock.memory.regions[idx].size) >= end;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
mm-page_alloc-remove-redundant-init-code-for-zone_movable.patch

