From: akpm@linux-foundation.org
Subject: + fix-vmi-time-header-bug.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:24 -0800
Message-ID: <200703151848.l2FImQWV023243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXCOSsa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de


The patch titled
     Fix vmi time header bug
has been added to the -mm tree.  Its filename is
     fix-vmi-time-header-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix vmi time header bug
From: Zachary Amsden <zach@vmware.com>

Some gcc apparently put this function in .init.text because the header didn't
match.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/vmi_time.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/vmi_time.h~fix-vmi-time-header-bug include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~fix-vmi-time-header-bug
+++ a/include/asm-i386/vmi_time.h
@@ -54,7 +54,7 @@ extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
-extern void __init vmi_timer_setup_secondary_alarm(void);
+extern void __devinit vmi_timer_setup_secondary_alarm(void);
 extern void apic_vmi_timer_interrupt(void);
 #endif
 
_

Patches currently in -mm which might be from zach@vmware.com are

fix-vmi-time-header-bug.patch
paravirt-build-fixes.patch
make-struct-vmi_ops-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
replace-get_scheduled_cycles-with-sched_clock-paravirt_op.patch
fix-vmi-and-compat_vdso.patch
