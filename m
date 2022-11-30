Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9FFC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 20:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiK3UeE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 15:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiK3Udn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 15:33:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353DB140C7
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 12:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D5A7B81CCF
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 20:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDC8C433C1;
        Wed, 30 Nov 2022 20:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669840365;
        bh=yNzyck1dEBMFncyBbdEpAhnYpRndPoTpPahxEUcvbQc=;
        h=Date:To:From:Subject:From;
        b=EtvQYaso3vTpuplS6OSRoE+X0uyEfpENWZfqUjAGIw+oJzP1sdfDW9DEFvcT00IFq
         EKn+VVGASWVp85p5/qbDPfeZa4kZ6DXYfVkKWxweKbjf8WDjphXGBPEv8eYi89mu/W
         jpwLTU6+T8kcG4JKDRsl3nKvm0cAUUFSr5MTzDvY=
Date:   Wed, 30 Nov 2022 12:32:44 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-introduce-hugetlb_walk-fix-2.patch added to mm-unstable branch
Message-Id: <20221130203245.3CDC8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-hugetlb_walk-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm-hugetlb-introduce-hugetlb_walk-fix-2
Date: Wed, 30 Nov 2022 10:45:21 -0500

hugetlb.h needs mm.h

Link: https://lkml.kernel.org/r/Y4d8ZLzD9A+nW70m@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-hugetlb_walk-fix-2
+++ a/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_HUGETLB_H
 #define _LINUX_HUGETLB_H
 
+#include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch
selftests-vm-use-memfd-for-hugepage-mmap-test.patch
mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

