From: akpm@linux-foundation.org
Subject: [merged] alloc_vmap_area-fix-memory-leak.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:12 -0700
Message-ID: <200905071916.n47JGCta020148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbZEGTTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralphw@linux.vnet.ibm.com, cl@linux-foundation.org, minchan.kim@gmail.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     alloc_vmap_area: fix memory leak
has been removed from the -mm tree.  Its filename was
     alloc_vmap_area-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alloc_vmap_area: fix memory leak
From: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>

If alloc_vmap_area() fails the allocated struct vmap_area has to be freed.

Signed-off-by: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmalloc.c~alloc_vmap_area-fix-memory-leak mm/vmalloc.c
--- a/mm/vmalloc.c~alloc_vmap_area-fix-memory-leak
+++ a/mm/vmalloc.c
@@ -402,6 +402,7 @@ overflow:
 			printk(KERN_WARNING
 				"vmap allocation for size %lu failed: "
 				"use vmalloc=<size> to increase size.\n", size);
+		kfree(va);
 		return ERR_PTR(-EBUSY);
 	}
 
_

Patches currently in -mm which might be from ralphw@linux.vnet.ibm.com are

origin.patch

