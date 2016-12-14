From: akpm@linux-foundation.org
Subject: [merged] mm-remove-free_unmap_vmap_area_addr.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:25:48 -0800
Message-ID: <58519cbc./5aZzdHBJ+hWZMeC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove free_unmap_vmap_area_addr()
has been removed from the -mm tree.  Its filename was
     mm-remove-free_unmap_vmap_area_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove free_unmap_vmap_area_addr()

Just inline it into the only caller.

Link: http://lkml.kernel.org/r/1479474236-4139-3-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jisheng Zhang <jszhang@marvell.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/vmalloc.c~mm-remove-free_unmap_vmap_area_addr mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-free_unmap_vmap_area_addr
+++ a/mm/vmalloc.c
@@ -731,16 +731,6 @@ static struct vmap_area *find_vmap_area(
 	return va;
 }
 
-static void free_unmap_vmap_area_addr(unsigned long addr)
-{
-	struct vmap_area *va;
-
-	va = find_vmap_area(addr);
-	BUG_ON(!va);
-	free_unmap_vmap_area(va);
-}
-
-
 /*** Per cpu kva allocator ***/
 
 /*
@@ -1098,6 +1088,7 @@ void vm_unmap_ram(const void *mem, unsig
 {
 	unsigned long size = (unsigned long)count << PAGE_SHIFT;
 	unsigned long addr = (unsigned long)mem;
+	struct vmap_area *va;
 
 	BUG_ON(!addr);
 	BUG_ON(addr < VMALLOC_START);
@@ -1107,10 +1098,14 @@ void vm_unmap_ram(const void *mem, unsig
 	debug_check_no_locks_freed(mem, size);
 	vmap_debug_free_range(addr, addr+size);
 
-	if (likely(count <= VMAP_MAX_ALLOC))
+	if (likely(count <= VMAP_MAX_ALLOC)) {
 		vb_free(mem, size);
-	else
-		free_unmap_vmap_area_addr(addr);
+		return;
+	}
+
+	va = find_vmap_area(addr);
+	BUG_ON(!va);
+	free_unmap_vmap_area(va);
 }
 EXPORT_SYMBOL(vm_unmap_ram);
 
_

Patches currently in -mm which might be from hch@lst.de are


