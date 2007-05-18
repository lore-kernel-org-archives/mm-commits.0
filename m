From: akpm@linux-foundation.org
Subject: - let-smp_call_function_single-return-ebusy-on-up.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:13 -0700
Message-ID: <200705180706.l4I76CrY010160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbXERH3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Let smp_call_function_single return -EBUSY on UP
has been removed from the -mm tree.  Its filename was
     let-smp_call_function_single-return-ebusy-on-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Let smp_call_function_single return -EBUSY on UP
From: Heiko Carstens <heiko.carstens@de.ibm.com>

All architectures that have an implementation of smp_call_function_single
let it return -EBUSY if it is asked to execute func on the current cpu. 
(akpm: except for x86_64).  Therefore the UP version must always return
-EBUSY.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/smp.h~let-smp_call_function_single-return-ebusy-on-up include/linux/smp.h
--- a/include/linux/smp.h~let-smp_call_function_single-return-ebusy-on-up
+++ a/include/linux/smp.h
@@ -6,6 +6,7 @@
  *		Alan Cox. <alan@redhat.com>
  */
 
+#include <linux/errno.h>
 
 extern void cpu_idle(void);
 
@@ -99,11 +100,9 @@ static inline void smp_send_reschedule(i
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
 static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
-				void *info, int retry, int wait)
+					   void *info, int retry, int wait)
 {
-	/* Disable interrupts here? */
-	func(info);
-	return 0;
+	return -EBUSY;
 }
 
 #endif /* !SMP */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-spinlock-initializer-cleanup.patch
x86_64-fix-smp_call_function_single-return-value.patch
