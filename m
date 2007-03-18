From: akpm@linux-foundation.org
Subject: - fix-ktime_sec_max-on-32-bit.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:22 -0800
Message-ID: <200703180910.l2I9AMLj020084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60559 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXCRJLu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix MTIME_SEC_MAX on 32-bit
has been removed from the -mm tree.  Its filename was
     fix-ktime_sec_max-on-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix MTIME_SEC_MAX on 32-bit
From: Thomas Gleixner <tglx@linutronix.de>

The maximum seconds value we can handle on 32bit is LONG_MAX.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ktime.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/ktime.h~fix-ktime_sec_max-on-32-bit include/linux/ktime.h
--- a/include/linux/ktime.h~fix-ktime_sec_max-on-32-bit
+++ a/include/linux/ktime.h
@@ -57,7 +57,11 @@ typedef union {
 } ktime_t;
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#if (BITS_PER_LONG == 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
 
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
i386-trust-the-pm-timer-calibration-of-the-local-apic.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
