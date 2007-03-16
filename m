From: akpm@linux-foundation.org
Subject: + fix-ktime_sec_max-on-32-bit.patch added to -mm tree
Date: Fri, 16 Mar 2007 13:57:32 -0800
Message-ID: <200703162157.l2GLvWji022787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965981AbXCPV5j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 17:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     fix MTIME_SEC_MAX on 32-bit
has been added to the -mm tree.  Its filename is
     fix-ktime_sec_max-on-32-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch
hrtimer-fixup-unlocked-access-to-wall_to_monotonic.patch
futex-pi-state-locking-fix.patch
fix-ktime_sec_max-on-32-bit.patch
make-config_paravirt-require-no_hz.patch
paravirt-build-fixes.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
