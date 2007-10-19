From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-x86_64-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:32:18 -0700
Message-ID: <200710190432.l9J4WIlc015206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbXJSEcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use extended crashkernel command line on x86_64 (update)
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-x86_64-update.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-x86_64.patch

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

 arch/x86/kernel/setup_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/setup_64.c~use-extended-crashkernel-command-line-on-x86_64-update arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~use-extended-crashkernel-command-line-on-x86_64-update
+++ a/arch/x86/kernel/setup_64.c
@@ -194,11 +194,11 @@ static inline void copy_edd(void)
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

origin.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
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
