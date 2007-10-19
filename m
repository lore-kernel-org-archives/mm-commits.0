From: akpm@linux-foundation.org
Subject: - mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:14 -0700
Message-ID: <200710192251.l9JMpEnM024167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765217AbXJSXF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each
+++ a/mm/oom_kill.c
@@ -337,7 +337,6 @@ static int oom_kill_process(struct task_
 			    unsigned long points, const char *message)
 {
 	struct task_struct *c;
-	struct list_head *tsk;
 
 	if (printk_ratelimit()) {
 		printk(KERN_WARNING "%s invoked oom-killer: "
@@ -360,8 +359,7 @@ static int oom_kill_process(struct task_
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

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ftdi-elan-driver-convert-ftdi-u132_lock-to-mutex.patch
