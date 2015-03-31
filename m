From: akpm@linux-foundation.org
Subject: + msgrcv-use-freezable-blocking-call.patch added to -mm tree
Date: Tue, 31 Mar 2015 14:30:38 -0700
Message-ID: <551b11fe.phnL3b8rGy4J9kQ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbbCaVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yn.gaur@samsung.com, a.p.zijlstra@chello.nl, manjeet.p@samsung.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: use freezable blocking call
has been added to the -mm tree.  Its filename is
     msgrcv-use-freezable-blocking-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/msgrcv-use-freezable-blocking-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/msgrcv-use-freezable-blocking-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yogesh Gaur <yn.gaur@samsung.com>
Subject: ipc/msg.c: use freezable blocking call

Avoid waking up every thread sleeping in a msgrcv call during suspend and
resume by calling a freezable blocking call.  Previous patches modified
the freezer to avoid sending wakeups to threads that are blocked in
freezable blocking calls.

Ref: https://lkml.org/lkml/2013/5/1/424

Backtrace: 
[<c03e3924>] (__schedule+0x0/0x5d8) from [<c03e3f88>] (schedule+0x8c/0x90)
[<c03e3efc>] (schedule+0x0/0x90) from [<c01ef9f8>] (do_msgrcv+0x2e0/0x368)
[<c01ef718>] (do_msgrcv+0x0/0x368) from [<c01efaac>] (SyS_msgrcv+0x2c/0x38)
[<c01efa80>] (SyS_msgrcv+0x0/0x38) from [<c001a180>] (ret_fast_syscall+0x0/0x48)
tPlay0Cb2       R running      0   297    204 0x00000001

Signed-off-by: Yogesh Gaur <yn.gaur@samsung.com>
Signed-off-by: Manjeet Pawar <manjeet.p@samsung.com>
Reviewed-by : Ajeet Yadav <ajeet.y@samsung.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/msg.c~msgrcv-use-freezable-blocking-call ipc/msg.c
--- a/ipc/msg.c~msgrcv-use-freezable-blocking-call
+++ a/ipc/msg.c
@@ -37,6 +37,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/freezer.h>
 
 #include <asm/current.h>
 #include <linux/uaccess.h>
@@ -915,7 +916,7 @@ long do_msgrcv(int msqid, void __user *b
 
 		ipc_unlock_object(&msq->q_perm);
 		rcu_read_unlock();
-		schedule();
+		freezable_schedule();
 
 		/* Lockless receive, part 1:
 		 * Disable preemption.  We don't hold a reference to the queue
_

Patches currently in -mm which might be from yn.gaur@samsung.com are

restart_syscall-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch

