From: akpm@linux-foundation.org
Subject: + mm-memblockc-remove-unnecessary-log-and-clean-up.patch added to -mm tree
Date: Wed, 18 Jan 2017 15:07:09 -0800
Message-ID: <587ff51d.bVhZk4VmuFrt3lGA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdARXHK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 18:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: remove unnecessary log and clean up
has been added to the -mm tree.  Its filename is
     mm-memblockc-remove-unnecessary-log-and-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-remove-unnecessary-log-and-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-remove-unnecessary-log-and-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/memblock.c: remove unnecessary log and clean up

There is no variable named flags in memblock_add() and memblock_reserve()
so remove it from the log messages.

This patch also cleans up the type casting for phys_addr_t by using %pa to
print them.

Link: http://lkml.kernel.org/r/1484720165-25403-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   54 ++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-remove-unnecessary-log-and-clean-up mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-remove-unnecessary-log-and-clean-up
+++ a/mm/memblock.c
@@ -611,10 +611,10 @@ int __init_memblock memblock_add_node(ph
 
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
-	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
-		     (unsigned long long)base,
-		     (unsigned long long)base + size - 1,
-		     0UL, (void *)_RET_IP_);
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("memblock_add: [%pa-%pa] %pF\n",
+		     &base, &end, (void *)_RET_IP_);
 
 	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
 }
@@ -718,10 +718,10 @@ int __init_memblock memblock_remove(phys
 
 int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
-	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
-		     (unsigned long long)base,
-		     (unsigned long long)base + size - 1,
-		     (void *)_RET_IP_);
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("   memblock_free: [%pa-%pa] %pF\n",
+		     &base, &end, (void *)_RET_IP_);
 
 	kmemleak_free_part_phys(base, size);
 	return memblock_remove_range(&memblock.reserved, base, size);
@@ -729,10 +729,10 @@ int __init_memblock memblock_free(phys_a
 
 int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
-	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
-		     (unsigned long long)base,
-		     (unsigned long long)base + size - 1,
-		     0UL, (void *)_RET_IP_);
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("memblock_reserve: [%pa-%pa] %pF\n",
+		     &base, &end, (void *)_RET_IP_);
 
 	return memblock_add_range(&memblock.reserved, base, size, MAX_NUMNODES, 0);
 }
@@ -1227,8 +1227,8 @@ phys_addr_t __init memblock_alloc_base(p
 	alloc = __memblock_alloc_base(size, align, max_addr);
 
 	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
-		      (unsigned long long) size, (unsigned long long) max_addr);
+		panic("ERROR: Failed to allocate %pa bytes below %pa.\n",
+		      &size, &max_addr);
 
 	return alloc;
 }
@@ -1695,7 +1695,7 @@ phys_addr_t __init_memblock memblock_get
 
 static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
-	unsigned long long base, size;
+	phys_addr_t base, end, size;
 	unsigned long flags;
 	int idx;
 	struct memblock_region *rgn;
@@ -1707,23 +1707,24 @@ static void __init_memblock memblock_dum
 
 		base = rgn->base;
 		size = rgn->size;
+		end = base + size - 1;
 		flags = rgn->flags;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
 #endif
-		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s flags: %#lx\n",
-			name, idx, base, base + size - 1, size, nid_buf, flags);
+		pr_info(" %s[%#x]\t[%pa-%pa], %pa bytes%s flags: %#lx\n",
+			name, idx, &base, &end, &size, nid_buf, flags);
 	}
 }
 
 void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
-	pr_info(" memory size = %#llx reserved size = %#llx\n",
-		(unsigned long long)memblock.memory.total_size,
-		(unsigned long long)memblock.reserved.total_size);
+	pr_info(" memory size = %pa reserved size = %pa\n",
+		&memblock.memory.total_size,
+		&memblock.reserved.total_size);
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
@@ -1749,19 +1750,14 @@ static int memblock_debug_show(struct se
 	struct memblock_type *type = m->private;
 	struct memblock_region *reg;
 	int i;
+	phys_addr_t end;
 
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
-		seq_printf(m, "%4d: ", i);
-		if (sizeof(phys_addr_t) == 4)
-			seq_printf(m, "0x%08lx..0x%08lx\n",
-				   (unsigned long)reg->base,
-				   (unsigned long)(reg->base + reg->size - 1));
-		else
-			seq_printf(m, "0x%016llx..0x%016llx\n",
-				   (unsigned long long)reg->base,
-				   (unsigned long long)(reg->base + reg->size - 1));
+		end = reg->base + reg->size - 1;
 
+		seq_printf(m, "%4d: ", i);
+		seq_printf(m, "%pa..%pa\n", &reg->base, &end);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-add-comment-for-failed-to-check-map-error.patch
mm-memblockc-remove-unnecessary-log-and-clean-up.patch
checkpatch-update-logfunctions.patch

