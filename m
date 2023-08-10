Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE7CC001DE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjHJR1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHJR1b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E1F211C
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F16DA65420
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D43EC433C8;
        Thu, 10 Aug 2023 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691688450;
        bh=23BQK1Jkclwk8/Z9g8G7CMa6S0YeA1AysmqJ2w12ygo=;
        h=Date:To:From:Subject:From;
        b=fTXyeWzeXjQDpRr7m7osVXAlRd30VvU7fI2BD3cdgs43VXO+ZIvXJSFgpdvRIoGbU
         80PPJh+RFJuKFCW3yAsKcQeVlBlWBc+wHhiB1euOTmETxzust0D4u2uLpUXkZ9lU8B
         tCDp3+s2awhwnumwZqSqkdifKtGLgeIIvgBcPkG4=
Date:   Thu, 10 Aug 2023 10:27:29 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, mgorman@techsingularity.net,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch added to mm-unstable branch
Message-Id: <20230810172730.4D43EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: remove unused parameter from reserve_highatomic_pageblock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: page_alloc: remove unused parameter from reserve_highatomic_pageblock()
Date: Wed, 9 Aug 2023 15:33:23 +0800

Just remove the redundant parameter alloc_order from
reserve_highatomic_pageblock(). No functional modification involved.

Link: https://lkml.kernel.org/r/20230809073323.1065286-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock
+++ a/mm/page_alloc.c
@@ -1899,8 +1899,7 @@ int find_suitable_fallback(struct free_a
  * Reserve a pageblock for exclusive use of high-order atomic allocations if
  * there are no empty page blocks that contain a page with a suitable order
  */
-static void reserve_highatomic_pageblock(struct page *page, struct zone *zone,
-				unsigned int alloc_order)
+static void reserve_highatomic_pageblock(struct page *page, struct zone *zone)
 {
 	int mt;
 	unsigned long max_managed, flags;
@@ -3246,7 +3245,7 @@ try_this_zone:
 			 * if the pageblock should be reserved for the future
 			 */
 			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, zone, order);
+				reserve_highatomic_pageblock(page, zone);
 
 			return page;
 		} else {
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch
mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

