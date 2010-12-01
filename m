From: akpm@linux-foundation.org
Subject: + vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch added to -mm tree
Date: Tue, 30 Nov 2010 16:33:19 -0800
Message-ID: <201012010033.oB10XJOS019568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab0LAAeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 19:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk


The patch titled
     vmalloc: avoid double-unmapping percpu blocks
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
Subject: vmalloc: avoid double-unmapping percpu blocks
From: Jeremy Fitzhardinge <jeremy@goop.org>

The area has always been unmapped by the time free_vmap_block() is
called, so there's no need to unmap it again.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix
+++ a/mm/vmalloc.c
@@ -667,13 +667,12 @@ static void purge_vmap_area_lazy(void)
 }
 
 /*
- * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
- * called for the correct range previously.
+ * Free a vmap area, caller ensuring that the area has been unmapped
+ * and flush_cache_vunmap had been called for the correct range
+ * previously.
  */
-static void free_unmap_vmap_area_noflush(struct vmap_area *va)
+static void free_vmap_area_noflush(struct vmap_area *va)
 {
-	unmap_vmap_area(va);
-
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
 	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
@@ -681,6 +680,16 @@ static void free_unmap_vmap_area_noflush
 }
 
 /*
+ * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
+ * called for the correct range previously.
+ */
+static void free_unmap_vmap_area_noflush(struct vmap_area *va)
+{
+	unmap_vmap_area(va);
+	free_vmap_area_noflush(va);
+}
+
+/*
  * Free and unmap a vmap area
  */
 static void free_unmap_vmap_area(struct vmap_area *va)
@@ -856,7 +865,7 @@ static void free_vmap_block(struct vmap_
 	spin_unlock(&vmap_block_tree_lock);
 	BUG_ON(tmp != vb);
 
-	free_unmap_vmap_area_noflush(vb->va);
+	free_vmap_area_noflush(vb->va);
 	call_rcu(&vb->rcu_head, rcu_free_vb);
 }
 
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
vmalloc-eagerly-clear-ptes-on-vunmap.patch
vmalloc-eagerly-clear-ptes-on-vunmap-fix.patch

