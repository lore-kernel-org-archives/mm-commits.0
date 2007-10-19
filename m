From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-ia64-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:32:42 -0700
Message-ID: <200710190432.l9J4WgGD015223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbXJSEcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     Use extended crashkernel command line on ia64 (update)
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-ia64-update.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-ia64.patch

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

 arch/ia64/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64-update arch/ia64/kernel/efi.c
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

origin.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
