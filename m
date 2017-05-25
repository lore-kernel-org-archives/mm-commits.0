From: akpm@linux-foundation.org
Subject: + ipc-move-atomic_set-to-where-it-is-needed.patch added to -mm
 tree
Date: Thu, 25 May 2017 15:11:22 -0700
Message-ID: <5927568a.k+G54k0EPmz3VEVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943082AbdEYWLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: move atomic_set() to where it is needed
has been added to the -mm tree.  Its filename is
     ipc-move-atomic_set-to-where-it-is-needed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-move-atomic_set-to-where-it-is-needed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-move-atomic_set-to-where-it-is-needed.patch

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
Subject: ipc: move atomic_set() to where it is needed

Only after ipc_addid() has succeeded will refcounting be used, so move
initialization into ipc_addid() and remove from open-coded *_alloc()
routines.

Link: http://lkml.kernel.org/r/20170525185107.12869-17-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    2 --
 ipc/sem.c  |    1 -
 ipc/shm.c  |    2 --
 ipc/util.c |    1 +
 4 files changed, 1 insertion(+), 5 deletions(-)

diff -puN ipc/msg.c~ipc-move-atomic_set-to-where-it-is-needed ipc/msg.c
--- a/ipc/msg.c~ipc-move-atomic_set-to-where-it-is-needed
+++ a/ipc/msg.c
@@ -117,8 +117,6 @@ static struct msg_queue *msg_alloc(void)
 	if (unlikely(!msq))
 		return NULL;
 
-	atomic_set(&msq->q_perm.refcount, 1);
-
 	return msq;
 }
 
diff -puN ipc/sem.c~ipc-move-atomic_set-to-where-it-is-needed ipc/sem.c
--- a/ipc/sem.c~ipc-move-atomic_set-to-where-it-is-needed
+++ a/ipc/sem.c
@@ -465,7 +465,6 @@ static struct sem_array *sem_alloc(size_
 		return NULL;
 
 	memset(sma, 0, size);
-	atomic_set(&sma->sem_perm.refcount, 1);
 
 	return sma;
 }
diff -puN ipc/shm.c~ipc-move-atomic_set-to-where-it-is-needed ipc/shm.c
--- a/ipc/shm.c~ipc-move-atomic_set-to-where-it-is-needed
+++ a/ipc/shm.c
@@ -526,8 +526,6 @@ static struct shmid_kernel *shm_alloc(vo
 	if (unlikely(!shp))
 		return NULL;
 
-	atomic_set(&shp->shm_perm.refcount, 1);
-
 	return shp;
 }
 
diff -puN ipc/util.c~ipc-move-atomic_set-to-where-it-is-needed ipc/util.c
--- a/ipc/util.c~ipc-move-atomic_set-to-where-it-is-needed
+++ a/ipc/util.c
@@ -232,6 +232,7 @@ int ipc_addid(struct ipc_ids *ids, struc
 
 	idr_preload(GFP_KERNEL);
 
+	atomic_set(&new->refcount, 1);
 	spin_lock_init(&new->lock);
 	new->deleted = false;
 	rcu_read_lock();
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

