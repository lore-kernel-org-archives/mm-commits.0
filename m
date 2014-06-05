From: akpm@linux-foundation.org
Subject: [merged] arch-x86-mm-numac-use-for_each_memblock.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:51:29 -0700
Message-ID: <5390ca41.96bnOdHlLg/g0sNL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaFETva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, Emilian.Medve@Freescale.com

Subject: [merged] arch-x86-mm-numac-use-for_each_memblock.patch removed from -mm tree
To: Emilian.Medve@Freescale.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:29 -0700


The patch titled
     Subject: arch/x86/mm/numa.c: use for_each_memblock()
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-numac-use-for_each_memblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Emil Medve <Emilian.Medve@Freescale.com>
Subject: arch/x86/mm/numa.c: use for_each_memblock()

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/numa.c~arch-x86-mm-numac-use-for_each_memblock arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~arch-x86-mm-numac-use-for_each_memblock
+++ a/arch/x86/mm/numa.c
@@ -559,7 +559,7 @@ static void __init numa_clear_kernel_nod
 	int i, nid;
 	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
 	unsigned long start, end;
-	struct memblock_type *type = &memblock.reserved;
+	struct memblock_region *r;
 
 	/*
 	 * At this time, all memory regions reserved by memblock are
@@ -573,8 +573,8 @@ static void __init numa_clear_kernel_nod
 	}
 
 	/* Mark all kernel nodes. */
-	for (i = 0; i < type->cnt; i++)
-		node_set(type->regions[i].nid, numa_kernel_nodes);
+	for_each_memblock(reserved, r)
+		node_set(r->nid, numa_kernel_nodes);
 
 	/* Clear MEMBLOCK_HOTPLUG flag for memory in kernel nodes. */
 	for (i = 0; i < numa_meminfo.nr_blks; i++) {
_

Patches currently in -mm which might be from Emilian.Medve@Freescale.com are

origin.patch
linux-next.patch

