From: akpm@linux-foundation.org
Subject: - robust-futex-thread-exit-race.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:54:59 -0700
Message-ID: <200710022254.l92MsxeP026751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbXJBWz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     robust futex thread exit race
has been removed from the -mm tree.  Its filename was
     robust-futex-thread-exit-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: robust futex thread exit race
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Calling handle_futex_death in exit_robust_list for the different robust
mutexes of a thread basically frees the mutex.  Another thread might grab
the lock immediately which updates the next pointer of the mutex. 
fetch_robust_entry over the next pointer might therefore branch into the
robust mutex list of a different thread.  This can cause two problems: 1)
some mutexes held by the dead thread are not getting freed and 2) some
mutexs held by a different thread are freed.

The next point need to be read before calling handle_futex_death.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c        |   26 ++++++++++++++++----------
 kernel/futex_compat.c |   28 ++++++++++++++++++----------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff -puN kernel/futex.c~robust-futex-thread-exit-race kernel/futex.c
--- a/kernel/futex.c~robust-futex-thread-exit-race
+++ a/kernel/futex.c
@@ -1943,9 +1943,10 @@ static inline int fetch_robust_entry(str
 void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
-	struct robust_list __user *entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	struct robust_list __user *entry, *next_entry, *pending;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
 	unsigned long futex_offset;
+	int rc;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
@@ -1965,12 +1966,14 @@ void exit_robust_list(struct task_struct
 	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
 
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
-
+	next_entry = NULL;	/* avoid warning with gcc */
 	while (entry != &head->list) {
 		/*
+		 * Fetch the next entry in the list before calling
+		 * handle_futex_death:
+		 */
+		rc = fetch_robust_entry(&next_entry, &entry->next, &next_pi);
+		/*
 		 * A pending lock might already be on the list, so
 		 * don't process it twice:
 		 */
@@ -1978,11 +1981,10 @@ void exit_robust_list(struct task_struct
 			if (handle_futex_death((void __user *)entry + futex_offset,
 						curr, pi))
 				return;
-		/*
-		 * Fetch the next entry in the list:
-		 */
-		if (fetch_robust_entry(&entry, &entry->next, &pi))
+		if (rc)
 			return;
+		entry = next_entry;
+		pi = next_pi;
 		/*
 		 * Avoid excessively long or circular lists:
 		 */
@@ -1991,6 +1993,10 @@ void exit_robust_list(struct task_struct
 
 		cond_resched();
 	}
+
+	if (pending)
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
diff -puN kernel/futex_compat.c~robust-futex-thread-exit-race kernel/futex_compat.c
--- a/kernel/futex_compat.c~robust-futex-thread-exit-race
+++ a/kernel/futex_compat.c
@@ -38,10 +38,11 @@ fetch_robust_entry(compat_uptr_t *uentry
 void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
-	struct robust_list __user *entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	compat_uptr_t uentry, upending;
+	struct robust_list __user *entry, *next_entry, *pending;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	compat_uptr_t uentry, next_uentry, upending;
 	compat_long_t futex_offset;
+	int rc;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
@@ -61,11 +62,16 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
+	next_entry = NULL;	/* avoid warning with gcc */
 	while (entry != (struct robust_list __user *) &head->list) {
 		/*
+		 * Fetch the next entry in the list before calling
+		 * handle_futex_death:
+		 */
+		rc = fetch_robust_entry(&next_uentry, &next_entry,
+			(compat_uptr_t __user *)&entry->next, &next_pi);
+		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
 		 */
@@ -74,12 +80,11 @@ void compat_exit_robust_list(struct task
 						curr, pi))
 				return;
 
-		/*
-		 * Fetch the next entry in the list:
-		 */
-		if (fetch_robust_entry(&uentry, &entry,
-				       (compat_uptr_t __user *)&entry->next, &pi))
+		if (rc)
 			return;
+		uentry = next_uentry;
+		entry = next_entry;
+		pi = next_pi;
 		/*
 		 * Avoid excessively long or circular lists:
 		 */
@@ -88,6 +93,9 @@ void compat_exit_robust_list(struct task
 
 		cond_resched();
 	}
+	if (pending)
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 }
 
 asmlinkage long
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

git-s390.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-mm_struct-and-vm_area_struct.patch
move-mm_struct-and-vm_area_struct-fix.patch
unicode-diacritics-support-s390-fix.patch
bitops-introduce-lock-ops.patch
