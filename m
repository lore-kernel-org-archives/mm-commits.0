From: akpm@osdl.org
Subject: - x86_64-make-the-numa-hash-function-nodemap-allocation-fix.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:20:41 -0800
Message-ID: <200612140620.kBE6Keq3002407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbWLNGVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amul.shah@unisys.com, ak@suse.de, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: Make the NUMA hash function nodemap allocation dynamic and remove NODEMAPSIZE
has been removed from the -mm tree.  Its filename was
     x86_64-make-the-numa-hash-function-nodemap-allocation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: Make the NUMA hash function nodemap allocation dynamic and remove NODEMAPSIZE
From: Amul Shah <amul.shah@unisys.com>

Updated patch to fix a bug that Andi Kleen found for platforms that
don't support NUMA (or "numa=off").

Cc: Andi Kleen <ak@suse.de>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/e820.c  |    3 ++-
 arch/x86_64/kernel/setup.c |    3 ++-
 arch/x86_64/mm/numa.c      |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix
+++ a/arch/x86_64/kernel/e820.c
@@ -83,12 +83,13 @@ static inline int bad_addr(unsigned long
 		return 1;
 	}
 
+#ifdef CONFIG_NUMA
 	/* NUMA memory to node map */
 	if (last >= nodemap_addr && addr < nodemap_addr + nodemap_size) {
 		*addrp = nodemap_addr + nodemap_size;
 		return 1;
 	}
-
+#endif
 	/* XXX ramdisk image here? */ 
 	return 0;
 } 
diff -puN arch/x86_64/kernel/setup.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix
+++ a/arch/x86_64/kernel/setup.c
@@ -444,10 +444,11 @@ void __init setup_arch(char **cmdline_p)
 	/* reserve ebda region */
 	if (ebda_addr)
 		reserve_bootmem_generic(ebda_addr, ebda_size);
-
+#ifdef CONFIG_NUMA
 	/* reserve nodemap region */
 	if (nodemap_addr)
 		reserve_bootmem_generic(nodemap_addr, nodemap_size);
+#endif
 
 #ifdef CONFIG_SMP
 	/*
diff -puN arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix
+++ a/arch/x86_64/mm/numa.c
@@ -345,6 +345,7 @@ void __init numa_initmem_init(unsigned l
 	       end_pfn << PAGE_SHIFT); 
 		/* setup dummy node covering all memory */ 
 	memnode_shift = 63; 
+	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
 	nodes_clear(node_online_map);
 	node_set_online(0);
_

Patches currently in -mm which might be from amul.shah@unisys.com are

x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch

