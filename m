From: akpm@linux-foundation.org
Subject: [merged]
 memblock-dont-align-size-silent-in-memblock_virt_alloc.patch removed from
 -mm tree
Date: Tue, 28 Jan 2014 11:09:05 -0800
Message-ID: <52e80051.TFVy8naoYt+vQXFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com, mingo@elte.hu, linux@arm.linux.org.uk, konrad.wilk@oracle.com, hpa@zytor.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: [merged] memblock-dont-align-size-silent-in-memblock_virt_alloc.patch removed from -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,hpa@zytor.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mingo@elte.hu,santosh.shilimkar@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:05 -0800


The patch titled
     Subject: memblock: don't silently align size in memblock_virt_alloc()
has been removed from the -mm tree.  Its filename was
     memblock-dont-align-size-silent-in-memblock_virt_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: don't silently align size in memblock_virt_alloc()

In original __alloc_memory_core_early() for bootmem wrapper, we do not
align size silently.

We should not do that, as later free with old size will leave some
range not freed.

It's obvious that code is copied from memblock_base_nid(), and that code
is wrong for the same reason.

Also remove that in memblock_alloc_base.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/memblock.c~memblock-dont-align-size-silent-in-memblock_virt_alloc mm/memblock.c
--- a/mm/memblock.c~memblock-dont-align-size-silent-in-memblock_virt_alloc
+++ a/mm/memblock.c
@@ -984,9 +984,6 @@ static phys_addr_t __init memblock_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
 	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
@@ -1080,9 +1077,6 @@ static void * __init memblock_virt_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
