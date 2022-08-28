Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2551EECAAD1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 01:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiH1Bk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 21:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiH1Bk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 21:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F26B2F3B7
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 18:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9859560F0C
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 01:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2318C433D6;
        Sun, 28 Aug 2022 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661650825;
        bh=xeO0d2oeSIlvxbKDvGCIiAqFyWMQh+1mke3YCxLDMOw=;
        h=Date:To:From:Subject:From;
        b=AZQrE7XCPnh+H0mL8QTejddpeacN7ZW1zRqP5/rwfnWo5a012ExjERrtvmA+Ov9ZZ
         bthm+Aw2IV5sPqc1z6mJThmGDZbTVfpybt35J62x0XrHJKDOTxIh+6PLS8vw0G9aCF
         3wIDVjl+pfMWnXaZuPISkBnDo/vsANw0vubQyLA4=
Date:   Sat, 27 Aug 2022 18:40:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        slawomirx.laba@intel.com, jhubbard@nvidia.com, hch@lst.de,
        felix.kuehling@amd.com, apopple@nvidia.com,
        alex.williamson@redhat.com, alex.sierra@amd.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-allow-pinning-of-zero-pfns-again-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220828014024.F2318C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-re-allow-pinning-of-zero-pfns-again-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-re-allow-pinning-of-zero-pfns-again-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-allow-pinning-of-zero-pfns-again-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-re-allow-pinning-of-zero-pfns-again-fix
Date: Sat Aug 27 06:38:23 PM PDT 2022

simplify comment, per John

Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns-again-fix
+++ a/include/linux/mm.h
@@ -1544,11 +1544,7 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	/*
-	 * The zero page might reside in a movable zone, however it may not
-	 * be migrated and can therefore be pinned.  The vfio subsystem pins
-	 * user mappings including the zero page for IOMMU translation.
-	 */
+	/* The zero page may always be pinned */
 	if (is_zero_pfn(page_to_pfn(page)))
 		return true;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-re-allow-pinning-of-zero-pfns-again-fix.patch
asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

