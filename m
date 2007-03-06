From: akpm@linux-foundation.org
Subject: - bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch removed from -mm tree
Date: Mon, 05 Mar 2007 21:09:25 -0800
Message-ID: <200703060509.l2659PbQ012599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXCFFM7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guichaz@gmail.com, guichaz@yahoo.fr, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Bugfix: Don't use the TSC in sched_clock if unstable
has been removed from the -mm tree.  Its filename was
     bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Bugfix: Don't use the TSC in sched_clock if unstable
From: "Guillaume Chazarain" <guichaz@gmail.com>

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f9690982b8c2f9a2c65acdc113e758ec356676a3
caused a regression by letting sched_clock use the TSC even when cpufreq
disabled it. This caused scheduling weirdnesses.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/tsc.c~bugfix-dont-use-the-tsc-in-sched_clock-if-unstable arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~bugfix-dont-use-the-tsc-in-sched_clock-if-unstable
+++ a/arch/i386/kernel/tsc.c
@@ -105,7 +105,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (unlikely(tsc_disable))
+	if (tsc_unstable || unlikely(tsc_disable))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
_

Patches currently in -mm which might be from guichaz@gmail.com are

bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
