Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83764C6FA86
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIKXXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIKXXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BDF26560;
        Sun, 11 Sep 2022 16:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F17BAB80BAB;
        Sun, 11 Sep 2022 23:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCD3C433B5;
        Sun, 11 Sep 2022 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938588;
        bh=rU8wKU8t7PSTf1ETRvQCyy7T6S4k0Gzb0hVc1fx284Y=;
        h=Date:To:From:Subject:From;
        b=DlVhOnxGwKgVFsUfmkUAnT1hCu2ijdWqePsvIau8DL4wGU0dgsy8hNPTvONceqWL7
         hkdAP5/XDri7oz/Mr8VmnM5ensdqfaNjg9sI9yARxHIn6Nu96vN4nGCPv3k8dl3Q79
         KlmGkRjEXuRtkpNsWoFSe2v21j5Sgg7jXIoUV/Jo=
Date:   Sun, 11 Sep 2022 16:23:08 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, stable@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, paulus@ozlabs.org, nadav.amit@gmail.com,
        lyude@redhat.com, logang@deltatee.com, kherbst@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, huang.ying.caritas@gmail.com,
        Felix.Kuehling@amd.com, david@redhat.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate_devicec-add-missing-flush_cache_page.patch removed from -mm tree
Message-Id: <20220911232308.AFCD3C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: add missing flush_cache_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-add-missing-flush_cache_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: add missing flush_cache_page()
Date: Fri, 2 Sep 2022 10:35:52 +1000

Currently we only call flush_cache_page() for the anon_exclusive case,
however in both cases we clear the pte so should flush the cache.

Link: https://lkml.kernel.org/r/5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-add-missing-flush_cache_page
+++ a/mm/migrate_device.c
@@ -193,9 +193,9 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
 				ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch
mm-migrate_devicec-fix-a-misleading-and-out-dated-comment.patch

