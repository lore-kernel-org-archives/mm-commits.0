From: akpm@linux-foundation.org
Subject: [folded] user-namespace-make-signalc-respect-user-namespaces-v5-fix-2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:57:58 -0800
Message-ID: <20120110225758.78EE31000FC@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:63640 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab2AJW57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:57:59 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so14601ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:57:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ebiederm@xmission.com, matthltc@us.ibm.com, oleg@redhat.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: lock() => unlock() typo
has been removed from the -mm tree.  Its filename was
     user-namespace-make-signalc-respect-user-namespaces-v5-fix-2.patch

This patch was dropped because it was folded into user-namespace-make-signalc-respect-user-namespaces-v5.patch

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
@@ -557,7 +557,7 @@ static void __do_notify(struct mqueue_in
 						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
 						current_cred(), current_uid());
-			rcu_read_lock();
+			rcu_read_unlock();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
leds-add-driver-for-tca6507-led-controller.patch
user-namespace-make-signalc-respect-user-namespaces-v5.patch

