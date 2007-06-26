From: akpm@linux-foundation.org
Subject: + i386-add-cpu_relax-to-cmos_lock.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:41:02 -0700
Message-ID: <200706262041.l5QKf2gA001710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbXFZUmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@lisas.de, ak@suse.de


The patch titled
     i386: add cpu_relax() to cmos_lock()
has been added to the -mm tree.  Its filename is
     i386-add-cpu_relax-to-cmos_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: add cpu_relax() to cmos_lock()
From: Andreas Mohr <andi@lisas.de>

Add cpu_relax() to cmos_lock() inline function for faster operation on SMT
CPUs and less power consumption on others in case of lock contention (which
probably doesn't happen too often, so admittedly this patch is not too
exciting).

Signed-off-by: Andreas Mohr <andi@lisas.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mc146818rtc.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/mc146818rtc.h~i386-add-cpu_relax-to-cmos_lock include/asm-i386/mc146818rtc.h
--- a/include/asm-i386/mc146818rtc.h~i386-add-cpu_relax-to-cmos_lock
+++ a/include/asm-i386/mc146818rtc.h
@@ -43,8 +43,10 @@ static inline void lock_cmos(unsigned ch
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
i386-add-cpu_relax-to-cmos_lock.patch
i386-add-cpu_relax-to-cmos_lock-fix.patch
