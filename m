Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42229C636C8
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6F5613CC
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhGOSln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 14:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGOSlm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 14:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6629A613CA;
        Thu, 15 Jul 2021 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626374328;
        bh=TADcx9EDw0B1m7vn0TGlJpZukbe1g/eoCyrV8Css1xk=;
        h=Date:From:To:Subject:From;
        b=hq29iXFYMML07les2mUetf/2q1lxutfZZxY476pmqiGYRtMT8WnoUAKBphtQTPzc2
         +97HC6PsFxDk/a8QETPsQF2dXuhY6KlmHu7EzU5Ufm+np/lHnZZOOwTVTMp0xbdDyS
         CP7Ms7Dx0Rxng/PQ2RDxSNbAJB0CH5Tqpj1mRf2Y=
Date:   Thu, 15 Jul 2021 11:38:47 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org
Subject:  + mm-hugetlb-__unmap_hugepage_range-can-be-static.patch
 added to -mm tree
Message-ID: <20210715183847.kOy4-Jlyd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: __unmap_hugepage_range() can be static
has been added to the -mm tree.  Its filename is
     mm-hugetlb-__unmap_hugepage_range-can-be-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-__unmap_hugepage_range-can-be-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-__unmap_hugepage_range-can-be-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: mm/hugetlb: __unmap_hugepage_range() can be static

mm/hugetlb.c:4334:6: warning: symbol '__unmap_hugepage_range' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20210715170524.GA48547@78ef4ef0cd6c
Signed-off-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-__unmap_hugepage_range-can-be-static
+++ a/mm/hugetlb.c
@@ -4402,9 +4402,9 @@ again:
 	return ret;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct page *ref_page)
+static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   struct page *ref_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
_

Patches currently in -mm which might be from lkp@intel.com are

lib-fix-bugoncocci-warnings.patch
mm-hugetlb-__unmap_hugepage_range-can-be-static.patch

