From: akpm@linux-foundation.org
Subject: + ipc-util-drop-ipc_rcu_alloc.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:14 -0700
Message-ID: <59275682.ykiDvL5mGhR/qdbh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165681AbdEYWLP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util: drop ipc_rcu_alloc()
has been added to the -mm tree.  Its filename is
     ipc-util-drop-ipc_rcu_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-util-drop-ipc_rcu_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-util-drop-ipc_rcu_alloc.patch

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
Subject: ipc/util: drop ipc_rcu_alloc()

No callers remain for ipc_rcu_alloc(). Drop the function.

[manfred@colorfullife.com: Rediff because the memset was temporarily inside ipc_rcu_free()]
Link: http://lkml.kernel.org/r/20170525185107.12869-13-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   21 ---------------------
 ipc/util.h |    3 ---
 2 files changed, 24 deletions(-)

diff -puN ipc/util.c~ipc-util-drop-ipc_rcu_alloc ipc/util.c
--- a/ipc/util.c~ipc-util-drop-ipc_rcu_alloc
+++ a/ipc/util.c
@@ -394,27 +394,6 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	ipcp->deleted = true;
 }
 
-/**
- * ipc_rcu_alloc - allocate ipc space
- * @size: size desired
- *
- * Allocate memory for an ipc object.
- * The first member must be struct kern_ipc_perm.
- */
-struct kern_ipc_perm *ipc_rcu_alloc(int size)
-{
-	/*
-	 * We prepend the allocation with the rcu struct
-	 */
-	struct kern_ipc_perm *out = kvmalloc(size, GFP_KERNEL);
-	if (unlikely(!out))
-		return NULL;
-
-	memset(out, 0, size);
-	atomic_set(&out->refcount, 1);
-	return out;
-}
-
 int ipc_rcu_getref(struct kern_ipc_perm *ptr)
 {
 	return atomic_inc_not_zero(&ptr->refcount);
diff -puN ipc/util.h~ipc-util-drop-ipc_rcu_alloc ipc/util.h
--- a/ipc/util.h~ipc-util-drop-ipc_rcu_alloc
+++ a/ipc/util.h
@@ -112,10 +112,7 @@ int ipcperms(struct ipc_namespace *ns, s
  * Objects are reference counted, they start with reference count 1.
  * getref increases the refcount, the putref call that reduces the recount
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
- *
- * struct kern_ipc_perm must be the first member in the allocated structure.
  */
-struct kern_ipc_perm *ipc_rcu_alloc(int size);
 int ipc_rcu_getref(struct kern_ipc_perm *ptr);
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
 			void (*func)(struct rcu_head *head));
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

