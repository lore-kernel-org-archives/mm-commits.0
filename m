Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F695C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFIXcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjFIXbf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76023C2B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7F1065D09
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC00C433EF;
        Fri,  9 Jun 2023 23:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353355;
        bh=kRGoZ2TYistaF7/QOXEC8ezWXHmonXQCX8+A/f4IQm0=;
        h=Date:To:From:Subject:From;
        b=dobUvt38asNI463r9hjYHkrUo/5q+dpIfkeRScJvegDypzfhfMTGZrcrC0SLXQm2s
         ya5TqSrYTtmu8RYaDuHPNKRSLo7OcbyIOzA031z+p/g8D/vI6bW9qCgVvFort0umw1
         x9SA1kOIFBONnaCGb1ILd04nbb9CabXfUbbTjUWg=
Date:   Fri, 09 Jun 2023 16:29:14 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-check-free-space-in-vmap_block-lockless.patch removed from -mm tree
Message-Id: <20230609232915.0DC00C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: check free space in vmap_block lockless
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-check-free-space-in-vmap_block-lockless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/vmalloc: check free space in vmap_block lockless
Date: Thu, 25 May 2023 14:57:07 +0200 (CEST)

vb_alloc() unconditionally locks a vmap_block on the free list to check
the free space.

This can be done locklessly because vmap_block::free never increases, it's
only decreased on allocations.

Check the free space lockless and only if that succeeds, recheck under the
lock.

Link: https://lkml.kernel.org/r/20230525124504.750481992@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-check-free-space-in-vmap_block-lockless
+++ a/mm/vmalloc.c
@@ -2168,6 +2168,9 @@ static void *vb_alloc(unsigned long size
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 		unsigned long pages_off;
 
+		if (READ_ONCE(vb->free) < (1UL << order))
+			continue;
+
 		spin_lock(&vb->lock);
 		if (vb->free < (1UL << order)) {
 			spin_unlock(&vb->lock);
@@ -2176,7 +2179,7 @@ static void *vb_alloc(unsigned long size
 
 		pages_off = VMAP_BBMAP_BITS - vb->free;
 		vaddr = vmap_block_vaddr(vb->va->va_start, pages_off);
-		vb->free -= 1UL << order;
+		WRITE_ONCE(vb->free, vb->free - (1UL << order));
 		bitmap_set(vb->used_map, pages_off, (1UL << order));
 		if (vb->free == 0) {
 			spin_lock(&vbq->lock);
_

Patches currently in -mm which might be from tglx@linutronix.de are


