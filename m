From: akpm@linux-foundation.org
Subject: + geode-configuration-fixes.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:09:06 -0800
Message-ID: <200702052109.l15L96WO031211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933451AbXBEVJR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:09:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takada@mbf.nifty.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, jordan.crouse@amd.com


The patch titled
     geode configuration fixes
has been added to the -mm tree.  Its filename is
     geode-configuration-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode configuration fixes
From: TAKADA Yoshihito <takada@mbf.nifty.com>

Original code doesn't write back to CCR4 register.  This patch reflects a
value of a register.

Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cyrix.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~geode-configuration-fixes arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~geode-configuration-fixes
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -162,19 +162,19 @@ static void __cpuinit set_cx86_inc(void)
 static void __cpuinit geode_configure(void)
 {
 	unsigned long flags;
-	u8 ccr3, ccr4;
+	u8 ccr3;
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
 
 	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* Enable */
+	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
 	
-	ccr4 = getCx86(CX86_CCR4);
-	ccr4 |= 0x38;		/* FPU fast, DTE cache, Mem bypass */
-	
-	setCx86(CX86_CCR3, ccr3);
+
+	/* FPU fast, DTE cache, Mem bypass */
+	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
+	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 	
 	set_cx86_memwb();
 	set_cx86_reorder();	
@@ -420,15 +420,14 @@ static void __cpuinit cyrix_identify(str
 		
    	        if (dir0 == 5 || dir0 == 3)
    	        {
-			unsigned char ccr3, ccr4;
+			unsigned char ccr3;
 			unsigned long flags;
 			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
-			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN  */
-			ccr4 = getCx86(CX86_CCR4);
-			setCx86(CX86_CCR4, ccr4 | 0x80);          /* enable cpuid  */
-			setCx86(CX86_CCR3, ccr3);                 /* disable MAPEN */
+			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
+			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}
 	}
_

Patches currently in -mm which might be from takada@mbf.nifty.com are

geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
cyrix-fails-to-detect-mediagx-warning-fix.patch
geode-configuration-fixes.patch
