Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD6AC3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 21:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiHXVLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 17:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiHXVLy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 17:11:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1563A7B295
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 14:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B5E061835
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 21:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB61C433C1;
        Wed, 24 Aug 2022 21:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661375513;
        bh=L1DyWUtkySEqB/AVnSRooYZj7JTHGdYLD88lHYN/918=;
        h=Date:To:From:Subject:From;
        b=ttoveespnuCrOzyimi+RNLLnYHfRxXReSkJbAGkh0mW67eCPbPVGaS8cYWfG7zVr+
         t6OWuYSi8gOeNGlbkLlYtmGgcndH27ScXGfwZKZ565FtuHSLV+cHzGjYLmbsvjdY8m
         t4ZQP1WungSRIFLIfcz5SN8vKJrj5oldKPMBdya8=
Date:   Wed, 24 Aug 2022 14:11:51 -0700
To:     mm-commits@vger.kernel.org, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch added to mm-unstable branch
Message-Id: <20220824211152.ECB61C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gupc-refactor-check_and_migrate_movable_pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch

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
Subject: mm-gupc-refactor-check_and_migrate_movable_pages-fix
Date: Wed Aug 24 02:10:22 PM PDT 2022

mm/gup.c: In function 'check_and_migrate_movable_pages':
mm/gup.c:2045:13: error: unused variable 'ret' [-Werror=unused-variable]
 2045 |         int ret;
      |             ^~~

Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/gup.c~mm-gupc-refactor-check_and_migrate_movable_pages-fix
+++ a/mm/gup.c
@@ -2042,7 +2042,6 @@ err:
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
 {
-	int ret;
 	unsigned long collected;
 	LIST_HEAD(movable_page_list);
 
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
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

