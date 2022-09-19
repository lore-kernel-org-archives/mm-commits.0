Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3868FECAAD8
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 00:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiISAHX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Sep 2022 20:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiISAHW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Sep 2022 20:07:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A861570C
        for <mm-commits@vger.kernel.org>; Sun, 18 Sep 2022 17:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C6E60F7C
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 00:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7861DC433C1;
        Mon, 19 Sep 2022 00:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663546040;
        bh=7IMiEgVW5phDc0uMfjM81XLpUpEog3rDrhsv+BcByhk=;
        h=Date:To:From:Subject:From;
        b=qoDb6RCGr6e4INth/G3hcHJRhrigNd+grR/1riJ/NNpIyfSVeSaBzuRIS42eJklTV
         HG1b6AGg8eBPooxzpcB89LMGtsK2mXs0g3+Nz+AaSfuBvSeNX2zAozAbbEtOFHqMzk
         9YMeWoJof5TDKQ9xrf/0cRy/FawnoFNwYbkhjJMY=
Date:   Sun, 18 Sep 2022 17:07:19 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-unused-mmf_oom_victim-flag-fix.patch added to mm-unstable branch
Message-Id: <20220919000720.7861DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-delete-unused-mmf_oom_victim-flag-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-unused-mmf_oom_victim-flag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-unused-mmf_oom_victim-flag-fix.patch

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

mmhwpoison-check-mm-when-killing-accessing-process-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-fix.patch
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

