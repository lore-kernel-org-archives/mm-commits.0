From: akpm@linux-foundation.org
Subject: + mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:33:00 -0700
Message-ID: <200707232133.l6NLX0Di012934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbXGWVdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, nickpiggin@yahoo.com.au


The patch titled
     mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
has been added to the -mm tree.  Its filename is
     mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

mm/oom_kill.c: Convert list_for_each to list_for_each_entry in
oom_kill_process()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each
+++ a/mm/oom_kill.c
@@ -347,7 +347,6 @@ static int oom_kill_process(struct task_
 		const char *message)
 {
 	struct task_struct *c;
-	struct list_head *tsk;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -362,8 +361,7 @@ static int oom_kill_process(struct task_
 					message, p->pid, p->comm, points);
 
 	/* Try to kill a child first */
-	list_for_each(tsk, &p->children) {
-		c = list_entry(tsk, struct task_struct, sibling);
+	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
 		if (!oom_kill_task(c))
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
