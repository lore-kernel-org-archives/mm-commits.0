From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-sem-optimise-undo-list-search.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:33 -0800
Message-ID: <200912162038.nBGKcXr9013441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964944AbZLPUik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: sem optimise undo list search
has been removed from the -mm tree.  Its filename was
     ipc-semc-sem-optimise-undo-list-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: sem optimise undo list search
From: Nick Piggin <npiggin@suse.de>

Around a month ago, there was some discussion about an improvement of the
sysv sem algorithm: Most (at least: some important) users only use simple
semaphore operations, therefore it's worthwile to optimize this use case.


This patch:

Move last looked up sem_undo struct to the head of the task's undo list. 
Attempt to move common entries to the front of the list so search time is
reduced.  This reduces lookup_undo on oprofile of problematic SAP workload
by 30% (see patch 4 for a description of SAP workload).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN ipc/sem.c~ipc-semc-sem-optimise-undo-list-search ipc/sem.c
--- a/ipc/sem.c~ipc-semc-sem-optimise-undo-list-search
+++ a/ipc/sem.c
@@ -962,17 +962,31 @@ static inline int get_undo_list(struct s
 	return 0;
 }
 
-static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
+static struct sem_undo *__lookup_undo(struct sem_undo_list *ulp, int semid)
 {
-	struct sem_undo *walk;
+	struct sem_undo *un;
 
-	list_for_each_entry_rcu(walk, &ulp->list_proc, list_proc) {
-		if (walk->semid == semid)
-			return walk;
+	list_for_each_entry_rcu(un, &ulp->list_proc, list_proc) {
+		if (un->semid == semid)
+			return un;
 	}
 	return NULL;
 }
 
+static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
+{
+	struct sem_undo *un;
+
+  	assert_spin_locked(&ulp->lock);
+
+	un = __lookup_undo(ulp, semid);
+	if (un) {
+		list_del_rcu(&un->list_proc);
+		list_add_rcu(&un->list_proc, &ulp->list_proc);
+	}
+	return un;
+}
+
 /**
  * find_alloc_undo - Lookup (and if not present create) undo array
  * @ns: namespace
@@ -1308,7 +1322,7 @@ void exit_sem(struct task_struct *tsk)
 		if (IS_ERR(sma))
 			continue;
 
-		un = lookup_undo(ulp, semid);
+		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-anon_inodes-implement-dname.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

