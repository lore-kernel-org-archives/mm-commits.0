Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F475C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99B861261
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 18:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhJGSOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 14:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243487AbhJGSOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 14:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8B161260;
        Thu,  7 Oct 2021 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633630371;
        bh=WNv9v5k97PDczsvvQIBKyLkM/f16yKmJ5oMyX297hyI=;
        h=Date:From:To:Subject:From;
        b=qTTNSzb6IXkIEr8U8zXHYhhZ2fO4mBfVUixOTeeosE46WiVqJNcRq2T6A2Y/na29r
         jkoMmQOfNHsittzTbVsHCoth1j5Aww/vRMxGc+1I/Z/ImIbO4fksukboRIr47NX3+k
         75jflknvHKlMZ3S2fdtrX9SGhznSD1PpysT/tKiI=
Date:   Thu, 07 Oct 2021 11:12:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20211007181250.Ex4Yi78iS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    2 +-
 kernel/sched/core.c      |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/sched/mm.h~linux-next-rejects
+++ a/include/linux/sched/mm.h
@@ -59,7 +59,7 @@ static inline void mmgrab_lazy_tlb(struc
 static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
 {
 	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT)) {
-		mmdrop(mm);
+		mmdrop_sched(mm);
 	} else {
 		/*
 		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
--- a/kernel/sched/core.c~linux-next-rejects
+++ a/kernel/sched/core.c
@@ -4850,12 +4850,6 @@ static struct rq *finish_task_switch(str
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 
-		/*
-		 * Remove function-return probe instances associated with this
-		 * task and put them back on the free list.
-		 */
-		kprobe_flush_task(prev);
-
 		/* Task is done with its stack. */
 		put_task_stack(prev);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-dont-call-should_failslab-for-config_failslab-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

