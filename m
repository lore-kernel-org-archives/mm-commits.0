From: akpm@linux-foundation.org
Subject: + fix-compat-futex-code-for-private-futexes.patch added to -mm tree
Date: Tue, 29 May 2007 15:36:09 -0700
Message-ID: <200705292236.l4TMa9fu013334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXE2Whi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, dada1@cosmosbay.com, mingo@elte.hu


The patch titled
     fix compat futex code for private futexes
has been added to the -mm tree.  Its filename is
     fix-compat-futex-code-for-private-futexes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix compat futex code for private futexes
From: Ulrich Drepper <drepper@redhat.com>

When the private futex support was added the compat code wasn't changed. 
The result is that code using compat code which fail, e.g., because the
timeout values are not correctly passed.  The following patch should fix
that.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex_compat.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/futex_compat.c~fix-compat-futex-code-for-private-futexes kernel/futex_compat.c
--- a/kernel/futex_compat.c~fix-compat-futex-code-for-private-futexes
+++ a/kernel/futex_compat.c
@@ -144,20 +144,21 @@ asmlinkage long compat_sys_futex(u32 __u
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
 	int val2 = 0;
+	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
 		t = timespec_to_ktime(ts);
-		if (op == FUTEX_WAIT)
+		if (cmd == FUTEX_WAIT)
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
+	    || cmd == FUTEX_CMP_REQUEUE_PI)
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
_

Patches currently in -mm which might be from drepper@redhat.com are

fix-compat-futex-code-for-private-futexes.patch
