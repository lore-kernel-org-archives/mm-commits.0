From: akpm@linux-foundation.org
Subject: + sys_futex64-allows-64bit-futexes-fix.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:42:21 -0700
Message-ID: <200703262142.l2QLgQJC031281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXCZVmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Pierre.Peiffer@bull.net, drepper@redhat.com, mingo@elte.hu, pierre.peiffer@bull.net, sebastien.dugue@bull.net


The patch titled
     Fix: timeout not passed anymore to futex_lock_pi
has been added to the -mm tree.  Its filename is
     sys_futex64-allows-64bit-futexes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix: timeout not passed anymore to futex_lock_pi
From: Pierre Peiffer <Pierre.Peiffer@bull.net>

This is a fix for a bug introduced by the patch
make-futex_wait-use-an-hrtimer-for-timeout.patch : the timeout value
is not passed anymore to futex_lock_pi.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/futex.c~sys_futex64-allows-64bit-futexes-fix kernel/futex.c
--- a/kernel/futex.c~sys_futex64-allows-64bit-futexes-fix
+++ a/kernel/futex.c
@@ -2383,8 +2383,10 @@ sys_futex64(u64 __user *uaddr, int op, u
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
 		if (op == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	/*
_

Patches currently in -mm which might be from Pierre.Peiffer@bull.net are

make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
sys_futex64-allows-64bit-futexes-fix.patch
