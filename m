From: akpm@linux-foundation.org
Subject: - lguest-the-asm-offsets.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:58 -0700
Message-ID: <200707192004.l6JK4wQK019993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760704AbXGSUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     lguest: the asm offsets
has been removed from the -mm tree.  Its filename was
     lguest-the-asm-offsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: the asm offsets
From: Rusty Russell <rusty@rustcorp.com.au>

This is the structure offsets required by lg.ko's switcher.S.

Unfortunately we don't have infrastructure for private asm-offsets
creation.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~lguest-the-asm-offsets
+++ a/arch/i386/kernel/asm-offsets.c
@@ -19,6 +19,11 @@
 
 #include <xen/interface/xen.h>
 
+#ifdef CONFIG_LGUEST_GUEST
+#include <linux/lguest.h>
+#include "../../../drivers/lguest/lg.h"
+#endif
+
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
@@ -124,4 +129,19 @@ void foo(void)
 	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
 	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
 #endif
+
+#ifdef CONFIG_LGUEST_GUEST
+	BLANK();
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
+	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
+	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
+	OFFSET(LGUEST_PAGES_host_sp, lguest_pages, state.host_sp);
+	OFFSET(LGUEST_PAGES_guest_gdt_desc, lguest_pages,state.guest_gdt_desc);
+	OFFSET(LGUEST_PAGES_guest_idt_desc, lguest_pages,state.guest_idt_desc);
+	OFFSET(LGUEST_PAGES_guest_gdt, lguest_pages, state.guest_gdt);
+	OFFSET(LGUEST_PAGES_regs_trapnum, lguest_pages, regs.trapnum);
+	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
+	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
+#endif
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
