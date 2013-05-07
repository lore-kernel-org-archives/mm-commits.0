From: akpm@linux-foundation.org
Subject: [merged] semaphore-boolize-semaphore_waiters-up.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:24 -0700
Message-ID: <20130507175024.73BBD5A4512@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51390 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:25 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86310ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lig.fnst@cn.fujitsu.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: semaphore: use `bool' type for semaphore_waiter's up
has been removed from the -mm tree.  Its filename was
     semaphore-boolize-semaphore_waiters-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: semaphore: use `bool' type for semaphore_waiter's up

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/semaphore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/semaphore.c~semaphore-boolize-semaphore_waiters-up kernel/semaphore.c
--- a/kernel/semaphore.c~semaphore-boolize-semaphore_waiters-up
+++ a/kernel/semaphore.c
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(up);
 struct semaphore_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	int up;
+	bool up;
 };
 
 /*
@@ -209,7 +209,7 @@ static inline int __sched __down_common(
 
 	list_add_tail(&waiter.list, &sem->wait_list);
 	waiter.task = task;
-	waiter.up = 0;
+	waiter.up = false;
 
 	for (;;) {
 		if (signal_pending_state(state, task))
@@ -258,6 +258,6 @@ static noinline void __sched __up(struct
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
 	list_del(&waiter->list);
-	waiter->up = 1;
+	waiter->up = true;
 	wake_up_process(waiter->task);
 }
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

origin.patch

