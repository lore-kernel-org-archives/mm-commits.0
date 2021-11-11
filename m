Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85327C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD2F613B3
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhKKCqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhKKCqE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9946D61247;
        Thu, 11 Nov 2021 02:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598595;
        bh=crZnm50Uh4g2+Rlf0D0WENV7tXVleWgrTgOCqT6bVH4=;
        h=Date:From:To:Subject:From;
        b=tAq8uSp5myLs0Ag3K9n/xSdFSPpGvIwZHtF7EEj3jriYbvNSJULa7Qn1hWcHOff6o
         YoZtHztVAvsdLF3qTnVcGuKPHZ0+aUc9u+CaeFwmFUu0BOMn5SMZVeDYDt9hy+il9b
         ONJ2vidSwpGzb4ajghocXn4Ph4Lzx/W+Gk3nTfH0=
Date:   Wed, 10 Nov 2021 18:43:15 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, david@redhat.com, hch@lst.de,
        keescook@chromium.org, mgorman@suse.de, mm-commits@vger.kernel.org,
        peterz@infradead.org, urezki@gmail.com, will@kernel.org
Subject:  [merged] mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch
 removed from -mm tree
Message-ID: <20211111024315.o6Q7jw39k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: don't allow VM_NO_GUARD on vmap()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: mm/vmalloc: don't allow VM_NO_GUARD on vmap()

The vmalloc guard pages are added on top of each allocation, thereby
isolating any two allocations from one another.  The top guard of the
lower allocation is the bottom guard guard of the higher allocation etc.

Therefore VM_NO_GUARD is dangerous; it breaks the basic premise of
isolating separate allocations.

There are only two in-tree users of this flag, neither of which use it
through the exported interface.  Ensure it stays this way.

Link: https://lkml.kernel.org/r/YUMfdA36fuyZ+/xt@hirez.programming.kicks-ass.net
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-dont-allow-vm_no_guard-on-vmap
+++ a/include/linux/vmalloc.h
@@ -22,7 +22,7 @@ struct notifier_block;		/* in notifier.h
 #define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_DMA_COHERENT		0x00000010	/* dma_alloc_coherent */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
-#define VM_NO_GUARD		0x00000040      /* don't add guard page */
+#define VM_NO_GUARD		0x00000040      /* ***DANGEROUS*** don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
 #define VM_FLUSH_RESET_PERMS	0x00000100	/* reset direct map and flush TLB on unmap, can't be freed in atomic context */
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
--- a/mm/vmalloc.c~mm-vmalloc-dont-allow-vm_no_guard-on-vmap
+++ a/mm/vmalloc.c
@@ -2743,6 +2743,13 @@ void *vmap(struct page **pages, unsigned
 
 	might_sleep();
 
+	/*
+	 * Your top guard is someone else's bottom guard. Not having a top
+	 * guard compromises someone else's mappings too.
+	 */
+	if (WARN_ON_ONCE(flags & VM_NO_GUARD))
+		flags &= ~VM_NO_GUARD;
+
 	if (count > totalram_pages())
 		return NULL;
 
_

Patches currently in -mm which might be from peterz@infradead.org are


