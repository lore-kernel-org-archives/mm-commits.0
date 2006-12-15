From: akpm@osdl.org
Subject: + paravirt-iopl-handling-for-paravirt-guests.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:27:17 -0800
Message-ID: <200612152227.kBFMRHgW002968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50236 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231AbWLOW1y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     paravirt: iOPL handling for paravirt guests
has been added to the -mm tree.  Its filename is
     paravirt-iopl-handling-for-paravirt-guests.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt: iOPL handling for paravirt guests
From: Zachary Amsden <zach@vmware.com>

I found a clever way to make the extra IOPL switching invisible to
non-paravirt compiles - since kernel_rpl is statically defined to be zero
there, and only non-zero rpl kernel have a problem restoring IOPL, as popf
does not restore IOPL flags unless run at CPL-0.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/process.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN arch/i386/kernel/process.c~paravirt-iopl-handling-for-paravirt-guests arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~paravirt-iopl-handling-for-paravirt-guests
+++ a/arch/i386/kernel/process.c
@@ -665,6 +665,15 @@ struct task_struct fastcall * __switch_t
 	load_TLS(next, cpu);
 
 	/*
+	 * Restore IOPL if needed.  In normal use, the flags restore
+	 * in the switch assembly will handle this.  But if the kernel
+	 * is running virtualized at a non-zero CPL, the popf will
+	 * not restore flags, so it must be done in a separate step.
+	 */
+	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
+		set_iopl_mask(next->iopl);
+
+	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
_

Patches currently in -mm which might be from zach@vmware.com are

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-timer-patches.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch

