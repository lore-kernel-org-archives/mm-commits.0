From: akpm@linux-foundation.org
Subject: - fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:54 -0700
Message-ID: <200710051958.l95JwsR0022586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762329AbXJEUBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/locks.c: use list_for_each_entry() instead of list_for_each()
has been removed from the -mm tree.  Its filename was
     fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/locks.c: use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/locks.c: use list_for_each_entry() instead of list_for_each() in
posix_locks_deadlock() and get_locks_status()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/locks.c~fs-locksc-use-list_for_each_entry-instead-of-list_for_each fs/locks.c
--- a/fs/locks.c~fs-locksc-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/locks.c
@@ -700,13 +700,12 @@ EXPORT_SYMBOL(posix_test_lock);
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
@@ -2170,24 +2169,22 @@ static void move_lock_status(char **p, o
 
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

git-alsa.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
git-dvb.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-sched.patch
git-scsi-misc.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
