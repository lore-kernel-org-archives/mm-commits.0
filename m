Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE94BECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiILAnL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiILAnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:43:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A0D27CE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3451061142
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C06CC433D7;
        Mon, 12 Sep 2022 00:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943388;
        bh=K31C12srdbOZOgAN9vf5uuXBYxuL5yz/RE54TUbYe18=;
        h=Date:To:From:Subject:From;
        b=loSUuco++GhnFZJlStnSGbs/2Pc++G5ZU9Ti/B3C6lxxV9jzVPmVITZaMOGYe9EYv
         X3wn6LtIoOsiF1NKxOHpHLKqIYNfmWxR4LOq2HR9RLmom9O+S11Spjlcd3kwBSjiDq
         YKNb44PsNEHSWPabnFFaNFAxfVg/BN63De+xlHqk=
Date:   Sun, 11 Sep 2022 17:43:07 -0700
To:     mm-commits@vger.kernel.org, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch removed from -mm tree
Message-Id: <20220912004308.8C06CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-gupc-refactor-check_and_migrate_movable_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch

This patch was dropped because it was folded into mm-gupc-refactor-check_and_migrate_movable_pages.patch

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
@@ -2078,7 +2078,6 @@ err:
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages)
 {
-	int ret;
 	unsigned long collected;
 	LIST_HEAD(movable_page_list);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gupc-refactor-check_and_migrate_movable_pages.patch
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

