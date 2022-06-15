Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA48C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344323AbiFOU0j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245605AbiFOU0f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:26:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E115252A
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E693E615E5
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCA5C3411A;
        Wed, 15 Jun 2022 20:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324788;
        bh=sQWN1WA4/Htec+TRf13/PmJpxB4Xv7QskT088f8D9PQ=;
        h=Date:To:From:Subject:From;
        b=aFnqwkbQHXC4IfjZzYy824g4WJ9msaKbnZELNw1FjcqBj9VXypENASE+AqsUtXDWB
         5f9XLskFiAxrVOII2YuGoVGky0crpUZiz0urcvOGqOT2ANbeGMH1fwjgNNzMOIAX8F
         HwZhtrDNk0GhDerm9qdk8P/3yqAhsgRO92tmpirg=
Date:   Wed, 15 Jun 2022 13:26:27 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch added to mm-unstable branch
Message-Id: <20220615202628.4CCA5C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch

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
Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
Date: Wed, 15 Jun 2022 10:29:22 -0700

The hugepage_vma_revalidate() needs to check if the vma is still anonymous
vma or not since the address may be unmapped then remapped to file before
khugepaged reaquired the mmap_lock.

The old comment is not quite helpful, elaborate this with better
comment.

Link: https://lkml.kernel.org/r/20220615172926.546974-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate
+++ a/mm/khugepaged.c
@@ -954,7 +954,13 @@ static int hugepage_vma_revalidate(struc
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
-	/* Anon VMA expected */
+	/*
+	 * Anon VMA expected, the address may be unmapped then
+	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 *
+	 * hugepage_vma_check may return true for qualified file
+	 * vmas.
+	 */
 	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return SCAN_VMA_CHECK;
 	return 0;
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

