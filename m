Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967ACC43334
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 19:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbiF0TLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240365AbiF0TLF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 15:11:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5714F5597
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 12:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE505B81A5B
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 19:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B98C3411D;
        Mon, 27 Jun 2022 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656357057;
        bh=LRXnFGzGxSnDJ38mA/kzZSrxp4bwqUw3O+cEtsfqTpc=;
        h=Date:To:From:Subject:From;
        b=R2S5GS72ab8XsPeZ1Uca5pUunIzSIl3SdTBhaVq703CFFXqJKIGhCO4//61C80fh+
         tsRbPOtjinSBfURgGzCtzoh/ZJSByKmt3BNoDVborkZcMztvIk2s5+lg8VK51I/iKP
         c3l/3CqhjLxeS4jaLUINtxJf5/LPAnqWr/DnL5RI=
Date:   Mon, 27 Jun 2022 12:10:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-minor-cleanup-for-filemap_write_and_wait_range.patch added to mm-unstable branch
Message-Id: <20220627191057.82B98C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: minor cleanup for filemap_write_and_wait_range
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

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
Subject: filemap: minor cleanup for filemap_write_and_wait_range
Date: Mon, 27 Jun 2022 21:23:51 +0800

Restructure the logic in filemap_write_and_wait_range to simplify the code
and make it more consistent with file_write_and_wait_range. No functional
change intended.

Link: https://lkml.kernel.org/r/20220627132351.55680-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/filemap.c~filemap-minor-cleanup-for-filemap_write_and_wait_range
+++ a/mm/filemap.c
@@ -667,7 +667,7 @@ EXPORT_SYMBOL_GPL(filemap_range_has_writ
 int filemap_write_and_wait_range(struct address_space *mapping,
 				 loff_t lstart, loff_t lend)
 {
-	int err = 0;
+	int err = 0, err2;
 
 	if (mapping_needs_writeback(mapping)) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
@@ -678,18 +678,12 @@ int filemap_write_and_wait_range(struct
 		 * But the -EIO is special case, it may indicate the worst
 		 * thing (e.g. bug) happened, so we avoid waiting for it.
 		 */
-		if (err != -EIO) {
-			int err2 = filemap_fdatawait_range(mapping,
-						lstart, lend);
-			if (!err)
-				err = err2;
-		} else {
-			/* Clear any previously stored errors */
-			filemap_check_errors(mapping);
-		}
-	} else {
-		err = filemap_check_errors(mapping);
+		if (err != -EIO)
+			__filemap_fdatawait_range(mapping, lstart, lend);
 	}
+	err2 = filemap_check_errors(mapping);
+	if (!err)
+		err = err2;
 	return err;
 }
 EXPORT_SYMBOL(filemap_write_and_wait_range);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages-v3.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

