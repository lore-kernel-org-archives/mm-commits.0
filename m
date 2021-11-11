Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52192C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CD0861108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhKKCzK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E12E610A2;
        Thu, 11 Nov 2021 02:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599141;
        bh=1DSya8izoAHdJhfLNGSRq6alRmqrJZ2xgPG5IAVM45s=;
        h=Date:From:To:Subject:From;
        b=pGwNu4ZPOoAPgGKd6LLuuVVNFll/iDw0F0iKYiGlqFwBpwhBTvm1NrzUSlJlUsH5K
         sqOR/biT/BAG6YLSe0Ot1X4kVZkXiVXyEOlu7Y9xDqfzdYUjgkomM+bPDupqu7HMTS
         ccPVrbW15hrjj8L204F9B+keWVRwJrQ+UYahbGvA=
Date:   Wed, 10 Nov 2021 18:52:21 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, mm-commits@vger.kernel.org,
        tglx@linutronix.de
Subject:  [merged]
 mm-scatterlist-replace-the-preemptible-warning-in-sg_miter_stop.patch
 removed from -mm tree
Message-ID: <20211111025221.JKCZ-8wxK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/scatterlist: replace the !preemptible warning in sg_miter_stop()
has been removed from the -mm tree.  Its filename was
     mm-scatterlist-replace-the-preemptible-warning-in-sg_miter_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/scatterlist: replace the !preemptible warning in sg_miter_stop()

sg_miter_stop() checks for disabled preemption before unmapping a page via
kunmap_atomic().  The kernel doc mentions under context that preemption
must be disabled if SG_MITER_ATOMIC is set.

There is no active requirement for the caller to have preemption disabled
before invoking sg_mitter_stop().  The sg_mitter_*() implementation itself
has no such requirement.

In fact, preemption is disabled by kmap_atomic() as part of
sg_miter_next() and remains disabled as long as there is an active
SG_MITER_ATOMIC mapping.  This is a consequence of kmap_atomic() and not a
requirement for sg_mitter_*() itself.

The user chooses SG_MITER_ATOMIC because it uses the API in a context
where blocking is not possible or blocking is possible but he chooses a
lower weight mapping which is not available on all CPUs and so it might
need less overhead to setup at a price that now preemption will be
disabled.

The kmap_atomic() implementation on PREEMPT_RT does not disable
preemption.  It simply disables CPU migration to ensure that the task
remains on the same CPU while the caller remains preemptible.  This in
turn triggers the warning in sg_miter_stop() because preemption is
allowed.

The PREEMPT_RT and !PREEMPT_RT implementation of kmap_atomic() disable
pagefaults as a requirement.  It is sufficient to check for this instead
of disabled preemption.

Check for disabled pagefault handler in the SG_MITER_ATOMIC case.  Remove
the "preemption disabled" part from the kernel doc as the sg_milter*()
implementation does not care.

[bigeasy@linutronix.de: commit description]
Link: https://lkml.kernel.org/r/20211015211409.cqopacv3pxdwn2ty@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/lib/scatterlist.c~mm-scatterlist-replace-the-preemptible-warning-in-sg_miter_stop
+++ a/lib/scatterlist.c
@@ -828,8 +828,7 @@ static bool sg_miter_get_next_page(struc
  *   stops @miter.
  *
  * Context:
- *   Don't care if @miter is stopped, or not proceeded yet.
- *   Otherwise, preemption disabled if the SG_MITER_ATOMIC is set.
+ *   Don't care.
  *
  * Returns:
  *   true if @miter contains the valid mapping.  false if end of sg
@@ -865,8 +864,7 @@ EXPORT_SYMBOL(sg_miter_skip);
  *   @miter->addr and @miter->length point to the current mapping.
  *
  * Context:
- *   Preemption disabled if SG_MITER_ATOMIC.  Preemption must stay disabled
- *   till @miter is stopped.  May sleep if !SG_MITER_ATOMIC.
+ *   May sleep if !SG_MITER_ATOMIC.
  *
  * Returns:
  *   true if @miter contains the next mapping.  false if end of sg
@@ -906,8 +904,7 @@ EXPORT_SYMBOL(sg_miter_next);
  *   need to be released during iteration.
  *
  * Context:
- *   Preemption disabled if the SG_MITER_ATOMIC is set.  Don't care
- *   otherwise.
+ *   Don't care otherwise.
  */
 void sg_miter_stop(struct sg_mapping_iter *miter)
 {
@@ -922,7 +919,7 @@ void sg_miter_stop(struct sg_mapping_ite
 			flush_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
-			WARN_ON_ONCE(preemptible());
+			WARN_ON_ONCE(!pagefault_disabled());
 			kunmap_atomic(miter->addr);
 		} else
 			kunmap(miter->page);
_

Patches currently in -mm which might be from tglx@linutronix.de are


