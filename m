Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E678C00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbiHXSM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239381AbiHXSM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F0D43E4A
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63A2FB8260D
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 18:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A68C433C1;
        Wed, 24 Aug 2022 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661364773;
        bh=PHcNw0THcOMgJHO4TLVsXyxMni0fNtWh9l9UqsxzeDc=;
        h=Date:To:From:Subject:From;
        b=DCF5Nixio9zIxao17lwcInVOoBCGiaJ4Cw9Y3B2aDsDbJELvkc4EJQkvjHI9xO8fN
         bjHisYBzLl2xiVX9FlFwIZNFyhg8V6dw5lkWvb7TJW0Pr+YfacqC8YBR7E0Ys/uXjd
         V48eqKbYHY/WpL1RWiQj1X/rTIX11PAj1GbDRiik=
Date:   Wed, 24 Aug 2022 11:12:52 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch added to mm-nonmm-unstable branch
Message-Id: <20220824181252.F2A68C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: task_work: use try_cmpxchg in task_work_add, task_work_cancel_match and task_work_run
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch

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

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch
aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch
iversion-use-atomic64_try_cmpxchg.patch
bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch
task_work-use-try_cmpxchg-in-task_work_add-task_work_cancel_match-and-task_work_run.patch

