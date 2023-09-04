Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714D5C83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 18:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbjIDS7i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 14:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbjIDS7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 14:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55E8DB
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 11:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4256560BA1
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 18:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95176C433C7;
        Mon,  4 Sep 2023 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693853970;
        bh=IIBwmGYIRxnEpBrePjHQQXhfR0zflfvTnYurQbb1aQA=;
        h=Date:To:From:Subject:From;
        b=2AB9IsDkzutlCpsfQ630fOXnYAp9ACrKLjQQ8PhKv8bBNzhIfe7nMlXOCPGi+RW1W
         PmRBxoilyeplYCOnqFicfzoTcpA7xsRJ5FeRoUIPsZ3uSR/TMQRIhSWAoRVlhiEMVV
         R1Zt4lJiA2Mk0OouViyu/qhg4ea71otUAL15NYnQ=
Date:   Mon, 04 Sep 2023 11:59:29 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + change-next_thread-to-use-__next_thread-group_leader.patch added to mm-nonmm-unstable branch
Message-Id: <20230904185930.95176C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: change next_thread() to use __next_thread() ?: group_leader
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     change-next_thread-to-use-__next_thread-group_leader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/change-next_thread-to-use-__next_thread-group_leader.patch

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
Subject: change next_thread() to use __next_thread() ?: group_leader
Date: Thu, 24 Aug 2023 16:32:01 +0200

This relies on fact that group leader is always the 1st entry in the
signal->thread_head list.

With or without this change, if the lockless next_thread(last_thread)
races with exec it can return the old or the new leader.

We are almost ready to kill task->thread_group, after this change its
only user is thread_group_empty().

Link: https://lkml.kernel.org/r/20230824143201.GB31222@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/signal.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/sched/signal.h~change-next_thread-to-use-__next_thread-group_leader
+++ a/include/linux/sched/signal.h
@@ -726,10 +726,9 @@ static inline struct task_struct *__next
 					thread_node);
 }
 
-static inline struct task_struct *next_thread(const struct task_struct *p)
+static inline struct task_struct *next_thread(struct task_struct *p)
 {
-	return list_entry_rcu(p->thread_group.next,
-			      struct task_struct, thread_group);
+	return __next_thread(p) ?: p->group_leader;
 }
 
 static inline int thread_group_empty(struct task_struct *p)
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-__next_thread-fix-next_tid-vs-exec-race.patch
change-next_thread-to-use-__next_thread-group_leader.patch
change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch
__kill_pgrp_info-simplify-the-calculation-of-return-value.patch

