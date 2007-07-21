From: akpm@linux-foundation.org
Subject: + fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:08:04 -0700
Message-ID: <200707210008.l6L084pq023496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbXGUAIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     fs/locks.c: use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/locks.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/locks.c: use list_for_each_entry() instead of list_for_each() in
posix_locks_deadlock() and get_locks_status()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/locks.c~fs-locksc-use-list_for_each_entry-instead-of-list_for_each fs/locks.c
--- a/fs/locks.c~fs-locksc-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/locks.c
@@ -698,13 +698,12 @@ EXPORT_SYMBOL(posix_test_lock);
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
-	struct list_head *tmp;
+	struct file_lock *fl;
 
 next_task:
 	if (posix_same_owner(caller_fl, block_fl))
 		return 1;
-	list_for_each(tmp, &blocked_list) {
-		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
+	list_for_each_entry(fl, &blocked_list, fl_link) {
 		if (posix_same_owner(fl, block_fl)) {
 			fl = fl->fl_next;
 			block_fl = fl;
@@ -2161,24 +2160,22 @@ static void move_lock_status(char **p, o
 
 int get_locks_status(char *buffer, char **start, off_t offset, int length)
 {
-	struct list_head *tmp;
+	struct file_lock *fl;
 	char *q = buffer;
 	off_t pos = 0;
 	int i = 0;
 
 	lock_kernel();
-	list_for_each(tmp, &file_lock_list) {
-		struct list_head *btmp;
-		struct file_lock *fl = list_entry(tmp, struct file_lock, fl_link);
+	list_for_each_entry(fl, &file_lock_list, fl_link) {
+		struct file_lock *bfl;
+
 		lock_get_status(q, fl, ++i, "");
 		move_lock_status(&q, &pos, offset);
 
 		if(pos >= offset+length)
 			goto done;
 
-		list_for_each(btmp, &fl->fl_block) {
-			struct file_lock *bfl = list_entry(btmp,
-					struct file_lock, fl_block);
+		list_for_each_entry(bfl, &fl->fl_block, fl_block) {
 			lock_get_status(q, bfl, i, " ->");
 			move_lock_status(&q, &pos, offset);
 
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
