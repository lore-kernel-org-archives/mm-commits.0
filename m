From: akpm@osdl.org
Subject: + x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch added to -mm tree
Date: Fri, 08 Dec 2006 15:35:19 -0800
Message-ID: <200612082335.kB8NZJlA009136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51573 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883AbWLHXf1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 18:35:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amul.shah@unisys.com, ak@suse.de, rohitseth@google.com


The patch titled
     x86_64-make-the-numa-hash-function-nodemap-allocation fix fix
has been added to the -mm tree.  Its filename is
     x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64-make-the-numa-hash-function-nodemap-allocation fix fix
From: Amul Shah <amul.shah@unisys.com>

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

x86_64-make-the-numa-hash-function-nodemap-allocation.patch
x86_64-make-the-numa-hash-function-nodemap-allocation-fix.patch
x86_64-make-the-numa-hash-function-nodemap-allocation-fix-2.patch

