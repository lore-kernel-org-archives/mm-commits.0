Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CE4C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbjEYTcK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjEYTcJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:32:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBFDE6C
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DBC661010
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77728C433EF;
        Thu, 25 May 2023 19:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043095;
        bh=pYQeMRafdoeujR577Xh7Cp4+rYbDGafDzmDh75QLUeo=;
        h=Date:To:From:Subject:From;
        b=2ugtvk0K6y7rydHFjbdfTPihGLZ79iP3xtS7kzs5h2Q1/rurCh5EBH8j6z7FNPsHT
         wm0hrMdtoeN9lq94k8CdIZNDCgDeAY/uz1q12ZvnF0Q/y5GY24f4Bfo/z74KsLiOnr
         ur/QIvPi6RZ91BKRWNiYgsq2i/R2prOOW+YneOG4=
Date:   Thu, 25 May 2023 12:31:34 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch added to mm-unstable branch
Message-Id: <20230525193135.77728C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: prevent flushing dirty space over and over
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch

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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
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

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

