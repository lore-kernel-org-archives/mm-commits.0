From: akpm@linux-foundation.org
Subject: [merged] ipc-sem-avoid-ipc_rcu_alloc.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:41:31 -0700
Message-ID: <20170713204131.MFVCUQEjp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUlc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: avoid ipc_rcu_alloc()
has been removed from the -mm tree.  Its filename was
     ipc-sem-avoid-ipc_rcu_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ipc/sem: avoid ipc_rcu_alloc()

Instead of using ipc_rcu_alloc() which only performs the refcount bump,
open code it to perform better sem-specific checks.  This also allows for
sem_array structure layout to be randomized in the future.

[manfred@colorfullife.com: Rediff, because the memset was temporarily inside ipc_rcu_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-10-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-sem-avoid-ipc_rcu_alloc ipc/sem.c
--- a/ipc/sem.c~ipc-sem-avoid-ipc_rcu_alloc
+++ a/ipc/sem.c
@@ -451,6 +451,25 @@ static inline void sem_rmid(struct ipc_n
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
 }
 
+static struct sem_array *sem_alloc(size_t nsems)
+{
+	struct sem_array *sma;
+	size_t size;
+
+	if (nsems > (INT_MAX - sizeof(*sma)) / sizeof(sma->sems[0]))
+		return NULL;
+
+	size = sizeof(*sma) + nsems * sizeof(sma->sems[0]);
+	sma = kvmalloc(size, GFP_KERNEL);
+	if (unlikely(!sma))
+		return NULL;
+
+	memset(sma, 0, size);
+	atomic_set(&sma->sem_perm.refcount, 1);
+
+	return sma;
+}
+
 /**
  * newary - Create a new semaphore set
  * @ns: namespace
@@ -463,7 +482,6 @@ static int newary(struct ipc_namespace *
 	int id;
 	int retval;
 	struct sem_array *sma;
-	int size;
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
@@ -474,10 +492,7 @@ static int newary(struct ipc_namespace *
 	if (ns->used_sems + nsems > ns->sc_semmns)
 		return -ENOSPC;
 
-	BUILD_BUG_ON(offsetof(struct sem_array, sem_perm) != 0);
