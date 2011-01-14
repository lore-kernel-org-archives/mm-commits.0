From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-get_vm_area_node.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:05 -0800
Message-ID: <201101142247.p0EMltqr005055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab1ANWsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused get_vm_area_node
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-get_vm_area_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unused get_vm_area_node
From: David Rientjes <rientjes@google.com>

get_vm_area_node() is unused in the kernel and can thus be removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 ---
 mm/vmalloc.c            |    7 -------
 2 files changed, 10 deletions(-)

diff -puN include/linux/vmalloc.h~mm-remove-unused-get_vm_area_node include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-remove-unused-get_vm_area_node
+++ a/include/linux/vmalloc.h
@@ -90,9 +90,6 @@ extern struct vm_struct *__get_vm_area_c
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					void *caller);
-extern struct vm_struct *get_vm_area_node(unsigned long size,
-					  unsigned long flags, int node,
-					  gfp_t gfp_mask);
 extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
diff -puN mm/vmalloc.c~mm-remove-unused-get_vm_area_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-unused-get_vm_area_node
+++ a/mm/vmalloc.c
@@ -1315,13 +1315,6 @@ struct vm_struct *get_vm_area_caller(uns
 						-1, GFP_KERNEL, caller);
 }
 
-struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
-				   int node, gfp_t gfp_mask)
-{
-	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
-				  node, gfp_mask, __builtin_return_address(0));
-}
