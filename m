From: akpm@linux-foundation.org
Subject: [patch 36/96] ipc/sem: do not use ipc_rcu_free()
Date: Wed, 12 Jul 2017 14:34:50 -0700
Message-ID: <20170712213450.nu3q81J4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbdGLVev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: ipc/sem: do not use ipc_rcu_free()

Avoid using ipc_rcu_free, since it just re-finds the original structure
pointer.  For the pre-list-init failure path, there is no RCU needed,
since it was just allocated.  It can be directly freed.

Link: http://lkml.kernel.org/r/20170525185107.12869-6-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-do-not-use-ipc_rcu_free ipc/sem.c
--- a/ipc/sem.c~ipc-sem-do-not-use-ipc_rcu_free
+++ a/ipc/sem.c
@@ -258,13 +258,18 @@ static void merge_queues(struct sem_arra
 	}
 }
 
+static void __sem_free(struct sem_array *sma)
+{
+	kvfree(sma);
+}
+
 static void sem_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
 	struct sem_array *sma = container_of(p, struct sem_array, sem_perm);
 
 	security_sem_free(sma);
-	ipc_rcu_free(head);
+	__sem_free(sma);
 }
 
 /*
@@ -482,7 +487,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_perm.security = NULL;
 	retval = security_sem_alloc(sma);
 	if (retval) {
-		ipc_rcu_putref(&sma->sem_perm, ipc_rcu_free);
+		__sem_free(sma);
 		return retval;
 	}
 
_
