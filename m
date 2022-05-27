Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F14C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349671AbiE0QfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354199AbiE0QfN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FE73B56F
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FE4B825B0
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D51C385B8;
        Fri, 27 May 2022 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669309;
        bh=5y7n3Jk+a7UY0vllWW8Tl76u+OiLTi9/XsRR2Dd+8Y0=;
        h=Date:To:From:Subject:From;
        b=pO3fR1kB/+0LZI0dqbS6jpl2ujniYiO/8nr+zP9Yqk7r7VsyQGtHU5QCnWyXmw4pe
         gBuYCInXTEyhPI5D2RYE70I0fdG3Gz4dI9MUdvFoMF1FYI9+zcjMFJl2JXSK8IYpJU
         2vVgHmgnJEEDv1S3EFwbaE+RA7nD9BCyUsTI+0l0=
Date:   Fri, 27 May 2022 09:35:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch removed from -mm tree
Message-Id: <20220527163509.D2D51C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: fix lost swap bits in unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix lost swap bits in unuse_pte()
Date: Thu, 19 May 2022 20:50:27 +0800

This is observed by code review only but not any real report.

When we turn off swapping we could have lost the bits stored in the swap
ptes.  The new rmap-exclusive bit is fine since that turned into a page
flag, but not for soft-dirty and uffd-wp.  Add them.

Link: https://lkml.kernel.org/r/20220519125030.21486-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-lost-swap-bits-in-unuse_pte
+++ a/mm/swapfile.c
@@ -1774,7 +1774,7 @@ static int unuse_pte(struct vm_area_stru
 {
 	struct page *swapcache;
 	spinlock_t *ptl;
-	pte_t *pte;
+	pte_t *pte, new_pte;
 	int ret = 1;
 
 	swapcache = page;
@@ -1823,8 +1823,12 @@ static int unuse_pte(struct vm_area_stru
 		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
-	set_pte_at(vma->vm_mm, addr, pte,
-		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
+	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
+	if (pte_swp_soft_dirty(*pte))
+		new_pte = pte_mksoft_dirty(new_pte);
+	if (pte_swp_uffd_wp(*pte))
+		new_pte = pte_mkuffd_wp(new_pte);
+	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	swap_free(entry);
 out:
 	pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


