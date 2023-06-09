Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9184DC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjFIXcU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjFIXbf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7D23C25
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D1F463EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF7FC433EF;
        Fri,  9 Jun 2023 23:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353354;
        bh=YHaGSNE3z7mhWKEiOzBOFZY3bqKibGpL5FCOYp18kEA=;
        h=Date:To:From:Subject:From;
        b=nXd3SMPOCoRsxhiKGJwkdmmkNfszKBdSEr8kAnVb2Nnl+mwBMaKMXiXwXxXugg5iU
         rH7YrVK18YtIRiIx1tokS6+TR6jK6S27bzS7kLJzTvJANvT0x8g/uPWzolyOxOIaqq
         e8xQDs3XUqsoFdMTbMs6TJYLKicM7q7fy+rqJQkc=
Date:   Fri, 09 Jun 2023 16:29:13 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch removed from -mm tree
Message-Id: <20230609232913.EEF7FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: prevent flushing dirty space over and over
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/vmalloc: prevent flushing dirty space over and over
Date: Thu, 25 May 2023 14:57:05 +0200 (CEST)

vmap blocks which have active mappings cannot be purged.  Allocations
which have been freed are accounted for in vmap_block::dirty_min/max, so
that they can be detected in _vm_unmap_aliases() as potentially stale
TLBs.

If there are several invocations of _vm_unmap_aliases() then each of them
will flush the dirty range.  That's pointless and just increases the
probability of full TLB flushes.

Avoid that by resetting the flush range after accounting for it.  That's
safe versus other invocations of _vm_unmap_aliases() because this is all
serialized with vmap_purge_lock.

Link: https://lkml.kernel.org/r/20230525124504.692056496@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-prevent-flushing-dirty-space-over-and-over
+++ a/mm/vmalloc.c
@@ -2226,7 +2226,7 @@ static void vb_free(unsigned long addr,
 
 	spin_lock(&vb->lock);
 
-	/* Expand dirty range */
+	/* Expand the not yet TLB flushed dirty range */
 	vb->dirty_min = min(vb->dirty_min, offset);
 	vb->dirty_max = max(vb->dirty_max, offset + (1UL << order));
 
@@ -2264,7 +2264,7 @@ static void _vm_unmap_aliases(unsigned l
 			 * space to be flushed.
 			 */
 			if (!purge_fragmented_block(vb, vbq, &purge_list) &&
-			    vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
+			    vb->dirty_max && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
 
@@ -2274,6 +2274,10 @@ static void _vm_unmap_aliases(unsigned l
 				start = min(s, start);
 				end   = max(e, end);
 
+				/* Prevent that this is flushed again */
+				vb->dirty_min = VMAP_BBMAP_BITS;
+				vb->dirty_max = 0;
+
 				flush = 1;
 			}
 			spin_unlock(&vb->lock);
_

Patches currently in -mm which might be from tglx@linutronix.de are


