Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83BEC678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjCCCEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjCCCET (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:04:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB1118163
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:04:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0D99616F5
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6FFC4339C;
        Fri,  3 Mar 2023 02:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809057;
        bh=e+b3SKv3nW/i0CxRyZlvLpn4LTsq9TyttQd7DPTvar8=;
        h=Date:To:From:Subject:From;
        b=mJS8dWZyPwu6QotyHfR/WxG4AoOAgei6zAnWn/OSeZsJHCcjWU+QKUaKu4M3KdLlE
         kAuynvbeDNA4jJpfg5EZYaent575HyNJD3X044JYlDmxlWkaMlWO91y3IS0xVlio6q
         noIqAao+zTQccFubNRBoKyMI+u7XclqkjPamjtf8=
Date:   Thu, 02 Mar 2023 18:04:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch added to mm-unstable branch
Message-Id: <20230303020417.3F6FFC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swap: remove unneeded cgroup_throttle_swaprate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

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
Subject: mm: swap: remove unneeded cgroup_throttle_swaprate()
Date: Thu, 2 Mar 2023 19:58:35 +0800

All the callers of cgroup_throttle_swaprate() are converted to
folio_throttle_swaprate(), so make __cgroup_throttle_swaprate() to take a
folio, and rename it to __folio_throttle_swaprate(), also rename gfp_mask
to gfp and drop redundant extern keyword.  finally, drop unused
cgroup_throttle_swaprate().

Link: https://lkml.kernel.org/r/20230302115835.105364-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/swap.h~mm-swap-remove-unneeded-cgroup_throttle_swaprate
+++ a/include/linux/swap.h
@@ -641,22 +641,18 @@ extern atomic_t zswap_stored_pages;
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-extern void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
-static inline  void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp);
+static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__cgroup_throttle_swaprate(page, gfp_mask);
+	__folio_throttle_swaprate(folio, gfp);
 }
 #else
-static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
-{
-}
-#endif
 static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
-	cgroup_throttle_swaprate(&folio->page, gfp);
 }
+#endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
--- a/mm/swapfile.c~mm-swap-remove-unneeded-cgroup_throttle_swaprate
+++ a/mm/swapfile.c
@@ -3635,12 +3635,12 @@ static void free_swap_count_continuation
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
+void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
-	int nid = page_to_nid(page);
+	int nid = folio_nid(folio);
 
-	if (!(gfp_mask & __GFP_IO))
+	if (!(gfp & __GFP_IO))
 		return;
 
 	if (!blk_cgroup_congested())
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

