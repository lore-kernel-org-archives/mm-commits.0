From: akpm@osdl.org
Subject: - i386-sched_clock-using-init-data-tsc_disable-fix.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:17:55 -0800
Message-ID: <200701122217.l0CMHtQe030760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39119 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153AbXALWS4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: sched_clock using init data tsc_disable fix
has been removed from the -mm tree.  Its filename was
     i386-sched_clock-using-init-data-tsc_disable-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: sched_clock using init data tsc_disable fix
From: Vivek Goyal <vgoyal@in.ibm.com>

o sched_clock() a non-init function is using init data tsc_disable. This
  is flagged by MODPOST on i386 if CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.data:tsc_disable from .text between 'sched_clock' (at offset 0xc0109d58) and 'tsc_update_callback'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/tsc.c~i386-sched_clock-using-init-data-tsc_disable-fix arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~i386-sched_clock-using-init-data-tsc_disable-fix
+++ a/arch/i386/kernel/tsc.c
@@ -24,7 +24,7 @@
  */
 unsigned int tsc_khz;
 
-int tsc_disable __cpuinitdata = 0;
+int tsc_disable;
 
 #ifdef CONFIG_X86_TSC
 static int __init tsc_setup(char *str)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
