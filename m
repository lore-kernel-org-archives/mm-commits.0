From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-x86_64.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:05 -0700
Message-ID: <200710192254.l9JMs5Ia024495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966993AbXJSXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ak@suse.de, ebiederm@xmission.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use extended crashkernel command line on x86_64
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820_64.c          |    3 +-
 arch/x86/kernel/machine_kexec_64.c |   27 ------------------
 arch/x86/kernel/setup_64.c         |   39 ++++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 35 deletions(-)

diff -puN arch/x86/kernel/e820_64.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86/kernel/e820_64.c
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
diff -puN arch/x86/kernel/machine_kexec_64.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86/kernel/machine_kexec_64.c
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
diff -puN arch/x86/kernel/setup_64.c~use-extended-crashkernel-command-line-on-x86_64 arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~use-extended-crashkernel-command-line-on-x86_64
+++ a/arch/x86/kernel/setup_64.c
@@ -191,6 +191,37 @@ static inline void copy_edd(void)
 }
 #endif
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long free_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	free_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
+
+	ret = parse_crashkernel(boot_command_line, free_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size) {
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
 #define EBDA_ADDR_POINTER 0x40E
 
 unsigned __initdata ebda_addr;
@@ -357,13 +388,7 @@ void __init setup_arch(char **cmdline_p)
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

origin.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
