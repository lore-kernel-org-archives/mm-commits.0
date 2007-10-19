From: akpm@linux-foundation.org
Subject: - kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:10 -0700
Message-ID: <200710192251.l9JMpARc024161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966659AbXJSXFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/exit.c: Use list_for_each_entry(_safe) instead of list_for_each(_safe)
has been removed from the -mm tree.  Its filename was
     kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 6 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe
+++ a/kernel/exit.c
@@ -669,8 +669,7 @@ reparent_thread(struct task_struct *p, s
 static void
 forget_original_parent(struct task_struct *father, struct list_head *to_release)
 {
-	struct task_struct *p, *reaper = father;
-	struct list_head *_p, *_n;
+	struct task_struct *p, *n, *reaper = father;
 
 	do {
 		reaper = next_thread(reaper);
@@ -688,9 +687,8 @@ forget_original_parent(struct task_struc
 	 *
 	 * Search them and reparent children.
 	 */
-	list_for_each_safe(_p, _n, &father->children) {
+	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		int ptrace;
-		p = list_entry(_p, struct task_struct, sibling);
 
 		ptrace = p->ptrace;
 
@@ -718,8 +716,7 @@ forget_original_parent(struct task_struc
 		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
 			list_add(&p->ptrace_list, to_release);
 	}
-	list_for_each_safe(_p, _n, &father->ptrace_children) {
-		p = list_entry(_p, struct task_struct, ptrace_list);
+	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		p->real_parent = reaper;
 		reparent_thread(p, father, 1);
 	}
@@ -1518,12 +1515,9 @@ repeat:
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
@@ -1605,9 +1599,8 @@ check_continued:
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

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
