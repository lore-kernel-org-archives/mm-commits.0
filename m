Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A36DC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6364D60E76
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350386AbhICU6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350417AbhICU6O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D5D9610E5;
        Fri,  3 Sep 2021 20:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702633;
        bh=umvBGAyCy2ATGEW0apNq9msRvmO/Ve/Gn6xW7GtRhro=;
        h=Date:From:To:Subject:From;
        b=pTN5czRTFxmCKfe3ZxLWiMa45VE2bRRkddR9RNDZaaTj7OklJS2h4CzcUXaW/F2TT
         71fqg65Tk5JHggc+UxIhUzrE9RuCcPB3TKwBzxXcpXP80kLyrdTyu3AVAuorKJ64qK
         51LKZ3VMFm8NK/imy/T7TTWkx0U39xyYLISeL4io=
Date:   Fri, 03 Sep 2021 13:57:13 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged]
 shmem-shmem_writepage-split-unlikely-i915-thp.patch removed from -mm tree
Message-ID: <20210903205713.rwcAMgLgh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: shmem_writepage() split unlikely i915 THP
has been removed from the -mm tree.  Its filename was
     shmem-shmem_writepage-split-unlikely-i915-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shmem_writepage() split unlikely i915 THP

drivers/gpu/drm/i915/gem/i915_gem_shmem.c contains a shmem_writeback()
which calls shmem_writepage() from a shrinker: that usually works well
enough; but if /sys/kernel/mm/transparent_hugepage/shmem_enabled has been
set to "always" (intended to be usable) or "force" (forces huge everywhere
for easy testing), shmem_writepage() is surprised to be called with a huge
page, and crashes on the VM_BUG_ON_PAGE(PageCompound) (I did not find out
where the crash happens when CONFIG_DEBUG_VM is off).

LRU page reclaim always splits the shmem huge page first: I'd prefer not
to demand that of i915, so check and split compound in shmem_writepage().

Patch history: when first sent last year
http://lkml.kernel.org/r/alpine.LSU.2.11.2008301401390.5954@eggly.anvils
https://lore.kernel.org/linux-mm/20200919042009.bomzxmrg7%25akpm@linux-foundation.org/
Matthew Wilcox noticed that tail pages were wrongly left clean.  This
version brackets the split with Set and Clear PageDirty as he suggested:
which works very well, even if it falls short of our aspirations.  And
recently I realized that the crash is not limited to the testing option
"force", but affects "always" too: which is more important to fix.

Link: https://lkml.kernel.org/r/bac6158c-8b3d-4dca-cffc-4982f58d9794@google.com
Fixes: 2d6692e642e7 ("drm/i915: Start writeback from the shrinker")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-shmem_writepage-split-unlikely-i915-thp
+++ a/mm/shmem.c
@@ -1344,7 +1344,19 @@ static int shmem_writepage(struct page *
 	swp_entry_t swap;
 	pgoff_t index;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
+	/*
+	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
+	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
+	 * and its shmem_writeback() needs them to be split when swapping.
+	 */
+	if (PageTransCompound(page)) {
+		/* Ensure the subpages are still dirty */
+		SetPageDirty(page);
+		if (split_huge_page(page) < 0)
+			goto redirty;
+		ClearPageDirty(page);
+	}
+
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
 	index = page->index;
_

Patches currently in -mm which might be from hughd@google.com are


