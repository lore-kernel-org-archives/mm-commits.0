Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09222ECAAD8
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 00:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiISADI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Sep 2022 20:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiISADH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Sep 2022 20:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9610413EA7
        for <mm-commits@vger.kernel.org>; Sun, 18 Sep 2022 17:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDD060B63
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 00:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888B4C433C1;
        Mon, 19 Sep 2022 00:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663545785;
        bh=/ZczMoCjw6YjiMsNrL2zB+XDKCrsaxr34pAefDwr3R4=;
        h=Date:To:From:Subject:From;
        b=B32PrBpk6y0K622YKj2+2XIQxVkTH1HoZgg5VM14O3f3sDRk+u8RMSomJgP/q4CDc
         kV7iq0riS1an+XMep1clsuWVeoHa2Xm5KylYkk90q8psd4t/junW7MVvOyu+BrsPxB
         M2EGYGTSYmha9JE4MeYnUBPhKXVL3jIbWVRbaElo=
Date:   Sun, 18 Sep 2022 17:03:04 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch removed from -mm tree
Message-Id: <20220919000305.888B4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-delete-unused-mmf_oom_victim-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-delete-unused-mmf_oom_victim-flag-fix
Date: Mon Aug 22 03:11:53 PM PDT 2022

remove MGLRU's mm_is_oom_victim() calls from vmscan.c

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/vmscan.c~mm-delete-unused-mmf_oom_victim-flag-vs-mglru
+++ a/mm/vmscan.c
@@ -3429,9 +3429,6 @@ static bool should_skip_mm(struct mm_str
 	if (size < MIN_LRU_BATCH)
 		return true;
 
-	if (mm_is_oom_victim(mm))
-		return true;
-
 	return !mmget_not_zero(mm);
 }
 
@@ -4130,9 +4127,6 @@ restart:
 
 		walk_pmd_range(&val, addr, next, args);
 
-		if (mm_is_oom_victim(args->mm))
-			return 1;
-
 		/* a racy check to curtail the waiting time */
 		if (wq_has_sleeper(&walk->lruvec->mm_state.wait))
 			return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmhwpoison-check-mm-when-killing-accessing-process-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
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

