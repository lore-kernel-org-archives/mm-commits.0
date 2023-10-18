Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEB1CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjJRPjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjJRPjw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:39:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B09C114
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:39:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE97C433C7;
        Wed, 18 Oct 2023 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643590;
        bh=fhxN+BurWumKUiX8FSgs6VQSuHBJ8CUZbKgeqwnqkd8=;
        h=Date:To:From:Subject:From;
        b=sbdEk4IMaTF+SOimli4xcBaLhCfwoI8jo3QRPZsYFY4uAoATaLLol/wxMPj8+Bq3T
         +m/PkkfLe4C8FnKIJ+L+6e3kJiHpPVPTGUQtp7VF9oD3IjLbpw0L5RZvLzFsQ6IXog
         GeWxBLBnTPAFmFtKYHKlUAOGTzhur0SU0+4KrI6w=
Date:   Wed, 18 Oct 2023 08:39:49 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch added to mm-unstable branch
Message-Id: <20231018153950.2CE97C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: use kmemleak_free_part_phys in put_page_bootmem
has been added to the -mm mm-unstable branch.  Its filename is
     bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch

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
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

