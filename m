From: akpm@osdl.org
Subject: - x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:22 -0800
Message-ID: <200701102302.l0AN2MrV010732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965227AbXAJXCw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amul.shah@unisys.com, ak@suse.de, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-make-the-numa-hash-function-nodemap-allocation fix fix
has been removed from the -mm tree.  Its filename was
     x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64-make-the-numa-hash-function-nodemap-allocation fix fix
From: Amul Shah <amul.shah@unisys.com>

- Removed an extraneous debug message from allocate_cachealigned_map

- Changed extract_lsb_from_nodes to return 63 for the case where there was
  only one memory node.  The prevents the creation of the dynamic hashmap.

- Changed extract_lsb_from_nodes to use only the starting memory address of
  a node.  On an ES7000, our nodes overlap the starting and ending address,
  meaning, that we see nodes like

	00000 - 10000
	10000 - 20000

  But other systems have nodes whose start and end addresses do not overlap.
   For example:

	00000 - 0FFFF
	10000 - 1FFFF

  In this case, using the ending address will result in an LSB much lower
  than what is possible.  In this case an LSB of 1 when in reality it should
  be 16.  

Cc: Andi Kleen <ak@suse.de>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/mm/numa.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2 arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2
+++ a/arch/x86_64/mm/numa.c
@@ -78,11 +78,8 @@ static int __init allocate_cachealigned_
 	unsigned long pad, pad_addr;
 
 	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= 48) {
-		printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
-		       nodemap_addr, nodemap_addr + nodemap_size);
+	if (memnodemapsize <= 48)
 		return 0;
-	}
 
 	pad = L1_CACHE_BYTES - 1;
 	pad_addr = 0x8000;
@@ -110,7 +107,7 @@ static int __init allocate_cachealigned_
 static int __init
 extract_lsb_from_nodes (const struct bootnode *nodes, int numnodes)
 {
-	int i;
+	int i, nodes_used = 0;
 	unsigned long start, end;
 	unsigned long bitfield = 0, memtop = 0;
 
@@ -119,11 +116,15 @@ extract_lsb_from_nodes (const struct boo
 		end = nodes[i].end;
 		if (start >= end)
 			continue;
-		bitfield |= start | end;
+		bitfield |= start;
+		nodes_used++;
 		if (end > memtop)
 			memtop = end;
 	}
-	i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
+	if (nodes_used <= 1 )
+		i = 63;
+	else
+		i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
 	memnodemapsize = (memtop >> i)+1;
 	return i;
 }
_

Patches currently in -mm which might be from amul.shah@unisys.com are
