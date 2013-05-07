From: akpm@linux-foundation.org
Subject: [merged] semaphore-give-an-unlikely-for-downs-timeout.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:21 -0700
Message-ID: <20130507175021.A2EFC5A44EF@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:41439 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3EGRuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:22 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so86329vea.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lig.fnst@cn.fujitsu.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: semaphore: use unlikely() for down's timeout
has been removed from the -mm tree.  Its filename was
     semaphore-give-an-unlikely-for-downs-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

