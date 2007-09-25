From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-ia64-update.patch added to -mm tree
Date: Tue, 25 Sep 2007 12:47:20 -0700
Message-ID: <200709251947.l8PJlKbR001485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbXIYTr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 15:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de


The patch titled
     Use extended crashkernel command line on ia64 (update)
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-ia64-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on ia64 (update)
From: Bernhard Walle <bwalle@suse.de>

This patch adapts IA64 to use the generic parse_crashkernel() function
instead of its own parsing for the crashkernel command line.

Because the total amount of System RAM must be known when calling this
function, efi_memmap_init() is modified to return its accumulated total_memory
variable.

Also, the crashkernel handling is moved in an own function in
arch/ia64/kernel/setup.c to make the code more readable.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c   |    2 +-
 arch/ia64/kernel/setup.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64-update arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64-update
+++ a/arch/ia64/kernel/efi.c
@@ -1085,7 +1085,7 @@ efi_memmap_init(unsigned long *s, unsign
 	*s = (u64)kern_memmap;
 	*e = (u64)++k;
 
-	return total_mem;
+	return total_memory;
 }
 
 void
diff -puN arch/ia64/kernel/setup.c~use-extended-crashkernel-command-line-on-ia64-update arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~use-extended-crashkernel-command-line-on-ia64-update
+++ a/arch/ia64/kernel/setup.c
@@ -261,7 +261,7 @@ void __init
 reserve_memory (void)
 {
 	int n = 0;
-	unsigned long total_memory = 0;
+	unsigned long total_memory;
 
 	/*
 	 * none of the entries in this table overlap
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
