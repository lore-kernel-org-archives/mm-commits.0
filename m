Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B3AC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCCCEV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCCER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84157166D1
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 390A1B8161F
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCCDC433D2;
        Fri,  3 Mar 2023 02:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809054;
        bh=FOpXJDBjrhuOMi8+uihK99UsnxOdou9X+uzLkp8hWTQ=;
        h=Date:To:From:Subject:From;
        b=eM+fFAWy+3+Sa/Mmt1g9WSihgmWqN7Rx+FA3An2tI3nunhUWUx6GLRZLKAQEHe04K
         foVOle325+D9ecMDyfLVsP7GvhyL9sQJHLvp9plOjh3zp+vjQehN3QG3os9ERfi7oz
         ynw0fxQT3NdR5m7hNJdNIcQd5Dpb+Cwu6FAku+2M=
Date:   Thu, 02 Mar 2023 18:04:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch added to mm-unstable branch
Message-Id: <20230303020413.ECCCDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use folio_throttle_swaprate() in do_anonymous_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch

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
Subject: mm: memory: use folio_throttle_swaprate() in do_anonymous_page()
Date: Thu, 2 Mar 2023 19:58:33 +0800

Directly use folio_throttle_swaprate() instead of
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page
+++ a/mm/memory.c
@@ -4065,7 +4065,7 @@ static vm_fault_t do_anonymous_page(stru
 
 	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
-	cgroup_throttle_swaprate(&folio->page, GFP_KERNEL);
+	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

