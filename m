Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47E5C7EE23
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 18:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjFGS7o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjFGS7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 14:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221481BF8
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 11:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B28BB63F10
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 18:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA17C433EF;
        Wed,  7 Jun 2023 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686164379;
        bh=8uDDmtY/OsQ7RIYDLRikJOIKfVdLUv0e2qLuU6mK2UM=;
        h=Date:To:From:Subject:From;
        b=G5mv65Ags1pOMU82pLtFgdtwkxU85LitBrU5eNjQZMx7kMzE2nOF4eiZYP0EtodGr
         bjFxhxaBLNeXP/QqSEm5pH+q6zizTTQhHaxroO9pKihoxevrNRgtRTAWQsYVdLU759
         cGJr2FpH+ZuIHI0ROe7bTOHeQVoedwb16ZvmHLgI=
Date:   Wed, 07 Jun 2023 11:59:38 -0700
To:     mm-commits@vger.kernel.org, stevensd@chromium.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230607185939.0EA17C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch

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
Subject: mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
Date: Wed Jun  7 11:58:24 AM PDT 2023

tidy up comment layout

Cc: David Stevens <stevensd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
+++ a/mm/shmem.c
@@ -1035,10 +1035,12 @@ whole_folios:
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-					 * If we split a page, reset the loop so that we
-					 * pick up the new sub pages. Otherwise the THP
-					 * was entirely dropped or the target range was
-					 * zeroed, so just continue the loop as is.
+					 * If we split a page, reset the loop so
+					 * that we pick up the new sub pages.
+					 * Otherwise the THP was entirely
+					 * dropped or the target range was
+					 * zeroed, so just continue the loop as
+					 * is.
 					 */
 					if (!folio_test_large(folio)) {
 						folio_unlock(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

