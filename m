Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C25EE0213
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjIMVRW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjIMVRV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:17:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF55173A;
        Wed, 13 Sep 2023 14:17:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1440C433C7;
        Wed, 13 Sep 2023 21:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694639836;
        bh=cNGjVujAxTWKrufj+S/IW/S3BMgwmlW056HZpn5+D0Y=;
        h=Date:To:From:Subject:From;
        b=wpjVrs5xKSgpudG3qiArxwQYrN0K82Ldl4LOf+rS3KqjGlmYajIW3IwW/QXLn26PB
         C7Zo+weoHUMGb7A07TxrsZbKOVvmyW0/4QNOIBRyGDV39VlAUua29kHCfIXao65Jz1
         MBFrWt4+Ze6nPvV+Y0s2UnnMEzL1CMx/NCj/Umec=
Date:   Wed, 13 Sep 2023 14:17:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230913211716.B1440C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: use nth_page() in place of direct struct page manipulation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mips: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:48 -0400

__flush_dcache_pages() is called during hugetlb migration via
migrate_pages() -> migrate_hugetlbs() -> unmap_and_move_huge_page() ->
move_to_new_folio() -> flush_dcache_folio().  And with hugetlb and without
sparsemem vmemmap, struct page is not guaranteed to be contiguous beyond a
section.  Use nth_page() instead.

Link: https://lkml.kernel.org/r/20230913201248.452081-6-zi.yan@sent.com
Fixes: 15fa3e8e3269 ("mips: implement the new page table range API")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mm/cache.c~mips-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/arch/mips/mm/cache.c
@@ -117,7 +117,7 @@ void __flush_dcache_pages(struct page *p
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(page + i);
+		addr = (unsigned long)kmap_local_page(nth_page(page, i));
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch
fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

