From: akpm@linux-foundation.org
Subject: [patch 107/142] mm/memblock.c: trivial code refine in
 memblock_is_region_memory()
Date: Wed, 22 Feb 2017 15:45:04 -0800
Message-ID: <58ae2280.uZ4qP/vo95jJ1jWV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934315AbdBVXpL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, richard.weiyang@gmail.com, mhocko@suse.com

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
