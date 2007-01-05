From: akpm@osdl.org
Subject: + paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch added to -mm tree
Date: Thu, 04 Jan 2007 20:45:43 -0800
Message-ID: <200701050445.l054jgGg009688@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312AbXAEEqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 23:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     Vmi compile fix
has been added to the -mm tree.  Its filename is
     paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Vmi compile fix
From: Zachary Amsden <zach@vmware.com>

The variable no_timer_check does not exist in UP builds; don't try to
set it in the vmi init code.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-compile-fix arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-compile-fix
+++ a/arch/i386/kernel/vmi.c
@@ -868,7 +868,9 @@ void __init vmi_init(void)
 
 	local_irq_save(flags);
 	activate_vmi();
+#ifdef CONFIG_SMP
 	no_timer_check = 1;
+#endif
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
 
_

Patches currently in -mm which might be from zach@vmware.com are

convert-i386-pda-code-to-use-%fs.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch
paravirt-vmi-timer-patches.patch
vmi-initialize-fs-for-smp.patch
vmi-native-fix.patch
vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
