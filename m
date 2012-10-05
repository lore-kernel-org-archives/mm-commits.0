From: akpm@linux-foundation.org
Subject: [merged] scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:00 -0700
Message-ID: <20121005201600.AD8C61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51942 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2JEUQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:01 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236105ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, maximlevitsky@gmail.com, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: atomic sg_mapping_iter() no longer needs disabled IRQs
has been removed from the -mm tree.  Its filename was
     scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: scatterlist: atomic sg_mapping_iter() no longer needs disabled IRQs

SG mapping iterator w/ SG_MITER_ATOMIC set required IRQ disabled because
it originally used KM_BIO_SRC_IRQ to allow use from IRQ handlers. 
kmap_atomic() has long been updated to handle stacking atomic mapping
requests on per-cpu basis and only requires not sleeping while mapped.

Update sg_mapping_iter such that atomic iterators only require disabling
preemption instead of disabling IRQ.

While at it, convert wte weird @ARG@ notations to @ARG in the comment of
sg_miter_start().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs
+++ a/lib/scatterlist.c
@@ -404,14 +404,13 @@ EXPORT_SYMBOL(sg_miter_start);
  * @miter: sg mapping iter to proceed
  *
  * Description:
- *   Proceeds @miter@ to the next mapping.  @miter@ should have been
- *   started using sg_miter_start().  On successful return,
- *   @miter@->page, @miter@->addr and @miter@->length point to the
- *   current mapping.
+ *   Proceeds @miter to the next mapping.  @miter should have been started
+ *   using sg_miter_start().  On successful return, @miter->page,
+ *   @miter->addr and @miter->length point to the current mapping.
  *
  * Context:
- *   IRQ disabled if SG_MITER_ATOMIC.  IRQ must stay disabled till
- *   @miter@ is stopped.  May sleep if !SG_MITER_ATOMIC.
+ *   Preemption disabled if SG_MITER_ATOMIC.  Preemption must stay disabled
+ *   till @miter is stopped.  May sleep if !SG_MITER_ATOMIC.
  *
  * Returns:
  *   true if @miter contains the next mapping.  false if end of sg
@@ -465,7 +464,8 @@ EXPORT_SYMBOL(sg_miter_next);
  *   resources (kmap) need to be released during iteration.
  *
  * Context:
- *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ *   Preemption disabled if the SG_MITER_ATOMIC is set.  Don't care
+ *   otherwise.
  */
 void sg_miter_stop(struct sg_mapping_iter *miter)
 {
@@ -479,7 +479,7 @@ void sg_miter_stop(struct sg_mapping_ite
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
-			WARN_ON(!irqs_disabled());
+			WARN_ON_ONCE(preemptible());
 			kunmap_atomic(miter->addr);
 		} else
 			kunmap(miter->page);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
block-store-partition_meta_infouuid-as-a-string.patch
init-reduce-partuuid-min-length-to-1-from-36.patch
block-partition-msdos-provide-uuids-for-partitions.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch

