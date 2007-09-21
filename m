From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-i386.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:26:46 -0700
Message-ID: <200709210726.l8L7QlQ9024510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127AbXIUH2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:28:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de, ebiederm@xmission.com, vgoyal@in.ibm.com


The patch titled
     Use extended crashkernel command line on i386
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on i386
From: Bernhard Walle <bwalle@suse.de>

This patch removes the crashkernel parsing from
arch/i386/kernel/machine_kexec.c and calls the generic function, introduced in
the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c          |    3 +-
 arch/i386/kernel/machine_kexec.c |   22 -----------------
 arch/i386/kernel/setup.c         |   37 +++++++++++++++++++++++++----
 3 files changed, 34 insertions(+), 28 deletions(-)

diff -puN arch/i386/kernel/e820.c~use-extended-crashkernel-command-line-on-i386 arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~use-extended-crashkernel-command-line-on-i386
+++ a/arch/i386/kernel/e820.c
@@ -288,7 +288,8 @@ legacy_init_iomem_resources(struct resou
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
 #ifdef CONFIG_KEXEC
-			request_resource(res, &crashk_res);
+			if (crashk_res.start != crashk_res.end)
+				request_resource(res, &crashk_res);
 #endif
 		}
 	}
diff -puN arch/i386/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-i386 arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-i386
+++ a/arch/i386/kernel/machine_kexec.c
@@ -149,28 +149,6 @@ NORET_TYPE void machine_kexec(struct kim
 			image->start, cpu_has_pae);
 }
 
-/* crashkernel=size@addr specifies the location to reserve for
- * a crash kernel.  By reserving this memory we guarantee
- * that linux never sets it up as a DMA target.
- * Useful for holding code to do something appropriate
- * after a kernel panic.
- */
-static int __init parse_crashkernel(char *arg)
-{
-	unsigned long size, base;
-	size = memparse(arg, &arg);
-	if (*arg == '@') {
-		base = memparse(arg+1, &arg);
-		/* FIXME: Do I want a sanity check
-		 * to validate the memory range?
-		 */
-		crashk_res.start = base;
-		crashk_res.end   = base + size - 1;
-	}
-	return 0;
-}
-early_param("crashkernel", parse_crashkernel);
-
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
diff -puN arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386 arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386
+++ a/arch/i386/kernel/setup.c
@@ -381,6 +381,37 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long 	free_mem;
+	unsigned long long 	crash_size, crash_base;
+	int			ret;
+
+	free_mem = (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+
+	ret = parse_crashkernel(boot_command_line, free_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base > 0) {
+			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+					"for crashkernel (System RAM: %ldMB)\n",
+					(unsigned long)(crash_size >> 20),
+					(unsigned long)(crash_base >> 20),
+					(unsigned long)(free_mem >> 20));
+			crashk_res.start = crash_base;
+			crashk_res.end   = crash_base + crash_size - 1;
+			reserve_bootmem(crash_base, crash_size);
+		} else
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+	}
+}
+#else
+static inline void __init reserve_crashkernel(void)
+{}
+#endif
+
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -456,11 +487,7 @@ void __init setup_bootmem_allocator(void
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end)
-		reserve_bootmem(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-#endif
+	reserve_crashkernel();
 }
 
 /*
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
