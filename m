Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE119CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjJRPj5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjJRPj5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:39:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B002111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:39:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171AEC433C8;
        Wed, 18 Oct 2023 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643595;
        bh=xnDEMbvPinP1L4f7HRtJNvUXrCCQ38VtCV75nvFt5io=;
        h=Date:To:From:Subject:From;
        b=U6BchpL4MFswt1Y94RMjYSPOv5/qjEFVG/uvz09DoHAAAc0wQDM4rSUpAof9Kfooe
         1LB5K3PaOqBjWYtT7lvBGaqz2G1vx13yzARgfoWlZ8wW/ZH2t3nGQRBBKdUjOasxZD
         Pchm0WtTk8xGBkWlj+zKdGKLJFEAGgbxXCknxlEs=
Date:   Wed, 18 Oct 2023 08:39:54 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch added to mm-unstable branch
Message-Id: <20231018153955.171AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: use kmemleak_free_part_phys in free_bootmem_page
has been added to the -mm mm-unstable branch.  Its filename is
     bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch

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
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

