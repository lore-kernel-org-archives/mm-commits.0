From: akpm@linux-foundation.org
Subject: - x86-use-explicit-copy-in-vdso_gettimeofday.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:22 -0700
Message-ID: <200805270728.m4R7SMkP014937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596AbYE0Hgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: use explicit copy in vdso_gettimeofday()
has been removed from the -mm tree.  Its filename was
     x86-use-explicit-copy-in-vdso_gettimeofday.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use explicit copy in vdso_gettimeofday()
From: Andi Kleen <andi@firstfloor.org>

Jeremy's gcc 3.4 seems to be unable to inline a 8 byte memcpy.  But the
vdso doesn't support external references.  Copy the structure members
of struct timezone explicitely instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vclock_gettime.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/vdso/vclock_gettime.c~x86-use-explicit-copy-in-vdso_gettimeofday arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~x86-use-explicit-copy-in-vdso_gettimeofday
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -106,9 +106,9 @@ int __vdso_gettimeofday(struct timeval *
 		do_realtime((struct timespec *)tv);
 		tv->tv_usec /= 1000;
 		if (unlikely(tz != NULL)) {
-			/* This relies on gcc inlining the memcpy. We'll notice
-			   if it ever fails to do so. */
-			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));
+			/* Avoid memcpy. Some old compilers fail to inline it */
+			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 		}
 		return 0;
 	}
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
gcov-architecture-specific-compile-flag-adjustments.patch
profile-likely-unlikely-macros.patch

