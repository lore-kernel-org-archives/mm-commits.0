From: akpm@linux-foundation.org
Subject: + kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:32:56 -0700
Message-ID: <200707232132.l6NLWugk012928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbXGWVdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     kernel/exit.c: Use list_for_each_entry(_safe) instead of list_for_each(_safe)
has been added to the -mm tree.  Its filename is
     kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/exit.c: Use list_for_each_entry(_safe) instead of list_for_each(_safe)
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

kernel/exit.c: Convert list_for_each(_safe) to
list_for_each_entry(_safe) in forget_original_parent(), exit_notify()
and do_wait()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe
+++ a/kernel/exit.c
@@ -689,8 +689,7 @@ reparent_thread(struct task_struct *p, s
 static void
 forget_original_parent(struct task_struct *father, struct list_head *to_release)
 {
-	struct task_struct *p, *reaper = father;
-	struct list_head *_p, *_n;
+	struct task_struct *p, *n, *reaper = father;
 
 	do {
 		reaper = next_thread(reaper);
@@ -708,9 +707,8 @@ forget_original_parent(struct task_struc
 	 *
 	 * Search them and reparent children.
 	 */
-	list_for_each_safe(_p, _n, &father->children) {
+	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		int ptrace;
-		p = list_entry(_p, struct task_struct, sibling);
 
 		ptrace = p->ptrace;
 
@@ -738,8 +736,7 @@ forget_original_parent(struct task_struc
 		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
 			list_add(&p->ptrace_list, to_release);
 	}
-	list_for_each_safe(_p, _n, &father->ptrace_children) {
-		p = list_entry(_p, struct task_struct, ptrace_list);
+	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		choose_new_parent(p, reaper);
 		reparent_thread(p, father, 1);
 	}
@@ -1543,12 +1540,9 @@ repeat:
 	tsk = current;
 	do {
 		struct task_struct *p;
-		struct list_head *_p;
 		int ret;
 
-		list_for_each(_p,&tsk->children) {
-			p = list_entry(_p, struct task_struct, sibling);
-
+		list_for_each_entry(p, &tsk->children, sibling) {
 			ret = eligible_child(pid, options, p);
 			if (!ret)
 				continue;
@@ -1630,9 +1624,8 @@ check_continued:
 			}
 		}
 		if (!flag) {
-			list_for_each(_p, &tsk->ptrace_children) {
-				p = list_entry(_p, struct task_struct,
-						ptrace_list);
+			list_for_each_entry(p, &tsk->ptrace_children,
+					    ptrace_list) {
 				if (!eligible_child(pid, options, p))
 					continue;
 				flag = 1;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
