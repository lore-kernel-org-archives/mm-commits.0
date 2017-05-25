From: akpm@linux-foundation.org
Subject: + ipc-util-drop-ipc_rcu_free.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:06 -0700
Message-ID: <5927567a.tMnUAPHW6pyj4gLc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943233AbdEYWLI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util: drop ipc_rcu_free()
has been added to the -mm tree.  Its filename is
     ipc-util-drop-ipc_rcu_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-util-drop-ipc_rcu_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-util-drop-ipc_rcu_free.patch

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
Subject: ipc/util: drop ipc_rcu_free()

There are no more callers of ipc_rcu_free(), so remove it.

Link: http://lkml.kernel.org/r/20170525185107.12869-9-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    7 -------
 ipc/util.h |    1 -
 2 files changed, 8 deletions(-)

diff -puN ipc/util.c~ipc-util-drop-ipc_rcu_free ipc/util.c
--- a/ipc/util.c~ipc-util-drop-ipc_rcu_free
+++ a/ipc/util.c
@@ -429,13 +429,6 @@ void ipc_rcu_putref(struct kern_ipc_perm
 	call_rcu(&ptr->rcu, func);
 }
 
-void ipc_rcu_free(struct rcu_head *h)
-{
-	struct kern_ipc_perm *ptr = container_of(h, struct kern_ipc_perm, rcu);
-
-	kvfree(ptr);
-}
-
 /**
  * ipcperms - check ipc permissions
  * @ns: ipc namespace
diff -puN ipc/util.h~ipc-util-drop-ipc_rcu_free ipc/util.h
--- a/ipc/util.h~ipc-util-drop-ipc_rcu_free
+++ a/ipc/util.h
@@ -119,7 +119,6 @@ struct kern_ipc_perm *ipc_rcu_alloc(int
 int ipc_rcu_getref(struct kern_ipc_perm *ptr);
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
 			void (*func)(struct rcu_head *head));
-void ipc_rcu_free(struct rcu_head *h);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_obtain_object_idr(struct ipc_ids *ids, int id);
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

