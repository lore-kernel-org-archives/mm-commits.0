Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50C4C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIZUbi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIZUbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F94640A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8739B8111A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE14C433C1;
        Mon, 26 Sep 2022 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664224294;
        bh=c1ILoTFVdG501cSWuSUoPXWmQdBgFFlcfuL8sf6/IEs=;
        h=Date:To:From:Subject:From;
        b=aKGhJVKftuPWSakPkwqCk24vQ/XC20z2x/5mGH4P10T6qhOQiTmyeDKfdGTA2FoQl
         ziAlECD/p9MM96Fe0qJjv7ffQOyYYtfJG5EUqUPK1vwoC6R5/fbZQUVUDrakIVKK2p
         GDAINn4UgD++PVqyqTtknWTYxK09tX/wJc1fTqU0=
Date:   Mon, 26 Sep 2022 13:31:33 -0700
To:     mm-commits@vger.kernel.org, quic_pbrahma@quicinc.com,
        quic_charante@quicinc.com, mhocko@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch removed from -mm tree
Message-Id: <20220926203134.5BE14C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch

This patch was dropped because it was folded into mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
Date: Wed Aug 17 09:01:08 AM PDT 2022

reduce 80-col overflows

Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Pratyush Brahma <quic_pbrahma@quicinc.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix
+++ a/mm/oom_kill.c
@@ -1259,10 +1259,10 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 		ret = -EAGAIN;
 
 	pr_debug("process_mrelease: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
-						task_pid_nr(task), task->comm,
-						K(get_mm_counter(mm, MM_ANONPAGES)),
-						K(get_mm_counter(mm, MM_FILEPAGES)),
-						K(get_mm_counter(mm, MM_SHMEMPAGES)));
+		 task_pid_nr(task), task->comm,
+		 K(get_mm_counter(mm, MM_ANONPAGES)),
+		 K(get_mm_counter(mm, MM_FILEPAGES)),
+		 K(get_mm_counter(mm, MM_SHMEMPAGES)));
 	trace_finish_task_reaping(task->pid);
 
 read_unlock:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom_kill-add-trace-logs-in-process_mrelease-system-call.patch
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
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

