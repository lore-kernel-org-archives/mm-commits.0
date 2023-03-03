Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5754C7EE30
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCCCEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCCEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:04:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EC0166D1
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC0E616F4
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32E2C433D2;
        Fri,  3 Mar 2023 02:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809048;
        bh=IaTLaVNJ/0PkwJUjSwHkk8FTqAaAGIv0s+U3wZGjtfM=;
        h=Date:To:From:Subject:From;
        b=Ukb456Mfl++CJr3JWpTLZlM1VId7RXuv5zIzwGIbCuzQwHh0W0ak6fZc43n+xuCpQ
         NoSlqiePj+QHk5v971NU4O3ZJGhOekltp4HuuhzHTkdAEHY/9WvHBR8OXUm1juFcub
         uknl1xnicoufUnht+G/EmgnmUp0WPrpJxwBIl92o=
Date:   Thu, 02 Mar 2023 18:04:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch added to mm-unstable branch
Message-Id: <20230303020408.D32E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_throttle_swaprate() in do_swap_page()
Date: Thu, 2 Mar 2023 19:58:30 +0800

Directly use folio_throttle_swaprate() instead of
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-do_swap_page
+++ a/mm/memory.c
@@ -3848,7 +3848,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			lru_add_drain();
 	}
 
-	cgroup_throttle_swaprate(page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

