From: akpm@linux-foundation.org
Subject: + user-namespace-make-signalc-respect-user-namespaces-v5-fix-2.patch added to -mm tree
Date: Wed, 30 Nov 2011 12:42:24 -0800
Message-ID: <201111302042.pAUKgQ59027550@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:60019 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1K3Umd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 15:42:33 -0500
Received: by ggnp2 with SMTP id p2so136730ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 12:42:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, ebiederm@xmission.com, matthltc@us.ibm.com, oleg@redhat.com, serge@hallyn.com


The patch titled
     Subject: ipc/mqueue: lock() => unlock() typo
has been added to the -mm tree.  Its filename is
     user-namespace-make-signalc-respect-user-namespaces-v5-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ipc/mqueue: lock() => unlock() typo

There was a double lock typo introduced in b085f4bd6b21 "user namespace:
make signal.c respect user namespaces"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~user-namespace-make-signalc-respect-user-namespaces-v5-fix-2 ipc/mqueue.c
--- a/ipc/mqueue.c~user-namespace-make-signalc-respect-user-namespaces-v5-fix-2
+++ a/ipc/mqueue.c
@@ -558,7 +558,7 @@ static void __do_notify(struct mqueue_in
 						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
 						current_cred(), current_uid());
-			rcu_read_lock();
+			rcu_read_unlock();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
_
Subject: Subject: ipc/mqueue: lock() => unlock() typo

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
user-namespace-make-signalc-respect-user-namespaces-v5-fix-2.patch

