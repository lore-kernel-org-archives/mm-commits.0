Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2957C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 22:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiHVWWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 18:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiHVWWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 18:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D504D26A
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 15:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB070B81613
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 22:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32C8C433D6;
        Mon, 22 Aug 2022 22:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661206971;
        bh=Qh2+jn98vVagbazeyxQtp9We1ECEqFF3W7oJjQjUQBk=;
        h=Date:To:From:Subject:From;
        b=VovxcIHrvJMBo3Vv1wsChxsyNKiXRJ6kkNjlUBg81ZeICPQJ+cC5a19I22DNMt+Mr
         144rn4CBDNpujs401xcwdncHNotgkAgHfXWo6bR0n9iWNr/CdoCky+kc5YJUN29PLu
         f/AinRyrCn5zieXveqmWIAR3hkafgOW5so6Vraa8=
Date:   Mon, 22 Aug 2022 15:22:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch added to mm-unstable branch
Message-Id: <20220822222251.A32C8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-delete-unused-mmf_oom_victim-flag-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch

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
 
@@ -4127,9 +4124,6 @@ restart:
 
 		walk_pmd_range(&val, addr, next, args);
 
-		if (mm_is_oom_victim(args->mm))
-			return 1;
-
 		/* a racy check to curtail the waiting time */
 		if (wq_has_sleeper(&walk->lruvec->mm_state.wait))
 			return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
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
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

