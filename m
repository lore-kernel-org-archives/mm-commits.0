Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D4CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1696108F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhIPTJi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239124AbhIPTJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DFB5610D1;
        Thu, 16 Sep 2021 19:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819294;
        bh=RqwRgasF712K7qiD624iGVv+SFSUgXVxkkUbSikhSZk=;
        h=Date:From:To:Subject:From;
        b=PayhapaiaOGZLlUXKc87qqdBegNJzmy0ucR+hxoEjU9IRek/Ax3ArJWS+lDdhUB3H
         stfHsycth4LA1FUFcl8QmMmtpHoy/H+GTo9134aKRyaczXqnG8lnLq9a4hvIOUNvQH
         oht+FIoTbH8/HGEBa2ST87ZrN6aogaNY7ek7+MyY=
Date:   Thu, 16 Sep 2021 12:08:14 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, david@redhat.com, hch@lst.de,
        keescook@chromium.org, mgorman@suse.de, mm-commits@vger.kernel.org,
        peterz@infradead.org, urezki@gmail.com, will@kernel.org
Subject:  + mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch added
 to -mm tree
Message-ID: <20210916190814.-GHDYCX75%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: don't allow VM_NO_GUARD on vmap()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-dont-allow-vm_no_guard-on-vmap.patch

