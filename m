Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B1AC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiK3UZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 15:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3UZn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 15:25:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122112B5
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 12:25:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B87FFB81CD3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 20:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B32AC433D6;
        Wed, 30 Nov 2022 20:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669839936;
        bh=IMii+vCqqRdm+Sh1TNSuoztVBFvQiqxd5hpnvb2qG6U=;
        h=Date:To:From:Subject:From;
        b=l7nOF6Cmu1H1jmdozWfUxheCGeYvUrh6RMA+K1JfoFhmmGXg7ER5iisLIt1t8KaDt
         JPLZ4zmbjB9DHh+DCdcqnH1bi7nXExkChlzTpt8n19FxW1G2z3HTSZ5c+xJPVS1CrD
         bJ2XBRvhtaueqZdg0rRK6Bq8og4vUiTFXdTDHvC0=
Date:   Wed, 30 Nov 2022 12:25:35 -0800
To:     mm-commits@vger.kernel.org, ebiggers@kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-introduce-hugetlb_walk-fix.patch added to mm-unstable branch
Message-Id: <20221130202536.6B32AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-hugetlb_walk-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-introduce-hugetlb_walk-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-introduce-hugetlb_walk-fix.patch

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
Subject: mm-hugetlb-introduce-hugetlb_walk-fix
Date: Wed, 30 Nov 2022 10:33:44 -0500

fix build with CONFIG_HUGETLB_PAGE=n, CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y

Link: https://lkml.kernel.org/r/Y4d4qh0ACmo455Nj@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-hugetlb_walk-fix
+++ a/include/linux/hugetlb.h
@@ -1248,7 +1248,8 @@ __vma_shareable_flags_pmd(struct vm_area
 static inline pte_t *
 hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 {
-#if defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_LOCKDEP)
+#if defined(CONFIG_HUGETLB_PAGE) && \
+	defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_LOCKDEP)
 	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 	/*
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

