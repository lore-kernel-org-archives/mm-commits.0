Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5140CE936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbjJDUYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244907AbjJDUXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD8E10B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E75CC433C8;
        Wed,  4 Oct 2023 20:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450998;
        bh=rfGVtc3xPnZRQiIYQjiAlKoFF0Kk5Zak0XrpDSJIjJQ=;
        h=Date:To:From:Subject:From;
        b=fZXm1WJx6MFGlt/NkKVPv3zzTlJmVZU31ScOu2TDw9yAG3bx9DyPIYZ5fD67iP//D
         rfO5JFhhaQWFBRxDZPD1K0cWTlLbGL/TldN2WUMwkwDnRmVt6ISXxDdUGrDISbs5wB
         Q+m7Hpp8HHOo6KXopgkT7TRaIRJyQ23ZV2X2eOag=
Date:   Wed, 04 Oct 2023 13:23:16 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] introduce-__next_thread-fix-next_tid-vs-exec-race.patch removed from -mm tree
Message-Id: <20231004202318.8E75CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: introduce __next_thread(), fix next_tid() vs exec() race
has been removed from the -mm tree.  Its filename was
     introduce-__next_thread-fix-next_tid-vs-exec-race.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3840,10 +3840,8 @@ static struct task_struct *next_tid(stru
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


