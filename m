From: akpm@linux-foundation.org
Subject: +
 ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch added to
 -mm tree
Date: Wed, 19 Jul 2017 15:34:35 -0700
Message-ID: <596fde7b.oKr73vvUaTI7id1Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932078AbdGSWeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 18:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elena.reshetova@intel.com, adobriyan@gmail.com, arozansk@redhat.com, dave@stgolabs.net, dwindsor@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, keescook@chromium.org, manfred@colorfullife.com, mingo@redhat.com, peterz@infradead.org, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: convert sem_undo_list.refcnt from atomic_t to refcount_t
has been added to the -mm tree.  Its filename is
     ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: ipc: convert sem_undo_list.refcnt from atomic_t to refcount_t

refcount_t type and corresponding API should be used instead of atomic_t
when the variable is used as a reference counter.  This allows to avoid
accidental refcounter overflows that might lead to use-after-free
situations.

Link: http://lkml.kernel.org/r/1499417992-3238-3-git-send-email-elena.reshetova@intel.com
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: <arozansk@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t ipc/sem.c
--- a/ipc/sem.c~ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t
+++ a/ipc/sem.c
@@ -122,7 +122,7 @@ struct sem_undo {
  * that may be shared among all a CLONE_SYSVSEM task group.
  */
 struct sem_undo_list {
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	spinlock_t		lock;
 	struct list_head	list_proc;
 };
@@ -1642,7 +1642,7 @@ static inline int get_undo_list(struct s
 		if (undo_list == NULL)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
-		atomic_set(&undo_list->refcnt, 1);
+		refcount_set(&undo_list->refcnt, 1);
 		INIT_LIST_HEAD(&undo_list->list_proc);
 
 		current->sysvsem.undo_list = undo_list;
@@ -2041,7 +2041,7 @@ int copy_semundo(unsigned long clone_fla
 		error = get_undo_list(&undo_list);
 		if (error)
 			return error;
-		atomic_inc(&undo_list->refcnt);
+		refcount_inc(&undo_list->refcnt);
 		tsk->sysvsem.undo_list = undo_list;
 	} else
 		tsk->sysvsem.undo_list = NULL;
@@ -2070,7 +2070,7 @@ void exit_sem(struct task_struct *tsk)
 		return;
 	tsk->sysvsem.undo_list = NULL;
 
-	if (!atomic_dec_and_test(&ulp->refcnt))
+	if (!refcount_dec_and_test(&ulp->refcnt))
 		return;
 
 	for (;;) {
_

Patches currently in -mm which might be from elena.reshetova@intel.com are

ipc-convert-ipc_namespacecount-from-atomic_t-to-refcount_t.patch
ipc-convert-sem_undo_listrefcnt-from-atomic_t-to-refcount_t.patch
ipc-convert-kern_ipc_permrefcount-from-atomic_t-to-refcount_t.patch

