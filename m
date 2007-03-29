From: akpm@linux-foundation.org
Subject: - introduce-load_tls-to-the-for-loop.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:52 -0700
Message-ID: <200703292338.l2TNcqnH015377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934393AbXC2Xi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] Introduce load_TLS to the "for" loop.
has been removed from the -mm tree.  Its filename was
     introduce-load_tls-to-the-for-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
