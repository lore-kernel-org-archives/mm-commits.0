From: akpm@linux-foundation.org
Subject: [merged] ipc-sem-drop-__sem_free.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:41:51 -0700
Message-ID: <20170713204151.aP5SmCSYW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: drop __sem_free()
has been removed from the -mm tree.  Its filename was
     ipc-sem-drop-__sem_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/sem: drop __sem_free()

The remaining users of __sem_free() can simply call kvfree() instead for
better readability.

[manfred@colorfullife.com: Rediff to keep rcu protection for security_sem_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-20-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN ipc/sem.c~ipc-sem-drop-__sem_free ipc/sem.c
--- a/ipc/sem.c~ipc-sem-drop-__sem_free
+++ a/ipc/sem.c
@@ -258,18 +258,13 @@ static void merge_queues(struct sem_arra
 	}
 }
 
-static void __sem_free(struct sem_array *sma)
-{
-	kvfree(sma);
-}
-
 static void sem_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
 	struct sem_array *sma = container_of(p, struct sem_array, sem_perm);
 
 	security_sem_free(sma);
-	__sem_free(sma);
+	kvfree(sma);
 }
 
 /*
@@ -500,7 +495,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_perm.security = NULL;
 	retval = security_sem_alloc(sma);
 	if (retval) {
-		__sem_free(sma);
+		kvfree(sma);
 		return retval;
 	}
 
_

Patches currently in -mm which might be from keescook@chromium.org are


