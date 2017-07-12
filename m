From: akpm@linux-foundation.org
Subject: [patch 47/96] ipc: move atomic_set() to where it is needed
Date: Wed, 12 Jul 2017 14:35:22 -0700
Message-ID: <20170712213522.Jg7aBeXAq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753410AbdGLVfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
