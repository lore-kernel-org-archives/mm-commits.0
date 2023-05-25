Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8555C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjEYTdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbjEYTdX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:33:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E0DE4A
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE746009E
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B7C433EF;
        Thu, 25 May 2023 19:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043091;
        bh=avGInY3zj6FhhZTqRsdYb2q9I/vHP0vcoWF1Cn1Wnw4=;
        h=Date:To:From:Subject:From;
        b=jHK1BHnXsYtNVLWyDwkgPurfYwiQL+nuByYya3CdVaVW2eNijmZSn5U0ZB526yFa4
         orwjXfFmxLO86sTEvGMv+BsWn0D5gzqFFvSFWLkcYNPS8CvMfrnGFU5qQwyKE4Bboh
         rAicPPayvlXL68UkZWKOhxMykMhu+rliXnQF/2+E=
Date:   Thu, 25 May 2023 12:31:30 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch added to mm-unstable branch
Message-Id: <20230525193131.861B7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: prevent stale TLBs in fully utilized blocks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch

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
Subject: mm/vmalloc: prevent stale TLBs in fully utilized blocks
Date: Thu, 25 May 2023 14:57:03 +0200 (CEST)

Patch series "mm/vmalloc: Assorted fixes and improvements", v2.

this series addresses the following issues:

  1) Prevent the stale TLB problem related to fully utilized vmap blocks

  2) Avoid the double per CPU list walk in _vm_unmap_aliases()

  3) Avoid flushing dirty space over and over

  4) Add a lockless quickcheck in vb_alloc() and add missing
     READ/WRITE_ONCE() annotations

  5) Prevent overeager purging of usable vmap_blocks if
     not under memory/address space pressure.


This patch (of 6):

_vm_unmap_aliases() is used to ensure that no unflushed TLB entries for a
page are left in the system. This is required due to the lazy TLB flush
mechanism in vmalloc.

This is tried to achieve by walking the per CPU free lists, but those do
not contain fully utilized vmap blocks because they are removed from the
free list once the blocks free space became zero.

When the block is not fully unmapped then it is not on the purge list
either.

So neither the per CPU list iteration nor the purge list walk find the
block and if the page was mapped via such a block and the TLB has not yet
been flushed, the guarantee of _vm_unmap_aliases() that there are no stale
TLBs after returning is broken:

x = vb_alloc() // Removes vmap_block from free list because vb->free became 0
vb_free(x)     // Unmaps page and marks in dirty_min/max range
	       // Block has still mappings and is not put on purge list

// Page is reused
vm_unmap_aliases() // Can't find vmap block with the dirty space -> FAIL

So instead of walking the per CPU free lists, walk the per CPU xarrays
which hold pointers to _all_ active blocks in the system including those
removed from the free lists.

Link: https://lkml.kernel.org/r/20230525122342.109672430@linutronix.de
Link: https://lkml.kernel.org/r/20230525124504.573987880@linutronix.de
Fixes: db64fe02258f ("mm: rewrite vmap layer")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks
+++ a/mm/vmalloc.c
@@ -2236,9 +2236,10 @@ static void _vm_unmap_aliases(unsigned l
 	for_each_possible_cpu(cpu) {
 		struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, cpu);
 		struct vmap_block *vb;
+		unsigned long idx;
 
 		rcu_read_lock();
-		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
+		xa_for_each(&vbq->vmap_blocks, idx, vb) {
 			spin_lock(&vb->lock);
 			if (vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
_

Patches currently in -mm which might be from tglx@linutronix.de are

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

