Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B44C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjASBRp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjASBPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13270689C7
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5A2D61B20
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE4DC433F0;
        Thu, 19 Jan 2023 01:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090894;
        bh=tcXpkaLVcWJvrvABJIQdIXrm6+Zv6KZ3XAXknfPwduI=;
        h=Date:To:From:Subject:From;
        b=nOd8vUOdEwm5SWG5jR/asS5jCuCWhJnM7Og1P5kmkSVEufxdFXT17vhqJeliSF5h9
         sR7ZeeqgtkEy/iONMG8vOw5Lh+2xsQtsSOAiYld60XqsPI7rV8+Zqo+BZGt8xNDwOJ
         QrioOzsCO8Y2c1A/6FMmt2CNc1uQs/36wGPyv1hQ=
Date:   Wed, 18 Jan 2023 17:14:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        npiggin@gmail.com, hch@infradead.org, bhe@redhat.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch removed from -mm tree
Message-Id: <20230119011454.0FE4DC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: correct use of __GFP_NOWARN mask in __vmalloc_area_node()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: vmalloc: correct use of __GFP_NOWARN mask in __vmalloc_area_node()
Date: Mon, 19 Dec 2022 12:36:59 +0000

This function sets __GFP_NOWARN in the gfp_mask rendering the warn_alloc()
invocations no-ops.  Remove this and instead rely on this flag being set
only for the vm_area_alloc_pages() function, ensuring it is cleared for
each of the warn_alloc() calls.

Link: https://lkml.kernel.org/r/20221219123659.90614-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -3031,7 +3031,7 @@ static void *__vmalloc_area_node(struct
 	int ret;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
-	gfp_mask |= __GFP_NOWARN;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

