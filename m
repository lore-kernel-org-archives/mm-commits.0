From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:41:39 -0700
Message-ID: <20170713204139.-UJrtOta5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59310 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUlk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: avoid ipc_rcu_putref for failed ipc_addid()
has been removed from the -mm tree.  Its filename was
     ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: avoid ipc_rcu_putref for failed ipc_addid()

Loosely based on a patch from Kees Cook <keescook@chromium.org>:
- id and retval can be merged
- if ipc_addid() fails, then use call_rcu() directly.

The difference is that call_rcu is used for failed ipc_addid() calls, to
continue to guaranteed an rcu delay for security_sem_free().

Link: http://lkml.kernel.org/r/20170525185107.12869-14-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid
+++ a/ipc/sem.c
@@ -479,7 +479,6 @@ static struct sem_array *sem_alloc(size_
  */
 static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 {
-	int id;
 	int retval;
 	struct sem_array *sma;
 	key_t key = params->key;
@@ -520,10 +519,10 @@ static int newary(struct ipc_namespace *
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
 
-	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if (id < 0) {
-		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
-		return id;
+	retval = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	if (retval < 0) {
+		call_rcu(&sma->sem_perm.rcu, sem_rcu_free);
+		return retval;
 	}
 	ns->used_sems += nsems;
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are


