From: akpm@linux-foundation.org
Subject: + introduce-load_tls-to-the-for-loop.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:51:57 -0800
Message-ID: <200703151851.l2FIpxmC023365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXCOSwH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     Subject: [PATCH] Introduce load_TLS to the "for" loop.
has been added to the -mm tree.  Its filename is
     introduce-load_tls-to-the-for-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH] Introduce load_TLS to the "for" loop.
From: Rusty Russell <rusty@rustcorp.com.au>

GCC (4.1 at least) unrolls it anyway, but I can't believe this code
was ever justifiable.  (I've also submitted a patch which cleans up
i386, which is even uglier).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/desc.h |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN include/asm-x86_64/desc.h~introduce-load_tls-to-the-for-loop include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h~introduce-load_tls-to-the-for-loop
+++ a/include/asm-x86_64/desc.h
@@ -145,16 +145,13 @@ static inline void set_seg_base(unsigned
 	(info)->useable		== 0	&& \
 	(info)->lm		== 0)
 
-#if TLS_SIZE != 24
-# error update this code.
-#endif
-
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
+	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
-	gdt[0] = t->tls_array[0];
-	gdt[1] = t->tls_array[1];
-	gdt[2] = t->tls_array[2];
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+		gdt[i] = t->tls_array[i];
 } 
 
 /*
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
