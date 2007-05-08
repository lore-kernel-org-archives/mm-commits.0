From: akpm@linux-foundation.org
Subject: - uml-eliminate-a-piece-of-debugging-code.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:35 -0700
Message-ID: <200705080007.l4807Z3X009299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967258AbXEHAHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: eliminate a piece of debugging code
has been removed from the -mm tree.  Its filename was
     uml-eliminate-a-piece-of-debugging-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: eliminate a piece of debugging code
From: Jeff Dike <jdike@addtoit.com>

I missed removing another piece of debugging in an earlier patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/kernel/tlb.c~uml-eliminate-a-piece-of-debugging-code arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-eliminate-a-piece-of-debugging-code
+++ a/arch/um/kernel/tlb.c
@@ -252,7 +252,6 @@ void fix_range_common(struct mm_struct *
 					    &op_index, force, mmu, &flush,
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
-	log_info("total flush time - %Ld nsecs\n", end_time - start_time);
 
 	if(!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
