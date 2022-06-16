Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A44FC43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiFPSXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377540AbiFPSXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD73043396
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 609D0B82276
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87EC34114;
        Thu, 16 Jun 2022 18:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655403800;
        bh=g2ZOcIXO9HLJNCUvjTuMA+diuFCS7wyYiR7CbFCBdlQ=;
        h=Date:To:From:Subject:From;
        b=z55pZkUVkzwhEdxBf2KWyVD4d7qKn5b7uCO/TLoPQn6G1lvKRTlwhLnHqzitYGy+q
         5McfY5sUnpKeZBqalWut7XRyBeNwdQwivlRu5V2lXuAipYpLQyH40G0nOCLX76iDdQ
         2Gn6XBF2Fzwxep1SOtD4eqfhCKiL3FO1r/5tK/YI=
Date:   Thu, 16 Jun 2022 11:23:19 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-proc-fix-the-description-to-thpeligible.patch added to mm-unstable branch
Message-Id: <20220616182319.DD87EC34114@smtp.kernel.org>
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
Date: Thu, 16 Jun 2022 10:48:40 -0700

The THPeligible bit shows 1 if and only if the VMA is eligible for
allocating THP and the THP is also PMD mappable.  Some misaligned file
VMAs may be eligible for allocating THP but the THP can't be mapped by
PMD.  Make this more explictly to avoid ambiguity.

Link: https://lkml.kernel.org/r/20220616174840.1202070-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

