Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97358ECAAD1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 00:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiH1AFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 20:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH1AFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 20:05:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E048D10553
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 17:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 960D2B80A6A
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 00:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10909C433B5;
        Sun, 28 Aug 2022 00:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661645105;
        bh=7O/dDhSi7byVF2t5seKflL8+jpvuMr4yRVjp2m4Upok=;
        h=Date:To:From:Subject:From;
        b=1epfFSYMyeCTqXbxM3WY6M18eo42w2ICzoY2Y942RziyhKZBpKI7oanzZ3N2bBvqE
         zMRZu2+KJd+rsIQTjiSAaFUNfQShconiMw0bjNnwGaNOa+k/T0UeMPThmbpmFdsDdF
         lI8EvBI2iKMRJIKDra2IUQby2z4m6TA27fjhPOtI=
Date:   Sat, 27 Aug 2022 17:05:04 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch added to mm-unstable branch
Message-Id: <20220828000505.10909C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-handle-truncate-racing-with-page-faults-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-handle-truncate-racing-with-page-faults-fix-fix
Date: Sat Aug 27 05:03:27 PM PDT 2022

fix merge snafu

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-handle-truncate-racing-with-page-faults-fix-fix
+++ a/fs/hugetlbfs/inode.c
@@ -541,7 +541,6 @@ static void remove_inode_hugepages(struc
 	struct folio_batch fbatch;
 	struct folio *folio;
 	pgoff_t next, index;
-	int i, freed = 0;
 	unsigned int i;
 	long freed = 0;
 	u32 hash;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

