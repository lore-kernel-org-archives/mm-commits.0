From: akpm@linux-foundation.org
Subject: + ipc-shm-remove-special-shm_alloc-free.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:24 -0700
Message-ID: <5927568c.hl53MASZc/KwQb5U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943086AbdEYWLZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: remove special shm_alloc/free
has been added to the -mm tree.  Its filename is
     ipc-shm-remove-special-shm_alloc-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-remove-special-shm_alloc-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-remove-special-shm_alloc-free.patch

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
Subject: ipc/shm: remove special shm_alloc/free

There is nothing special about the shm_alloc/free routines any more, so
remove them to make code more readable.

[manfred@colorfullife.com: Rediff, to continue to keep rcu for free calls after a successful security_shm_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-18-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN ipc/shm.c~ipc-shm-remove-special-shm_alloc-free ipc/shm.c
--- a/ipc/shm.c~ipc-shm-remove-special-shm_alloc-free
+++ a/ipc/shm.c
@@ -172,11 +172,6 @@ static inline void shm_lock_by_ptr(struc
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
-static void __shm_free(struct shmid_kernel *shp)
-{
-	kvfree(shp);
-}
-
 static void shm_rcu_free(struct rcu_head *head)
 {
 	struct kern_ipc_perm *ptr = container_of(head, struct kern_ipc_perm,
@@ -184,7 +179,7 @@ static void shm_rcu_free(struct rcu_head
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
 	security_shm_free(shp);
-	__shm_free(shp);
+	kvfree(shp);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -518,17 +513,6 @@ static const struct vm_operations_struct
 #endif
 };
 
-static struct shmid_kernel *shm_alloc(void)
-{
-	struct shmid_kernel *shp;
-
-	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
-	if (unlikely(!shp))
-		return NULL;
-
-	return shp;
-}
-
 /**
  * newseg - Create a new shared memory segment
  * @ns: namespace
@@ -558,8 +542,8 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = shm_alloc();
-	if (!shp)
+	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
+	if (unlikely(!shp))
 		return -ENOMEM;
 
 	shp->shm_perm.key = key;
@@ -569,7 +553,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(shp);
 	if (error) {
-		__shm_free(shp);
+		kvfree(shp);
 		return error;
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

