From: akpm@linux-foundation.org
Subject: + remove-unused-set_seg_base.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:51:59 -0800
Message-ID: <200703151852.l2FIq1Eh023368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbXCOSwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     Remove unused set_seg_base
has been added to the -mm tree.  Its filename is
     remove-unused-set_seg_base.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused set_seg_base
From: Rusty Russell <rusty@rustcorp.com.au>

The set_seg_base function isn't used anywhere (2.6.21-rc3-git1)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/desc.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN include/asm-x86_64/desc.h~remove-unused-set_seg_base include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h~remove-unused-set_seg_base
+++ a/include/asm-x86_64/desc.h
@@ -107,16 +107,6 @@ static inline void set_ldt_desc(unsigned
 			      DESC_LDT, size * 8 - 1);
 }
 
-static inline void set_seg_base(unsigned cpu, int entry, void *base)
-{ 
-	struct desc_struct *d = &cpu_gdt(cpu)[entry];
-	u32 addr = (u32)(u64)base;
-	BUG_ON((u64)base >> 32); 
-	d->base0 = addr & 0xffff;
-	d->base1 = (addr >> 16) & 0xff;
-	d->base2 = (addr >> 24) & 0xff;
-} 
-
 #define LDT_entry_a(info) \
 	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
 /* Don't allow setting of the lm bit. It is useless anyways because 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
