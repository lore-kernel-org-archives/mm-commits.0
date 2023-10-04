Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA179E75455
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244594AbjJDUXJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbjJDUWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D3CD9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4AFC433C7;
        Wed,  4 Oct 2023 20:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450936;
        bh=muf8kOK/iFTjKaGpR5gcxXlwCzVaLgH2ZsLjSaOJRso=;
        h=Date:To:From:Subject:From;
        b=Hw8FyktHdvJCrCQC4zHAP3ORiKQaOPYlhAiDNtkYdwk/eDARDASLm7Vzbpo8vXqIv
         f4G/ohR/lXn1XopdGsOghsWNUMM5NUSesOjTAZRQtM4xno4WxoIoxfMH8k64xgDjOi
         uVK9gLSvhw8K9xSgkleePrDvkDft1XTWvKaNh9kc=
Date:   Wed, 04 Oct 2023 13:22:15 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rppt@kernel.org, punit.agrawal@bytedance.com,
        mike.kravetz@oracle.com, fam.zheng@bytedance.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch removed from -mm tree
Message-Id: <20231004202216.7E4AFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: use nid of the head page to reallocate it
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: mm: hugetlb_vmemmap: use nid of the head page to reallocate it
Date: Wed, 13 Sep 2023 11:53:58 +0100

Patch series "mm: hugetlb: Skip initialization of gigantic tail struct
pages if freed by HVO", v5.

This series moves the boot time initialization of tail struct pages of a
gigantic page to later on in the boot.  Only the
HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page) - 1 tail struct pages
are initialized at the start.  If HVO is successful, then no more tail
struct pages need to be initialized.  For a 1G hugepage, this series avoid
initialization of 262144 - 63 = 262081 struct pages per hugepage.

When tested on a 512G system (allocating 500 1G hugepages), the kexec-boot
times with DEFERRED_STRUCT_PAGE_INIT enabled are:

- with patches, HVO enabled: 1.32 seconds
- with patches, HVO disabled: 2.15 seconds
- without patches, HVO enabled: 3.90  seconds
- without patches, HVO disabled: 3.58 seconds

This represents an approximately 70% reduction in boot time and will
significantly reduce server downtime when using a large number of gigantic
pages.


This patch (of 4):

If tail page prep and initialization is skipped, then the "start" page
will not contain the correct nid.  Use the nid from first vmemap page.

Link: https://lkml.kernel.org/r/20230913105401.519709-1-usama.arif@bytedance.com
Link: https://lkml.kernel.org/r/20230913105401.519709-2-usama.arif@bytedance.com
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it
+++ a/mm/hugetlb_vmemmap.c
@@ -319,7 +319,7 @@ static int vmemmap_remap_free(unsigned l
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 	};
-	int nid = page_to_nid((struct page *)start);
+	int nid = page_to_nid((struct page *)reuse);
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
 
 	/*
_

Patches currently in -mm which might be from usama.arif@bytedance.com are


