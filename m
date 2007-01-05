From: akpm@osdl.org
Subject: + paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch added to -mm tree
Date: Thu, 04 Jan 2007 20:46:51 -0800
Message-ID: <200701050446.l054koQj009702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52903 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030322AbXAEEr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 23:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     Vmi: initialize fs for smp
has been added to the -mm tree.  Its filename is
     paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Vmi: initialize fs for smp
From: Zachary Amsden <zach@vmware.com>

Now that Jeremy's change to move the kernel PDA to %fs has arrived,
convert the AP processor setup for SMP to use FS instead of GS.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp
+++ a/arch/i386/kernel/vmi.c
@@ -518,8 +518,8 @@ vmi_startup_ipi_hook(int phys_apicid, un
 
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
-	ap.fs = 0;
-	ap.gs = __KERNEL_PDA;
+	ap.fs = __KERNEL_PDA;
+	ap.gs = 0;
 
 	ap.eflags = 0;
 
_

Patches currently in -mm which might be from zach@vmware.com are

convert-i386-pda-code-to-use-%fs.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch
paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch
paravirt-vmi-timer-patches.patch
vmi-native-fix.patch
vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
