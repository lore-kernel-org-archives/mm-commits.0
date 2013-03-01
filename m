From: akpm@linux-foundation.org
Subject: + semaphore-boolize-semaphore_waiters-up.patch added to -mm tree
Date: Fri, 01 Mar 2013 13:08:51 -0800
Message-ID: <20130301210852.1F8E731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:33520 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3CAVIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 16:08:53 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so381623qen.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 13:08:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lig.fnst@cn.fujitsu.com, jkosina@suse.cz


The patch titled
     Subject: semaphore: use `bool' type for semaphore_waiter's up
has been added to the -mm tree.  Its filename is
     semaphore-boolize-semaphore_waiters-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch

