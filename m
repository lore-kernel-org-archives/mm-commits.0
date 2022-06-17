Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB60C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379834AbiFQCtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379812AbiFQCtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C82065421
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 118E5B826F6
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF11DC3411C;
        Fri, 17 Jun 2022 02:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434171;
        bh=4y5JMJhrGgeOHeREOCi7vHwnGYS6w9BX3uI39D4pvIY=;
        h=Date:To:From:Subject:From;
        b=BYOkmuYpowYrv8MHTNrldySHJiwjz2EtM1bSu/a+1Pth0TtP+zDLA04hB87bCXGt9
         FCi1WX811YqD2r+YDi3J6CtST8Fasm0colfNapdu2MJw3TQQ+DopmMv+NeHbB9wygy
         rflC1UFzakaUTyTOM6Ei7Nxwu/o3Ap84vguXUya4=
Date:   Thu, 16 Jun 2022 19:49:31 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        jglisse@redhat.com, jgg@ziepe.ca, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-avoid-accessing-uninitialized-pages.patch removed from -mm tree
Message-Id: <20220617024931.BF11DC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_hmm: avoid accessing uninitialized pages
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-avoid-accessing-uninitialized-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -732,7 +732,7 @@ static int dmirror_exclusive(struct dmir
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		unsigned long mapped;
+		unsigned long mapped = 0;
 		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
@@ -741,7 +741,13 @@ static int dmirror_exclusive(struct dmir
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

mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

