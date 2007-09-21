From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-sh.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:26:52 -0700
Message-ID: <200709210726.l8L7Qqke024525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbXIUH2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:28:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, lethal@linux-sh.org, vgoyal@in.ibm.com


The patch titled
     Use extended crashkernel command line on sh
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-sh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -121,6 +121,37 @@ static void __init register_bootmem_low_
 	free_bootmem(PFN_PHYS(curr_pfn), PFN_PHYS(pages));
 }
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long 	free_mem;
+	unsigned long long 	crash_size, crash_base;
+	int			ret;
+
+	free_mem = (max_low_pfn - min_low_pfn) << PAGE_SHIFT;
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
@@ -182,11 +213,8 @@ void __init setup_bootmem_allocator(unsi
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
