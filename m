From: akpm@linux-foundation.org
Subject: - cleanup-remove-extern-declaration-from.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:52:17 -0800
Message-ID: <200702150852.l1F8qHS5025357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965582AbXBOIwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     cleanup: Remove extern declaration from mm/discontig.c, put in header.
has been removed from the -mm tree.  Its filename was
     cleanup-remove-extern-declaration-from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup: Remove extern declaration from mm/discontig.c, put in header.
From: Rusty Russell <rusty@rustcorp.com.au>

Extern declarations belong in headers.  Times, they are a'changin.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/discontig.c |    1 -
 include/asm-i386/setup.h |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/i386/mm/discontig.c~cleanup-remove-extern-declaration-from arch/i386/mm/discontig.c
--- a/arch/i386/mm/discontig.c~cleanup-remove-extern-declaration-from
+++ a/arch/i386/mm/discontig.c
@@ -101,7 +101,6 @@ extern void find_max_pfn(void);
 extern void add_one_highpage_init(struct page *, int, int);
 
 extern struct e820map e820;
-extern unsigned long init_pg_tables_end;
 extern unsigned long highend_pfn, highstart_pfn;
 extern unsigned long max_low_pfn;
 extern unsigned long totalram_pages;
diff -puN include/asm-i386/setup.h~cleanup-remove-extern-declaration-from include/asm-i386/setup.h
--- a/include/asm-i386/setup.h~cleanup-remove-extern-declaration-from
+++ a/include/asm-i386/setup.h
@@ -77,6 +77,8 @@ int __init sanitize_e820_map(struct e820
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
 
+extern unsigned long init_pg_tables_end;
+
 #endif /* __ASSEMBLY__ */
 
 #endif  /*  __KERNEL__  */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-acpi.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
