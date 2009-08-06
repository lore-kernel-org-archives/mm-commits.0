From: akpm@linux-foundation.org
Subject: [obsolete] arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:38:47 -0700
Message-ID: <200908062338.n76NclFK028676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbZHFXjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.chong.tan@intel.com, arjan@linux.intel.com, johnstul@us.ibm.com, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/tsc.c: SMI workaround for pit_expect_msb()
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/tsc.c: SMI workaround for pit_expect_msb()
From: Wei Chong Tan <wei.chong.tan@intel.com>

pit_expect_msb() seems to be vulnerable to SMI disturbance corner case in
some platforms which causes /proc/cpuinfo to show wrong CPU MHz value when
quick_pit_calibrate() jump to success section.

This patch tries to minimize such cases by rejecting them so that other
calibration method is utilized.

Initial trial shows that out of 300 reboot cycles, 18 uses
quick_pit_calibrate() successfully and /proc/cpuinfo shows reasonable CPU
MHz.  Without the patch, 1 out of roughly 20 reboot cycles may show wrong
MHz value.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Wei Chong Tan <wei.chong.tan@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tsc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN arch/x86/kernel/tsc.c~arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb
+++ a/arch/x86/kernel/tsc.c
@@ -285,10 +285,29 @@ static inline int pit_expect_msb(unsigne
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
+		/*
+		 * What if an SMI kicks in here when count is just slightly over
+		 * 5 and the SMI run long enough so that PIT MSB value is way
+		 * bigger then val?
+		 * Then tscp will have an unreasonably large value, since the
+		 * code has no notion of how much inb(0x42) MSB is bigger than
+		 * val when it return from SMI.
+		 * In addition, since the 2 get_cycles() are near, deltap may
+		 * get a sane value.  If this happens on the final few readings
+		 * just before (d1+d2 < delta >> 11), this may skew the average
+		 * delta variable of quick_pit_calibrate().
+		 */
 		tsc = get_cycles();
 	}
 	*deltap = get_cycles() - tsc;
 	*tscp = tsc;
+	/* inb(0x42) will need to be separately repeated here as
+	 * the SMI may take so long that the old reading
+	 * is no longer reliable. inb(0x42) after all get_cycles is the safest.
+	 */
+	inb(0x42);
+	if (inb(0x42) < (val - 1))
+		return 0;
 
 	/*
 	 * We require _some_ success, but the quality control
_

Patches currently in -mm which might be from wei.chong.tan@intel.com are

arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb.patch

