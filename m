From: akpm@linux-foundation.org
Subject: - cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:50 -0800
Message-ID: <200711152111.lAFLBoci015799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759543AbXKOVRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: fixes in arch/cris/kernel/time.c
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: fixes in arch/cris/kernel/time.c
From: Jesper Nilsson <jesper.nilsson@axis.com>

- Remove debug print.
- Change #if to #ifdef to avoid compile time warning if CONFIG_PROFILING
  isn't set.
- Number of parameters to profile_tick has changed, drop the regs parameter.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/time.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/cris/kernel/time.c~cris-build-fixes-fixes-in-arch-cris-kernel-timec arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~cris-build-fixes-fixes-in-arch-cris-kernel-timec
+++ a/arch/cris/kernel/time.c
@@ -171,10 +171,6 @@ get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	printk(KERN_DEBUG
-	       "rtc: sec 0x%x min 0x%x hour 0x%x day 0x%x mon 0x%x year 0x%x\n",
-	       sec, min, hour, day, mon, year);
-
 	BCD_TO_BIN(sec);
 	BCD_TO_BIN(min);
 	BCD_TO_BIN(hour);
@@ -207,12 +203,12 @@ void
 cris_do_profile(struct pt_regs* regs)
 {
 
-#if CONFIG_SYSTEM_PROFILER
+#ifdef CONFIG_SYSTEM_PROFILER
         cris_profile_sample(regs);
 #endif
 
-#if CONFIG_PROFILING
-        profile_tick(CPU_PROFILING, regs);
+#ifdef CONFIG_PROFILING
+        profile_tick(CPU_PROFILING);
 #endif
 }
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
