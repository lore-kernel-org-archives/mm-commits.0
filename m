From: akpm@linux-foundation.org
Subject: [folded-merged]
 memblock-make-memblock_set_node-support-different-memblock_type-fix.patch
 removed from -mm tree
Date: Tue, 21 Jan 2014 15:31:24 -0800
Message-ID: <52df034c.ks+y1GvjMVqvtds9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaAUXbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, sfr@canb.auug.org.au

Subject: [folded-merged] memblock-make-memblock_set_node-support-different-memblock_type-fix.patch removed from -mm tree
To: sfr@canb.auug.org.au,tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:31:24 -0800


The patch titled
     Subject: memblock-make-memblock_set_node-support-different-memblock_type-fix
has been removed from the -mm tree.  Its filename was
     memblock-make-memblock_set_node-support-different-memblock_type-fix.patch

This patch was dropped because it was folded into memblock-make-memblock_set_node-support-different-memblock_type.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: memblock-make-memblock_set_node-support-different-memblock_type-fix

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

arch/powerpc/mm/mem.c: In function 'do_init_bootmem':
arch/powerpc/mm/mem.c:212:49: error: 'memblock_memory' undeclared (first us=
e in this function)
  memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock_memory, 0);
                                                 ^

Caused by commit 3a543893d46a ("memblock: make memblock_set_node()
support different memblock_type") from the apm-current tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/mem.c~memblock-make-memblock_set_node-support-different-memblock_type-fix arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~memblock-make-memblock_set_node-support-different-memblock_type-fix
+++ a/arch/powerpc/mm/mem.c
@@ -209,7 +209,7 @@ void __init do_init_bootmem(void)
 	/* Place all memblock_regions in the same node and merge contiguous
 	 * memblock_regions
 	 */
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock_memory, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock.memory, 0);
 
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch
x86-mm-memblock-switch-to-use-numa_no_node.patch

