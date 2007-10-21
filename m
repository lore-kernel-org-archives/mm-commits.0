From: akpm@linux-foundation.org
Subject: - kexec-use-bootmem_exclusive-on-x86.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:08:43 -0700
Message-ID: <200710212315.l9LNFCJp031936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbXJUXPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ebiederm@xmission.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kexec: use BOOTMEM_EXCLUSIVE on x86
has been removed from the -mm tree.  Its filename was
     kexec-use-bootmem_exclusive-on-x86.patch

This patch was dropped because it had testing failures

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
kexec-add-bss-to-resource-tree.patch
kexec-use-bootmem_exclusive-on-x86.patch
