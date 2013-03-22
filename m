From: akpm@linux-foundation.org
Subject: + ipc-remove-bogus-lock-comment-for-ipc_checkid.patch added to -mm tree
Date: Fri, 22 Mar 2013 14:04:29 -0700
Message-ID: <20130322210429.EFC6E31C398@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:38219 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423101Ab3CVVEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:04:31 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so423027yen.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:04:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, benisty.e@gmail.com, chegu_vinod@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     Subject: ipc: remove bogus lock comment for ipc_checkid
has been added to the -mm tree.  Its filename is
     ipc-remove-bogus-lock-comment-for-ipc_checkid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: remove bogus lock comment for ipc_checkid

This series makes the sysv semaphore code more scalable, by reducing the
time the semaphore lock is held, and making the locking more scalable for
semaphore arrays with multiple semaphores.

The first four patches were written by Davidlohr Buesso, and reduce the
hold time of the semaphore lock.

The last three patches change the sysv semaphore code locking to be more
fine grained, providing a performance boost when multiple semaphores in a
semaphore array are being manipulated simultaneously.

On a 24 CPU system, performance numbers with the semop-multi
test with N threads and N semaphores, look like this:

	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
	threads			patches		rwlock patches	v3 patches
	10	610652		726325		1783589		2142206
	20	341570		365699		1520453		1977878
	30	288102		307037		1498167		2037995
	40	290714		305955		1612665		2256484
	50	288620		312890		1733453		2650292
	60	289987		306043		1649360		2388008
	70	291298		306347		1723167		2717486
	80	290948		305662		1729545		2763582
	90	290996		306680		1736021		2757524
	100	292243		306700		1773700		3059159



This patch:

There is no reason to be holding the ipc lock while reading ipcp->seq,
hence remove misleading comment.

Also simplify the return value for the function.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN ipc/util.h~ipc-remove-bogus-lock-comment-for-ipc_checkid ipc/util.h
--- a/ipc/util.h~ipc-remove-bogus-lock-comment-for-ipc_checkid
+++ a/ipc/util.h
@@ -150,14 +150,9 @@ static inline int ipc_buildid(int id, in
 	return SEQ_MULTIPLIER * seq + id;
 }
 
-/*
- * Must be called with ipcp locked
- */
 static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 {
-	if (uid / SEQ_MULTIPLIER != ipcp->seq)
-		return 1;
-	return 0;
+	return uid / SEQ_MULTIPLIER != ipcp->seq;
 }
 
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch

