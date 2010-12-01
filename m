From: akpm@linux-foundation.org
Subject: + vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch added to -mm tree
Date: Wed, 01 Dec 2010 13:44:26 -0800
Message-ID: <201012012144.oB1LiQM5009297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab0LAVow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 16:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk


The patch titled
     vmalloc: always unmap in vb_free()
has been added to the -mm tree.  Its filename is
     vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch

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

linux-next.patch
vmalloc-eagerly-clear-ptes-on-vunmap.patch
vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch

