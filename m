From: akpm@linux-foundation.org
Subject: +
 memblock-make-memblock_set_node-support-different-memblock_type-fix.patch
 added to -mm tree
Date: Wed, 18 Dec 2013 13:22:27 -0800
Message-ID: <52b21213.KglU8Q9RNiZupZEa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3LRVW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 16:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, sfr@canb.auug.org.au

Subject: + memblock-make-memblock_set_node-support-different-memblock_type-fix.patch added to -mm tree
To: sfr@canb.auug.org.au,tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 13:22:27 -0800


The patch titled
     Subject: memblock-make-memblock_set_node-support-different-memblock_type-fix
has been added to the -mm tree.  Its filename is
     memblock-make-memblock_set_node-support-different-memblock_type-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-make-memblock_set_node-support-different-memblock_type-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-make-memblock_set_node-support-different-memblock_type-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memblock-make-memblock_set_node-support-different-memblock_type-fix.patch
rtc-add-hym8563-rtc-driver-fix.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

