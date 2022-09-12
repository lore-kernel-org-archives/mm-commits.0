Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF2BECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiILE52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiILE5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AD6286F7
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 438EAB80B21
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE1BC433D7;
        Mon, 12 Sep 2022 04:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958612;
        bh=yWzSMvLBMDnvauopV2SkOvlixBPi4YNeiXk1S2Zov7g=;
        h=Date:To:From:Subject:From;
        b=pENURjCqMa44KirHzTmxT3EicGwdtHiO62DwktDcA6yRfl9RnE//4nGB7MQ9nq8vA
         KYWjmXC7jJ4v8VX21Ovz40fgYZs8XvvA77RO/KKxsFtyCL4CFtxH7JgTI8JpXh6Uah
         g7Z5F76pNfydbGCS7K0b5gkzCgHi1ka87Ufeg9Vk=
Date:   Sun, 11 Sep 2022 21:56:51 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch removed from -mm tree
Message-Id: <20220912045651.DAE1BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: task_work: use try_cmpxchg in task_work_add, task_work_cancel_match and task_work_run
has been removed from the -mm tree.  Its filename was
     task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: task_work: use try_cmpxchg in task_work_add, task_work_cancel_match and task_work_run
Date: Tue, 23 Aug 2022 17:26:32 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
task_work_add, task_work_cancel_match and task_work_run.  x86 CMPXCHG
instruction returns success in ZF flag, so this change saves a compare
after cmpxchg (and related move instruction in front of cmpxchg).

Also, atomic_try_cmpxchg implicitly assigns old *ptr value to "old"
when cmpxchg fails, enabling further code simplifications.

The patch avoids extra memory read in case cmpxchg fails.

Link: https://lkml.kernel.org/r/20220823152632.4517-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/task_work.c~task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run
+++ a/kernel/task_work.c
@@ -47,12 +47,12 @@ int task_work_add(struct task_struct *ta
 	/* record the work call stack in order to print it in KASAN reports */
 	kasan_record_aux_stack(work);
 
+	head = READ_ONCE(task->task_works);
 	do {
-		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
 		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	} while (!try_cmpxchg(&task->task_works, &head, work));
 
 	switch (notify) {
 	case TWA_NONE:
@@ -100,10 +100,12 @@ task_work_cancel_match(struct task_struc
 	 * we raced with task_work_run(), *pprev == NULL/exited.
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	while ((work = READ_ONCE(*pprev))) {
-		if (!match(work, data))
+	work = READ_ONCE(*pprev);
+	while (work) {
+		if (!match(work, data)) {
 			pprev = &work->next;
-		else if (cmpxchg(pprev, work, work->next) == work)
+			work = READ_ONCE(*pprev);
+		} else if (try_cmpxchg(pprev, &work, work->next))
 			break;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -151,16 +153,16 @@ void task_work_run(void)
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
+		work = READ_ONCE(task->task_works);
 		do {
 			head = NULL;
-			work = READ_ONCE(task->task_works);
 			if (!work) {
 				if (task->flags & PF_EXITING)
 					head = &work_exited;
 				else
 					break;
 			}
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		} while (!try_cmpxchg(&task->task_works, &work, head));
 
 		if (!work)
 			break;
_

Patches currently in -mm which might be from ubizjak@gmail.com are


