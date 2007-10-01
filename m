From: akpm@linux-foundation.org
Subject: - futex_compat-update-to-match-native-version.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:08:38 -0700
Message-ID: <200710010708.l9178cgj004307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbXJAHJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, davem@davemloft.net, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     futex_compat: update to match native version
has been removed from the -mm tree.  Its filename was
     futex_compat-update-to-match-native-version.patch

This patch was dropped because of rejects against mainline

------------------------------------------------------
Subject: futex_compat: update to match native version
From: Arnd Bergmann <arnd@arndb.de>

A few changes have gone into the futex code but not into the futex_compat
code, the most significant one being a fix for FUTEX_WAKE_OP in commit
f54f098612d7f86463b5fb4763d03533d634de73.

This brings both versions in sync again.

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@kernel.org>
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

futex_compat-update-to-match-native-version.patch
whitespace-fixes-compat-syscalls.patch
