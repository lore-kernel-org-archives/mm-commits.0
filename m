Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AA1ECAAD8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 23:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIUX6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 19:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIUX6I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 19:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07694A2205
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 16:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C22F630E6
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 23:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B63EC433D6;
        Wed, 21 Sep 2022 23:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663804686;
        bh=VgKNiMmSmSgcpxarNuibHVxrZdZ25f/0gsuHcVmEq/g=;
        h=Date:To:From:Subject:From;
        b=kjO9CjhTKP9obUAlVy+xg8ni97Wy3CAw2orRZ2iGJStV7JtVN+AtdBNEHEXRMy2op
         ursEYn8kd3sEDyGGjJohhbYrV9suV3G8MvbT2OqxMmd5Qg+55PnA0+MVVNPnGRkANf
         WzvGU1KXuUkCPW6KqfGNkg1VXl4EZJ6PiwweeJ1g=
Date:   Wed, 21 Sep 2022 16:58:05 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20220921235806.9B63EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: a
Date: Wed Sep 21 04:54:33 PM PDT 2022

In file included from ./include/linux/kernel.h:26,
                 from ./arch/x86/include/asm/percpu.h:27,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:55,
                 from ./include/linux/ipc.h:5,
                 from ./include/uapi/linux/msg.h:5,
                 from ./include/linux/msg.h:6,
                 from ipc/msg.c:27:
ipc/msg.c: In function 'msgctl_info':
./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
ipc/msg.c:504:35: note: in expansion of macro 'min'
  504 |                 msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs), INT_MAX);
      |                                   ^~~
./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
ipc/msg.c:505:35: note: in expansion of macro 'min'
  505 |                 msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes), INT_MAX);
      |                                   ^~~



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix
+++ a/ipc/msg.c
@@ -501,8 +501,12 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs), INT_MAX);
-		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes), INT_MAX);
+		msginfo->msgmap = min_t(int,
+				     percpu_counter_sum(&ns->percpu_msg_hdrs),
+				     INT_MAX);
+		msginfo->msgtql = min_t(int,
+		                     percpu_counter_sum(&ns->percpu_msg_bytes),
+				     INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
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
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

