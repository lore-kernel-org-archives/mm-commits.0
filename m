Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74ACEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjHUUmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjHUUmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FDF10CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447B464B06
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A7CC433C8;
        Mon, 21 Aug 2023 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650459;
        bh=HUGelGIKssI7HkhqHDVvhkfn/mYBpch4LX4O5yn/JqE=;
        h=Date:To:From:Subject:From;
        b=MImz/4/pI/BvuWFShDrDiqyH9uOiuqaJ7GtULrr2BV0RhZewlBDdOuTJpg8uJvNNz
         s492i2d0OoEnP68Yqn2UGI/E74uxX39u1cIPyafNSB46uHQs6Hg7ej4SXn99lsVjL7
         LYNLtGdOPTDddG8jVE/qNV5inu5NPfPpQ9TtVEMI=
Date:   Mon, 21 Aug 2023 13:40:59 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, mgorman@techsingularity.net,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch removed from -mm tree
Message-Id: <20230821204059.98A7CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: remove unused parameter from reserve_highatomic_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3210,7 +3209,7 @@ try_this_zone:
 			 * if the pageblock should be reserved for the future
 			 */
 			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, zone, order);
+				reserve_highatomic_pageblock(page, zone);
 
 			return page;
 		} else {
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


