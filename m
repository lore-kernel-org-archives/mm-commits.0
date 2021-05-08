Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AC3C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A77976142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhEHWy4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhEHWyy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A48D610FA;
        Sat,  8 May 2021 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514432;
        bh=3FGVJPOZlZ/eOx3lMp19iWpzskppm5FgCT7dElPAV0c=;
        h=Date:From:To:Subject:From;
        b=1vXWkQZFDBlp1Yt9Jc6PEzt5xJd1uZ61Q/LJG93dui/f6X8hmx0U8i10jIUeVJ5F5
         +S7BeFtXR0jXD7Y9lKSJ9Feucu8e5OV96o7uTtHWxujvKw2LU1sKzwXyKjoKiLJU6P
         JcSimIKDbSc1Q5G+6L4pnjmoUmy78eNJYivNQ4pc=
Date:   Sat, 08 May 2021 15:53:52 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, joshs@netflix.com, laoar.shao@gmail.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 delayacct-clear-right-tasks-flag-after-blkio-completes.patch removed from
 -mm tree
Message-ID: <20210508225352.IQRTv06Lf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: clear right task's flag after blkio completes
has been removed from the -mm tree.  Its filename was
     delayacct-clear-right-tasks-flag-after-blkio-completes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: delayacct: clear right task's flag after blkio completes

When I was implementing a latency analyze tool by using task->delays and
other things, I found there's issue in delayacct.  The issue is it should
clear the target's flag instead of current's in delayacct_blkio_end().

When I git blame delayacct, I found there're some similar issues we have
fixed in delayacct_blkio_end().
'Commit c96f5471ce7d ("delayacct: Account blkio completion on the correct task")'
fixed the issue that it should account blkio completion on the target
task instead of current.
'Commit b512719f771a ("delayacct: fix crash in delayacct_blkio_end() after delayacct init failure")'
fixed the issue that it should check target task's delays instead of
current task'. It seems that delayacct_blkio_{begin, end} are error prone.
So I introduce a new paratmeter - the target task 'p' into these helpers,
after that change, the callsite will specifilly set the right task, which
should make it less error prone.

Link: https://lkml.kernel.org/r/20210414083720.24083-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josh Snyder <joshs@netflix.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   20 ++++++++++----------
 mm/memory.c               |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/delayacct.h~delayacct-clear-right-tasks-flag-after-blkio-completes
+++ a/include/linux/delayacct.h
@@ -82,16 +82,16 @@ static inline int delayacct_is_task_wait
 		return 0;
 }
 
-static inline void delayacct_set_flag(int flag)
+static inline void delayacct_set_flag(struct task_struct *p, int flag)
 {
-	if (current->delays)
-		current->delays->flags |= flag;
+	if (p->delays)
+		p->delays->flags |= flag;
 }
 
-static inline void delayacct_clear_flag(int flag)
+static inline void delayacct_clear_flag(struct task_struct *p, int flag)
 {
-	if (current->delays)
-		current->delays->flags &= ~flag;
+	if (p->delays)
+		p->delays->flags &= ~flag;
 }
 
 static inline void delayacct_tsk_init(struct task_struct *tsk)
@@ -114,7 +114,7 @@ static inline void delayacct_tsk_free(st
 
 static inline void delayacct_blkio_start(void)
 {
-	delayacct_set_flag(DELAYACCT_PF_BLKIO);
+	delayacct_set_flag(current, DELAYACCT_PF_BLKIO);
 	if (current->delays)
 		__delayacct_blkio_start();
 }
@@ -123,7 +123,7 @@ static inline void delayacct_blkio_end(s
 {
 	if (p->delays)
 		__delayacct_blkio_end(p);
-	delayacct_clear_flag(DELAYACCT_PF_BLKIO);
+	delayacct_clear_flag(p, DELAYACCT_PF_BLKIO);
 }
 
 static inline int delayacct_add_tsk(struct taskstats *d,
@@ -166,9 +166,9 @@ static inline void delayacct_thrashing_e
 }
 
 #else
-static inline void delayacct_set_flag(int flag)
+static inline void delayacct_set_flag(struct task_struct *p, int flag)
 {}
-static inline void delayacct_clear_flag(int flag)
+static inline void delayacct_clear_flag(struct task_struct *p, int flag)
 {}
 static inline void delayacct_init(void)
 {}
--- a/mm/memory.c~delayacct-clear-right-tasks-flag-after-blkio-completes
+++ a/mm/memory.c
@@ -3339,7 +3339,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 
-	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
+	delayacct_set_flag(current, DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
 
@@ -3388,7 +3388,7 @@ vm_fault_t do_swap_page(struct vm_fault
 					vmf->address, &vmf->ptl);
 			if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
 				ret = VM_FAULT_OOM;
-			delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+			delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 			goto unlock;
 		}
 
@@ -3402,13 +3402,13 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * owner processes (which may be unknown at hwpoison time)
 		 */
 		ret = VM_FAULT_HWPOISON;
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 		goto out_release;
 	}
 
 	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
 
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+	delayacct_clear_flag(current, DELAYACCT_PF_SWAPIN);
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
 		goto out_release;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


