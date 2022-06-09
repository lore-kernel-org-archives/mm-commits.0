Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA79C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 16:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344820AbiFIQvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbiFIQvR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 12:51:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42CD13325D
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 09:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DD85B82EAC
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 16:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03458C3411E;
        Thu,  9 Jun 2022 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654793463;
        bh=PXrfaxtizg81H9FMOMMVOvQ0xgx9+7SWnQKsjWDmjCg=;
        h=Date:To:From:Subject:From;
        b=2YvisbqsS3KmFkopcX+8iKR7DsiJXTd4mcvE5bVt8SmOmm4WRIIb81wCJll5pqDt/
         cWZGaYEFGDHhgYyEOW8hi0fv8Lau3nGfOr2GBMREQJPJLXunQ0yY7Jog+Z20On2+Tg
         S/uS/hlpx5VH6hUgrIX5+0vhtvcdFe0On+78nf3o=
Date:   Thu, 09 Jun 2022 09:51:02 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        jglisse@redhat.com, jgg@ziepe.ca, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-avoid-accessing-uninitialized-pages.patch added to mm-unstable branch
Message-Id: <20220609165103.03458C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hmm: avoid accessing uninitialized pages
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-avoid-accessing-uninitialized-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-avoid-accessing-uninitialized-pages.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: lib/test_hmm: avoid accessing uninitialized pages
Date: Thu, 9 Jun 2022 21:08:35 +0800

If make_device_exclusive_range() fails or returns pages marked for
exclusive access less than required, remaining fields of pages will left
uninitialized.  So dmirror_atomic_map() will access those yet
uninitialized fields of pages.  To fix it, do dmirror_atomic_map() iff all
pages are marked for exclusive access (we will break if mapped is less
than required anyway) so we won't access those uninitialized fields of
pages.

Link: https://lkml.kernel.org/r/20220609130835.35110-1-linmiaohe@huawei.com
Fixes: b659baea7546 ("mm: selftests for exclusive device memory")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-avoid-accessing-uninitialized-pages
+++ a/lib/test_hmm.c
@@ -797,7 +797,7 @@ static int dmirror_exclusive(struct dmir
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		unsigned long mapped;
+		unsigned long mapped = 0;
 		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
@@ -806,7 +806,13 @@ static int dmirror_exclusive(struct dmir
 			next = addr + (ARRAY_SIZE(pages) << PAGE_SHIFT);
 
 		ret = make_device_exclusive_range(mm, addr, next, pages, NULL);
-		mapped = dmirror_atomic_map(addr, next, pages, dmirror);
+		/*
+		 * Do dmirror_atomic_map() iff all pages are marked for
+		 * exclusive access to avoid accessing uninitialized
+		 * fields of pages.
+		 */
+		if (ret == (next - addr) >> PAGE_SHIFT)
+			mapped = dmirror_atomic_map(addr, next, pages, dmirror);
 		for (i = 0; i < ret; i++) {
 			if (pages[i]) {
 				unlock_page(pages[i]);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch

