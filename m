From: akpm@linux-foundation.org
Subject: + ipc-sem-drop-__sem_free.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:28 -0700
Message-ID: <59275690.pAAMaL9vePtLE41Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970364AbdEYWL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: drop __sem_free()
has been added to the -mm tree.  Its filename is
     ipc-sem-drop-__sem_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-drop-__sem_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-drop-__sem_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch

