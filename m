Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1C2C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbjEYTcW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbjEYTcN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5951CE70
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C1A63C09
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5B3C4339B;
        Thu, 25 May 2023 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685043097;
        bh=QbQ8geR06uDL1Jf5ourwh2VZPT/Qm20V4xnB9xqomLM=;
        h=Date:To:From:Subject:From;
        b=puJL1hX5yWMuyVxKerczPru0BmKt05wGwiUkqP2JtJws5rbmJ1s2oo5ufWOsdgPYd
         YkLE27LjeA7aAFYo8aT1om6ZWLKNjCNDdUoEXVqWf1+7TT63OqpGJNbuxAwjb7RIBC
         yme+VcBEOwpKe1Nhh9EAKyeArF/70G1KMhoH7EqU=
Date:   Thu, 25 May 2023 12:31:36 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@lst.de, bhe@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-check-free-space-in-vmap_block-lockless.patch added to mm-unstable branch
Message-Id: <20230525193137.8E5B3C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: check free space in vmap_block lockless
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-check-free-space-in-vmap_block-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-check-free-space-in-vmap_block-lockless.patch

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
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
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

mm-vmalloc-prevent-stale-tlbs-in-fully-utilized-blocks.patch
mm-vmalloc-avoid-iterating-over-per-cpu-vmap-blocks-twice.patch
mm-vmalloc-prevent-flushing-dirty-space-over-and-over.patch
mm-vmalloc-check-free-space-in-vmap_block-lockless.patch
mm-vmalloc-add-missing-read-write_once-annotations.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

