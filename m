Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C155CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiGRAVq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiGRAUV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D14214D11
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D532B80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE92FC341C0;
        Mon, 18 Jul 2022 00:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103515;
        bh=g8OG4hm/oqJwLr9FTbwZx1s9LuaTJO1ACZiY6VefJSU=;
        h=Date:To:From:Subject:From;
        b=w0SNzNLUU/Uu2HeMWMm9Ckz/YqofkYRXVQlFw9UTt/N2XBrFCXqPleCKhb1E9r/JL
         /vvXYqLoJ5P/s3J9Ov0ybpy4YqGVd5OfFVwV3lux9nE6mMpoHALQZoGpEYeaosW2z9
         5FKLba4I1MB1ZzUvEcz7z/xRCL8WfTjVEfE0LzoA=
Date:   Sun, 17 Jul 2022 17:18:35 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch removed from -mm tree
Message-Id: <20220718001835.BE92FC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: try to free subpage in swapcache when possible
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: try to free subpage in swapcache when possible
Date: Mon, 4 Jul 2022 21:21:56 +0800

Subpages in swapcache won't be freed even if it is the last user of the
page until next time reclaim. It shouldn't hurt indeed, but we could try
to free these pages to save more memory for system.

Link: https://lkml.kernel.org/r/20220704132201.14611-12-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible
+++ a/mm/huge_memory.c
@@ -2538,7 +2538,7 @@ static void __split_huge_page(struct pag
 		 * requires taking the lru_lock so we do the put_page
 		 * of the tail pages after the split is complete.
 		 */
-		put_page(subpage);
+		free_page_and_swap_cache(subpage);
 	}
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

