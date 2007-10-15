From: akpm@linux-foundation.org
Subject: + ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:10:39 -0700
Message-ID: <200710151910.l9FJAdXt020266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757720AbXJOTLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC: cleanup some code and wrong comments about semundo list managment
has been added to the -mm tree.  Its filename is
     ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPC: cleanup some code and wrong comments about semundo list managment
From: Pierre Peiffer <pierre.peiffer@bull.net>

Some comments about sem_undo_list seem wrong.
About the comment above unlock_semundo:
"... If task2 now exits before task1 releases the lock (by calling
unlock_semundo()), then task1 will never call spin_unlock(). ..."

This is just wrong, I see no reason for which task1 will not call
spin_unlock... The rest of this comment is also wrong... Unless I
miss something (of course).

Finally, (un)lock_semundo functions are useless, so remove them
for simplification. (this avoids an useless if statement)

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   46 ++++++----------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff -puN ipc/sem.c~ipc-cleanup-some-code-and-wrong-comments-about-semundo ipc/sem.c
--- a/ipc/sem.c~ipc-cleanup-some-code-and-wrong-comments-about-semundo
+++ a/ipc/sem.c
@@ -999,36 +999,6 @@ asmlinkage long sys_semctl (int semid, i
 	}
 }
 
-static inline void lock_semundo(void)
-{
-	struct sem_undo_list *undo_list;
-
-	undo_list = current->sysvsem.undo_list;
-	if (undo_list)
-		spin_lock(&undo_list->lock);
-}
-
-/* This code has an interaction with copy_semundo().
- * Consider; two tasks are sharing the undo_list. task1
- * acquires the undo_list lock in lock_semundo().  If task2 now
- * exits before task1 releases the lock (by calling
- * unlock_semundo()), then task1 will never call spin_unlock().
- * This leave the sem_undo_list in a locked state.  If task1 now creats task3
- * and once again shares the sem_undo_list, the sem_undo_list will still be
- * locked, and future SEM_UNDO operations will deadlock.  This case is
- * dealt with in copy_semundo() by having it reinitialize the spin lock when 
- * the refcnt goes from 1 to 2.
- */
-static inline void unlock_semundo(void)
-{
-	struct sem_undo_list *undo_list;
-
-	undo_list = current->sysvsem.undo_list;
-	if (undo_list)
-		spin_unlock(&undo_list->lock);
-}
-
-
 /* If the task doesn't already have a undo_list, then allocate one
  * here.  We guarantee there is only one thread using this undo list,
  * and current is THE ONE
@@ -1089,9 +1059,9 @@ static struct sem_undo *find_undo(struct
 	if (error)
 		return ERR_PTR(error);
 
-	lock_semundo();
+	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
-	unlock_semundo();
+	spin_unlock(&ulp->lock);
 	if (likely(un!=NULL))
 		goto out;
 
@@ -1114,10 +1084,10 @@ static struct sem_undo *find_undo(struct
 	new->semadj = (short *) &new[1];
 	new->semid = semid;
 
-	lock_semundo();
+	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		unlock_semundo();
+		spin_unlock(&ulp->lock);
 		kfree(new);
 		ipc_lock_by_ptr(&sma->sem_perm);
 		ipc_rcu_putref(sma);
@@ -1128,7 +1098,7 @@ static struct sem_undo *find_undo(struct
 	ipc_rcu_putref(sma);
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
-		unlock_semundo();
+		spin_unlock(&ulp->lock);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1139,7 +1109,7 @@ static struct sem_undo *find_undo(struct
 	sma->undo = new;
 	sem_unlock(sma);
 	un = new;
-	unlock_semundo();
+	spin_unlock(&ulp->lock);
 out:
 	return un;
 }
@@ -1315,10 +1285,6 @@ asmlinkage long sys_semop (int semid, st
 
 /* If CLONE_SYSVSEM is set, establish sharing of SEM_UNDO state between
  * parent and child tasks.
- *
- * See the notes above unlock_semundo() regarding the spin_lock_init()
- * in this code.  Initialize the undo_list->lock here instead of get_undo_list()
- * because of the reasoning in the comment above unlock_semundo.
  */
 
 int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch
