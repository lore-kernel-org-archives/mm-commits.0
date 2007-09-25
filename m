From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-x86_64-update.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:47:18 -0700
Message-ID: <200709251947.l8PJlIFI001482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbXIYTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Use extended crashkernel command line on x86_64 (update)
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-x86_64-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on x86_64 (update)
From: Bernhard Walle <bwalle@suse.de>

This patch removes the crashkernel parsing from
arch/x86_64/kernel/machine_kexec.c and calls the generic function, introduced in
the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/setup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/setup.c~use-extended-crashkernel-command-line-on-x86_64-update arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~use-extended-crashkernel-command-line-on-x86_64-update
+++ a/arch/x86_64/kernel/setup.c
@@ -197,11 +197,11 @@ static inline void copy_edd(void)
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
-	unsigned long long 	free_mem;
-	unsigned long long 	crash_size, crash_base;
-	int			ret;
+	unsigned long long free_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
 
-	free_mem = max_low_pfn << PAGE_SHIFT;
+	free_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
 
 	ret = parse_crashkernel(boot_command_line, free_mem,
 			&crash_size, &crash_base);
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
