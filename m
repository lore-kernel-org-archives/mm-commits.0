Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF53C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 22:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiLSWKd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 17:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiLSWKM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 17:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC02D1580F
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 14:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5029A61178
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 22:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D204C433D2;
        Mon, 19 Dec 2022 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671487655;
        bh=TzHorClq2kexBJ4ULbVUxlETUuJJpdQeqz/TmSmm5Hg=;
        h=Date:To:From:Subject:From;
        b=aZZjx8TbSsP3POLsv4/7MfB6uGLxal40nB8NhDSGtjeqwqZzzn8hIzeUO/9nW/3LT
         bghdgSfy/ZmeKsp0AGWVNvK/HqPf24bzdVErO4MO2wdMA8wiyV31N/27VAEqD/DQry
         XZI/EMYmkjIhNom9xgMeWR01CBIAZ70rv2VDojwo=
Date:   Mon, 19 Dec 2022 14:07:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        npiggin@gmail.com, hch@infradead.org, bhe@redhat.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch added to mm-unstable branch
Message-Id: <20221219220735.9D204C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: correct use of __GFP_NOWARN mask in __vmalloc_area_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch

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

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch

