From: akpm@linux-foundation.org
Subject: [nacked] mm-warn-about-vfree-from-atomic-context.patch removed
 from -mm tree
Date: Tue, 22 Nov 2016 14:57:13 -0800
Message-ID: <5834cd49.6+lKlQDV7ZibGrSa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933931AbcKVW5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 17:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: warn about vfree from atomic context
has been removed from the -mm tree.  Its filename was
     mm-warn-about-vfree-from-atomic-context.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: warn about vfree from atomic context

We can't handle vfree itself from atomic context, but callers
can explicitly use vfree_atomic instead, which defers the actual
vfree to a workqueue.  Unfortunately in_atomic does not work
on non-preemptible kernels, so we can't just do the right thing
by default.

Link: http://lkml.kernel.org/r/1479474236-4139-8-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmalloc.c~mm-warn-about-vfree-from-atomic-context mm/vmalloc.c
--- a/mm/vmalloc.c~mm-warn-about-vfree-from-atomic-context
+++ a/mm/vmalloc.c
@@ -1530,6 +1530,7 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	BUG_ON(in_nmi());
+	WARN_ON_ONCE(in_atomic());
 
 	kmemleak_free(addr);
 
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-free_unmap_vmap_area_noflush.patch
mm-remove-free_unmap_vmap_area_addr.patch
mm-refactor-__purge_vmap_area_lazy.patch
mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch
mm-turn-vmap_purge_lock-into-a-mutex.patch

