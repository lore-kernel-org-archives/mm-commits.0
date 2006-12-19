From: akpm@osdl.org
Subject: + compile-error-of-register_memory.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:29:48 -0800
Message-ID: <200612192029.kBJKTmDY009431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60552 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934AbWLSU3z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, ak@suse.de


The patch titled
     compile error of register_memory()
has been added to the -mm tree.  Its filename is
     compile-error-of-register_memory.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: compile error of register_memory()
From: Yasunori Goto <y-goto@jp.fujitsu.com>

register_memory() becomes double definition in 2.6.20-rc1.  It is defined
in arch/i386/kernel/setup.c as static definition in 2.6.19.  But it is
moved to arch/i386/kernel/e820.c in 2.6.20-rc1.  And same name function is
defined in driver/base/memory.c too.  So, it becomes cause of compile error
of duplicate definition if memory hotplug option is on.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/e820.c  |    2 +-
 arch/i386/kernel/setup.c |    2 +-
 include/asm-i386/e820.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/e820.c~compile-error-of-register_memory arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~compile-error-of-register_memory
+++ a/arch/i386/kernel/e820.c
@@ -668,7 +668,7 @@ void __init register_bootmem_low_pages(u
 	}
 }
 
-void __init register_memory(void)
+void __init e820_register_memory(void)
 {
 	unsigned long gapstart, gapsize, round;
 	unsigned long long last;
diff -puN arch/i386/kernel/setup.c~compile-error-of-register_memory arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~compile-error-of-register_memory
+++ a/arch/i386/kernel/setup.c
@@ -639,7 +639,7 @@ void __init setup_arch(char **cmdline_p)
 		get_smp_config();
 #endif
 
-	register_memory();
+	e820_register_memory();
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
diff -puN include/asm-i386/e820.h~compile-error-of-register_memory include/asm-i386/e820.h
--- a/include/asm-i386/e820.h~compile-error-of-register_memory
+++ a/include/asm-i386/e820.h
@@ -40,7 +40,7 @@ extern int e820_all_mapped(unsigned long
 			   unsigned type);
 extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
-extern void register_memory(void);
+extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

handle-slob-with-sparsemen.patch
compile-error-of-register_memory.patch

