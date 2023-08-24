Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9254C727A6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbjHXXWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbjHXXWW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B8FE51
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5B1B63676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BD3C433C8;
        Thu, 24 Aug 2023 23:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919339;
        bh=BW6cp8XBHBqjEHZ+eQkggIhL0+eQ52g9FTdH/9ynuNw=;
        h=Date:To:From:Subject:From;
        b=oW2nSgvkLmDNPivx5WN5b1dItYzGujMR814w+P79Mm0KjM1kjB7rejm5fMhN4Ynv0
         s2pG8u1reS0EYbDG37rdVZV18vaeMXM6vlQiuAFnP0pbXimsKSJ1+5mRyiXBaT4/9G
         roy6CrEoj0Q6hPjmQMgQKaL5gg3uyNpStnID9Hrk=
Date:   Thu, 24 Aug 2023 16:22:18 -0700
To:     mm-commits@vger.kernel.org, dinguyen@kernel.org, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-fix-flush_dcache_page-for-usage-from-irq-context.patch removed from -mm tree
Message-Id: <20230824232219.19BD3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: fix flush_dcache_page() for usage from irq context
has been removed from the -mm tree.  Its filename was
     nios2-fix-flush_dcache_page-for-usage-from-irq-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: nios2: fix flush_dcache_page() for usage from irq context
Date: Tue, 22 Aug 2023 16:27:49 +0200

Since at least kernel 6.1, flush_dcache_page() is called with IRQs
disabled, e.g.  from aio_complete().

But the current implementation for flush_dcache_page() on NIOS2
unintentionally re-enables IRQs, which may lead to deadlocks.

Fix it by using xa_lock_irqsave() and xa_unlock_irqrestore() for the
flush_dcache_mmap_*lock() macros instead.

Link: https://lkml.kernel.org/r/ZOTF5WWURQNH9+iw@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/cacheflush.h |    4 ++++
 arch/nios2/mm/cacheflush.c          |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/nios2/include/asm/cacheflush.h~nios2-fix-flush_dcache_page-for-usage-from-irq-context
+++ a/arch/nios2/include/asm/cacheflush.h
@@ -52,5 +52,9 @@ extern void invalidate_dcache_range(unsi
 
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)
 
 #endif /* _ASM_NIOS2_CACHEFLUSH_H */
--- a/arch/nios2/mm/cacheflush.c~nios2-fix-flush_dcache_page-for-usage-from-irq-context
+++ a/arch/nios2/mm/cacheflush.c
@@ -75,12 +75,13 @@ static void flush_aliases(struct address
 {
 	struct mm_struct *mm = current->active_mm;
 	struct vm_area_struct *vma;
+	unsigned long flags;
 	pgoff_t pgoff;
 	unsigned long nr = folio_nr_pages(folio);
 
 	pgoff = folio->index;
 
-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
 		unsigned long start;
 
@@ -92,7 +93,7 @@ static void flush_aliases(struct address
 		start = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		flush_cache_range(vma, start, start + nr * PAGE_SIZE);
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }
 
 void flush_cache_all(void)
_

Patches currently in -mm which might be from deller@gmx.de are


