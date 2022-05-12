Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDC8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357433AbiELSVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357550AbiELSVX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAE13F31A
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BE1AB80AEA
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE721C385B8;
        Thu, 12 May 2022 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652379678;
        bh=unwIZQi7pHYIR/YnoqnKxxwX1IPmPcavwFusQ/VBgUk=;
        h=Date:To:From:Subject:From;
        b=ocxL6jYo42lfrXcBK8N0Vks4PXZWf7TtFnVfwxU4agtj4TNFTNLqK27lXnxXaB5Ml
         3kd69XNqo3j2v4pUkxOmgaEUlux1s9HTbq0YWRf5t2e2zhGild+6W7fElIQJkLeEwq
         MMo5EPanD+k1cAqV5yT6olSPy25SstHsIK9z31hU=
Date:   Thu, 12 May 2022 11:21:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch added to mm-unstable branch
Message-Id: <20220512182118.DE721C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK

The parameter used by DEFINE_PAGE_VMA_WALK is _page not page, fix the
parameter name.  It didn't cause any build error, it is probably because
the only caller is write_protect_page() from ksm.c, which pass in page.

Link: https://lkml.kernel.org/r/20220512174551.81279-1-shy828301@gmail.com
Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk
+++ a/include/linux/rmap.h
@@ -325,8 +325,8 @@ struct page_vma_mapped_walk {
 #define DEFINE_PAGE_VMA_WALK(name, _page, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
 		.pfn = page_to_pfn(_page),				\
-		.nr_pages = compound_nr(page),				\
-		.pgoff = page_to_pgoff(page),				\
+		.nr_pages = compound_nr(_page),				\
+		.pgoff = page_to_pgoff(_page),				\
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch
mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

