From: akpm@osdl.org
Subject: + paravirt-vmi-backend-for-paravirt-ops-native-fix.patch added to -mm tree
Date: Thu, 04 Jan 2007 20:47:45 -0800
Message-ID: <200701050447.l054lilI009720@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXAEEsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 23:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     Vmi: native fix
has been added to the -mm tree.  Its filename is
     paravirt-vmi-backend-for-paravirt-ops-native-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

convert-i386-pda-code-to-use-%fs.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-backend-for-paravirt-ops-compile-fix.patch
paravirt-vmi-backend-for-paravirt-ops-initialize-fs-for-smp.patch
paravirt-vmi-backend-for-paravirt-ops-native-fix.patch
paravirt-vmi-timer-patches.patch
vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
