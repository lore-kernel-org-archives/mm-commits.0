From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-sh-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:33:59 -0700
Message-ID: <200710190433.l9J4XxG4015344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966553AbXJSEeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     use-extended-crashkernel-command-line-on-sh update
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-sh-update.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-sh.patch

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

origin.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
