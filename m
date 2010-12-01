From: akpm@linux-foundation.org
Subject: + vmalloc-eagerly-clear-ptes-on-vunmap.patch added to -mm tree
Date: Tue, 30 Nov 2010 16:33:16 -0800
Message-ID: <201012010033.oB10XHpS019560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab0LAAeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 19:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk


The patch titled
     vmalloc: eagerly clear ptes on vunmap
has been added to the -mm tree.  Its filename is
     vmalloc-eagerly-clear-ptes-on-vunmap.patch

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
Subject: vmalloc: eagerly clear ptes on vunmap
From: Jeremy Fitzhardinge <jeremy@goop.org>

When unmapping a region in the vmalloc space, clear the ptes immediately. 
There's no point in deferring this because there's no amortization
benefit.

The TLBs are left dirty, and they are flushed lazily to amortize the cost
of the IPIs.

This specific motivation for this patch is a performance regression since
2.6.36 when using NFS under Xen, triggered by the NFS client's use of
vm_map_ram() introduced in 56e4ebf877b60 ("NFS: readdir with vmapped
pages") .  XFS also uses vm_map_ram() and could cause similar problems.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap
+++ a/mm/vmalloc.c
@@ -623,7 +623,6 @@ static void __purge_vmap_area_lazy(unsig
 			if (va->va_end > *end)
 				*end = va->va_end;
 			nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
-			unmap_vmap_area(va);
 			list_add_tail(&va->purge_list, &valist);
 			va->flags |= VM_LAZY_FREEING;
 			va->flags &= ~VM_LAZY_FREE;
@@ -673,6 +672,8 @@ static void purge_vmap_area_lazy(void)
  */
 static void free_unmap_vmap_area_noflush(struct vmap_area *va)
 {
+	unmap_vmap_area(va);
+
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
 	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
@@ -1001,8 +1002,10 @@ static void vb_free(const void *addr, un
 		BUG_ON(vb->free);
 		spin_unlock(&vb->lock);
 		free_vmap_block(vb);
-	} else
+	} else {
 		spin_unlock(&vb->lock);
+		vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
+	}
 }
 
 /**
@@ -1045,7 +1048,6 @@ void vm_unmap_aliases(void)
 
 				s = vb->va->va_start + (i << PAGE_SHIFT);
 				e = vb->va->va_start + (j << PAGE_SHIFT);
-				vunmap_page_range(s, e);
 				flush = 1;
 
 				if (s < start)
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
vmalloc-eagerly-clear-ptes-on-vunmap.patch
vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch

