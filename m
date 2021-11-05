Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC01C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD796126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhKEUmD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKEUmC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914A06056B;
        Fri,  5 Nov 2021 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144762;
        bh=w5HZz/nvaFNsq3igD47VFQavMrp+gHMdvsVCo8mPFbE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DiYUdMdWnAa/FcSkNwBMfMl+/77/yCJWzVDgCFNNurneaTphJVv5r4DqimGt7VxDe
         PUeaOOg03YWykBP35Ah57dvdsv9L/U4Riq7bH0zTZwImMMJbFnCsBCk1AJ5tbCj5Nr
         ToQNkNi3YizPXWXRA999NCYX/6D10EUFlQ6sviN0=
Date:   Fri, 05 Nov 2021 13:39:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, david@redhat.com,
        hch@lst.de, keescook@chromium.org, linux-mm@kvack.org,
        mgorman@suse.de, mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, urezki@gmail.com, will@kernel.org
Subject:  [patch 090/262] mm/vmalloc: don't allow VM_NO_GUARD on
 vmap()
Message-ID: <20211105203922.X-KS3cTcm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
