From: akpm@osdl.org
Subject: + fix-typo-in-geode_configre-cyrixc.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:12:26 -0800
Message-ID: <200701092112.l09LCQJE015405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbXAIVMe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:12:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takada@mbf.nifty.com, jordan.crouse@amd.com


The patch titled
     fix typo in geode_configre()@cyrix.c
has been added to the -mm tree.  Its filename is
     fix-typo-in-geode_configre-cyrixc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix typo in geode_configre()@cyrix.c
From: takada <takada@mbf.nifty.com>

We write back the wrong register when configuring the Geode processor.
Instead of storing to CCR4, it stores to CCR3.

Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cyrix.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~fix-typo-in-geode_configre-cyrixc arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~fix-typo-in-geode_configre-cyrixc
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -173,7 +173,7 @@ static void __cpuinit geode_configure(vo
 	ccr4 = getCx86(CX86_CCR4);
 	ccr4 |= 0x38;		/* FPU fast, DTE cache, Mem bypass */
 	
-	setCx86(CX86_CCR3, ccr3);
+	setCx86(CX86_CCR4, ccr4);
 	
 	set_cx86_memwb();
 	set_cx86_reorder();	
_

Patches currently in -mm which might be from takada@mbf.nifty.com are

fix-typo-in-geode_configre-cyrixc.patch
