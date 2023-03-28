Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8700C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjC1XWD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjC1XVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12930C4
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C9AE618FE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850CFC433EF;
        Tue, 28 Mar 2023 23:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045686;
        bh=c+8DhwMn+gNa6xuBa7rbTClVcwpyUCSMpKtUInvOsBA=;
        h=Date:To:From:Subject:From;
        b=leoQOoa9RzZdwiLYTPetL/BYXWLCKbjH+eFVxhf+K3GCPK3yMBWDiOfkoikLjwUQF
         o5ykqvcplny5fiyMxxLf2lpzZ4h+XRtyzQSZ0jQm702Z0xvhOEX/+9aPYgjc/WPPTw
         hldbGLFIU3qEoITEqFn4voX64OSxa/9yF4XZ/6XA=
Date:   Tue, 28 Mar 2023 16:21:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch removed from -mm tree
Message-Id: <20230328232126.850CFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: swap: remove unneeded cgroup_throttle_swaprate()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/swap.h |   12 ++++--------
 mm/swapfile.c        |    6 +++---
 2 files changed, 7 insertions(+), 11 deletions(-)

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


