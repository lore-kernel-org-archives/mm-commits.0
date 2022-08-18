Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65763C00140
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 22:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiHRW6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 18:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiHRW6c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 18:58:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7F03C179
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 15:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA7F961701
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4539EC433D6;
        Thu, 18 Aug 2022 22:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660863508;
        bh=y4os7rJaSlBlTpxxJpEPzYOm5XBRyY8ryQEwS+inRcQ=;
        h=Date:To:From:Subject:From;
        b=EqGQEwWYLzI3oYcsfoeJXUUinH2YZoduArMSH2TqTVp1AXHKAQEhSQ77irgdO54bG
         3u6vJfDi9JXtpW6RatnmogxZbzfCXeBwge8iLE2sJvXI+Ohgccpkg94oSq5AwJFcz1
         hVSdLdK3F6/zMVGDUr5lG89b6vbT7thFdsA35exM=
Date:   Thu, 18 Aug 2022 15:58:27 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, npiggin@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + support-highmem-pages-in-vmap_pages_range_noflush.patch added to mm-unstable branch
Message-Id: <20220818225828.4539EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: support HIGHMEM pages in vmap_pages_range_noflush()
has been added to the -mm mm-unstable branch.  Its filename is
     support-highmem-pages-in-vmap_pages_range_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/support-highmem-pages-in-vmap_pages_range_noflush.patch

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
Subject: mm/vmalloc.c: support HIGHMEM pages in vmap_pages_range_noflush()
Date: Thu, 18 Aug 2022 22:07:41 +0100

If the pages being mapped are in HIGHMEM, page_address() returns NULL. 
This probably wasn't noticed before because there aren't currently any
architectures with HAVE_ARCH_HUGE_VMALLOC and HIGHMEM, but it's simpler to
call page_to_phys() and futureproofs us against such configurations
existing.

Link: https://lkml.kernel.org/r/Yv6qHc6e+m7TMWhi@casper.infradead.org
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~support-highmem-pages-in-vmap_pages_range_noflush
+++ a/mm/vmalloc.c
@@ -590,7 +590,7 @@ int vmap_pages_range_noflush(unsigned lo
 		int err;
 
 		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					__pa(page_address(pages[i])), prot,
+					page_to_phys(pages[i]), prot,
 					page_shift);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from willy@infradead.org are

support-highmem-pages-in-vmap_pages_range_noflush.patch

