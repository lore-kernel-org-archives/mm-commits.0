From: akpm@linux-foundation.org
Subject: - i386-add-cpu_relax-to-cmos_lock.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:17 -0700
Message-ID: <200707192010.l6JKAHlg020656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760650AbXGSUPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@lisas.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: add cpu_relax() to cmos_lock()
has been removed from the -mm tree.  Its filename was
     i386-add-cpu_relax-to-cmos_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: add cpu_relax() to cmos_lock()
From: Andreas Mohr <andi@lisas.de>

Add cpu_relax() to cmos_lock() inline function for faster operation on SMT
CPUs and less power consumption on others in case of lock contention (which
probably doesn't happen too often, so admittedly this patch is not too
exciting).

[akpm@linux-foundation.org: Include the header file for cpu_relax()]
Signed-off-by: Andreas Mohr <andi@lisas.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mc146818rtc.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/mc146818rtc.h~i386-add-cpu_relax-to-cmos_lock include/asm-i386/mc146818rtc.h
--- a/include/asm-i386/mc146818rtc.h~i386-add-cpu_relax-to-cmos_lock
+++ a/include/asm-i386/mc146818rtc.h
@@ -6,6 +6,7 @@
 
 #include <asm/io.h>
 #include <asm/system.h>
+#include <asm/processor.h>
 #include <linux/mc146818rtc.h>
 
 #ifndef RTC_PORT
@@ -43,8 +44,10 @@ static inline void lock_cmos(unsigned ch
 	unsigned long new;
 	new = ((smp_processor_id()+1) << 8) | reg;
 	for (;;) {
-		if (cmos_lock)
+		if (cmos_lock) {
+			cpu_relax();
 			continue;
+		}
 		if (__cmpxchg(&cmos_lock, 0, new, sizeof(cmos_lock)) == 0)
 			return;
 	}
_

Patches currently in -mm which might be from andi@lisas.de are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
