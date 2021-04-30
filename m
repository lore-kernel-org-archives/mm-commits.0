Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5647CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C72661423
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhD3F3c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3F3b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:29:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D05F161434;
        Fri, 30 Apr 2021 05:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760523;
        bh=rawKnRoDTvZYaAIw78hBZIZt9CjXDXNJ9wmeRjL27/4=;
        h=Date:From:To:Subject:From;
        b=II0hrZXI/e5RqbwVmqQeAsVaku8el7rciPlDws4jYOPSeM8yj7wqfq1BT46THXpDN
         PbfRAfrF6cIFtSZu8V3ItscsgHdFtsfDvSrLkpdh8NjyU7Bam+/JHPTgevFTqPhjqO
         Kj4mpGTdlpAcGDdgIlDC6ohO12Vjwsy5gDL/pM3w=
Date:   Thu, 29 Apr 2021 22:28:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch removed from -mm tree
Message-ID: <20210430052842.R5B8sUYPY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-unmap_kernel_range-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch

This patch was dropped because it was folded into mm-vmalloc-remove-unmap_kernel_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-remove-unmap_kernel_range-fix-fix

move vunmap_range_noflush() stub inside !CONFIG_MMU, not !CONFIG_NUMA

Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-vmalloc-remove-unmap_kernel_range-fix-fix
+++ a/mm/internal.h
@@ -447,7 +447,9 @@ static inline struct file *maybe_unlock_
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-
+static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+}
 #endif /* !CONFIG_MMU */
 
 /*
@@ -541,9 +543,6 @@ static inline int node_reclaim(struct pg
 {
 	return NODE_RECLAIM_NOSCAN;
 }
-static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
-{
-}
 #endif
 
 extern int hwpoison_filter(struct page *p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-remove-unmap_kernel_range.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

