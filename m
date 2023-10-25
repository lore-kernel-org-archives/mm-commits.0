Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC560C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjJYXuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbjJYXsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D1C19F
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35142C433CA;
        Wed, 25 Oct 2023 23:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277732;
        bh=sa5MuaLtS7NwOAVyps8LP2YoTfgEJyc//Fa/3F5QrAE=;
        h=Date:To:From:Subject:From;
        b=s1+QCWiGUTiHG2VMp5Ujdmk4c383Lu+NyogXHBYXnLnSUoMP+prYi1e1AoDsLxYpb
         zLb/mhVxf5omD1H1ba4xPxBZFR4bdehh+bBwk/MLTVfujoEUZG1tKWluW8T52gK+Lh
         S/nfctg7/KhqgN5REvTII/91sJMPwNlTkJCEi7s0=
Date:   Wed, 25 Oct 2023 16:48:51 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch removed from -mm tree
Message-Id: <20231025234852.35142C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bootmem: use kmemleak_free_part_phys in free_bootmem_page
has been removed from the -mm tree.  Its filename was
     bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: bootmem: use kmemleak_free_part_phys in free_bootmem_page
Date: Wed, 18 Oct 2023 18:29:47 +0800

Since kmemleak_alloc_phys() rather than kmemleak_alloc() was called from
memblock_alloc_range_nid(), kmemleak_free_part_phys() should be used to
delete kmemleak object in free_bootmem_page().  In debug mode, there are
following warning:

 kmemleak: Partially freeing unknown object at 0xffff97345aff7000 (size 4096)

Link: https://lkml.kernel.org/r/20231018102952.3339837-3-liushixin2@huawei.com
Fixes: 028725e73375 ("bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/bootmem_info.h~bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page
+++ a/include/linux/bootmem_info.h
@@ -60,7 +60,7 @@ static inline void get_page_bootmem(unsi
 
 static inline void free_bootmem_page(struct page *page)
 {
-	kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
+	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

