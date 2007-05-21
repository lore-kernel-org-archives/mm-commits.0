From: akpm@linux-foundation.org
Subject: - i386-mtrr-fix-pge-mask.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:42 -0700
Message-ID: <200705212009.l4LK9fMF018780@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935514AbXEUUKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgerst@didntduck.org, mm-commits@vger.kernel.org


The patch titled
     i386 mtrr: fix PGE mask
has been removed from the -mm tree.  Its filename was
     i386-mtrr-fix-pge-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 mtrr: fix PGE mask
From: Brian Gerst <bgerst@didntduck.org>

cr4 is a 32-bit register, so casting the mask to an unsigned char is wrong,
as it clears more than the PGE bit.

Signed-off-by: Brian Gerst <bgerst@didntduck.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/cyrix.c |    2 +-
 arch/i386/kernel/cpu/mtrr/state.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/cyrix.c~i386-mtrr-fix-pge-mask arch/i386/kernel/cpu/mtrr/cyrix.c
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c~i386-mtrr-fix-pge-mask
+++ a/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -136,7 +136,7 @@ static void prepare_set(void)
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
 	if ( cpu_has_pge ) {
 		cr4 = read_cr4();
-		write_cr4(cr4 & (unsigned char) ~(1 << 7));
+		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
 	/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
diff -puN arch/i386/kernel/cpu/mtrr/state.c~i386-mtrr-fix-pge-mask arch/i386/kernel/cpu/mtrr/state.c
--- a/arch/i386/kernel/cpu/mtrr/state.c~i386-mtrr-fix-pge-mask
+++ a/arch/i386/kernel/cpu/mtrr/state.c
@@ -19,7 +19,7 @@ void set_mtrr_prepare_save(struct set_mt
 		/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
 		if ( cpu_has_pge ) {
 			ctxt->cr4val = read_cr4();
-			write_cr4(ctxt->cr4val & (unsigned char) ~(1 << 7));
+			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
 		}
 
 		/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
_

Patches currently in -mm which might be from bgerst@didntduck.org are

origin.patch
