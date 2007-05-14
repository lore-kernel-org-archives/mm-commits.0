From: akpm@linux-foundation.org
Subject: + let-smp_call_function_single-return-ebusy-on-up.patch added to -mm tree
Date: Mon, 14 May 2007 12:12:45 -0700
Message-ID: <200705141912.l4EJCjHH023880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXENTNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, ak@suse.de


The patch titled
     Let smp_call_function_single return -EBUSY on UP
has been added to the -mm tree.  Its filename is
     let-smp_call_function_single-return-ebusy-on-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Let smp_call_function_single return -EBUSY on UP
From: Heiko Carstens <heiko.carstens@de.ibm.com>

All architectures that have an implementation of smp_call_function_single
let it return -EBUSY if it is asked to execute func on the current cpu. 
(akpm: except for x86_64).  Therefore the UP version must always return
-EBUSY.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/smp.h~let-smp_call_function_single-return-ebusy-on-up include/linux/smp.h
--- a/include/linux/smp.h~let-smp_call_function_single-return-ebusy-on-up
+++ a/include/linux/smp.h
@@ -99,11 +99,9 @@ static inline void smp_send_reschedule(i
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

s390-spinlock-initializer-cleanup.patch
simplify-compat_sys_timerfd.patch
let-smp_call_function_single-return-ebusy-on-up.patch
