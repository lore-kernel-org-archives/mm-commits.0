From: akpm@linux-foundation.org
Subject: + ipc-msgc-msgsnd-use-freezable-blocking-call.patch added to -mm
 tree
Date: Wed, 06 May 2015 15:22:14 -0700
Message-ID: <554a9416.FeJMtjsCR+k9ITwx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbEFWWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 18:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, a.p.zijlstra@chello.nl, ajeet.y@samsung.com, manjeet.p@samsung.com, tj@kernel.org, v.narang@samsung.com, yn.gaur@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: msgsnd: use freezable blocking call
has been added to the -mm tree.  Its filename is
     ipc-msgc-msgsnd-use-freezable-blocking-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msgc-msgsnd-use-freezable-blocking-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msgc-msgsnd-use-freezable-blocking-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: ipc/msg.c: msgsnd: use freezable blocking call

Avoid waking up every thread sleeping in a msgsnd call during suspend and
resume by calling a freezable blocking call.  Previous patches modified
the freezer to avoid sending wakeups to threads that are blocked in
freezable blocking calls.

This call was selected to be converted to a freezable call because it
doesn't hold any locks or release any resources when interrupted that
might be needed by another freezing task or a kernel driver during
suspend, and is a common site where idle userspace tasks are blocked.

Signed-off-by: Vaneet narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Yogesh Gaur <yn.gaur@samsung.com>
Cc: Manjeet Pawar <manjeet.p@samsung.com>
Cc: Ajeet Yadav <ajeet.y@samsung.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipc-msgc-msgsnd-use-freezable-blocking-call ipc/msg.c
--- a/ipc/msg.c~ipc-msgc-msgsnd-use-freezable-blocking-call
+++ a/ipc/msg.c
@@ -673,7 +673,7 @@ long do_msgsnd(int msqid, long mtype, vo
 
 		ipc_unlock_object(&msq->q_perm);
 		rcu_read_unlock();
-		schedule();
+		freezable_schedule();
 
 		rcu_read_lock();
 		ipc_lock_object(&msq->q_perm);
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch

