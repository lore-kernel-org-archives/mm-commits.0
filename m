Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292F2C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjFIXcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbjFIXbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8884682
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE64B60FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6E7C4339B;
        Fri,  9 Jun 2023 23:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353356;
        bh=jQgzipeBs5J0YqfvDZtmeJx2U1hZFAmQQvUtDDRixJs=;
        h=Date:To:From:Subject:From;
        b=RUM3LqvF14lZmuC4AmiDhfUQvsDIV4LYt6wrlgLkIDYQFBGu2Fb+VaeYY5/eb4joT
         EbkhkQxEKUGsjwLYVvfwrrnGZnNoMj5nt9oHa46GKWCE1GChD0k5Ham81FIpI+k9rG
         423S2O2NM0aLlMGkfz4cLGj+p8YqeX2Hb5rB3OO4=
Date:   Fri, 09 Jun 2023 16:29:15 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-missing-read-write_once-annotations.patch removed from -mm tree
Message-Id: <20230609232916.1E6E7C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: add missing READ/WRITE_ONCE() annotations
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-missing-read-write_once-annotations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <bhe@redhat.com>
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


