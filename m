Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6441AC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjEYTde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240778AbjEYTdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92E6E5F
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13BE663DA4
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC6C433EF;
        Thu, 25 May 2023 19:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043099;
        bh=RNodpSOenY+bcNIDxQ6PUp5YUk0V6vtKpF3XwiUePG4=;
        h=Date:To:From:Subject:From;
        b=ipGHIzFDGSaQDjtmNlEhXQKavTKPMs+I2Cy5hRVe+47c8cZLRwP1VBb8k27mV0Ny5
         dH/PAUKo8G8VMxkPJ8KAZKKQ9xtE4qc5/TlCVTCuUYJ6iuHukGe+CnyTfiwm0nI1tg
         g42HxWOWEs0Z1tX340KDZHppzHO9RNRaaZ2Eaqbo=
Date:   Thu, 25 May 2023 12:31:38 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-missing-read-write_once-annotations.patch added to mm-unstable branch
Message-Id: <20230525193139.6CEC6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add missing READ/WRITE_ONCE() annotations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-missing-read-write_once-annotations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-missing-read-write_once-annotations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/vmalloc: add missing READ/WRITE_ONCE() annotations
Date: Thu, 25 May 2023 14:57:08 +0200 (CEST)

purge_fragmented_blocks() accesses vmap_block::free and vmap_block::dirty
lockless for a quick check.

Add the missing READ/WRITE_ONCE() annotations.

Link: https://lkml.kernel.org/r/20230525124504.807356682@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-missing-read-write_once-annotations
+++ a/mm/vmalloc.c
@@ -2094,9 +2094,9 @@ static bool purge_fragmented_block(struc
 		return false;
 
 	/* prevent further allocs after releasing lock */
-	vb->free = 0;
+	WRITE_ONCE(vb->free, 0);
 	/* prevent purging it again */
-	vb->dirty = VMAP_BBMAP_BITS;
+	WRITE_ONCE(vb->dirty, VMAP_BBMAP_BITS);
 	vb->dirty_min = 0;
 	vb->dirty_max = VMAP_BBMAP_BITS;
 	spin_lock(&vbq->lock);
@@ -2124,8 +2124,11 @@ static void purge_fragmented_blocks(int
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-		if (vb->free + vb->dirty != VMAP_BBMAP_BITS ||
-		    vb->dirty == VMAP_BBMAP_BITS)
+		unsigned long free = READ_ONCE(vb->free);
+		unsigned long dirty = READ_ONCE(vb->dirty);
+
+		if (free + dirty != VMAP_BBMAP_BITS ||
+		    dirty == VMAP_BBMAP_BITS)
 			continue;
 
 		spin_lock(&vb->lock);
@@ -2233,7 +2236,7 @@ static void vb_free(unsigned long addr,
 	vb->dirty_min = min(vb->dirty_min, offset);
 	vb->dirty_max = max(vb->dirty_max, offset + (1UL << order));
 
-	vb->dirty += 1UL << order;
+	WRITE_ONCE(vb->dirty, vb->dirty + (1UL << order));
 	if (vb->dirty == VMAP_BBMAP_BITS) {
 		BUG_ON(vb->free);
 		spin_unlock(&vb->lock);
_

Patches currently in -mm which might be from tglx@linutronix.de are

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

