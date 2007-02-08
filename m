From: akpm@linux-foundation.org
Subject: - geode-support-classic-mediagxm.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:58 -0800
Message-ID: <200702082152.l18Lqwt9027675@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41477 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423463AbXBHVxJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takada@mbf.nifty.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     geode: support Classic MediaGXm
has been removed from the -mm tree.  Its filename was
     geode-support-classic-mediagxm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: geode: support Classic MediaGXm
From: takada <takada@mbf.nifty.com>

I hope to support "classic" MediaGXm in kernel.

The DIR1 register of MediaGXm( or Geode) shows the following values for
identify CPU.  For example, My MediaGXm shows 0x42.

We can read National Semiconductor's datasheet without any NDAs.
  http://www.national.com/pf/GX/GXLV.html

from datasheets:
DIR1
0x30 - 0x33 GXm rev. 1.0 - 2.3
0x34 - 0x4f GXm rev. 2.4 - 3.x
0x5x        GXm rev. 5.0 - 5.4
0x6x        GXLV
0x7x         (unknow)
0x8x	    Gx1

In nsc driver of X, accept 0x30 through 0x82. What will 0x7x mean?

Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cyrix.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~geode-support-classic-mediagxm arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~geode-support-classic-mediagxm
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -285,10 +285,15 @@ static void __cpuinit init_cyrix(struct 
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
+			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
 			
-			/* GXlv/GXm/GX1 */
-			if((dir1 >= 0x50 && dir1 <= 0x54) || dir1 >= 0x63)
+			/*
+			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
+			 * GXlv: 0x6x          GXlv datasheet 54
+			 *  ?  : 0x7x
+			 * GX1 : 0x8x          GX1  datasheet 56
+			 */
+			if((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <=dir1 && dir1 <= 0x8f))
 				geode_configure();
 			get_model_name(c);  /* get CPU marketing name */
 			return;
_

Patches currently in -mm which might be from takada@mbf.nifty.com are
