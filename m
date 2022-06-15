Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AC4C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiFOU0u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245556AbiFOU0q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:26:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D88544FC
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA240B82178
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3ECC3411A;
        Wed, 15 Jun 2022 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324799;
        bh=IohkYhGZCmKtsHOxCeWi/G7csamp0N3L7Z80cR0AAU8=;
        h=Date:To:From:Subject:From;
        b=bAv3qvKrygbZWzDc1jeLvaAsueOubnUjYH23sK+BQIfpYA5Awb37Y9mU+prnF7tV/
         U16RCDONBXrPshO0u+A8NPyOEHceDnKlL2hhueSAtDajAp12cfmGfsubeAATwBQcxk
         dwkDKy1tPQAk90DcdNE90pjtCO2NIBQDGoCVAU5w=
Date:   Wed, 15 Jun 2022 13:26:38 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-proc-fix-the-description-to-thpeligible.patch added to mm-unstable branch
Message-Id: <20220615202639.4D3ECC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: proc: fix the description to THPeligible
has been added to the -mm mm-unstable branch.  Its filename is
     doc-proc-fix-the-description-to-thpeligible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-proc-fix-the-description-to-thpeligible.patch

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
Subject: doc: proc: fix the description to THPeligible
Date: Wed, 15 Jun 2022 10:29:26 -0700

The THPeligible bit shows 1 if and only if the VMA is eligible for
allocating THP and the THP is also PMD mappable.  Some misaligned file
VMAs may be eligible for allocating THP but the THP can't be mapped by
PMD.  Make this more explictly to avoid ambiguity.

Link: https://lkml.kernel.org/r/20220615172926.546974-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~doc-proc-fix-the-description-to-thpeligible
+++ a/Documentation/filesystems/proc.rst
@@ -514,8 +514,10 @@ replaced by copy-on-write) part of the u
 "SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
+
 "THPeligible" indicates whether the mapping is eligible for allocating THP
-pages - 1 if true, 0 otherwise. It just shows the current status.
+pages as well as the THP is PMD mappable or not - 1 if true, 0 otherwise.
+It just shows the current status.
 
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

