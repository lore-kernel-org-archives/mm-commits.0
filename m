From: akpm@osdl.org
Subject: - paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:08 -0800
Message-ID: <200701102303.l0AN380d010790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965266AbXAJXDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Vmi compile fix
has been removed from the -mm tree.  Its filename was
     paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
