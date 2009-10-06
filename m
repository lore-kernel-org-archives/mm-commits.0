From: akpm@linux-foundation.org
Subject: + ipc-semc-sem-optimise-undo-list-search.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:32 -0700
Message-ID: <200910062117.n96LHWFW000491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933280AbZJFVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, manfred@colorfullife.com, peifferp@gmail.com


The patch titled
     ipc/sem.c: sem optimise undo list search
has been added to the -mm tree.  Its filename is
     ipc-semc-sem-optimise-undo-list-search.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -961,17 +961,31 @@ static inline int get_undo_list(struct s
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
@@ -1307,7 +1321,7 @@ void exit_sem(struct task_struct *tsk)
 		if (IS_ERR(sma))
 			continue;
 
-		un = lookup_undo(ulp, semid);
+		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

