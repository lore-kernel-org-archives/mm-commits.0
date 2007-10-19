From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-ppc64.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:09 -0700
Message-ID: <200710192254.l9JMs9om024501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935568AbXJSXGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, benh@kernel.crashing.org, ebiederm@xmission.com, paulus@samba.org, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use extended crashkernel command line on ppc64
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-ppc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use extended crashkernel command line on ppc64
From: Bernhard Walle <bwalle@suse.de>

This patch adapts the ppc64 code to use the generic parse_crashkernel()
function introduced in the generic patch of that series.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/machine_kexec.c |   52 +++++++++++++-------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64 arch/powerpc/kernel/machine_kexec.c
--- a/arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64
+++ a/arch/powerpc/kernel/machine_kexec.c
@@ -61,45 +61,39 @@ NORET_TYPE void machine_kexec(struct kim
 	for(;;);
 }
 
-static int __init early_parse_crashk(char *p)
+void __init reserve_crashkernel(void)
 {
-	unsigned long size;
-
-	if (!p)
-		return 1;
-
-	size = memparse(p, &p);
+	unsigned long long crash_size, crash_base;
+	int ret;
 
-	if (*p == '@')
-		crashk_res.start = memparse(p + 1, &p);
-	else
-		crashk_res.start = KDUMP_KERNELBASE;
-
-	crashk_res.end = crashk_res.start + size - 1;
-
-	return 0;
-}
-early_param("crashkernel", early_parse_crashk);
+	/* this is necessary because of lmb_phys_mem_size() */
+	lmb_analyze();
 
-void __init reserve_crashkernel(void)
-{
-	unsigned long size;
+	/* use common parsing */
+	ret = parse_crashkernel(boot_command_line, lmb_phys_mem_size(),
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base == 0)
+			crash_base = KDUMP_KERNELBASE;
+		crashk_res.start = crash_base;
+	} else {
+		/* handle the device tree */
+		crash_size = crashk_res.end - crashk_res.start + 1;
+	}
 
-	if (crashk_res.start == 0)
+	if (crash_size == 0)
 		return;
 
 	/* We might have got these values via the command line or the
 	 * device tree, either way sanitise them now. */
 
-	size = crashk_res.end - crashk_res.start + 1;
-
 	if (crashk_res.start != KDUMP_KERNELBASE)
 		printk("Crash kernel location must be 0x%x\n",
 				KDUMP_KERNELBASE);
 
 	crashk_res.start = KDUMP_KERNELBASE;
-	size = PAGE_ALIGN(size);
-	crashk_res.end = crashk_res.start + size - 1;
+	crash_size = PAGE_ALIGN(crash_size);
+	crashk_res.end = crashk_res.start + crash_size - 1;
 
 	/* Crash kernel trumps memory limit */
 	if (memory_limit && memory_limit <= crashk_res.end) {
@@ -108,7 +102,13 @@ void __init reserve_crashkernel(void)
 				memory_limit);
 	}
 
-	lmb_reserve(crashk_res.start, size);
+	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+			"for crashkernel (System RAM: %ldMB)\n",
+			(unsigned long)(crash_size >> 20),
+			(unsigned long)(crashk_res.start >> 20),
+			(unsigned long)(lmb_phys_mem_size() >> 20));
+
+	lmb_reserve(crashk_res.start, crash_size);
 }
 
 int overlaps_crashkernel(unsigned long start, unsigned long size)
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
kexec-use-bootmem_exclusive-on-x86.patch
