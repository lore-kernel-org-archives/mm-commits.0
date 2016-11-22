From: akpm@linux-foundation.org
Subject: + mm-add-preempt-points-into-__purge_vmap_area_lazy.patch added
 to -mm tree
Date: Mon, 21 Nov 2016 22:11:57 -0800
Message-ID: <5833e1ad.PNQgQuW7IE/ybwFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbcKVGL6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joelaf@google.com, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add preempt points into __purge_vmap_area_lazy()
has been added to the -mm tree.  Its filename is
     mm-add-preempt-points-into-__purge_vmap_area_lazy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-preempt-points-into-__purge_vmap_area_lazy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-preempt-points-into-__purge_vmap_area_lazy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from joelaf@google.com are

mm-add-preempt-points-into-__purge_vmap_area_lazy.patch

