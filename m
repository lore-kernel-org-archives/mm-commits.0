Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35F7ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiILAfZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiILAfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB5420BC2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72F06114A
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C5C433C1;
        Mon, 12 Sep 2022 00:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662942922;
        bh=+a/QyxDpQXt1LKsYpu1TLZn2f6X3dwtcAQGZGcPc5mU=;
        h=Date:To:From:Subject:From;
        b=v4S+dFf11Y5j6a/Rm6ZaCIy5+0MobR2HFrnfkUmp3MR3dLoWyekVahlcIIRYGY/vR
         Oqlyg5EgcXGdLov1f5oXOE/8/C2sxnSArXBlYw99A3Bj6lRXB3cch0Actn71uPtN8I
         WExjnqGkZy+v9G6/R8uZxpF5PC0JYlijuoZT3yBo=
Date:   Sun, 11 Sep 2022 17:35:21 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch removed from -mm tree
Message-Id: <20220912003521.EA4C5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc-zs_object_copy-add-clarifying-comment-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch

This patch was dropped because it was folded into zsmalloc-zs_object_copy-add-clarifying-comment.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-zs_object_copy-add-clarifying-comment-fix
Date: Thu Aug 11 02:20:45 PM PDT 2022

tweak comment layout

Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-add-clarifying-comment-fix
+++ a/mm/zsmalloc.c
@@ -1555,10 +1555,11 @@ static void zs_object_copy(struct size_c
 		d_off += size;
 		d_size -= size;
 
-		/* Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic() calls
-		 * must occurs in reverse order of calls to kmap_atomic().
-		 * So, to call kunmap_atomic(s_addr) we should first call kunmap_atomic(d_addr).
-		 * For more details see:
+		/*
+		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
+		 * calls must occurs in reverse order of calls to kmap_atomic().
+		 * So, to call kunmap_atomic(s_addr) we should first call
+		 * kunmap_atomic(d_addr).  For more details see
 		 * https://lore.kernel.org/linux-mm/5512421D.4000603@samsung.com/
 		 */
 		if (s_off >= PAGE_SIZE) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zsmalloc-zs_object_copy-add-clarifying-comment.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
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

