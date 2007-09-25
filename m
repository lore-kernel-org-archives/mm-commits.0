From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-sh-update.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:47:23 -0700
Message-ID: <200709251947.l8PJlNdT001491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbXIYTsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, lethal@linux-sh.org


The patch titled
     use-extended-crashkernel-command-line-on-sh update
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-sh-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use-extended-crashkernel-command-line-on-sh update
From: Bernhard Walle <bwalle@suse.de>

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/setup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sh/kernel/setup.c~use-extended-crashkernel-command-line-on-sh-update arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~use-extended-crashkernel-command-line-on-sh-update
+++ a/arch/sh/kernel/setup.c
@@ -131,11 +131,11 @@ static void __init register_bootmem_low_
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
-	unsigned long long 	free_mem;
-	unsigned long long 	crash_size, crash_base;
-	int			ret;
+	unsigned long long free_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
 
-	free_mem = (max_low_pfn - min_low_pfn) << PAGE_SHIFT;
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
