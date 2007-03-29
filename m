From: akpm@linux-foundation.org
Subject: - remove-unused-set_seg_base.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:54 -0700
Message-ID: <200703292338.l2TNcsd3015383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43151 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934398AbXC2XjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Remove unused set_seg_base
has been removed from the -mm tree.  Its filename was
     remove-unused-set_seg_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
