From: akpm@linux-foundation.org
Subject: - microcode-fix-section-mismatch-warning.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:26 -0700
Message-ID: <200706011748.l51HmPEW015205@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761570AbXFARs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     microcode: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     microcode-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: microcode: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following section mismatch warnings in microcode.c:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3966): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3992): Section mismatch: reference to .exit.text: (between 'microcode_init' and 'parse_maxcpus')

The warning are caused by a function marked __init that
calls a function marked __exit.
Functions marked __exit may be discarded either during link or run-time
and thus the reference is not good.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/microcode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/microcode.c~microcode-fix-section-mismatch-warning arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~microcode-fix-section-mismatch-warning
+++ a/arch/i386/kernel/microcode.c
@@ -478,7 +478,7 @@ static int __init microcode_dev_init (vo
 	return 0;
 }
 
-static void __exit microcode_dev_exit (void)
+static void microcode_dev_exit (void)
 {
 	misc_deregister(&microcode_dev);
 }
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
git-newsetup.patch
