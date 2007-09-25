From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-i386-update.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:47:16 -0700
Message-ID: <200709251947.l8PJlG8N001479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbXIYTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Use extended crashkernel command line on i386 (update)
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-i386-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on i386 (update)
From: Bernhard Walle <bwalle@suse.de>

This patch removes the crashkernel parsing from
arch/i386/kernel/machine_kexec.c and calls the generic function, introduced in
the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/setup.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff -puN arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386-update arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~use-extended-crashkernel-command-line-on-i386-update
+++ a/arch/i386/kernel/setup.c
@@ -381,29 +381,28 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-#ifdef CONFIG_HIGHMEM
-static inline unsigned long long get_total_mem(void)
-{
-	return (unsigned long long)
-		(max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
-}
-#else
 static inline unsigned long long get_total_mem(void)
 {
-	return (unsigned long long)max_low_pfn << PAGE_SHIFT;
-}
+	unsigned long long total;
+
+	total = max_low_pfn - min_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	total += highend_pfn - highstart_pfn;
 #endif
 
+	return total << PAGE_SHIFT;
+}
+
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
-	unsigned long long 	free_mem;
-	unsigned long long 	crash_size, crash_base;
-	int			ret;
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
 
-	free_mem = get_total_mem();
+	total_mem = get_total_mem();
 
-	ret = parse_crashkernel(boot_command_line, free_mem,
+	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
 		if (crash_base > 0) {
@@ -411,7 +410,7 @@ static void __init reserve_crashkernel(v
 					"for crashkernel (System RAM: %ldMB)\n",
 					(unsigned long)(crash_size >> 20),
 					(unsigned long)(crash_base >> 20),
-					(unsigned long)(free_mem >> 20));
+					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
 			reserve_bootmem(crash_base, crash_size);
_

Patches currently in -mm which might be from bwalle@suse.de are

ipsc-update-version-information.patch
add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
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
