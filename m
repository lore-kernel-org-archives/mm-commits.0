From: akpm@linux-foundation.org
Subject: [patch 077/123] mm: add preempt points into
 __purge_vmap_area_lazy()
Date: Mon, 12 Dec 2016 16:44:26 -0800
Message-ID: <584f446a.8cRmFtbYm/w+9nqb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753087AbcLMAo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joelaf@google.com, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de

From: Joel Fernandes <joelaf@google.com>
Subject: mm: add preempt points into __purge_vmap_area_lazy()

Use cond_resched_lock to avoid holding the vmap_area_lock for a
potentially long time and thus creating bad latencies for various
workloads.

[hch: split from a larger patch by Joel, wrote the crappy changelog]
Link: http://lkml.kernel.org/r/1479474236-4139-11-git-send-email-hch@lst.de
Signed-off-by: Joel Fernandes <joelaf@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jisheng Zhang <jszhang@marvell.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-add-preempt-points-into-__purge_vmap_area_lazy mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-preempt-points-into-__purge_vmap_area_lazy
+++ a/mm/vmalloc.c
@@ -628,7 +628,7 @@ static bool __purge_vmap_area_lazy(unsig
 	struct llist_node *valist;
 	struct vmap_area *va;
 	struct vmap_area *n_va;
-	int nr = 0;
+	bool do_free = false;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
@@ -638,18 +638,22 @@ static bool __purge_vmap_area_lazy(unsig
 			start = va->va_start;
 		if (va->va_end > end)
 			end = va->va_end;
-		nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
+		do_free = true;
 	}
 
-	if (!nr)
+	if (!do_free)
 		return false;
 
-	atomic_sub(nr, &vmap_lazy_nr);
 	flush_tlb_kernel_range(start, end);
 
 	spin_lock(&vmap_area_lock);
-	llist_for_each_entry_safe(va, n_va, valist, purge_list)
+	llist_for_each_entry_safe(va, n_va, valist, purge_list) {
+		int nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
+
 		__free_vmap_area(va);
+		atomic_sub(nr, &vmap_lazy_nr);
+		cond_resched_lock(&vmap_area_lock);
+	}
 	spin_unlock(&vmap_area_lock);
 	return true;
 }
_
