Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF911C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiIMVqw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIMVqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DB36BD7A
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:46:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 711C6B810E2
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE0C433D6;
        Tue, 13 Sep 2022 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663105607;
        bh=PU+/nZrry6ewC0fVyoo815mm8AbaHuD125vzbkvVQx0=;
        h=Date:To:From:Subject:From;
        b=wpUAKVgdfZwcK0+ETJON4QPbEQrhO/IFtRcyUtY334Zsy/aqOyzIi5RQK5tZ+sHvp
         p0HlU3mFXT+lV6ikdT4o2RyJ0+cQhxp39lJxvsOqCmC5j53OVl1+x14p9yo+QQTFR1
         202UoDqxPw57AdKZAb+7zPQ6v6ZLghmSee91Nmvc=
Date:   Tue, 13 Sep 2022 14:46:46 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        manfred@colorfullife.com, legion@kernel.org, jiebin.sun@intel.com,
        ebiederm@xmission.com, dennis@kernel.org, dave@stgolabs.net,
        cl@linux.com, alexander.mikhalitsyn@virtuozzo.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20220913214647.0ACE0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

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
Subject: ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
Date: Tue Sep 13 02:45:19 PM PDT 2022

WARNING: labels should not be indented
#158: FILE: ipc/msg.c:1319:
+	fail_msg_hdrs:

WARNING: labels should not be indented
#160: FILE: ipc/msg.c:1321:
+	fail_msg_bytes:

ERROR: space required after that ';' (ctx:VxV)
#203: FILE: ipc/util.h:75:
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0;}
                                                                   ^

total: 1 errors, 2 warnings, 144 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jiebin Sun <jiebin.sun@intel.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    8 ++++----
 ipc/util.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
+++ a/ipc/msg.c
@@ -1316,10 +1316,10 @@ int msg_init_ns(struct ipc_namespace *ns
 	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
 	return 0;
 
-	fail_msg_hdrs:
-		percpu_counter_destroy(&ns->percpu_msg_bytes);
-	fail_msg_bytes:
-		return ret;
+fail_msg_hdrs:
+	percpu_counter_destroy(&ns->percpu_msg_bytes);
+fail_msg_bytes:
+	return ret;
 }
 
 #ifdef CONFIG_IPC_NS
--- a/ipc/util.h~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
+++ a/ipc/util.h
@@ -72,7 +72,7 @@ void msg_exit_ns(struct ipc_namespace *n
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
 static inline void sem_init_ns(struct ipc_namespace *ns) { }
-static inline int msg_init_ns(struct ipc_namespace *ns) { return 0;}
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0; }
 static inline void shm_init_ns(struct ipc_namespace *ns) { }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

