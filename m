From: akpm@osdl.org
Subject: - paravirt-iopl-handling-for-paravirt-guests.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:59 -0800
Message-ID: <200701102302.l0AN2xPJ010781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965253AbXAJXDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     paravirt: iOPL handling for paravirt guests
has been removed from the -mm tree.  Its filename was
     paravirt-iopl-handling-for-paravirt-guests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -670,6 +670,15 @@ struct task_struct fastcall * __switch_t
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

vmi-versus-hrtimers.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
