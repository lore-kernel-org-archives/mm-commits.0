Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EDBE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjJDURW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E9BC6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE70CC433C9;
        Wed,  4 Oct 2023 20:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450637;
        bh=KbnbwK1XjhZz/LI08+3D0KJyjaa7VV/r/L3doAG7ajU=;
        h=Date:To:From:Subject:From;
        b=rQQeuTwbH54tP+/RhA+PJnaT21JItI2fi59uY0HP0TILK76LtHVAJ2T1YFUez5QQQ
         5dMrKPCObBRq1ECeN+lK3zktQ0fY15pm/ZnCTioMbUOsWfBInjKF/sN/OX76eLoUty
         ELIoZKqnYlgwzFF1S2jsNRCyvBZ3+lsRaRjs3tW8=
Date:   Wed, 04 Oct 2023 13:17:15 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch removed from -mm tree
Message-Id: <20231004201716.EE70CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix
has been removed from the -mm tree.  Its filename was
     buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch

This patch was dropped because it was folded into buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix
Date: Wed, 27 Sep 2023 16:02:40 +0100

fix grow_dev_page() error handling

Link: https://lkml.kernel.org/r/ZRREEIwqiy5DijKB@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/buffer.c~buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix
+++ a/fs/buffer.c
@@ -1060,6 +1060,7 @@ grow_dev_page(struct block_device *bdev,
 			goto failed;
 	}
 
+	ret = -ENOMEM;
 	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
 	if (!bh)
 		goto failed;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch
mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

