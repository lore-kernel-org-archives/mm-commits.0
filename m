From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-sh.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:11 -0700
Message-ID: <200710192254.l9JMsBr6024506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764365AbXJSXGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ebiederm@xmission.com, lethal@linux-sh.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use extended crashkernel command line on sh
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-sh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use extended crashkernel command line on sh
From: Bernhard Walle <bwalle@suse.de>

This patch removes the crashkernel parsing from arch/sh/kernel/machine_kexec.c
and calls the generic function, introduced in the generic patch, in
setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/machine_kexec.c |   21 -----------------
 arch/sh/kernel/setup.c         |   38 ++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 26 deletions(-)

diff -puN arch/sh/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-sh arch/sh/kernel/machine_kexec.c
--- a/arch/sh/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-sh
+++ a/arch/sh/kernel/machine_kexec.c
@@ -104,24 +104,3 @@ NORET_TYPE void machine_kexec(struct kim
 	(*rnk)(page_list, reboot_code_buffer, image->start, vbr_reg);
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
diff -puN arch/sh/kernel/setup.c~use-extended-crashkernel-command-line-on-sh arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~use-extended-crashkernel-command-line-on-sh
+++ a/arch/sh/kernel/setup.c
@@ -128,6 +128,37 @@ static void __init register_bootmem_low_
 	free_bootmem(PFN_PHYS(curr_pfn), PFN_PHYS(pages));
 }
 
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
 void __init setup_bootmem_allocator(unsigned long free_pfn)
 {
 	unsigned long bootmap_size;
@@ -189,11 +220,8 @@ void __init setup_bootmem_allocator(unsi
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end)
-		reserve_bootmem(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-#endif
+
+	reserve_crashkernel();
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
