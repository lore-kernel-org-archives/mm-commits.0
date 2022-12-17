Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0617C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 17 Dec 2022 00:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLQAGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 19:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQAGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 19:06:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E146E9ED
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 16:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB50622C8
        for <mm-commits@vger.kernel.org>; Sat, 17 Dec 2022 00:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F19C433EF;
        Sat, 17 Dec 2022 00:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235575;
        bh=AaGCdJgR3wVpPEbPCszrp0tVAPOgndj9qAjPDwuCUr0=;
        h=Date:To:From:Subject:From;
        b=KqR/nIUT+gahRQ4TSvSAR7bdrtJJ4Ub4qmkWcYN1Z0j6PYhUGmXwGuPQvyQ7Dc7Vd
         ns3/6hYel2LCSlL02jrlP+wHMCYeXrK69fILs0J3LFMBNL4B1Z175bPHcN1WbCRxoE
         76IrhHL+w/ZyHSCIr5QVEOVpzedxrUgGUQfJaeBc=
Date:   Fri, 16 Dec 2022 16:06:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        npiggin@gmail.com, hch@infradead.org, bhe@redhat.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch added to mm-unstable branch
Message-Id: <20221217000615.84F19C433EF@smtp.kernel.org>
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
Date: Fri, 16 Dec 2022 23:46:59 +0000

This function invokes warn_alloc() with __GFP_NOWARN set which is a no-op.
Set this flag _after_ this call so it is actually invoked, and
additionally remove a duplicate application of __GFP_NOWARN afterwards.

Link: https://lkml.kernel.org/r/20221216234659.493794-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -3031,7 +3031,7 @@ static void *__vmalloc_area_node(struct
 	int ret;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
-	gfp_mask |= __GFP_NOWARN;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
@@ -3051,10 +3051,12 @@ static void *__vmalloc_area_node(struct
 		return NULL;
 	}
 
+	gfp_mask |= __GFP_NOWARN;
+
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
 	page_order = vm_area_page_order(area);
 
-	area->nr_pages = vm_area_alloc_pages(gfp_mask | __GFP_NOWARN,
+	area->nr_pages = vm_area_alloc_pages(gfp_mask,
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch

