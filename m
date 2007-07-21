From: akpm@linux-foundation.org
Subject: + fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:07:58 -0700
Message-ID: <200707210007.l6L07w7T023481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbXGUAIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     fs/eventpoll.c: use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/eventpoll.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/eventpoll.c: use list_for_each_entry() instead of list_for_each()
in ep_poll_safewake()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each fs/eventpoll.c
--- a/fs/eventpoll.c~fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/eventpoll.c
@@ -325,15 +325,14 @@ static void ep_poll_safewake(struct poll
 	int wake_nests = 0;
 	unsigned long flags;
 	struct task_struct *this_task = current;
-	struct list_head *lsthead = &psw->wake_task_list, *lnk;
+	struct list_head *lsthead = &psw->wake_task_list;
 	struct wake_task_node *tncur;
 	struct wake_task_node tnode;
 
 	spin_lock_irqsave(&psw->lock, flags);
 
 	/* Try to see if the current task is already inside this wakeup call */
-	list_for_each(lnk, lsthead) {
-		tncur = list_entry(lnk, struct wake_task_node, llink);
+	list_for_each_entry(tncur, lsthead, llink) {
 
 		if (tncur->wq == wq ||
 		    (tncur->task == this_task && ++wake_nests > EP_MAX_POLLWAKE_NESTS)) {
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
