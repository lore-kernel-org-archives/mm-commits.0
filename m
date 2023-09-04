Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734E0C83F3E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 18:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjIDS7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 14:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237745AbjIDS7d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 14:59:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC348127
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 11:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 924C7B80EF6
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 18:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C38C433C7;
        Mon,  4 Sep 2023 18:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693853967;
        bh=U/1lkhRTV23p/qATHmU1aKGKu7KXmnmWL5t2ehCvx3I=;
        h=Date:To:From:Subject:From;
        b=hp2QNxEYzXGWN6ylW/2xyYbBMsjFgsxHfQJdxAtjCVKw19Caucn/exeRqUF0Euuzb
         cQ2bfd91lfrjp7Se7kD43L2I9NcbkDoS74nkDUQTGZK8fI79yh5fxJvMY3ju1hj9V8
         kT63K6NA2r9ZymIfdHk9cWtSlqpcPltIKf8u4Bo4=
Date:   Mon, 04 Sep 2023 11:59:26 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + introduce-__next_thread-fix-next_tid-vs-exec-race.patch added to mm-nonmm-unstable branch
Message-Id: <20230904185927.41C38C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: introduce __next_thread(), fix next_tid() vs exec() race
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     introduce-__next_thread-fix-next_tid-vs-exec-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/introduce-__next_thread-fix-next_tid-vs-exec-race.patch

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
Subject: introduce __next_thread(), fix next_tid() vs exec() race
Date: Thu, 24 Aug 2023 16:31:42 +0200

Patch series "introduce __next_thread(), change next_thread()".

After commit dce8f8ed1de1 ("document while_each_thread(), change
first_tid() to use for_each_thread()") + this series

1. We have only one lockless user of next_thread(), task_group_seq_get_next().
   I think it should be changed too.

2. We have only one user of task_struct->thread_group, thread_group_empty().
   The next patches will change thread_group_empty() and kill ->thread_group.


This patch (of 2):

next_tid(start) does:

	rcu_read_lock();
	if (pid_alive(start)) {
		pos = next_thread(start);
		if (thread_group_leader(pos))
			pos = NULL;
		else
			get_task_struct(pos);

it should return pos = NULL when next_thread() wraps to the 1st thread
in the thread group, group leader, and the thread_group_leader() check
tries to detect this case.

But this can race with exec. To simplify, suppose we have a main thread
M and a single sub-thread T, next_tid(T) should return NULL.

Now suppose that T execs. If next_tid(T) is called after T changes the
leadership and before it does release_task() which removes the old leader
from list, then next_thread() returns M and thread_group_leader(M) = F.

Lockless use of next_thread() should be avoided. After this change only
task_group_seq_get_next() does this, and I believe it should be changed
as well.

Link: https://lkml.kernel.org/r/20230824143112.GA31208@redhat.com
Link: https://lkml.kernel.org/r/20230824143142.GA31222@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c               |    6 ++----
 include/linux/sched/signal.h |   11 +++++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~introduce-__next_thread-fix-next_tid-vs-exec-race
+++ a/fs/proc/base.c
@@ -3839,10 +3839,8 @@ static struct task_struct *next_tid(stru
 	struct task_struct *pos = NULL;
 	rcu_read_lock();
 	if (pid_alive(start)) {
-		pos = next_thread(start);
-		if (thread_group_leader(pos))
-			pos = NULL;
-		else
+		pos = __next_thread(start);
+		if (pos)
 			get_task_struct(pos);
 	}
 	rcu_read_unlock();
--- a/include/linux/sched/signal.h~introduce-__next_thread-fix-next_tid-vs-exec-race
+++ a/include/linux/sched/signal.h
@@ -715,6 +715,17 @@ bool same_thread_group(struct task_struc
 	return p1->signal == p2->signal;
 }
 
+/*
+ * returns NULL if p is the last thread in the thread group
+ */
+static inline struct task_struct *__next_thread(struct task_struct *p)
+{
+	return list_next_or_null_rcu(&p->signal->thread_head,
+					&p->thread_node,
+					struct task_struct,
+					thread_node);
+}
+
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
 	return list_entry_rcu(p->thread_group.next,
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-__next_thread-fix-next_tid-vs-exec-race.patch
change-next_thread-to-use-__next_thread-group_leader.patch
change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch
__kill_pgrp_info-simplify-the-calculation-of-return-value.patch

