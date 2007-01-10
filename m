From: akpm@osdl.org
Subject: - paravirt-vmi-backend-for-paravirt-ops-native-fix.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:12 -0800
Message-ID: <200701102303.l0AN3CKl010796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965252AbXAJXDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Vmi: native fix
has been removed from the -mm tree.  Its filename was
     paravirt-vmi-backend-for-paravirt-ops-native-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Vmi: native fix
From: Zachary Amsden <zach@vmware.com>

In paravirt builds with VMI compiled in, vmi_bringup is called
unconditionally, not via a paravirt-ops table (as no other hypervisor uses the
APIC startup technique).  Make the calls to setup VMI state conditional on the
presence of the VMI ROM.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-native-fix arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt-vmi-backend-for-paravirt-ops-native-fix
+++ a/arch/i386/kernel/vmi.c
@@ -630,7 +630,8 @@ static inline int __init probe_vmi_rom(v
 void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
-	vmi_ops.set_linear_mapping(0, __PAGE_OFFSET, max_low_pfn, 0);
+	if (vmi_rom)
+		vmi_ops.set_linear_mapping(0, __PAGE_OFFSET, max_low_pfn, 0);
 }
 
 /*
_

Patches currently in -mm which might be from zach@vmware.com are

vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
