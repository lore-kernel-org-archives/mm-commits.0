Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA4CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiFPSXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiFPSXG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:23:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F078B29CAC
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8639961C0A
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B1BC34114;
        Thu, 16 Jun 2022 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655403783;
        bh=GfmGCoX9Bo/KiaK2S/giQXJQJ/AZJFf/26leOC4SYoc=;
        h=Date:To:From:Subject:From;
        b=IM7/LWLBFELgMckWTXnc2YmLoonfNpnpGzGKL4R1TfIjCSrJwRhXdmmvOkNrFl/FB
         7rq3Pny5bFHf2+00PEuBElnRuH/B8zMTucDzUNgzD8EY0OQZgwKzT/qWddkQ/XQDg3
         ePWHmh6MgwBK9wuJQJlShpRFAO+1gkqpxRJwsQYc=
Date:   Thu, 16 Jun 2022 11:23:03 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch added to mm-unstable branch
Message-Id: <20220616182303.D4B1BC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: check THP flag in hugepage_vma_check()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch

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
Subject: mm: khugepaged: check THP flag in hugepage_vma_check()
Date: Thu, 16 Jun 2022 10:48:34 -0700

Patch series "Cleanup transhuge_xxx helpers", v5.

This series is the follow-up of the discussion about cleaning up
transhuge_xxx helpers at
https://lore.kernel.org/linux-mm/627a71f8-e879-69a5-ceb3-fc8d29d2f7f1@suse.cz/.

THP has a bunch of helpers that do VMA sanity check for different paths,
they do the similar checks for the most callsites and have a lot duplicate
codes.  And it is confusing what helpers should be used at what
conditions.

This series reorganized and cleaned up the code so that we could
consolidate all the checks into hugepage_vma_check().

The transhuge_vma_enabled(), transparent_hugepage_active() and
__transparent_hugepage_enabled() are killed by this series.


This patch (of 7):

Currently the THP flag check in hugepage_vma_check() will fallthrough if
the flag is NEVER and VM_HUGEPAGE is set.  This is not a problem for now
since all the callers have the flag checked before or can't be invoked if
the flag is NEVER.

However, the following patch will call hugepage_vma_check() in more
places, for example, page fault, so this flag must be checked in
hugepge_vma_check().

Link: https://lkml.kernel.org/r/20220616174840.1202070-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20220616174840.1202070-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-check-thp-flag-in-hugepage_vma_check
+++ a/mm/khugepaged.c
@@ -451,6 +451,9 @@ bool hugepage_vma_check(struct vm_area_s
 	if (shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
 
+	if (!khugepaged_enabled())
+		return false;
+
 	/* THP settings require madvise. */
 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
 		return false;
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

