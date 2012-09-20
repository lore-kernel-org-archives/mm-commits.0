From: akpm@linux-foundation.org
Subject: + scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch added to -mm tree
Date: Thu, 20 Sep 2012 13:02:44 -0700
Message-ID: <20120920200246.08ED5100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64704 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2ITUCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 16:02:49 -0400
Received: by qcqs25 with SMTP id s25so69277qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 13:02:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     Subject: scatterlist: atomic sg_mapping_iter() no longer needs disabled IRQs
has been added to the -mm tree.  Its filename is
     scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scatterlist-atomic-sg_mapping_iter-no-longer-needs-disabled-irqs.patch
device_cgroup-add-deny_all-in-dev_cgroup-structure.patch
device_cgroup-introduce-dev_whitelist_clean.patch
device_cgroup-convert-device_cgroup-internally-to-policy-exceptions.patch
device_cgroup-rename-whitelist-to-exception-list.patch
memstick-add-support-for-legacy-memorysticks.patch

