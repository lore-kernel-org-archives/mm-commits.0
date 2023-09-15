Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87662C46CA1
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 22:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjIOWuF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbjIOWtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 18:49:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4976130D7
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 15:47:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3687C433CA;
        Fri, 15 Sep 2023 22:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694818056;
        bh=IX3vYnYvJ6OpUPQWJsKLFH5KMe8MVTK9IE+D/raZOz8=;
        h=Date:To:From:Subject:From;
        b=r6W+oXEoVjWGAVbTqRfXYTptM8tdfehADzPkGywbFu9BMOiUU8DbgQZUpOzvG6d7L
         +SVyMBHVNUeKtQdAeasdFs1vOey11+muIq7TCsL0qOmc3rcgbc/yNuVG6ZYIqGieGt
         uL0pXaQaaLXSD+LPJX6mLugEzRsgSZF9EmzZ7bvM=
Date:   Fri, 15 Sep 2023 15:47:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rppt@kernel.org, punit.agrawal@bytedance.com,
        mike.kravetz@oracle.com, fam.zheng@bytedance.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch added to mm-unstable branch
Message-Id: <20230915224736.C3687C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: use nid of the head page to reallocate it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch

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

mm-hugetlb_vmemmap-use-nid-of-the-head-page-to-reallocate-it.patch
memblock-pass-memblock_type-to-memblock_setclr_flag.patch
memblock-introduce-memblock_rsrv_noinit-flag.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo.patch

