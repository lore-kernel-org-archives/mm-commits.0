Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13252ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiILAhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiILAhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837A02558B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FB761148
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C61C433C1;
        Mon, 12 Sep 2022 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943037;
        bh=WLNXM0lgB3pI/N3cdEuHdl4RL0yaYeDjA6rG5qyMfHM=;
        h=Date:To:From:Subject:From;
        b=WRQkO3AMpjzo3lsTaNRmitGf5qYmlUddH7bcxcaBql0d6bcAixFokv+KJAqmsrwxz
         q3jvn9DQttGwU4H5V66+0zHXYqhBZPkrAwog4kvZYKWIeIrL2JaFuRKuRdefQQ7B5V
         prWDzD8mssTC459F6VFlQOCygWDmz/jp2pqSUi3A=
Date:   Sun, 11 Sep 2022 17:37:16 -0700
To:     mm-commits@vger.kernel.org, syoshida@redhat.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch removed from -mm tree
Message-Id: <20220912003717.79C61C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch

This patch was dropped because it was folded into mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
Date: Sun Aug 21 08:00:31 PM PDT 2022

fix code layout, per John

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix
+++ a/mm/gup.c
@@ -2087,11 +2087,13 @@ static long __gup_longterm_locked(struct
 					       NULL, gup_flags);
 	flags = memalloc_pin_save();
 	do {
-		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-							  NULL, gup_flags);
+		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
+							  pages, vmas, NULL,
+							  gup_flags);
 		if (nr_pinned_pages <= 0)
 			break;
-		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages, gup_flags);
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
+						     gup_flags);
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

