From: akpm@linux-foundation.org
Subject: - arch-alpha-kernel-trapsc-use-time_-macros.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:32 -0700
Message-ID: <200804282154.m3SLsW0U018016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567AbYD1Vy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     arch/alpha/kernel/traps.c: use time_* macros
has been removed from the -mm tree.  Its filename was
     arch-alpha-kernel-trapsc-use-time_-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/alpha/kernel/traps.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So implement usage of the time_after() macro, defined in linux/jiffies.h,
which deals with wrapping correctly

[akpm@linux-foundation.org: fix warning]
Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/alpha/kernel/traps.c~arch-alpha-kernel-trapsc-use-time_-macros arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c~arch-alpha-kernel-trapsc-use-time_-macros
+++ a/arch/alpha/kernel/traps.c
@@ -8,6 +8,7 @@
  * This file initializes the trap entry points
  */
 
+#include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -770,7 +771,7 @@ do_entUnaUser(void __user * va, unsigned
 	      unsigned long reg, struct pt_regs *regs)
 {
 	static int cnt = 0;
-	static long last_time = 0;
+	static unsigned long last_time;
 
 	unsigned long tmp1, tmp2, tmp3, tmp4;
 	unsigned long fake_reg, *reg_addr = &fake_reg;
@@ -781,7 +782,7 @@ do_entUnaUser(void __user * va, unsigned
 	   with the unaliged access.  */
 
 	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
-		if (cnt >= 5 && jiffies - last_time > 5*HZ) {
+		if (cnt >= 5 && time_after(jiffies, last_time + 5 * HZ)) {
 			cnt = 0;
 		}
 		if (++cnt < 5) {
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

origin.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch

