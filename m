From: akpm@linux-foundation.org
Subject: + kexec-use-bootmem_exclusive-on-x86.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:33:31 -0700
Message-ID: <200710182133.l9ILXVZJ032198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756987AbXJRVeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com


The patch titled
     kexec: use BOOTMEM_EXCLUSIVE on x86
has been added to the -mm tree.  Its filename is
     kexec-use-bootmem_exclusive-on-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kexec: use BOOTMEM_EXCLUSIVE on x86
From: Bernhard Walle <bwalle@suse.de>

This patch uses the BOOTMEM_EXCLUSIVE, introduced in the previous patch, to
avoid conflicts while reserving the memory for the kdump carpture kernel
(crashkernel=).

The modification has been tested on i386.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_32.c |   33 ++++++++++++++++++++-------------
 arch/x86/kernel/setup_64.c |   35 +++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 27 deletions(-)

diff -puN arch/x86/kernel/setup_32.c~kexec-use-bootmem_exclusive-on-x86 arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~kexec-use-bootmem_exclusive-on-x86
+++ a/arch/x86/kernel/setup_32.c
@@ -401,22 +401,29 @@ static void __init reserve_crashkernel(v
 
 	total_mem = get_total_mem();
 
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
+	ret = parse_crashkernel(boot_command_line, total_mem, &crash_size,
+				&crash_base);
 	if (ret == 0 && crash_size > 0) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(total_mem >> 20));
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end = crash_base + crash_size - 1;
 	}
 }
 #else
diff -puN arch/x86/kernel/setup_64.c~kexec-use-bootmem_exclusive-on-x86 arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~kexec-use-bootmem_exclusive-on-x86
+++ a/arch/x86/kernel/setup_64.c
@@ -201,28 +201,35 @@ static inline void copy_edd(void)
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
-	unsigned long long free_mem;
+	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	free_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
+	total_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
 
-	ret = parse_crashkernel(boot_command_line, free_mem,
+	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(free_mem >> 20));
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
 	}
 }
 #else
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
