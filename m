Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF8AC61D92
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 16:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbjKUQjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 11:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbjKUQjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 11:39:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AC218C
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 08:39:03 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25464C433C8;
        Tue, 21 Nov 2023 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700584743;
        bh=mdntPZ5h1PWzY8u5q/j7A5ai/UL0Bx7bcm1bqj8j3ic=;
        h=Date:To:From:Subject:From;
        b=GLlB/hUKOVc5VsW2povjXg1Um901cVSDXuhADIqJLM1sJNCpSbQ75ZmFTe41qdY27
         NwNEL/Z+Tcjur9df2tfPTwmcVmf3D2cFmuZiGZhn+Nzn1VSpyteI+BiTVZA3pRXkRT
         SN0BSHCJFJZLEv7yntph23RLTpCSh9ibvq72YbPI=
Date:   Tue, 21 Nov 2023 08:39:02 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + __ptrace_unlink-kill-the-obsolete-fixme-code.patch added to mm-nonmm-unstable branch
Message-Id: <20231121163903.25464C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: __ptrace_unlink: kill the obsolete "FIXME" code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     __ptrace_unlink-kill-the-obsolete-fixme-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/__ptrace_unlink-kill-the-obsolete-fixme-code.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: __ptrace_unlink: kill the obsolete "FIXME" code
Date: Tue, 21 Nov 2023 17:26:50 +0100

The corner case described by the comment is no longer possible after the
commit 7b3c36fc4c23 ("ptrace: fix task_join_group_stop() for the case when
current is traced"), task_join_group_stop() ensures that the new thread
has the correct signr in JOBCTL_STOP_SIGMASK regardless of ptrace.

Link: https://lkml.kernel.org/r/20231121162650.GA6635@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/kernel/ptrace.c~__ptrace_unlink-kill-the-obsolete-fixme-code
+++ a/kernel/ptrace.c
@@ -145,20 +145,9 @@ void __ptrace_unlink(struct task_struct
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
-	     child->signal->group_stop_count)) {
+	     child->signal->group_stop_count))
 		child->jobctl |= JOBCTL_STOP_PENDING;
 
-		/*
-		 * This is only possible if this thread was cloned by the
-		 * traced task running in the stopped group, set the signal
-		 * for the future reports.
-		 * FIXME: we should change ptrace_init_task() to handle this
-		 * case.
-		 */
-		if (!(child->jobctl & JOBCTL_STOP_SIGMASK))
-			child->jobctl |= SIGSTOP;
-	}
-
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
 	 * @child in the butt.  Note that @resume should be used iff @child
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-for_other_threadsp-t.patch
simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch
__ptrace_unlink-kill-the-obsolete-fixme-code.patch

