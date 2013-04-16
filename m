From: akpm@linux-foundation.org
Subject: + ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch added to -mm tree
Date: Tue, 16 Apr 2013 16:04:55 -0700
Message-ID: <20130416230455.7F8B531C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:48806 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565Ab3DPXE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 19:04:56 -0400
Received: by mail-yh0-f73.google.com with SMTP id i21so106041yha.4
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 16:04:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, davidlohr.bueso@hp.com, riel@redhat.com


The patch titled
     Subject: ipc,sem: prevent releasing RCU read lock twice in semctl_main
has been added to the -mm tree.  Its filename is
     ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: ipc,sem: prevent releasing RCU read lock twice in semctl_main

We will release RCU read lock twice if the sem id passed from userspace is
not within the legal range in semctl_main.

Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix
+++ a/ipc/sem.c
@@ -1098,8 +1098,10 @@ static int semctl_main(struct ipc_namesp
 	/* GETVAL, GETPID, GETNCTN, GETZCNT: fall-through */
 	}
 	err = -EINVAL;
-	if(semnum < 0 || semnum >= nsems)
-		goto out_unlock;
+	if(semnum < 0 || semnum >= nsems) {
+		rcu_read_unlock();
+		goto out_wakeup;
+	}
 
 	spin_lock(&sma->sem_perm.lock);
 	curr = &sma->sem_base[semnum];
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch

