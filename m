From: akpm@linux-foundation.org
Subject: [merged] mm-remove-free_unmap_vmap_area_noflush.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:25:45 -0800
Message-ID: <58519cb9.szGvglZiZpAlfb2E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove free_unmap_vmap_area_noflush()
has been removed from the -mm tree.  Its filename was
     mm-remove-free_unmap_vmap_area_noflush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove free_unmap_vmap_area_noflush()

Patch series "reduce latency in __purge_vmap_area_lazy", v2.


This patch (of 10):

Sort out the long lock hold times in __purge_vmap_area_lazy.  It is based
on a patch from Joel.


Inline free_unmap_vmap_area_noflush() it into the only caller.

Link: http://lkml.kernel.org/r/1479474236-4139-2-git-send-email-hch@lst.de
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

 mm/vmalloc.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN mm/vmalloc.c~mm-remove-free_unmap_vmap_area_noflush mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-free_unmap_vmap_area_noflush
+++ a/mm/vmalloc.c
@@ -711,22 +711,13 @@ static void free_vmap_area_noflush(struc
 }
 
 /*
- * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
- * called for the correct range previously.
- */
-static void free_unmap_vmap_area_noflush(struct vmap_area *va)
-{
-	unmap_vmap_area(va);
-	free_vmap_area_noflush(va);
-}
