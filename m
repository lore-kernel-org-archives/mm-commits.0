From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-x86_64.patch added to -mm tree
Date: Wed, 19 Sep 2007 15:35:45 -0700
Message-ID: <200709192235.l8JMZjBO014684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbXISWf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 18:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, ebiederm@xmission.com, vgoyal@in.ibm.com


The patch titled
     Use extended crashkernel command line on x86_64
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on x86_64
From: Bernhard Walle <bwalle@suse.de>

This patch removes the crashkernel parsing from
arch/x86_64/kernel/machine_kexec.c and calls the generic function, introduced
in the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c          |    3 +-
 arch/x86_64/kernel/machine_kexec.c |   27 --------------------
 arch/x86_64/kernel/setup.c         |   35 +++++++++++++++++++++------
 3 files changed, 30 insertions(+), 35 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86_64/kernel/e820.c
@@ -226,7 +226,8 @@ void __init e820_reserve_resources(void)
 			request_resource(res, &code_resource);
 			request_resource(res, &data_resource);
 #ifdef CONFIG_KEXEC
-			request_resource(res, &crashk_res);
+			if (crashk_res.start != crashk_res.end)
+				request_resource(res, &crashk_res);
 #endif
 		}
 	}
diff -puN arch/x86_64/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86_64/kernel/machine_kexec.c
@@ -231,33 +231,6 @@ NORET_TYPE void machine_kexec(struct kim
 			image->start);
 }
 
-/* crashkernel=size@addr specifies the location to reserve for
- * a crash kernel.  By reserving this memory we guarantee
- * that linux never set's it up as a DMA target.
- * Useful for holding code to do something appropriate
- * after a kernel panic.
- */
-static int __init setup_crashkernel(char *arg)
-{
-	unsigned long size, base;
-	char *p;
-	if (!arg)
-		return -EINVAL;
-	size = memparse(arg, &p);
-	if (arg == p)
-		return -EINVAL;
-	if (*p == '@') {
-		base = memparse(p+1, &p);
-		/* FIXME: Do I want a sanity check to validate the
-		 * memory range?  Yes you do, but it's too early for
-		 * e820 -AK */
-		crashk_res.start = base;
-		crashk_res.end   = base + size - 1;
-	}
-	return 0;
-}
-early_param("crashkernel", setup_crashkernel);
-
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
diff -puN arch/x86_64/kernel/setup.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86_64/kernel/setup.c
@@ -196,6 +196,33 @@ static inline void copy_edd(void)
 }
 #endif
 
+#ifdef CONFIG_KEXEC
+static inline void reserve_crashkernel(void)
+{
+	unsigned long long 	free_mem;
+	unsigned long long 	crash_size, crash_base;
+	int			ret;
+
+	free_mem = max_low_pfn << PAGE_SHIFT;
+
+	ret = parse_crashkernel(boot_command_line, free_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0 && crash_base > 0) {
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(free_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		reserve_bootmem(crash_base, crash_size);
+	}
+}
+#else
+static inline void reserve_crashkernel(void)
+{}
+#endif
+
 #define EBDA_ADDR_POINTER 0x40E
 
 unsigned __initdata ebda_addr;
@@ -367,13 +394,7 @@ void __init setup_arch(char **cmdline_p)
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end) {
-		reserve_bootmem_generic(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-	}
-#endif
-
+	reserve_crashkernel();
 	paging_init();
 
 #ifdef CONFIG_PCI
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
