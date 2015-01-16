From: akpm@linux-foundation.org
Subject: + ipcsem-use-current-state-helpers.patch added to -mm tree
Date: Thu, 15 Jan 2015 16:26:52 -0800
Message-ID: <54b85acc.hEY3XMgpdbwXiBx6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbAPA1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 19:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: use current->state helpers
has been added to the -mm tree.  Its filename is
     ipcsem-use-current-state-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsem-use-current-state-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcsem-use-current-state-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,sem: use current->state helpers

Call __set_current_state() instead of assigning the new state directly. 
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipcsem-use-current-state-helpers ipc/sem.c
--- a/ipc/sem.c~ipcsem-use-current-state-helpers
+++ a/ipc/sem.c
@@ -1941,7 +1941,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	queue.sleeper = current;
 
 sleep_again:
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	sem_unlock(sma, locknum);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch
linux-next.patch
ipcsem-use-current-state-helpers.patch
jbd-drop-jbd_enosys-debug.patch
signal-use-current-state-helpers.patch

