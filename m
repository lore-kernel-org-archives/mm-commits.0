From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch removed from
 -mm tree
Date: Wed, 15 Nov 2017 17:05:07 -0800
Message-ID: <5a0ce443.4onnhKOnxIVjYL1g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBFI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
has been removed from the -mm tree.  Its filename was
     mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch

This patch was dropped because it was folded into mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix

make vmemmap_alloc_block_zero() private to sparse-vmemmap.c

Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   11 -----------
 mm/sparse-vmemmap.c |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
+++ a/include/linux/mm.h
@@ -2530,17 +2530,6 @@ static inline void *vmemmap_alloc_block_
 	return __vmemmap_alloc_block_buf(size, node, NULL);
 }
 
-static inline void *vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node);
diff -puN mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix
+++ a/mm/sparse-vmemmap.c
@@ -179,6 +179,17 @@ pte_t * __meminit vmemmap_pte_populate(p
 	return pte;
 }
 
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
 pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

