From: akpm@linux-foundation.org
Subject: + semaphore-give-an-unlikely-for-downs-timeout.patch added to -mm tree
Date: Fri, 01 Mar 2013 13:08:48 -0800
Message-ID: <20130301210849.4027B5A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56240 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3CAVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 16:08:50 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so381233ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 13:08:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lig.fnst@cn.fujitsu.com, jkosina@suse.cz


The patch titled
     Subject: semaphore: use unlikely() for down's timeout
has been added to the -mm tree.  Its filename is
     semaphore-give-an-unlikely-for-downs-timeout.patch

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
Subject: semaphore: use unlikely() for down's timeout

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/semaphore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/semaphore.c~semaphore-give-an-unlikely-for-downs-timeout kernel/semaphore.c
--- a/kernel/semaphore.c~semaphore-give-an-unlikely-for-downs-timeout
+++ a/kernel/semaphore.c
@@ -214,7 +214,7 @@ static inline int __sched __down_common(
 	for (;;) {
 		if (signal_pending_state(state, task))
 			goto interrupted;
-		if (timeout <= 0)
+		if (unlikely(timeout <= 0))
 			goto timed_out;
 		__set_task_state(task, state);
 		raw_spin_unlock_irq(&sem->lock);
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch

