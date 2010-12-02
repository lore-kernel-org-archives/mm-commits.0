From: akpm@linux-foundation.org
Subject: [folded] vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch removed from -mm tree
Date: Thu, 02 Dec 2010 14:29:32 -0800
Message-ID: <201012022229.oB2MTXbG012330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757677Ab0LBWbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2010 17:31:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     vmalloc: always unmap in vb_free()
has been removed from the -mm tree.  Its filename was
     vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch

This patch was dropped because it was folded into vmalloc-eagerly-clear-ptes-on-vunmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: always unmap in vb_free()
From: Jeremy Fitzhardinge <jeremy@goop.org>

free_vmap_block() doesn't unmap anything, so just unconditionally unmap
the region.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix
+++ a/mm/vmalloc.c
@@ -941,6 +941,8 @@ static void vb_free(const void *addr, un
 	rcu_read_unlock();
 	BUG_ON(!vb);
 
+	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
+
 	spin_lock(&vb->lock);
 	BUG_ON(bitmap_allocate_region(vb->dirty_map, offset >> PAGE_SHIFT, order));
 
@@ -949,10 +951,8 @@ static void vb_free(const void *addr, un
 		BUG_ON(vb->free);
 		spin_unlock(&vb->lock);
 		free_vmap_block(vb);
-	} else {
+	} else
 		spin_unlock(&vb->lock);
-		vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
-	}
 }
 
 /**
_

Patches currently in -mm which might be from jeremy@goop.org are

vmalloc-eagerly-clear-ptes-on-vunmap.patch
linux-next.patch

