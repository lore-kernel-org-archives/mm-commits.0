From: akpm@linux-foundation.org
Subject: + futex_compat-simplify-pointer-magic.patch added to -mm tree
Date: Mon, 10 Sep 2007 12:31:40 -0700
Message-ID: <200709101931.l8AJVeda006955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760958AbXIJTcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 15:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     futex_compat: simplify pointer magic
has been added to the -mm tree.  Its filename is
     futex_compat-simplify-pointer-magic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: futex_compat: simplify pointer magic
From: Arnd Bergmann <arnd@arndb.de>

The futex_compat code currently mixes pointers to robust_list and
compat_robust_list for no apparent reason other than requiring extra
typecasts.  It also uses an extra argument to fetch_robust_entry() that is not
useful but has caused bugs to be introduced before.

Clean up the code to get rid of all this and make the compat version look more
like the native one.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex_compat.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff -puN kernel/futex_compat.c~futex_compat-simplify-pointer-magic kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex_compat-simplify-pointer-magic
+++ a/kernel/futex_compat.c
@@ -16,15 +16,17 @@
 /*
  * Fetch a robust-list pointer. Bit 0 signals PI futexes:
  */
-static inline int
-fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, int *pi)
+static inline int fetch_robust_entry(struct compat_robust_list __user **entry,
+				     compat_uptr_t __user *head,
+				     unsigned int *pi)
 {
-	if (get_user(*uentry, head))
+	compat_uptr_t uentry;
+
+	if (get_user(uentry, head))
 		return -EFAULT;
 
-	*entry = compat_ptr((*uentry) & ~1);
-	*pi = (unsigned int)(*uentry) & 1;
+	*entry = compat_ptr((uentry) & ~1);
+	*pi = (unsigned int)(uentry) & 1;
 
 	return 0;
 }
@@ -38,16 +40,16 @@ fetch_robust_entry(compat_uptr_t *uentry
 void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
-	struct robust_list __user *entry, *pending;
+	struct compat_robust_list __user *entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	compat_uptr_t uentry, upending;
+
 	compat_long_t futex_offset;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
 	 */
-	if (fetch_robust_entry(&uentry, &entry, &head->list.next, &pi))
+	if (fetch_robust_entry(&entry, &head->list.next, &pi))
 		return;
 	/*
 	 * Fetch the relative futex offset:
@@ -58,13 +60,12 @@ void compat_exit_robust_list(struct task
 	 * Fetch any possibly pending lock-add first, and handle it
 	 * if it exists:
 	 */
-	if (fetch_robust_entry(&upending, &pending,
-			       &head->list_op_pending, &pip))
+	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
 	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (entry != (struct robust_list __user *) &head->list) {
+	while (entry != &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
@@ -73,12 +74,10 @@ void compat_exit_robust_list(struct task
 			if (handle_futex_death((void __user *)entry + futex_offset,
 						curr, pi))
 				return;
-
 		/*
 		 * Fetch the next entry in the list:
 		 */
-		if (fetch_robust_entry(&uentry, &entry,
-				       (compat_uptr_t __user *)&entry->next, &pi))
+		if (fetch_robust_entry(&entry, &entry->next, &pi))
 			return;
 		/*
 		 * Avoid excessively long or circular lists:
_

Patches currently in -mm which might be from arnd@arndb.de are

futex_compat-fix-list-traversal-bugs.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
whitespace-fixes-compat-syscalls.patch
