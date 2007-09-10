From: akpm@linux-foundation.org
Subject: + futex_compat-update-to-match-native-version.patch added to -mm tree
Date: Mon, 10 Sep 2007 12:31:42 -0700
Message-ID: <200709101931.l8AJVgbt006958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859AbXIJTbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 15:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     futex_compat: update to match native version
has been added to the -mm tree.  Its filename is
     futex_compat-update-to-match-native-version.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: futex_compat: update to match native version
From: Arnd Bergmann <arnd@arndb.de>

A few changes have gone into the futex code but not into the futex_compat
code, the most significant one being a fix for FUTEX_WAKE_OP in commit
f54f098612d7f86463b5fb4763d03533d634de73.

This brings both versions in sync again.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex_compat.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN kernel/futex_compat.c~futex_compat-update-to-match-native-version kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex_compat-update-to-match-native-version
+++ a/kernel/futex_compat.c
@@ -62,8 +62,10 @@ void compat_exit_robust_list(struct task
 	 */
 	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
+
 	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 
 	while (entry != &head->list) {
 		/*
@@ -142,7 +144,7 @@ asmlinkage long compat_sys_futex(u32 __u
 {
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
-	int val2 = 0;
+	u32 val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
@@ -156,8 +158,13 @@ asmlinkage long compat_sys_futex(u32 __u
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
-		val2 = (int) (unsigned long) utime;
+	/*
+	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
+	 */
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_WAKE_OP)
+		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

futex_compat-fix-list-traversal-bugs.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
whitespace-fixes-compat-syscalls.patch
