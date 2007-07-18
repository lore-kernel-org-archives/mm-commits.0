From: akpm@linux-foundation.org
Subject: + futex-pass-nr_wake2-to-futex_wake_op.patch added to -mm tree
Date: Tue, 17 Jul 2007 18:06:32 -0700
Message-ID: <200707180106.l6I16WUJ016843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763841AbXGRBHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 21:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwab@suse.de, drepper@redhat.com, mingo@elte.hu, stable@kernel.org


The patch titled
     futex: pass nr_wake2 to futex_wake_op
has been added to the -mm tree.  Its filename is
     futex-pass-nr_wake2-to-futex_wake_op.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: futex: pass nr_wake2 to futex_wake_op
From: Andreas Schwab <schwab@suse.de>

The fourth argument of sys_futex is ignored when op == FUTEX_WAKE_OP,
but futex_wake_op expects it as its nr_wake2 parameter.

The only user of this operation in glibc is always passing 1, so this
bug had no consequences so far.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/futex.c~futex-pass-nr_wake2-to-futex_wake_op kernel/futex.c
--- a/kernel/futex.c~futex-pass-nr_wake2-to-futex_wake_op
+++ a/kernel/futex.c
@@ -2060,8 +2060,10 @@ asmlinkage long sys_futex(u32 __user *ua
 	}
 	/*
 	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
_

Patches currently in -mm which might be from schwab@suse.de are

futex-pass-nr_wake2-to-futex_wake_op.patch
