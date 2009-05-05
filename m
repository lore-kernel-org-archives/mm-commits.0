From: akpm@linux-foundation.org
Subject: + alloc_vmap_area-fix-memory-leak.patch added to -mm tree
Date: Tue, 05 May 2009 12:50:12 -0700
Message-ID: <200905051950.n45JoCtY021673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139AbZEETwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralphw@linux.vnet.ibm.com, cl@linux-foundation.org, minchan.kim@gmail.com, npiggin@suse.de


The patch titled
     alloc_vmap_area: fix memory leak
has been added to the -mm tree.  Its filename is
     alloc_vmap_area-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -403,6 +403,7 @@ overflow:
 			printk(KERN_WARNING
 				"vmap allocation for size %lu failed: "
 				"use vmalloc=<size> to increase size.\n", size);
+		kfree(va);
 		return ERR_PTR(-EBUSY);
 	}
 
_

Patches currently in -mm which might be from ralphw@linux.vnet.ibm.com are

alloc_vmap_area-fix-memory-leak.patch

