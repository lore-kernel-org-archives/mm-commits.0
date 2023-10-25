Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11357C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjJYXuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbjJYXsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C014198
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487D4C433C8;
        Wed, 25 Oct 2023 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277731;
        bh=Ggbkw4Y9joN7iIOY6iY/WPOfepNXXy+W6n3lsih/nC4=;
        h=Date:To:From:Subject:From;
        b=bZEPyOOwowg7eGMzuZhpAS63Wid6tqmH80R1k4vKUL+0DUwrxOEfxIJ7YN/41svpm
         vtOOTiTC0EOFzAicNo30JnHWHP6uSgwk08Zy9DYdyS10NQw2vFriy0pLf/lzWYgvkm
         TEA7skQiwWO751OdCrfZzKa3zsboGt7gZYp7GkQc=
Date:   Wed, 25 Oct 2023 16:48:50 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch removed from -mm tree
Message-Id: <20231025234851.487D4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bootmem: use kmemleak_free_part_phys in put_page_bootmem
has been removed from the -mm tree.  Its filename was
     bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: bootmem: use kmemleak_free_part_phys in put_page_bootmem
Date: Wed, 18 Oct 2023 18:29:46 +0800

Patch series "Some bugfix about kmemleak", v3.

Some bugfixes for kmemleak and the printed info from debug mode.


This patch (of 7):

Since kmemleak_alloc_phys() rather than kmemleak_alloc() was called from
memblock_alloc_range_nid(), kmemleak_free_part_phys() should be used to
delete kmemleak object in put_page_bootmem().  In debug mode, there are
following warning:

 kmemleak: Partially freeing unknown object at 0xffff97345aff7000 (size 4096)

Link: https://lkml.kernel.org/r/20231018102952.3339837-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20231018102952.3339837-2-liushixin2@huawei.com
Fixes: dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/bootmem_info.c~bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem
+++ a/mm/bootmem_info.c
@@ -34,7 +34,7 @@ void put_page_bootmem(struct page *page)
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
-		kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
+		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

