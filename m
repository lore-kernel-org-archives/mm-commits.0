Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA73C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJCVaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJCV3w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93248578BC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3B0601D7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF23C433D6;
        Mon,  3 Oct 2022 21:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832157;
        bh=7zludWIkHuV6oEtN9nWEte+qRilbzQgZ6icjokhWYSU=;
        h=Date:To:From:Subject:From;
        b=xawoW6IgAHU02Mi6WBTt06VPvoCXdh68NP6dRGrjQ+VC3WcT/nUq9LZ4aoQRSfaTa
         PjJUfeNkzfHauAHSfeVo6JUSv1vCqnQcVFN4V98yLSnhBsvjh41F9ZvfmxRSnfKWhS
         KkqUGhIQJLPI3IbSSA9isrE/AXE9jxdM02/aasRE=
Date:   Mon, 03 Oct 2022 14:22:36 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch removed from -mm tree
Message-Id: <20221003212237.7EF23C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: relay: use kvcalloc to alloc page array in relay_alloc_page_array
has been removed from the -mm tree.  Its filename was
     relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: relay: use kvcalloc to alloc page array in relay_alloc_page_array
Date: Fri, 9 Sep 2022 18:10:25 +0800

kvcalloc() is safer because it will check the integer overflows, and using
it will simple the logic of allocation size.

Link: https://lkml.kernel.org/r/20220909101025.82955-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/relay.c~relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array
+++ a/kernel/relay.c
@@ -60,10 +60,7 @@ static const struct vm_operations_struct
  */
 static struct page **relay_alloc_page_array(unsigned int n_pages)
 {
-	const size_t pa_size = n_pages * sizeof(struct page *);
-	if (pa_size > PAGE_SIZE)
-		return vzalloc(pa_size);
-	return kzalloc(pa_size, GFP_KERNEL);
+	return kvcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
 }
 
 /*
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

