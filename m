From: akpm@linux-foundation.org
Subject: + cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:12:37 -0700
Message-ID: <200710302212.l9UMCbjV030493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbXJ3WMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: fixes in arch/cris/kernel/time.c
has been added to the -mm tree.  Its filename is
     cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
