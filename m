From: akpm@linux-foundation.org
Subject: - uml-remove-debugging-remnants.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:27 -0700
Message-ID: <200705080007.l4807R44009284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967417AbXEHAHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove debugging remnants
has been removed from the -mm tree.  Its filename was
     uml-remove-debugging-remnants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove debugging remnants
From: Jeff Dike <jdike@addtoit.com>

I accidentally left the remnants of some debugging in an earlier patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/um/kernel/tlb.c~uml-remove-debugging-remnants arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-remove-debugging-remnants
+++ a/arch/um/kernel/tlb.c
@@ -235,9 +235,7 @@ void fix_range_common(struct mm_struct *
 	unsigned long addr = start_addr, next;
 	int ret = 0, last_op = ARRAY_SIZE(ops) - 1, op_index = -1;
 	void *flush = NULL;
-	unsigned long long start_time, end_time;
 
-	start_time = os_nsecs();
 	ops[0].type = NONE;
 	pgd = pgd_offset(mm, addr);
 	do {
@@ -254,7 +252,6 @@ void fix_range_common(struct mm_struct *
 					    &op_index, force, mmu, &flush,
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
-	end_time = os_nsecs();
 	log_info("total flush time - %Ld nsecs\n", end_time - start_time);
 
 	if(!ret)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
