Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76279C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiIZVEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiIZVEW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:04:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FC2A1D21
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B048BB80AE8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ACBC433D7;
        Mon, 26 Sep 2022 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226259;
        bh=CnAuAlx9F0NLFhB2iQD7LkrBgk+DEVvtQn4S/YXJv4c=;
        h=Date:To:From:Subject:From;
        b=LqNd4aj/0Yn89WZ6EyICfHPxFA7cAMlxQMzxz39JpE4VVen7HTcMY2Eda7uAwXy1j
         wcaZWel7TT5TpuzW7EmUb3QZvA5ZM7H2yYmcwC2JtfP7UgUD5cYH+lGdT/ixd60dHW
         hZP2PG3FpQzNZvF/hbiYobOR06gwI7+W7sdpZCbA=
Date:   Mon, 26 Sep 2022 14:04:18 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-delete-unused-mmf_oom_victim-flag-fix.patch removed from -mm tree
Message-Id: <20220926210419.69ACBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-delete-unused-mmf_oom_victim-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-delete-unused-mmf_oom_victim-flag-fix.patch

This patch was dropped because it was folded into mm-delete-unused-mmf_oom_victim-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-delete-unused-mmf_oom_victim-flag-fix
Date: Sun Sep 18 05:03:09 PM PDT 2022

remove comment about now-removed mm_is_oom_victim()

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-delete-unused-mmf_oom_victim-flag-fix
+++ a/mm/mmap.c
@@ -3105,8 +3105,7 @@ void exit_mmap(struct mm_struct *mm)
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
-	 * because the memory has been already freed. Do not bother checking
-	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
+	 * because the memory has been already freed.
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-delete-unused-mmf_oom_victim-flag.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

