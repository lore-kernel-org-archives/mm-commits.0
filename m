From: akpm@osdl.org
Subject: - fix-typo-in-geode_configre-cyrixc.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:20 -0800
Message-ID: <200701122218.l0CMIK0p030785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161141AbXALWSf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takada@mbf.nifty.com, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     fix typo in geode_configre()@cyrix.c
has been removed from the -mm tree.  Its filename was
     fix-typo-in-geode_configre-cyrixc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix typo in geode_configre()@cyrix.c
From: takada <takada@mbf.nifty.com>

We write back the wrong register when configuring the Geode processor.
Instead of storing to CCR4, it stores to CCR3.

Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cyrix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
