From: akpm@osdl.org
Subject: - paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:10 -0800
Message-ID: <200701102303.l0AN3A5b010793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965257AbXAJXDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Vmi: initialize fs for smp
has been removed from the -mm tree.  Its filename was
     paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
