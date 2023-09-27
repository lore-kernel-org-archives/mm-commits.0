Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713D3E82CA7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjI0PuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjI0PuD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:50:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D09EF8
        for <mm-commits@vger.kernel.org>; Wed, 27 Sep 2023 08:42:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B834C433CB;
        Wed, 27 Sep 2023 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695829321;
        bh=K7idKZa2L7YfHdvdbYOsugMb29anevWK580bOuKhfqM=;
        h=Date:To:From:Subject:From;
        b=xJ1ugM8DkF9EhURxW1g7sOCI8VPwFj2owQOrfhKAeGNR0x3XB2Bb4ZF0JB2eRaonN
         WR0j6k2OkkpeEWC+ZCkRMut1FsqdRUXF5LpDPzcW4qdPOm/HVDfmHAhSkeaz9/y4fS
         gHzE6QIMARshfUEs7xuOZhmijVrWYvZBLIWsZgAI=
Date:   Wed, 27 Sep 2023 08:42:00 -0700
To:     mm-commits@vger.kernel.org, dan.carpenter@linaro.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch added to mm-unstable branch
Message-Id: <20230927154201.7B834C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch

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

i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-report-success-more-often-from-filemap_map_folio_range.patch
mm-abstract-moving-to-the-next-pfn.patch
mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

