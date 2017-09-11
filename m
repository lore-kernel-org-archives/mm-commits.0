From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-useless-vma-parameter-to-offset_il_node.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:39:46 -0700
Message-ID: <20170911193946.UWWhbo7kq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdIKTjr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove useless vma parameter to offset_il_node
has been removed from the -mm tree.  Its filename was
     mm-remove-useless-vma-parameter-to-offset_il_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: remove useless vma parameter to offset_il_node

While reading the code I found that offset_il_node() has a vm_area_struct
pointer parameter which is unused.

Link: http://lkml.kernel.org/r/1502899755-23146-1-git-send-email-ldufour@linux.vnet.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-remove-useless-vma-parameter-to-offset_il_node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-remove-useless-vma-parameter-to-offset_il_node
+++ a/mm/mempolicy.c
@@ -1745,8 +1745,7 @@ unsigned int mempolicy_slab_node(void)
  * node in pol->v.nodes (starting from n=0), wrapping around if n exceeds the
  * number of present nodes.
  */
-static unsigned offset_il_node(struct mempolicy *pol,
-			       struct vm_area_struct *vma, unsigned long n)
+static unsigned offset_il_node(struct mempolicy *pol, unsigned long n)
 {
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
@@ -1779,7 +1778,7 @@ static inline unsigned interleave_nid(st
 		BUG_ON(shift < PAGE_SHIFT);
 		off = vma->vm_pgoff >> (shift - PAGE_SHIFT);
 		off += (addr - vma->vm_start) >> shift;
-		return offset_il_node(pol, vma, off);
+		return offset_il_node(pol, off);
 	} else
 		return interleave_nodes(pol);
 }
@@ -2247,7 +2246,7 @@ int mpol_misplaced(struct page *page, st
 
 		pgoff = vma->vm_pgoff;
 		pgoff += (addr - vma->vm_start) >> PAGE_SHIFT;
-		polnid = offset_il_node(pol, vma, pgoff);
+		polnid = offset_il_node(pol, pgoff);
 		break;
 
 	case MPOL_PREFERRED:
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-skip-hwpoisoned-pages-when-onlining-pages.patch

