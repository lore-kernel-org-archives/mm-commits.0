Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D0BECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiILAkQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILAkP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B558D140F9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC536114D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D1BC433C1;
        Mon, 12 Sep 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943213;
        bh=7Hs0lDjIKnRekMab4mLOsUn+9dafHoUJwm+yQvXXfAA=;
        h=Date:To:From:Subject:From;
        b=omnyHyiT56F0XafskX+Jau8oAF9w/XJa+lzO6W8myH//SgMDgsNroJjrqvDYwaJJ7
         bjClG0xDcPL1mqPYmPyjRGrM9DBRCisiLF/AbQ6/3IcbE2PckyZDJ3bqUm92Ze5xDS
         g8SDoSJc3PohFT0UN28jMVcQ7886pu20+kf0pZW8=
Date:   Sun, 11 Sep 2022 17:40:12 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220912004013.A1D1BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch

This patch was dropped because it was folded into zsmalloc-zs_object_copy-replace-email-link-to-doc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
Date: Wed Aug 17 10:42:29 AM PDT 2022


ERROR: code indent should use tabs where possible
#26: FILE: mm/zsmalloc.c:1562:
+         * kunmap_atomic(d_addr). For more details see$

ERROR: code indent should use tabs where possible
#27: FILE: mm/zsmalloc.c:1563:
+         * Documentation/mm/highmem$

total: 2 errors, 0 warnings, 10 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/zsmalloc-zs_object_copy-replace-email-link-to-doc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
+++ a/mm/zsmalloc.c
@@ -1559,8 +1559,8 @@ static void zs_object_copy(struct size_c
 		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
 		 * calls must occurs in reverse order of calls to kmap_atomic().
 		 * So, to call kunmap_atomic(s_addr) we should first call
-         * kunmap_atomic(d_addr). For more details see
-         * Documentation/mm/highmem
+		 * kunmap_atomic(d_addr). For more details see
+		 * Documentation/mm/highmem.
 		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zsmalloc-zs_object_copy-replace-email-link-to-doc.patch
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

